// ================= RESET =================
mouse_over = false;

// ================= GAMEPAD =================
var _max_pads = gamepad_get_device_count();
if (_max_pads > 0 && gamepad_is_connected(0)) {
    gamepad_set_axis_deadzone(0, 0.5);

    if (gamepad_axis_value(0, gp_axislv) != 0 || gamepad_axis_value(0, gp_axislh) != 0) {
        if (x < 1920 / 2 && gamepad_axis_value(0, gp_axislh) < -0.5) mouse_over = true;
        else if (x > 1920 / 2 && gamepad_axis_value(0, gp_axislh) > 0.5) mouse_over = true;
        else if (gamepad_axis_value(0, gp_axislv) < -0.5) mouse_over = true;
        global.is_mouse = false;
    } else {
        global.is_mouse = true;
    }

    if (gamepad_button_check_pressed(0, gp_face1)) {
        is_clicked = true;
        gamepad_bypass = true;
    }
} else {
    global.is_mouse = true;
}

// ================= RATÓN =================
if (device_mouse_x_to_gui(0) > bbox_left && device_mouse_x_to_gui(0) < bbox_right &&
    device_mouse_y_to_gui(0) > bbox_top && device_mouse_y_to_gui(0) < bbox_bottom &&
    global.is_mouse) {
    mouse_over = true;
}

// ================= REVEAL =================
if (roll_alpha >= 0) {
    mouse_over = false;
    roll_life -= delta_time * 0.000001;
    if (roll_life <= 0) roll_alpha -= delta_time * 0.000001 * 2;
}

// ================= CLICK EN CARTA =================
if (mouse_over) {
    if (mouse_check_button_pressed(mb_left)) {
        audio_play_sound(snd_click, 0, false);
        is_clicked = true;
    }

    if (is_clicked && (mouse_check_button_released(mb_left) || gamepad_bypass)) {
        audio_play_sound(snd_ui_select, 0, false);

        var price = upgrade_data[? "price"];
        if (global.coins >= price) {
            // Pagar
            global.coins -= price;

            // Aplicar mejora
            var _object = upgrade_data[? "object"];
            var _key    = upgrade_data[? "key"];
            var _amount = upgrade_data[? "amount"];

            if (_key == "unlocked") {
                // asegurar activado exacto
                _object[? _key] = 1;
            } else {
                _object[? _key] += _amount;
            }

            // Feedback de compra
            if (asset_get_index("snd_buy") != -1) audio_play_sound(snd_buy, 0, false);

            // Destruye SOLO esta carta (la tienda queda abierta)
            instance_destroy();

        } else {
            error_message = "❌ No tienes suficientes monedas!";
            error_timer = 90;
            if (asset_get_index("snd_error") != -1) audio_play_sound(snd_error, 0, false);
        }
    }
}

// ================= RESET =================
if (mouse_check_button_released(mb_left)) is_clicked = false;
gamepad_bypass = false;
if (error_timer > 0) error_timer--;
