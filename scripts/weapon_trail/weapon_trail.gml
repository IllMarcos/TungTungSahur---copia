// Create a map assigned to global.trail.
global.trail = ds_map_create();

// Call the function to reset the trail weapon.
// First time, this essentially setps it up.
weapon_trail_reset();

// Define the reset function for the trail weapon.
function weapon_trail_reset() 
{
	// Unlock weapon upgrade.
	ds_map_replace(global.trail, "damage", 1);
	ds_map_replace(global.trail, "attack_speed", 90);
	ds_map_replace(global.trail, "unlocked", false);
}

// Define function to retrieve upgrades for the trail weapon.
function weapon_trail_upgrades(_upgrade_list) 
{
    var _unlocked = ds_map_find_value(global.trail, "unlocked");

    if (!_unlocked)
    {
        var _map = ds_map_create();
        ds_map_replace(_map, "description", "Large but slow\narea attack");
        ds_map_replace(_map, "title", "UNLOCK");
        ds_map_replace(_map, "object", global.trail);
        ds_map_replace(_map, "key", "unlocked");
        ds_map_replace(_map, "amount", 1);
        ds_map_replace(_map, "icon", spr_trail_attack_big);
        ds_map_replace(_map, "weapon_name", "TRAIL");
        ds_map_replace(_map, "price", 10); // 💰 costo

        ds_list_add(_upgrade_list, _map);
        exit;
    }

    var _attack_speed = ds_map_find_value(global.trail, "attack_speed");
    if (_attack_speed > 30)
    {
        var _map = ds_map_create();
        ds_map_replace(_map, "description", "Increase Attack Speed");
        ds_map_replace(_map, "title", "SPEED");
        ds_map_replace(_map, "object", global.trail);
        ds_map_replace(_map, "key", "attack_speed");
        ds_map_replace(_map, "amount", -15);
        ds_map_replace(_map, "icon", spr_trail_attack_big);
        ds_map_replace(_map, "weapon_name", "TRAIL");
        ds_map_replace(_map, "price", 15); // 💰 costo

        ds_list_add(_upgrade_list, _map);
    }

    var _damage = ds_map_find_value(global.trail, "damage");
    if (_damage < 5)
    {
        var _map = ds_map_create();
        ds_map_replace(_map, "description", "Increase Damage");
        ds_map_replace(_map, "title", "DAMAGE");
        ds_map_replace(_map, "object", global.trail);
        ds_map_replace(_map, "key", "damage");
        ds_map_replace(_map, "amount", 1);
        ds_map_replace(_map, "icon", spr_trail_attack_big);
        ds_map_replace(_map, "weapon_name", "TRAIL");
        ds_map_replace(_map, "price", 20); // 💰 costo

        ds_list_add(_upgrade_list, _map);
    }
}
