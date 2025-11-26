// Si el juego está en pausa, no dibujamos nada
if (global.paused) {
    exit;
}


// JOYSTICK
var joy_x = 250;
var joy_y = display_get_gui_height() - 250;
var joy_radius = 200;

// Dibujar base del joystick
draw_sprite(spr_joystick_big, 0, joy_x, joy_y);


// Dibujar palanca (thumb)
if (mouse_check_button(mb_left)) {
    var dx = device_mouse_x_to_gui(0) - joy_x;
    var dy = device_mouse_y_to_gui(0) - joy_y;
    var dist = point_distance(joy_x, joy_y, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0));

    // Solo mover si el click está dentro del área del joystick
    if (dist <= joy_radius * 2) {
        if (dist > joy_radius) {
            dx = lengthdir_x(joy_radius, point_direction(0, 0, dx, dy));
            dy = lengthdir_y(joy_radius, point_direction(0, 0, dx, dy));
        }
        draw_sprite(spr_joystick_small, 0, joy_x + dx, joy_y + dy);
    } else {
        // Si clickeas fuera, queda fijo al centro
        draw_sprite(spr_joystick_small, 0, joy_x, joy_y);
    }
} else {
    // Si no está presionado, la palanca se queda en el centro
    draw_sprite(spr_joystick_small, 0, joy_x, joy_y);
}

