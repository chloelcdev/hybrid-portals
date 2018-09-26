
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function TransformPortalAngle( angle, portal, exit_portal )

	local l_angle = portal:WorldToLocalAngles( angle )
	l_angle:RotateAroundAxis( Vector(0, 0, 1), 180)
	local w_angle = exit_portal:LocalToWorldAngles( l_angle )

	return w_angle

end 

hook.Add( "SetupPlayerVisibility", "portalvishandle", function(pPlayer, pViewEntity) setupVisPortals(pPlayer,pViewEntity) end)

function setupVisPortals( pPlayer, pViewEntity )
	
	for i, portal in pairs(caro_tableofportals) do
		if IsValid(portal.exitportal) then
			for k,v in pairs(ents.FindInCone(portal.exitportal:GetPos(),portal.exitportal:GetForward(),700,0.5)) do
				AddOriginToPVS(v:GetPos())
			end
		end
	end
end




util.AddNetworkString("updatePortalEntities")

ENT.halfSecondInt = true

function ENT:Think()

	
	if (self.playersJustTeleported==nil) then
		self.playersJustTeleported = {}
	end
	// every half second
	if (self.halfSecondInt) then
		self.halfSecondInt = false
		timer.Simple(0.5, function() self.halfSecondInt = true end)

		if not table.HasValue(caro_tableofportals,self) then
			table.insert(caro_tableofportals,self)
		end

		// loop through each player in our list
		for k, v in pairs(self.playersJustTeleported) do
			ply = Entity(v)

			// if they're far enough from both portals
			if (ply:GetPos():Distance(self:GetPos())>50  &&  ply:GetPos():Distance(self.exitportal:GetPos())>50) then
				// loop through both lists, and if we find the player, remove them from the list
				for k,v2 in pairs(self.playersJustTeleported) do
					if (v==v2) then
						self.playersJustTeleported[k] = nil
					end
				end
				for k,v2 in pairs(self.exitportal.playersJustTeleported) do
					if (v==v2) then
						self.exitportal.playersJustTeleported[k] = nil
					end
				end
			end
		end
		for k,v in pairs(ents.GetAll()) do
			if (v:GetTable().deathTime && CurTime()>v:GetTable().deathTime) then
				v:Remove()
			end
		end
	end
end

concommand.Add("portals_updatelocations",function(ply) for k,v in pairs(player.GetAll()) do updateAllPortals(v) end end)
caro_canSendPortals=true
function updateAllPortals(ply)
	if (not ply.NEXTPORTALSEND) then
		ply.NEXTPORTALSEND = CurTime()+0.2
	end
	if ply.NEXTPORTALSEND<CurTime() && ply:IsSuperAdmin() then
		ply.NEXTPORTALSEND = CurTime()+0.2

		for k,v in pairs(caro_tableofportals) do
			if v.exitportal && IsValid(v.exitportal) then
				net.Start("updatePortalEntities")
					net.WriteString(v:EntIndex())
					net.WriteVector(v.exitportal:GetPos())
					net.WriteAngle(v.exitportal:GetAngles())
				net.Send(ply)
			end
		end
	end
end

util.AddNetworkString("requestportallocations")
net.Receive("requestportallocations",function(len,ply)
	updateAllPortals(ply)
end)



-- Teleportation
function ENT:Touch( ent )
	ent.isHandlingTeleporting = false
	if ent.isHandlingTeleporting && ent.isHandlingTeleporting==true then
		return
	end

	ent.isHandlingTeleporting = true

	if IsValid( self:GetParent() ) then
		local ents = constraint.GetAllConstrainedEntities( self:GetParent() ) // don't mess up this contraption we're on -- not really useful since i dissallowed ent teleports
		for k,v in pairs( ents ) do
			if v == ent then
				return
			end
		end
	end
	local vel_norm = ent:GetVelocity():GetNormalized()
	local posoffset = self:GetPos() - ent:GetPos()

	-- Object is moving towards the portal
	if vel_norm:Dot( self:GetForward() ) < -0.9 then
		if self.exitportal and (not table.HasValue(self.playersJustTeleported,ent:EntIndex())) then
			if IsValid(ent) and ent:IsPlayer() then
				localpos = self:WorldToLocal(ent:GetPos())

				local m_entLight = ents.Create("light_dynamic")
				m_entLight:SetKeyValue("_light", "0,100,0 100")
				m_entLight:SetKeyValue("brightness", "10")
				m_entLight:SetKeyValue("distance", "50")
				m_entLight:SetPos(self:GetPos() + -40*self:GetRight() + 40*self:GetForward() + 40*self:GetUp())
				m_entLight:SetParent(self.portal)
				m_entLight:Spawn()
				m_entLight:Activate()
				m_entLight.deathTime = CurTime() + 3;
				m_entLight:Fire("TurnOn", "", 0)

				LTWp, LTWa = LocalToWorld(localpos, self:GetAngles(), self.exitportal:GetPos(), self.exitportal:GetAngles())

				ent:SetPos(LTWp)


				// gmod doesn't handle velocity fast enough so the portals need to be at inverse angles anyways
				// which means at best this would occasionally mess up and screw with you

				/*local ang = ent:GetAngles() - (self.exitportal:GetAngles()-self:GetAngles())
					  ang.y = ang.y+180
					  ang.p = ent:GetAngles().p
					  ang.r = 0

				ent:SetEyeAngles(ang)*/

			end
			table.insert(self.playersJustTeleported, ent:EntIndex())
			table.insert(self.exitportal.playersJustTeleported, ent:EntIndex())
			ent.isHandlingTeleporting = false
		end
	end
end