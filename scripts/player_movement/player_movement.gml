// Archivo: scripts/player_movement/player_movement.gml

function player_movement() 
{
    // Si no es el jugador local, no procesamos inputs
    if (!is_local_player) exit;

    // 1. Configuración de velocidad
    var _speed_val = 4;
    var _move_h = 0;
    var _move_v = 0;
    
    // ---------------------------------------------------------
    // A. JOYSTICK VIRTUAL (Touch / Mouse)
    // ---------------------------------------------------------
    var joy_x = 250;
    var joy_y = display_get_gui_height() - 250;
    var joy_radius = 200;

    if (mouse_check_button(mb_left)) 
    {
        var dx = device_mouse_x_to_gui(0) - joy_x;
        var dy = device_mouse_y_to_gui(0) - joy_y;
        var dist = point_distance(joy_x, joy_y, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0));

        if (dist <= joy_radius * 2) 
        {
            var _dir = point_direction(0, 0, dx, dy);
            var _len = min(dist / joy_radius, 1) * _speed_val;
            
            _move_h = lengthdir_x(_len, _dir);
            _move_v = lengthdir_y(_len, _dir);
        }
    }
    
    // ---------------------------------------------------------
    // B. TECLADO (WASD)
    // ---------------------------------------------------------
    var _key_h = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    var _key_v = keyboard_check(ord("S")) - keyboard_check(ord("W"));

    if (_key_h != 0 || _key_v != 0)
    {
        var _dir_key = point_direction(0, 0, _key_h, _key_v);
        _move_h = lengthdir_x(_speed_val, _dir_key);
        _move_v = lengthdir_y(_speed_val, _dir_key);
    }

    // ---------------------------------------------------------
    // 3. APLICAR FÍSICA Y COLISIONES (PREDICCIÓN DE CLIENTE)
    // ---------------------------------------------------------
    // Esto mueve al personaje INMEDIATAMENTE en tu pantalla (Cero Lag visual)
    
    // Horizontal
    if (place_free(x + _move_h, y)) {
        x += _move_h;
    }
    
    // Vertical
    if (place_free(x, y + _move_v)) {
        y += _move_v;
    }

    // Actualizar variables nativas para animaciones
    hspeed = _move_h;
    vspeed = _move_v;

    // ---------------------------------------------------------
    // 4. ANIMACIÓN
    // ---------------------------------------------------------
    if (_move_h != 0) image_xscale = sign(_move_h);

    var _run_sprite = asset_get_index("spr_hero_run_22");
    var _idle_sprite = asset_get_index("spr_hero_idle");
    
    // Solo cambiar sprite si no estamos siendo golpeados
    if (sprite_index != spr_hero_hit)
    {
        if (_move_h != 0 || _move_v != 0)
        {
            if (_run_sprite > -1) sprite_index = _run_sprite;
        }
        else
        {
            if (_idle_sprite > -1) sprite_index = _idle_sprite;
        }
    }
    
    // Mantener dentro de la sala
    keep_in_room();
}