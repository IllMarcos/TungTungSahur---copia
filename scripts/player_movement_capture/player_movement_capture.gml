// Archivo: scripts/player_movement/player_movement_capture.gml

function player_movement_capture() 
{
    // Posición fija del joystick (abajo izquierda)
    var joy_x = 250;
    var joy_y = display_get_gui_height() - 250; 
    var joy_radius = 200; // radio del joystick

    // Reiniciar velocidad para la captura del frame actual
    hspeed = 0;
    vspeed = 0; 

    // ========================
    // 1. INPUT: JOYSTICK FIJO (Móvil)
    // ========================
    if (mouse_check_button(mb_left)) 
    {
        var dx = device_mouse_x_to_gui(0) - joy_x;
        var dy = device_mouse_y_to_gui(0) - joy_y; 
        var dist = point_distance(joy_x, joy_y, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0));
        
        // Solo mover si el click está cerca del joystick
        if (dist <= joy_radius * 2) 
        {
            if (dist > joy_radius) {
                dx = lengthdir_x(joy_radius, point_direction(0,0,dx,dy));
                dy = lengthdir_y(joy_radius, point_direction(0,0,dx,dy)); 
            }

            hspeed = dx * 0.2;
            vspeed = dy * 0.2;
        }
    }
    else
    {
        // ========================
        // 2. INPUT: GAMEPAD
        // ========================
        var _max_pads = gamepad_get_device_count();
        if (_max_pads > 0 && gamepad_is_connected(0)) 
        {
            gamepad_set_axis_deadzone(0, 0.1);
            if (gamepad_axis_value(0, gp_axislv) != 0 || gamepad_axis_value(0, gp_axislh) != 0) 
            {
                vspeed += 10 * gamepad_axis_value(0, gp_axislv);
                hspeed += 10 * gamepad_axis_value(0, gp_axislh);
            }
        }

        // ========================
        // 3. INPUT: TECLADO (PC)
        // ========================
        if (keyboard_check(ord("W"))) vspeed += -10;
        if (keyboard_check(ord("S"))) vspeed += 10;
        if (keyboard_check(ord("A"))) hspeed += -10;
        if (keyboard_check(ord("D"))) hspeed += 10;
    }

    // ========================
    // Normalizar velocidad
    // ========================
    var _speed = sqrt(sqr(hspeed) + sqr(vspeed));
    if (_speed > 10) 
    {
        hspeed *= 10 / _speed;
        vspeed *= 10 / _speed;
    }

    // ========================
    // Animación y dirección
    // ========================
    if (hspeed != 0) {
        image_xscale = sign(hspeed);
    }

    if (sprite_index != spr_hero_hit)
    {
        if (hspeed != 0 || vspeed != 0)
        {
            sprite_index = spr_hero_run_22;
        }
        else
        {
            sprite_index = spr_hero_idle;
        }
    }

    // ============================================================
    // APLICAR MOVIMIENTO (FIX OFFLINE Y ONLINE)
    // ============================================================
    // Antes solo dejábamos mover si (mode == 1 || mode == 2).
    // Ahora permitimos mover SIEMPRE que sea el jugador local.
    // Esto arregla el botón de "Play" normal (Modo 0).
    
    if (is_local_player)
    {
        // Moverse localmente aplicando colisiones
        // Usamos place_free para no atravesar paredes
        
        if (place_free(x + hspeed, y)) {
            x += hspeed;
        }
        
        if (place_free(x, y + vspeed)) {
            y += vspeed;
        }
    }
}