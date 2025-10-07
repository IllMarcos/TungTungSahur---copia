// ============================
// obj_shop - Create Event
// ============================

// Lista de ítems disponibles en la tienda
shop_items = ds_list_create();

// Ejemplo de ítems (puedes añadir más)
var _map1 = ds_map_create();
ds_map_add(_map1, "title", "SPEED");
ds_map_add(_map1, "description", "Aumenta velocidad de ataque");
ds_map_add(_map1, "price", 15);
ds_map_add(_map1, "icon", spr_shooting_attack_big);
ds_list_add(shop_items, _map1);

var _map2 = ds_map_create();
ds_map_add(_map2, "title", "DAMAGE");
ds_map_add(_map2, "description", "Aumenta daño del héroe");
ds_map_add(_map2, "price", 25);
ds_map_add(_map2, "icon", spr_arcing_attack_big);
ds_list_add(shop_items, _map2);

// Selección inicial
selected = -1;

// Variables para mensajes de error
error_timer = 0;
error_message = "";

// Crear botón de cerrar
close_button = instance_create_layer(0, 0, "UpgradeScreen", obj_boton_tienda);
close_button.parent_shop = id;
