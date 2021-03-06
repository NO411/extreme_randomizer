extreme_randomizer = {
        items = {},
        random_craft = {},
	drops = {},
	random_drops = {},
}

minetest.register_on_mods_loaded(function()
	for item, def in pairs(minetest.registered_items) do
		if def.groups.not_in_creative_inventory ~= 1 then
		        table.insert(extreme_randomizer.items, item)
		end
	end
	for _, item in pairs(extreme_randomizer.items) do
		extreme_randomizer.random_craft[item] = extreme_randomizer.items[math.random(#extreme_randomizer.items)]
	end
        for node, def in pairs(minetest.registered_nodes) do
                minetest.override_item(node, {
                        drop = extreme_randomizer.items[math.random(#extreme_randomizer.items)],
                })
        end
	for entity, def in pairs(minetest.registered_entities) do
		local drops = def.drops
		if drops then
			table.insert(extreme_randomizer.drops, drops)
		end
	end
	for entity, def in pairs(minetest.registered_entities) do
		local drops = def.drops
		if drops then
			extreme_randomizer.random_drops[entity] = extreme_randomizer.drops[math.random(#extreme_randomizer.drops)]
		end
	end
	for entity, def in pairs(minetest.registered_entities) do
		if def.drops then
			def.drops = extreme_randomizer.random_drops[entity]
		end
	end
end)

for _, craft in pairs({ "craft_predict", "on_craft" }) do
        minetest["register_" .. craft](function(itemstack)
        	itemstack:set_name(extreme_randomizer.random_craft[itemstack:get_name()])
        	return itemstack
        end)
end
