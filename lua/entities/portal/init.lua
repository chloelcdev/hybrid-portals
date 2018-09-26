AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

local portalModel = "models/props_wasteland/interior_fence002e.mdl"
//local portalScale = 1
//local portalW = 50
//local portalH = 105
//local portalY = -9
 
function ENT:Initialize()
	self:SetModel( portalModel )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	//self:SetPos(self:GetPos() + Vector(0,0,71))
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end
	//self:SetModelScale(self:GetModelScale()* portalScale)

	//self:SetCollisionGroup(COLLISION_GROUP_PUSHAWAY)
	
	//local vec1 = self:GetPos()
	//vec2:Add(vec1)
	
	
	self:SetUseType(SIMPLE_USE)
	
end
 
function ENT:Use( activator, caller )
/* really no need for this unless they had made it call the function above
	if(self.portals[1]:IsValid())then
		self.portals[1]:Remove()
		self.portals[2]:Remove()
		
	else
			
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Sleep()
		end
		local phys2 = self.exitportal:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Sleep()
		end
		
		//self.portals[1]=ents.Create("linked_portal_door")
		//self.portals[2]=ents.Create("linked_portal_door")
		
		self.portals[1]:SetWidth(portalW)
		self.portals[1]:SetHeight(portalH)
		local portal1vec = self:GetPos()
		portal1vec:Add(Vector(0,0,portalY))
		local selfangle=self:GetAngles()
		selfangle[1]=0
		selfangle[3]=0
		self:SetAngles(selfangle)
		self.portals[1]:SetAngles(selfangle)
		self.portals[1]:SetPos(portal1vec)
		self.portals[1]:SetExit(self.portals[2])
		self.portals[1]:SetParent(self)
		self.portals[1]:Spawn()
		self.portals[1]:Activate()
		
		self.portals[2]:SetWidth(portalW)
		self.portals[2]:SetHeight(portalH)
		local portal2vec = self.exitportal:GetPos()
		portal2vec:Add(Vector(0,0,portalY))
		local exitangle=self.exitportal:GetAngles()
		exitangle[1]=0
		exitangle[3]=0
		self.exitportal:SetAngles(exitangle)
		self.portals[2]:SetAngles(exitangle)
		self.portals[2]:SetPos(portal2vec)
		self.portals[2]:SetExit(self.portals[1])
		self.portals[2]:SetParent(self.exitportal)
		self.portals[2]:Spawn()
		self.portals[2]:Activate()
		
		self:PhysWake()
		self.exitportal:PhysWake()

		
	end
*/
end 



function ENT:Think()
    -- We don't need to think, we are just a prop after all!
end 

function ENT:OnRemove()
	//self.exitportal:Remove()
end