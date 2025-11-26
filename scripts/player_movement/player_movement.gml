// Archivo: scripts/player_movement/player_movement.gml (CORREGIDO PARA TECLADO Y JOYSTICK)

function player_movement() 
{
    if (!is_local_player) exit;

    // 1. Definir velocidad y resetear variables temporales
    var _speed_val = 4;
    var _move_h = 0;
    var _move_v = 0;
    
    // ---------------------------------------------------------
    // A. JOYSTICK VIRTUAL (Pantalla táctil / Mouse)
    // ---------------------------------------------------------
    var joy_x = 250;
    var joy_y = display_get_gui_height() - 250;
    var joy_radius = 200;
    
    // Detectar si se está usando el joystick virtual
    if (mouse_check_button(mb_left)) 
    {
        var dx = device_mouse_x_to_gui(0) - joy_x;
        var dy = device_mouse_y_to_gui(0) - joy_y;
        var dist = point_distance(joy_x, joy_y, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0));
        
        // Si el toque está cerca del área del joystick
        if (dist <= joy_radius * 2) 
        {
            var _dir = point_direction(0, 0, dx, dy);
            var _len = min(dist / joy_radius, 1) * _speed_val;
            
            _move_h = lengthdir_x(_len, _dir);
            _move_v = lengthdir_y(_len, _dir);
        }
    }
    
    // ---------------------------------------------------------
    // B. TECLADO (WASD) - Sobrescribe o suma al joystick
    // ---------------------------------------------------------
    var _key_h = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    var _key_v = keyboard_check(ord("S")) - keyboard_check(ord("W"));

    if (_key_h != 0 || _key_v != 0)
    {
        var _dir_key = point_direction(0, 0, _key_h, _key_v);
        _move_h = lengthdir_x(_speed_val, _dir_key);
        _move_v = lengthdir_y(_speed_val, _dir_key);
    }

    // Aplicar el movimiento calculado a las variables nativas
    hspeed = _move_h;
    vspeed = _move_v;

    // ---------------------------------------------------------
    // 2. ANIMACIÓN
    // ---------------------------------------------------------
    if (hspeed != 0) image_xscale = sign(hspeed);
    
    // Usa nombres de recursos directos (asegúrate que existen en tu proyecto)
    // Si te da error, usa asset_get_index("nombre_string")
    var _run_sprite = asset_get_index("spr_hero_run_22"); 
    var _idle_sprite = asset_get_index("spr_hero_idle");
    
    if (sprite_index != spr_hero_hit)
    {
        if (hspeed != 0 || vspeed != 0)
        {
            if (_run_sprite > -1) sprite_index = _run_sprite;
        }
        else
        {
            if (_idle_sprite > -1) sprite_index = _idle_sprite;
        }
    }

    // ---------------------------------------------------------
    // 3. SINCRONIZACIÓN DE RED
    // ---------------------------------------------------------
    var _net_mode = 0;
    if (instance_exists(global.network_controller)) _net_mode = global.network_controller.network_mode;

    // CLIENTE (Modo 2)
    if (_net_mode == 2) 
    {
        if (hspeed != 0 || vspeed != 0)
        {
            var _buffer = buffer_create(32, buffer_fixed, 1);
            buffer_write(_buffer, buffer_u8, NET_PACKET_TYPE.MOVEMENT_INPUT);
            buffer_write(_buffer, buffer_u8, net_player_id);
            buffer_write(_buffer, buffer_s16, hspeed); 
            buffer_write(_buffer, buffer_s16, vspeed);
            network_send_udp(global.network_controller.network_socket, global.network_controller.server_ip, NET_PORT, _buffer, buffer_tell(_buffer));
            buffer_delete(_buffer);
        }
        
        // Predicción de cliente
        if (place_free(x + hspeed, y)) x += hspeed;
        if (place_free(x, y + vspeed)) y += vspeed;
    }
    // SERVIDOR (Modo 1) O OFFLINE (Modo 0)
    else 
    {
        if (place_free(x + hspeed, y)) x += hspeed;
        if (place_free(x, y + vspeed)) y += vspeed;
    }
}