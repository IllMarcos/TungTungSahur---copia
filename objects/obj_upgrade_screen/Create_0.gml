// Pausar el juego (tu pause/unpause siguen como están)
//pause();

// --- Generar TODAS las mejoras disponibles una sola vez ---
var upgrades_list = ds_list_create();
weapon_shooting_upgrades(upgrades_list);
weapon_swipe_upgrades(upgrades_list);
weapon_trail_upgrades(upgrades_list);

// Acomodarlas en filas de 3
var cols = 3;
var start_x = 420;
var start_y = 360;
var gap_x  = 480;
var gap_y  = 520;

for (var i = 0; i < ds_list_size(upgrades_list); i++) {
    var u = upgrades_list[| i];
    var col = i mod cols;
    var row = i div cols;

    var xx = start_x + col * gap_x;
    var yy = start_y + row * gap_y;

    // Las cartas se dibujan en Draw GUI, así que la capa da igual; usa la que prefieras
    var inst = instance_create_layer(xx, yy, "Instances", obj_upgrade);
    inst.upgrade_data = u;
}
ds_list_destroy(upgrades_list);

// Botón cerrar (se dibuja en Draw GUI también)
instance_create_layer(1920 - 110, 110, "Instances", obj_boton_tienda);
