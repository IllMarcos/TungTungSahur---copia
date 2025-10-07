/// obj_shop: User Event 0  (cerrar tienda de forma segura)
{
    // liberar estructuras
    if (is_undefined(shop_items) == false) {
        for (var i = 0; i < ds_list_size(shop_items); i++) {
            var m = ds_list_find_value(shop_items, i);
            ds_map_destroy(m);
        }
        ds_list_destroy(shop_items);
    }

    // Despausar y cerrar
    unpause();   // o: global.paused = false;
    instance_destroy();
}
