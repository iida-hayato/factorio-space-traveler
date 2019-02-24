-- Space Traveler


-- INITIALIZATION --
local function init_globals()
	-- List of all factories
	global.factories = global.factories or {}
	-- Map: Save name -> Factory it is currently saving
	global.saved_factories = global.saved_factories or {}
	-- Map: Player or robot -> Save name to give him on the next relevant event
	global.pending_saves = global.pending_saves or {}
	-- Map: Entity unit number -> Factory it is a part of
	global.factories_by_entity = global.factories_by_entity or {}
	-- Map: Surface name -> list of factories on it
	global.surface_factories = global.surface_factories or {}
	-- Map: Surface name -> number of used factory spots on it
	global.surface_factory_counters = global.surface_factory_counters or {}
	-- Scalar
	global.next_factory_surface = global.next_factory_surface or 0
	-- Map: Player index -> Last teleport time
	global.last_player_teleport = global.last_player_teleport or {}
	-- Map: Player index -> Whether preview is activated
	global.player_preview_active = global.player_preview_active or {}

end

-- Generate Planets
local function generate_planets()
	local surface = game.create_surface("surface_name1", {seed = 0, width = 0, height = 0, 
	autoplace_settings = {
		 tile = {
			  settings = {
				   grass = {
					    "very-high", "very-high", "very-high"} } } } })
	if game.surfaces["surface_name1"] ~= nil then
		game.print("dekita")
	end
end


script.on_init(function()
    init_globals()
    generate_planets()
end)


-- TRAVEL --

local function enter_factory(player, factory)
	player.teleport({0, 0},game.surfaces["surface_name1"])
	global.last_player_teleport[player.index] = game.tick
	-- update_camera(player)
end

local function leave_factory(player, factory)
	player.teleport({1, 1},game.surfaces["nauvis"])
	global.last_player_teleport[player.index] = game.tick
	-- update_camera(player)
	-- update_overlay(factory)
end



-- Factory buildings are entities of type "storage-tank" internally, because reasons
local BUILDING_TYPE = "wood-chest"
local function find_factory_by_building(surface, area)
	local candidates = surface.find_entities_filtered{area=area, type=BUILDING_TYPE}
	game.print("teleport")
	for _,entity in pairs(candidates) do
		game.print(entity.name)
	end
	return nil
end


local function teleport_players()
	local tick = game.tick
	for player_index, player in pairs(game.players) do
		if player.connected and not player.driving and tick - (global.last_player_teleport[player_index] or 0) >= 45 then
			local walking_state = player.walking_state
			if walking_state.walking then
				if walking_state.direction == defines.direction.north
				or walking_state.direction == defines.direction.northeast
				or walking_state.direction == defines.direction.northwest then
					-- Enter factory
					enter_factory(player, factory)
					-- local portal = find_factory_by_building(player.surface, {{player.position.x-0.2, player.position.y-0.3},{player.position.x+0.2, player.position.y}})
					-- if factory ~= nil then
					-- 	if math.abs(player.position.x-factory.outside_x)<0.6 then
					-- 		enter_factory(player, factory)
					-- 	end
					-- end
				elseif walking_state.direction == defines.direction.south
				or walking_state.direction == defines.direction.southeast
				or walking_state.direction == defines.direction.southwest then
					leave_factory(player, factory)
					-- local factory = find_surrounding_factory(player.surface, player.position)
					-- if factory ~= nil then
					-- 	if player.position.y > factory.inside_door_y+1 then
					-- 		leave_factory(player, factory)
					-- 	end
					-- end
				end
			end
		end
	end
end

script.on_event(defines.events.on_tick, function(event)
	-- game.print(game.players[1].surface.name)
	-- Teleport players
	teleport_players()
end)
