// Archivo: objects/obj_network_controller/Other_68.gml (Async - Network)

var _id = ds_map_find_value(async_load, "id");
var _type = ds_map_find_value(async_load, "type");
var _buffer = ds_map_find_value(async_load, "buffer");

// Manejo de Desconexión y Errores (no es necesario leer el buffer aquí)
if (_type == network_type_none || _type == network_type_disconnect)
{
    // Lógica de desconexión: Si el socket se desconecta, elimine al jugador del mapa.
    var _player_id_to_remove = ds_map_find_value(global.network_controller.player_sockets, _id);
    if (!is_undefined(_player_id_to_remove))
    {
        ds_map_delete(global.network_controller.player_sockets, _id);
        
        // Opcional: Eliminar la instancia del héroe que se desconectó
        with(obj_hero)
        {
            if (player_id == _player_id_to_remove)
            {
                instance_destroy();
            }
        }
    }
    exit;
}

// =========================================================================
// PROCESAMIENTO DE DATOS (network_type_data)
// =========================================================================
if (_type == network_type_data && !is_undefined(_buffer))
{
    // CORRECCIÓN: buffer_seek requiere 3 argumentos
    buffer_seek(_buffer, buffer_seek_start, 0); 
    var _packet_type = buffer_read(_buffer, buffer_u8);

    if (network_mode == 1) // Lógica del SERVIDOR
    {
        var _client_socket_id = _id;
        var _p_id = ds_map_find_value(global.network_controller.player_sockets, _client_socket_id);
        
        // -------------------------------------------------------------
        // A. MANEJO DE NUEVA CONEXIÓN (Servidor recibe la solicitud)
        // -------------------------------------------------------------
        if (_packet_type == NET_PACKET_TYPE.CONNECT_REQUEST)
        {
            if (is_undefined(_p_id)) // Solo si el socket NO está registrado aún
            {
                if (global.network_controller.player_count < MAX_PLAYERS)
                {
                    var _new_player_id = global.network_controller.player_count;
                    global.network_controller.player_sockets[? _client_socket_id] = _new_player_id; // Registrar el socket -> ID
                    global.network_controller.player_count++;
                    
                    // 1. Enviar ID de vuelta al nuevo cliente
                    var _buffer_out = buffer_create(64, buffer_fixed, 1);
                    buffer_write(_buffer_out, buffer_u8, NET_PACKET_TYPE.CONNECT_ACCEPT);
                    buffer_write(_buffer_out, buffer_u8, _new_player_id); 
                    network_send_packet(network_socket, _client_socket_id, _buffer_out, buffer_get_size(_buffer_out));
                    buffer_delete(_buffer_out);
                    
                    // 2. Crear una instancia del héroe para el nuevo jugador (TungTung2)
                    var _hero = instance_create_layer(room_width / 2 + 100, room_height / 2, "Instances", obj_hero);
                    _hero.player_id = _new_player_id; 
                    _hero.is_local_player = false; 
                }
            }
        }
        
        // -------------------------------------------------------------
        // B. MANEJO DE DATOS RECIBIDOS (Movimiento y ataques)
        // -------------------------------------------------------------
        else if (!is_undefined(_p_id)) // Procesar solo si el jugador ya está identificado
        {
            if (_packet_type == NET_PACKET_TYPE.MOVEMENT_INPUT)
            {
                // Leemos los datos de movimiento (ya se leyó el tipo de paquete y el ID del jugador que envía el paquete)
                var _hspeed_in = buffer_read(_buffer, buffer_s16);
                var _vspeed_in = buffer_read(_buffer, buffer_s16);
                
                // Aplicar input al personaje correcto y moverlo
                with(obj_hero)
                {
                    if (player_id == _p_id) // Usamos el ID identificado por el socket
                    {
                        hspeed = _hspeed_in;
                        vspeed = _vspeed_in;
                        x += hspeed;
                        y += vspeed;
                        keep_in_room(); 
                        
                        // Sincronizar apariencia (CORRECCIÓN DE REFERENCIA DE SPRITE)
                        if (hspeed != 0) image_xscale = sign(hspeed);
                        
                        var _run_sprite = asset_get_index("spr_hero_run_22");
                        var _idle_sprite = asset_get_index("spr_hero_idle"); 
                        
                        if (hspeed != 0 || vspeed != 0) 
                        {
                            if (_run_sprite != -1) sprite_index = _run_sprite;
                        }
                        else 
                        {
                            if (_idle_sprite != -1) sprite_index = _idle_sprite;
                        }
                    }
                }
            }
            else if (_packet_type == NET_PACKET_TYPE.ATTACK_REQUEST)
            {
                 // Lógica de ataque aquí (usando _p_id para identificar quién atacó)
            }
        }
    }

    else if (network_mode == 2) // Lógica del CLIENTE
    {
        if (_packet_type == NET_PACKET_TYPE.CONNECT_ACCEPT)
        {
            client_id = buffer_read(_buffer, buffer_u8);
            
            // Asignar ID al héroe local (TungTung2)
            var _local_hero = instance_find(obj_hero, 0); 
            if (instance_exists(_local_hero))
            {
                _local_hero.player_id = client_id;
                _local_hero.is_local_player = true;
            }
        }
        else if (_packet_type == NET_PACKET_TYPE.PLAYER_STATE_UPDATE)
        {
            // Actualizar la posición y el estado de todos los jugadores
            while (buffer_get_size(_buffer) - buffer_tell(_buffer) > 0)
            {
                var _p_id = buffer_read(_buffer, buffer_u8);
                var _p_x = buffer_read(_buffer, buffer_s16);
                var _p_y = buffer_read(_buffer, buffer_s16);
                var _p_xscale = buffer_read(_buffer, buffer_s8);
                var _p_sprite = buffer_read(_buffer, buffer_string);
                var _p_image_index = buffer_read(_buffer, buffer_f32);
                
                with(obj_hero)
                {
                    if (player_id == _p_id)
                    {
                        // Si es el jugador remoto, forzamos su posición
                        if (!is_local_player) 
                        {
                            x = lerp(x, _p_x, 0.2); 
                            y = lerp(y, _p_y, 0.2);
                        }
                        
                        // Sincronizar apariencia para todos los héroes
                        image_xscale = _p_xscale;
                        var _sprite_asset = asset_get_index(_p_sprite);
                        if (_sprite_asset != -1) 
                        {
                            sprite_index = _sprite_asset;
                        }
                        image_index = _p_image_index;
                    }
                }
            }
        }
    }
}