
ENT.Type				= "anim"
ENT.RenderGroup			= RENDERGROUP_BOTH // fixes translucent stuff rendering behind the portal
ENT.Spawnable			= false
ENT.AdminOnly			= false
ENT.Editable			= false

caro_tableofportals = {}



function ENT:Initialize()

	local mins = Vector( 0, -60/2, -105/2 )
	local maxs = Vector( 0, 60/2, 105/2)

	if CLIENT then

		self:SetRenderBounds( mins, maxs )

	else

		self:SetTrigger( true )

	end

	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_OBB )
	self:SetNotSolid( true )
	//self:SetCollisionBounds( mins, maxs )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )

	self:DrawShadow( false )

end




function ENT:SetupDataTables()


end
