if (mouse_check_button_pressed(mb_left)) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    if (point_distance(mx, my, x, y) < 30) {
        // Destruir la tienda al cerrar
        with (obj_upgrade) instance_destroy();
        with (obj_upgrade_screen) instance_destroy();
        instance_destroy(); // destruir el botón mismo
    }
}
