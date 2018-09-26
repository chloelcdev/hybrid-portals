
CreateClientConVar( "portals_renderTempo", 2) 
include( "shared.lua" )



ENT.localPlayerJustTeleported = false

ENT.exitposinit = Vector(-243, -2046, 35)
ENT.exitpos = ENT.exitposinit


ENT.exitang = Angle(0,-90,0)


caro_renderSceneClick = true
caroportals_renderSceneClickTable = {}
caroportals_renderSceneClickIndex = 1

ENT.clientsidePortalModels = {}

//"models/shadertest/shader3"

-- Draw world portals
function ENT:Initialize()
	//self.texture = GetRenderTargetEx('uniquert'..self:EntIndex(), 4096, 4096, false)
	//render.MaxTextureHeight(4096)
	//render.MaxTextureWidth(4096)
	if not PORTALRT then
		PORTALRT = GetRTManager("portalmanagerrt",640,480,16)
	end

	//self.exitpos = self:GetPos()
	self.texture = PORTALRT:GetRT()
	//TEXTUREFLAGS_ANISOTROPIC
	self.mat = CreateMaterial("uniquemat"..self:EntIndex(),"UnlitGeneric",{});

	self.clientsidePortalModels = {}

	net.Start("requestportallocations")
	net.SendToServer()

	if not table.HasValue(caro_tableofportals,self) then
		table.insert(caro_tableofportals,self)
	end
	
	//ENT.portals_localmatvar = ENT.mat;
end

if hook.GetTable()["rendercaroportals"] then
	hook.Remove("RenderScene","rendercaroportals")
end

