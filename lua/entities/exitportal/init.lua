AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

// you need to spawn an exitportal, and a portal, and give them the same ENT.portalIndex

// THESE DO NOT MATTER
// PORTAL Y MATTERS BUT NOT THE OTHERS
// THE PORTAL WILL ALIGN ITSELF WITH THE PORTAL ENTS, DON'T CHANGE THEM HERE IN EXITPORTAL
local portalModel = "models/props_wasteland/interior_fence002e.mdl"
local portalScale = 1
local portalW = 50
local portalH = 105
local portalY = -9


function ENT:Initialize()
	--self:SetModel( "models/Bastien/Pack/maisone.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(false)
	end

	
	
	self:SetUseType(SIMPLE_USE)

	for k,v in pairs(ents.GetAll()) do
		if self==v then return end
		if self.portalIndex and v.portalIndex and v.portalIndex==self.portalIndex then
			//print("matchfound")

			self:SetModel( v:GetModel() )

			self.portal=ents.Create("caro_portal_door")

			v.portal=ents.Create("caro_portal_door")
			//self.portal:SetPortalMaterial(self.pmat1)
			//v.portal:SetPortalMaterial(self.pmat2)


			//self.portal:SetMaterial("models/props_combine/stasisshield_sheet")
			//v.portal:SetMaterial("models/props_combine/stasisshield_sheet")

			local portal2vec = self:GetPos()  + self:GetAngles():Forward() * 0 + self:GetAngles():Right() * 23
			portal2vec:Add(Vector(0,0,portalY))
			self.portal:SetPos(portal2vec)
			self.portal:SetModel("models/props_doors/door03_slotted_left.mdl")
			self.portal:SetAngles(self:GetAngles())
			self.portal:SetModelScale(self.portal:GetModelScale() * 0.7)
			self.portal.exitportal = v.portal
			//self.portal:SetExitPortal(v.portal:EntIndex())
			self.portal:SetParent(self)
			self.portal:Spawn()
			self.portal:Activate()

			
			local portal1vec = v:GetPos() + v:GetAngles():Forward() * 0 + v:GetAngles():Right() * 23
			portal1vec:Add(Vector(0,0,portalY))
			v.portal:SetPos(portal1vec)
			v.portal:SetModel("models/props_doors/door03_slotted_left.mdl")
			v.portal:SetAngles(v:GetAngles())
			v.portal:SetModelScale(v.portal:GetModelScale() * 0.9)
			v.portal.exitportal = self.portal
			//v.portal:SetExitPortal(self.portal:EntIndex())
			v.portal:SetParent(v)
			v.portal:Spawn()
			v.portal:Activate()
		end
	end
end
 
function ENT:Use( activator, caller )                   --credit goes to
		local ply = activator or caller                 --https://facepunch.com/member.php?u=144431
		if !ply:IsPlayer() then return end              --"101kl"
		if !IsValid( self.UseParent ) then return end   --for this section of code
		self.UseParent:Use(ply,ply,3,0)                 --
end                                                     --Thanks!



function ENT:Think()
    -- We don't need to think, we are just a prop after all!
end 

