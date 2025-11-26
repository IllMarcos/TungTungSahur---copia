// Archivo: objects/obj_network_controller/Other_68.gml
var _id = ds_map_find_value(async_load, "id");
var _type = ds_map_find_value(async_load, "type");
var _buffer = ds_map_find_value(async_load, "buffer");

if (_type == network_type_disconnect)
{
    var _player_id_to_remove = ds_map_find_value(player_sockets, _id);
    if (!is_undefined(_player_id_to_remove))
    {
        ds_map_delete(player_sockets, _id);
        with(obj_hero)
        {
            // CORRECCIÓN: Usar net_player_id
            if (variable_instance_exists(id, "net_player_id") && net_player_id == _player_id_to_remove)
            {
                instance_destroy();
            }
        }
    }
    exit;
}

if (_type == network_type_data && !is_undefined(_buffer))
{
    buffer_seek(_buffer, buffer_seek_start, 0);
    var _packet_type = buffer_read(_buffer, buffer_u8);

    // --- SERVIDOR ---
    if (network_mode == 1) 
    {
        var _client_socket = _id;
        var _p_id = ds_map_find_value(player_sockets, _client_socket);
        
        // 1. Solicitud de conexión
        if (_packet_type == NET_PACKET_TYPE.CONNECT_REQUEST)
        {
            // Solo si no lo conocemos ya
            if (is_undefined(_p_id) && player_count < MAX_PLAYERS)
            {
                var _new_id = player_count;
                player_sockets[? _client_socket] = _new_id;
                player_count++;
                
                // Responder al cliente
                var _buff_resp = buffer_create(32, buffer_fixed, 1);
                buffer_write(_buff_resp, buffer_u8, NET_PACKET_TYPE.CONNECT_ACCEPT);
                buffer_write(_buff_resp, buffer_u8, _new_id);
                network_send_udp(_client_socket, server_ip, NET_PORT, _buff_resp, buffer_tell(_buff_resp));
                buffer_delete(_buff_resp);
                
                // Crear el héroe en el servidor
                var _h = instance_create_layer(room_width/2, room_height/2, "Instances", obj_hero);
                // --- ¡AQUÍ ESTABA EL POSIBLE ERROR! ---
                _h.net_player_id = _new_id; // Usamos net_player_id, NO player_id
                _h.is_local_player = false;
                show_debug_message("Nuevo Cliente conectado. ID asignada: " + string(_new_id));
            }
        }
        // 2. Input de movimiento
        else if (_packet_type == NET_PACKET_TYPE.MOVEMENT_INPUT && !is_undefined(_p_id))
        {
            var _id_recv = buffer_read(_buffer, buffer_u8);
            var _move_h = buffer_read(_buffer, buffer_s16);
            var _move_v = buffer_read(_buffer, buffer_s16);
            
            with(obj_hero)
            {
                if (net_player_id == _p_id)
                {
                    if (place_free(x + _move_h, y)) x += _move_h;
                    if (place_free(x, y + _move_v)) y += _move_v;
                    if (_move_h != 0) image_xscale = sign(_move_h);
                }
            }
        }
    }
    // --- CLIENTE ---
    else if (network_mode == 2) 
    {
        if (_packet_type == NET_PACKET_TYPE.CONNECT_ACCEPT)
        {
            var _assigned_id = buffer_read(_buffer, buffer_u8);
            var _hero = instance_find(obj_hero, 0);
            if (instance_exists(_hero))
            {
                _hero.net_player_id = _assigned_id;
                _hero.is_local_player = true;
                show_debug_message("¡Conectado! Mi ID es: " + string(_assigned_id));
            }
        }
        else if (_packet_type == NET_PACKET_TYPE.PLAYER_STATE_UPDATE)
        {
            // Leer todos los jugadores del paquete
            while(buffer_tell(_buffer) < buffer_get_size(_buffer))
            {
                var _uid = buffer_read(_buffer, buffer_u8);
                var _ux = buffer_read(_buffer, buffer_s16);
                var _uy = buffer_read(_buffer, buffer_s16);
                var _uscale = buffer_read(_buffer, buffer_s8);
                var _usprite_name = buffer_read(_buffer, buffer_string);
                var _uindex = buffer_read(_buffer, buffer_f32);
                
                // Buscar si ya existe este personaje
                var _found = false;
                with(obj_hero) {
                    if (net_player_id == _uid) {
                        _found = true;
                        // Actualizar posición (si no soy yo)
                        if (!is_local_player) {
                            x = lerp(x, _ux, 0.3);
                            y = lerp(y, _uy, 0.3);
                            image_xscale = _uscale;
                            var _spr = asset_get_index(_usprite_name);
                            if (_spr > -1) sprite_index = _spr;
                            image_index = _uindex;
                        }
                    }
                }
                
                // --- IMPORTANTE: SI NO EXISTE, LO CREAMOS ---
                if (!_found) {
                    var _new_h = instance_create_layer(_ux, _uy, "Instances", obj_hero);
                    _new_h.net_player_id = _uid;
                    _new_h.is_local_player = false;
                }
            }
        }
    }
}