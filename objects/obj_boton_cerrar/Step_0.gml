if (mouse_check_button_pressed(mb_left)) {
    if (position_meeting(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), id)) {
        audio_play_sound(snd_click, 0, false);
        if (instance_exists(panel_padre)) {
            with(panel_padre) {
                instance_destroy();
            }
        }
        instance_destroy(); // Destruye el botón también
    }
}
