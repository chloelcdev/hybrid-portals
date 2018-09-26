if SERVER then

	function aSpawn_spawnEntity(class, model, pos, ang, color, material, map, basePiece)
		if map != game.GetMap() then return end

		local spawnentity = ents.Create(class)
		
		if class=="gmod_light" then
			spawnentity:SetRenderMode(RENDERMODE_TRANSALPHA)
			spawnentity:SetColor(Color(255,255,255,0))
			spawnentity:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
			spawnentity:SetBrightness(0.1)
			spawnentity:SetLightSize(256)
			spawnentity:SetOn(true)
		end

		if class=="portal" || class=="exitportal" then
			spawnentity.portalIndex = basePiece || 0
		end


		
		spawnentity:SetModel(model)
		spawnentity:SetPos(pos)
		spawnentity:SetAngles(ang)
		spawnentity:SetMaterial(material)
		spawnentity.TakeDamage = function() return end
		spawnentity:Spawn()

		local phys = spawnentity:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(false)
		end

		return spawnentity

	end

	function aSpawn_spawnNPC(class, model, pos, ang, color, material, map, basePiece)
		if map != game.GetMap() then return end
		local spawnentity = ents.Create(class)
		spawnentity:SetModel(model)
		spawnentity:SetPos(pos)
		spawnentity:SetAngles(ang)
		spawnentity:SetMaterial(material)
		spawnentity:Spawn()
	end

	function aSpawn_spawnVehicle(class, model, pos, ang, color, material, map, basePiece)
		if map != game.GetMap() then return end

		local spawnentity = ents.Create(class)
		spawnentity:SetModel(model)
		spawnentity:SetPos(pos)

		spawnentity:SetAngles(ang)
		spawnentity:SetMaterial(material)
		spawnentity:Spawn()
		spawnentity:Activate()
		local phys = spawnentity:GetPhysicsObject()
		phys:EnableMotion(false)

	end

	hook.Add("InitPostEntity","spawnstartentscaro",function() 
		timer.Simple(10, function() aSpawn_initspawns() end)
	end)

	function aSpawn_initspawns()

		aSpawn_spawnEntity('casinokit_roulette', 'models/casinokit/roulette.mdl', Vector(1280,-1350,-174), Angle(0, 0, 0), Color(255, 255, 255), '', 'rp_downtown_tits_v1')

		aSpawn_spawnEntity('portal', 'models/props_wasteland/interior_fence002e.mdl', Vector(699.998, -1448.276, -131.766), Angle(0, 90, 0), Color(255, 255, 255), '', 'rp_downtown_v4c_v2',1)
		aSpawn_spawnEntity('exitportal', 'models/props_wasteland/interior_fence002e.mdl', Vector(-1459.965, -4378.042, -134.744), Angle(0, -90, -0), Color(255, 255, 255), '', 'rp_downtown_v4c_v2',1)

		aSpawn_spawnEntity('portal', 'models/props_wasteland/interior_fence002e.mdl', Vector(632, -1448, -131), Angle(0, 90, 0), Color(255, 255, 255), '', 'rp_downtown_v4c_v2',2)
		aSpawn_spawnEntity('exitportal', 'models/props_wasteland/interior_fence002e.mdl', Vector(-1324.637, 911.261, -131.737), Angle(0, -90, 0), Color(255, 255, 255), '', 'rp_downtown_v4c_v2',2)

		aSpawn_spawnEntity('portal', 'models/props_wasteland/interior_fence002e.mdl', Vector(564.929, -1447.867, -131.766), Angle(0, 90, 0), Color(255, 255, 255), '', 'rp_downtown_v4c_v2',3)
		aSpawn_spawnEntity('exitportal', 'models/props_wasteland/interior_fence002e.mdl',Vector(2839.48, 1915.689, -131.86), Angle(0, -90, 0), Color(255, 255, 255), '', 'rp_downtown_v4c_v2',3)

		aSpawn_spawnEntity('portal', 'models/props_wasteland/interior_fence002e.mdl', Vector(494.435, -1447.58, -131.766), Angle(0, 90, 0), Color(255, 255, 255), '', 'rp_downtown_v4c_v2',4)
		aSpawn_spawnEntity('exitportal', 'models/props_wasteland/interior_fence002e.mdl', Vector(-3832.805, 4124.287, -131.577), Angle(0, -90, 0), Color(255, 255, 255), '', 'rp_downtown_v4c_v2',4)

		// flatgrass
		aSpawn_spawnEntity('portal', 'models/props_wasteland/interior_fence002e.mdl', Vector(785, -1448, -131), Angle(0, 90, 0), Color(255, 255, 255), '', 'rp_downtown_tits_v1',1)
		aSpawn_spawnEntity('exitportal', 'models/props_wasteland/interior_fence002e.mdl', Vector(2, 3310, 12258), Angle(0, -90, -0), Color(255, 255, 255), '', 'rp_downtown_tits_v1',1)

		//aSpawn_spawnEntity('portal', 'models/props_wasteland/interior_fence002e.mdl', Vector(632, -1448, -131), Angle(0, 90, 0), Color(255, 255, 255), '', 'rp_downtown_tits_v1',2)
		//aSpawn_spawnEntity('exitportal', 'models/props_wasteland/interior_fence002e.mdl', Vector(3591.279, 3596.131, -131.745), Angle(0, -90, 0), Color(255, 255, 255), '', 'rp_downtown_tits_v1',2, nil, "materials/teleportlocations/hub.png", "materials/teleportlocations/slums.png")
		local spacing = 90
		// fountain
		aSpawn_spawnEntity('portal', 'models/props_wasteland/interior_fence002e.mdl', Vector(785-spacing*1, -1448, -131), Angle(0, 90, 0), Color(255, 255, 255), '', 'rp_downtown_tits_v1',2)
		aSpawn_spawnEntity('exitportal', 'models/props_wasteland/interior_fence002e.mdl',Vector(-1916, -1125, -132), Angle(0, -90, 0), Color(255, 255, 255), '', 'rp_downtown_tits_v1',2)

		// court
		aSpawn_spawnEntity('portal', 'models/props_wasteland/interior_fence002e.mdl', Vector(785-spacing*2, -1448, -131), Angle(0, 90, 0), Color(255, 255, 255), '', 'rp_downtown_tits_v1',3)
		aSpawn_spawnEntity('exitportal', 'models/props_wasteland/interior_fence002e.mdl', Vector(1152, 6403, -131), Angle(0, -90, 0), Color(255, 255, 255), '', 'rp_downtown_tits_v1',3)

		// park
		aSpawn_spawnEntity('portal', 'models/props_wasteland/interior_fence002e.mdl', Vector(785-spacing*3, -1448, -131), Angle(0, 90, 0), Color(255, 255, 255), '', 'rp_downtown_tits_v1',4)
		aSpawn_spawnEntity('exitportal', 'models/props_wasteland/interior_fence002e.mdl', Vector(3448, 1383, -132), Angle(0, -90, 0), Color(255, 255, 255), '', 'rp_downtown_tits_v1',4)

		// suburbs
		aSpawn_spawnEntity('portal', 'models/props_wasteland/interior_fence002e.mdl', Vector(785-spacing*4, -1448, -131), Angle(0, 90, 0), Color(255, 255, 255), '', 'rp_downtown_tits_v1',5)
		aSpawn_spawnEntity('exitportal', 'models/props_wasteland/interior_fence002e.mdl', Vector(467, -4400, -132), Angle(0, -90, 0), Color(255, 255, 255), '', 'rp_downtown_tits_v1',5)


	end


	function updatePortal(portal, mat)
		net.Start("updatePortalMaterial")
			net.WriteEntity(portal)
			net.WriteString(mat)
		net.Broadcast()
	end

	function chatCommand( ply, text, public )
		if !checkULX(ply) then return end

	    if (string.lower(text) == "/refreshportals") then --if the first 4 letters are /die, kill him
	        for k,v in pairs(ents.FindByClass("portal")) do
	        	v:Remove()
	        end
	        for k,v in pairs(ents.FindByClass("exitportal")) do
	        	v:Remove()
	        end
	        aSpawn_initspawns()
	    end
	end

	hook.Add( "PlayerSay", "chatCommand", chatCommand )

	function checkULX(ply)
	    if (ply:GetUserGroup() == "owner" || ply:IsSuperAdmin() ) then
	    	return true;
	    end
	end
