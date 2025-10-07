// Create a map assigned to global.swipe
global.swipe = ds_map_create();

// Call the function to reset the swipe weapon.
// First time, this essentially setps it up.
weapon_swipe_reset();

// Define the reset function for the swipe weapon.
function weapon_swipe_reset() 
{
	// Reset swipe weapon values.
	ds_map_replace(global.swipe, "damage", 1);
	ds_map_replace(global.swipe, "attack_speed", 60);
	ds_map_replace(global.swipe, "unlocked", false);
}

// Decalre a function to get the swipe weapon upgrades.
function weapon_swipe_upgrades(_upgrade_list) 
{
    var _unlocked = ds_map_find_value(global.swipe, "unlocked");

    if (!_unlocked)
    {
        var _map = ds_map_create();
        ds_map_replace(_map, "description", "Small but fast\narea attack");
        ds_map_replace(_map, "title", "UNLOCK");
        ds_map_replace(_map, "object", global.swipe);
        ds_map_replace(_map, "key", "unlocked");
        ds_map_replace(_map, "amount", 1);
        ds_map_replace(_map, "icon", spr_arcing_attack_big);
        ds_map_replace(_map, "weapon_name", "SWIPE");
        ds_map_replace(_map, "price", 10); // 💰 costo

        ds_list_add(_upgrade_list, _map);
        exit;
    }

    var _attack_speed = ds_map_find_value(global.swipe, "attack_speed");
    if (_attack_speed > 10)
    {
        var _map = ds_map_create();
        ds_map_replace(_map, "description", "Increase Attack Speed");
        ds_map_replace(_map, "title", "SPEED");
        ds_map_replace(_map, "object", global.swipe);
        ds_map_replace(_map, "key", "attack_speed");
        ds_map_replace(_map, "amount", -10);
        ds_map_replace(_map, "icon", spr_arcing_attack_big);
        ds_map_replace(_map, "weapon_name", "SWIPE");
        ds_map_replace(_map, "price", 15); // 💰 costo

        ds_list_add(_upgrade_list, _map);
    }

    var _damage = ds_map_find_value(global.swipe, "damage");
    if (_damage < 5)
    {
        var _map = ds_map_create();
        ds_map_replace(_map, "description", "Increase Damage");
        ds_map_replace(_map, "title", "DAMAGE");
        ds_map_replace(_map, "object", global.swipe);
        ds_map_replace(_map, "key", "damage");
        ds_map_replace(_map, "amount", 1);
        ds_map_replace(_map, "icon", spr_arcing_attack_big);
        ds_map_replace(_map, "weapon_name", "SWIPE");
        ds_map_replace(_map, "price", 20); // 💰 costo

        ds_list_add(_upgrade_list, _map);
    }
}
