if (place_meeting(x, y, obj_hero)) {
    // El héroe está dentro del área de la tienda
    if (!instance_exists(obj_upgrade_screen)) {
        instance_create_layer(1920/2, 1080/2, "shopUI", obj_upgrade_screen);
    }
} else {
    // El héroe salió del área
    if (instance_exists(obj_upgrade_screen)) {
        with (obj_upgrade_screen) instance_destroy();
        with (obj_upgrade) instance_destroy();
        with (obj_boton_tienda) instance_destroy();
    }
}