end





if CLIENT then

	function qrnd(val)
		// this is only here so the bottom isn't ugly
		return math.Round(val,3)
	end

	function getPropLine(ent)
		local cls = ent:GetClass()
		local mdl = ent:GetModel()
		local pos = ent:GetPos()
		local ang = ent:GetAngles()
		local mat = ent:GetMaterial()
		local clr = ent:GetColor()
		local map = game.GetMap()
		local colgroup = ent:GetCollisionGroup()

		local clsString = "'" .. cls .. "'"
		local mdlString = "'" .. mdl .. "'"
		local mapString = "'" .. map .. "'"
		local posString = "Vector(" .. qrnd(pos.x) .. ", " .. qrnd(pos.y) .. ", " .. qrnd(pos.z) .. ")"
		local angString = "Angle(" .. qrnd(ang.p) .. ", " .. qrnd(ang.y) .. ", " .. qrnd(ang.r) .. ")"
		local clrString = "Color(" .. qrnd(clr.r) .. ", " .. qrnd(clr.g) .. ", " .. qrnd(clr.b) .. ")"
		local matString = "'" .. mat .. "'"

		local concat = "aSpawn_spawnEntity(" .. clsString .. ", " .. mdlString .. ", " .. posString .. ", " .. angString .. ", " .. clrString .. ", " .. matString .. ", " .. mapString

		if ent:GetClass() == "gmod_wire_textscreen" then
			concat = concat .. ", " .. "'" .. ent.text .. "'"
		end
		if ent.basePiece!=nil then
			concat = concat .. ", " .. ent.basePiece
		end

		
		concat = concat .. ")"
		

		return concat
	end


	concommand.Add("aspawns_propgrab",function(ply, cmd, args)
		if (ply:IsSuperAdmin()) then
			local propLine = getPropLine(ply:GetEyeTrace().Entity)

			
			SetClipboardText(propLine)
			print(propLine)
		end
	end)

	concommand.Add("aspawns_propgrab_all",function(ply, cmd, args)
		if (ply:IsSuperAdmin()) then
			local fullString = ""
			for k,v in pairs(ents.GetAll()) do
				if v.basePiece!=nil then
					fullString = fullString .. "\n" .. getPropLine(v)
				end
			end
			
			SetClipboardText(fullString)
			print(fullString)
		end
	end)
end