function renderPortalScene_c( plyOrigin, plyAngle )
	if caro_renderSceneClick==true then
		caro_renderSceneClick = false
		timer.Simple(GetConVar("portals_renderTempo"):GetFloat(), function() caro_renderSceneClick=true end)
	else 
		return
	end
	local ent
	local actualindex = 1
	for i,visibleportal in pairs(caroportals_renderSceneClickTable) do
		if i==caroportals_renderSceneClickIndex then 
			ent = visibleportal
		end
		actualindex = actualindex + 1
	end

	if IsValid(ent) then
		ent:setupRT()
		//allEntDraw()
		caroportals_renderSceneClickIndex = caroportals_renderSceneClickIndex + 1
		if (caroportals_renderSceneClickIndex>#caroportals_renderSceneClickTable) then
			caroportals_renderSceneClickIndex=1
		end
	else
		caroportals_renderSceneClickIndex=1
	end
end

hook.Add("RenderScene","rendercaroportals",renderPortalScene_c)


net.Receive("updatePortalEntities",function()


	local _portal = tonumber(net.ReadString())
	local _exitpos = net.ReadVector();
	local _exitangle = net.ReadAngle();



	local prtl = Entity(_portal)
	if not IsValid(prtl) then return end
	prtl.exitpos = _exitpos
	prtl.exitang = _exitangle

	//caroportals_renderSceneClick = true
	prtl:setupRT()
end)

local function isVisible(ent,pos)
    local trace = {start = EyePos(),endpos = pos,filter = {LocalPlayer(), ent}, mask=MASK_BLOCKLOS}
    local tr = util.TraceLine(trace)
    if tr.Fraction == 1 then
        return true
    elseif ent:GetPos():Distance(EyePos())<100 then
    	return true
    else
        return false
    end
end

local function ScreenCheck(o_pos)
	pos = o_pos:ToScreen()
    if pos.x < ScrW()+10 and pos.x > -10 and pos.y < ScrH()+10 and pos.y > -10 then
        return true;
    elseif o_pos:Distance(EyePos())<100 then
    	return true;
    else
        return false;
    end
end

function ENT:checkPortalSight()

	// check the four corners
	// top left
	if isVisible(self,self:GetPos() + Vector(0,0,self.PORTALHEIGHT)) && ScreenCheck(self:GetPos() + Vector(0,0,self.PORTALHEIGHT)) then
		return true
	end
	// bottom left
	if isVisible(self,self:GetPos() +  Vector(0,0,-self.PORTALHEIGHT)) && ScreenCheck(self:GetPos() + Vector(0,0,-self.PORTALHEIGHT)) then
		return true
	end
	// bottom right
	if isVisible(self,self:GetPos() + Vector(self.PORTALWIDTH,0,-self.PORTALHEIGHT)) && ScreenCheck(self:GetPos() + Vector(self.PORTALWIDTH,0,-self.PORTALHEIGHT)) then
		return true
	end
	// top right
	if isVisible(self,self:GetPos() + Vector(self.PORTALWIDTH,0,self.PORTALHEIGHT)) && ScreenCheck(self:GetPos() + Vector(self.PORTALWIDTH,0,self.PORTALHEIGHT)) then
		return true
	end


	return false
end

ENT.NEXTPLAYERREQUEST = 0
function ENT:Think()
	if self.exitpos:Distance(self.exitposinit)<2 && self.NEXTPLAYERREQUEST<CurTime() then
		self.NEXTPLAYERREQUEST = CurTime()+0.2
		net.Start("requestportallocations")
		net.SendToServer()
	end
	
	if self:checkPortalSight() then
		if caroportals_renderSceneClickTable && not table.HasValue(caroportals_renderSceneClickTable,self) then
			table.insert(caroportals_renderSceneClickTable,self)
		end
	else
		for k,v in pairs(caroportals_renderSceneClickTable) do
			if v==self then
				table.remove(caroportals_renderSceneClickTable,k)
			end
		end
	end
	if self:GetPos():Distance(EyePos())<32 then
		self:ClientTouch()
	end

	if (os.time()%2==0) then // this just slightly downs the frequency of the check, cause why not save a pinch of ops? idk it felt right at the time and i'm not gonna change it now to make it LESS efficient, long comment ahead DAMN too late
		if self.localPlayerJustTeleported then

			if self.exitpos && (EyePos():Distance(self:GetPos())>60  &&  EyePos():Distance(self.exitpos)>60) then
				self.localPlayerJustTeleported = false;
			end
		end
	end
end
-- Teleportation prediction
function ENT:ClientTouch()



	local vel_norm = LocalPlayer():GetVelocity():GetNormalized()
	local posoffset = self:GetPos() - LocalPlayer():GetPos()

	if vel_norm:Dot( self:GetForward() ) < -0.9 then
		if self.exitpos and (not self.localPlayerJustTeleported) then
			localpos = self:WorldToLocal(LocalPlayer():GetPos())
			//LocalToWorld( Vector localPos, Angle localAng, Vector originPos, Angle originAngle ) 
			LTWp, LTWa = LocalToWorld(localpos, self:GetAngles(), self.exitpos, self.exitang)
			LocalPlayer():SetPos(LTWp)


			local ang = LocalPlayer():GetAngles() - (self.exitang-self:GetAngles())
				  ang.y = ang.y+180
				  ang.p = LocalPlayer():GetAngles().p
				  ang.r = 0

			//LocalPlayer():SetEyeAngles(ang)

			self.localPlayerJustTeleported = true
			//self.exitportal.localPlayerJustTeleported = true
		end
	end
end

function ENT:setupRT()
	local oldRT = render.GetRenderTarget()

	local scrw, scrh = ScrW(), ScrH()

	-- this is a perfect render target dealio.
	render.PushRenderTarget(self.texture)

	//render.OverrideAlphaWriteEnable(true, true)

	//render.Clear( 0, 0, 0, 255 )
	//render.ClearDepth()
	//render.ClearStencil()

	//render.EnableClipping(false)
	//render.PushCustomClipPlane( self.exitportal:GetForward(), self.exitportal:GetForward():Dot(self.exitportal:GetPos() - (self.exitportal:GetForward() *0.5) ) )
	render.RenderView( {
					x = 0,
					y = 0,
					w = ScrW(),
					h = ScrH(),
					origin = self.exitpos,
					angles = self.exitang,
					drawpostprocess = false,
					drawhud = false,
					drawmonitors = false,
					drawviewmodel = false
					//zfar = 100
				} )


	render.PopRenderTarget()

	
end

ENT.PORTALWIDTH = 50;
ENT.PORTALHEIGHT = 55;
function ENT:Draw()
	self:customDraw(self.PORTALWIDTH)
	//self:DrawModel()
end

function ENT:customDraw(width)

	
	

	local ang = self:GetAngles()
	local pos = self:GetPos() - ang:Right()*20
	local plyHPos =  pos+ang:Up()*10


	local uWidth = 0.3
	//uWidth = math.Clamp(0.25-(dist*0.0005)^2,0.05,1)
	local vWidth = 1
	local dist = EyePos():Distance(plyHPos-self:GetForward()*20)
	local reldist = math.Clamp(dist/4000,0,0.01)
	uWidth = uWidth - reldist
	//uWidth = math.Clamp(uWidth,0.12,2000) - (dist/10000)
	//uWidth = math.Clamp(1-dist/1000,0.12,0.3)
	//print(reldist)
	//vWidth = math.Clamp(1-dist/100,0.12,1)


	local angToPlayer = (pos - EyePos()):GetNormalized():Angle()
	local angToPlayer2 = (plyHPos - (EyePos()-Vector(0,0,35))):GetNormalized():Angle()

	local angleDifferencey = math.AngleDifference(angToPlayer.yaw,-ang.yaw)
	angleDifferencey = angleDifferencey + 90
	angleDifferencey = angleDifferencey / 180

	local angleDifferencep = math.AngleDifference(angToPlayer.pitch,-ang.pitch)//*(1-dist*0.0015)
	angleDifferencep = angleDifferencep + 90
	angleDifferencep = angleDifferencep / 180

	ang:RotateAroundAxis(ang:Right(),-90)
	ang:RotateAroundAxis(ang:Up(),90)


	
	if (self.mat) then
		cam.Start3D2D( pos, ang, 1 )

			self.mat:SetTexture('$basetexture', self.texture)
			//PORTALRT:FreeRT(self.texture)

			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial(self.mat)
			local startU = 1-math.Clamp(Lerp(1-(dist-35)/100,angleDifferencey,0.45)+uWidth,0,1)
			local endU = 1-math.Clamp(Lerp(1-(dist-35)/100,angleDifferencey,0.55)-uWidth,0,1)

			local startV = math.Clamp(angleDifferencep*1.9-vWidth,0,1)
			local endV = 0.9


			surface.DrawTexturedRectUV( -22, -55, width, 109 , startU, startV, endU, endV)
		cam.End3D2D()
	end
end


// I was told I should manage the RTs because gmod never gets rid of them
// this is only still here because gmod may hold on to RTs at menu, and this (might) help with that

--[[---------------------------------------------
	RenderTarget manager, copied from WireMod's WireGPU.
	By Mijyuoon.
-----------------------------------------------]]

local RT_Manager = {}
RT_Manager.__index = RT_Manager

function GetRTManager(prefix, wid, hgt, size)
	if not prefix then return nil end
	local self = setmetatable({}, RT_Manager)
	self:Init(prefix, wid, hgt, size)
	return self
end

-- Handles rendertarget caching
function RT_Manager:Init(prefix, width, height, size)
	self.RT_Prefix = prefix
	self.RT_Width = width or 512
	self.RT_Height = height or 512
	self.RT_CacheSize = size or 32
	self.RT_CacheTbl = {}

	for i = 1, self.RT_CacheSize do
		table.insert(self.RT_CacheTbl, {
			false, -- Is rendertarget in use
			false -- The rendertarget (false if doesn't exist)
		})
	end
end

local function Clear_RT(rt)
	render.PushRenderTarget(rt)
	cam.Start2D()
		render.Clear(0, 0, 0, 255)
	cam.End2D()
	render.PopRenderTarget()
end

-- Returns a render target from the cache pool and marks it as used
function RT_Manager:GetRT()
	for _, RT in pairs(self.RT_CacheTbl) do
		if not RT[1] then -- not used
			local rendertarget = RT[2]
			if rendertarget then
				RT[1] = true -- Mark as used
				Clear_RT(rendertarget)
				return rendertarget
			end
		end
	end

	-- No free rendertargets. Find first non used and create it.
	for i, RT in pairs(self.RT_CacheTbl) do
		if not RT[1] and RT[2] == false then
			local rt_name = self.RT_Prefix.."_RT_"..i
			local rendertarget = GetRenderTarget(rt_name, self.RT_Width, self.RT_Height)
			if rendertarget then
				RT[1] = true -- Mark as used
				RT[2] = rendertarget -- Assign the RT
				Clear_RT(rendertarget)
				return rendertarget
			else
				RT[1] = true -- Mark as used since we couldn't create it
				ErrorNoHalt("Render target "..rt_name.." could not be created!\n")
			end
		end
	end

	ErrorNoHalt("All render targets are in use!\n")
	return nil
end

-- Frees an used RT
function RT_Manager:FreeRT(rt)
	for _, RT in pairs(self.RT_CacheTbl) do
		if RT[2] == rt then
			RT[1] = false
			return
		end
	end

	rt = rt and rt:GetName() or "(nil)"
	ErrorNoHalt("Render target "..rt.." could not be freed!\n")
end