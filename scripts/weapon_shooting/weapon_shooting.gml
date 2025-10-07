// Create map to store the shooting weapon data.
global.shooting = ds_map_create();

// Call function to reset the shooting weapon state.
weapon_shooting_reset();

// Define the function to reset the shooting weapon state.
function weapon_shooting_reset() 
{
	// Shooting weapon bases stats.
	// Shooting weapon starts unlocked as it's the first weapon.
	ds_map_replace(global.shooting, "damage", 0.75);
	ds_map_replace(global.shooting, "attack_speed", 30);
	ds_map_replace(global.shooting, "number_of_shots", 1);
	ds_map_replace(global.shooting, "unlocked", true);
}

// Define function to retrieve list of available shooting
// weapon upgrades.
function weapon_shooting_upgrades(_upgrade_list) 
{
    var _unlocked = ds_map_find_value(global.shooting, "unlocked");

    if (!_unlocked)
    {
        var _map = ds_map_create();
        ds_map_replace(_map, "description", "Unlock Shooting\nWeapon");
        ds_map_replace(_map, "title", "UNLOCK");
        ds_map_replace(_map, "object", global.shooting);
        ds_map_replace(_map, "key", "unlocked");
        ds_map_replace(_map, "amount", 1);
        ds_map_replace(_map, "icon", spr_shooting_attack_big);
        ds_map_replace(_map, "weapon_name", "PROJECTILE");
        ds_map_replace(_map, "price", 10); // 💰 costo

        ds_list_add(_upgrade_list, _map);
        exit;
    }

    var _attack_speed = ds_map_find_value(global.shooting, "attack_speed");
    if (_attack_speed > 5)
    {
        var _map = ds_map_create();
        ds_map_replace(_map, "description", "Increase Attack Speed");
        ds_map_replace(_map, "title", "SPEED");
        ds_map_replace(_map, "object", global.shooting);
        ds_map_replace(_map, "key", "attack_speed");
        ds_map_replace(_map, "amount", -5);
        ds_map_replace(_map, "icon", spr_shooting_attack_big);
        ds_map_replace(_map, "weapon_name", "PROJECTILE");
        ds_map_replace(_map, "price", 15); // 💰 costo

        ds_list_add(_upgrade_list, _map);
    }

    var _number_of_shots = ds_map_find_value(global.shooting, "number_of_shots");
    if (_number_of_shots < 7)
    {
        var _map = ds_map_create();
        ds_map_replace(_map, "description", "Number of shots +2");
        ds_map_replace(_map, "title", "BARRAGE");
        ds_map_replace(_map, "object", global.shooting);
        ds_map_replace(_map, "key", "number_of_shots");
        ds_map_replace(_map, "amount", 2);
        ds_map_replace(_map, "icon", spr_shooting_attack_big);
        ds_map_replace(_map, "weapon_name", "PROJECTILE");
        ds_map_replace(_map, "price", 20); // 💰 costo

        ds_list_add(_upgrade_list, _map);
    }

    var _damage = ds_map_find_value(global.shooting, "damage");
    if (_damage < 4)
    {
        var _map = ds_map_create();
        ds_map_replace(_map, "description", "Increase Damage");
        ds_map_replace(_map, "title", "DAMAGE");
        ds_map_replace(_map, "object", global.shooting);
        ds_map_replace(_map, "key", "damage");
        ds_map_replace(_map, "amount", 0.4);
        ds_map_replace(_map, "icon", spr_shooting_attack_big);
        ds_map_replace(_map, "weapon_name", "PROJECTILE");
        ds_map_replace(_map, "price", 25); // 💰 costo

        ds_list_add(_upgrade_list, _map);
    }
}
