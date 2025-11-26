/// @description Async - Networking

var _type = ds_map_find_value(async_load, "type");
var _buffer = ds_map_find_value(async_load, "buffer");
var _id = ds_map_find_value(async_load, "id");

// =========================================================================
// 1. OBTENER IDENTIFICACIÓN DEL REMITENTE (CRUCIAL PARA UDP)
// =========================================================================
// En UDP, 'id' es siempre nuestro propio socket.
// Para saber quién nos habla, necesitamos su IP y Puerto.
var _sender_ip = ds_map_find_value(async_load, "ip");
var _sender_port = ds_map_find_value(async_load, "port");

// Creamos una "Clave Única" para este cliente (Ej: "192.168.1.50:54321")
var _client_key = string(_sender_ip) + ":" + string(_sender_port);

// =========================================================================
// 2. PROCESAMIENTO DE DATOS
// =========================================================================
if (_type == network_type_data && !is_undefined(_buffer))
{
    buffer_seek(_buffer, buffer_seek_start, 0);
    var _packet_type = buffer_read(_buffer, buffer_u8);

    // ---------------------------------------------------------------------
    // A. LÓGICA DEL SERVIDOR (Recibe inputs y peticiones)
    // ---------------------------------------------------------------------
    if (network_mode == 1) 
    {
        // Buscamos si ya conocemos a este cliente por su clave IP:Puerto
        var _p_id = ds_map_find_value(player_sockets, _client_key);

        // --- CASO 1: NUEVA CONEXIÓN ---
        if (_packet_type == NET_PACKET_TYPE.CONNECT_REQUEST)
        {
            // Si es un desconocido y tenemos espacio
            if (is_undefined(_p_id) && player_count < MAX_PLAYERS)
            {
                var _new_id = player_count;
                
                // REGISTRARLO: Asociamos la clave "IP:Puerto" al ID del jugador
                player_sockets[? _client_key] = _new_id;
                player_count++;
                
                show_debug_message("SERVIDOR: Cliente aceptado. Key: " + _client_key + " -> ID: " + string(_new_id));

                // 1. Responder al cliente (Aceptación)
                var _buff_resp = buffer_create(32, buffer_fixed, 1);
                buffer_write(_buff_resp, buffer_u8, NET_PACKET_TYPE.CONNECT_ACCEPT);
                buffer_write(_buff_resp, buffer_u8, _new_id);
                
                // IMPORTANTE: Enviar específicamente a la IP y Puerto del remitente
                network_send_udp(network_socket, _sender_ip, _sender_port, _buff_resp, buffer_tell(_buff_resp));
                buffer_delete(_buff_resp);
                
                // 2. Crear el muñeco del cliente en el servidor
                var _h = instance_create_layer(room_width/2, room_height/2, "Instances", obj_hero);
                _h.net_player_id = _new_id;
                _h.is_local_player = false; // El servidor no controla este muñeco directamente
            }
        }
        
        // --- CASO 2: INPUT DE MOVIMIENTO ---
        else if (_packet_type == NET_PACKET_TYPE.MOVEMENT_INPUT && !is_undefined(_p_id))
        {
            // Leer datos del paquete
            var _id_recv = buffer_read(_buffer, buffer_u8); 
            var _move_h = buffer_read(_buffer, buffer_s16);
            var _move_v = buffer_read(_buffer, buffer_s16);
            
            // Buscar al héroe correcto y moverlo
            with(obj_hero)
            {
                // Usamos net_player_id para identificar
                if (variable_instance_exists(id, "net_player_id") && net_player_id == _p_id)
                {
                    // Mover respetando colisiones
                    if (place_free(x + _move_h, y)) x += _move_h;
                    if (place_free(x, y + _move_v)) y += _move_v;
                    
                    // Girar sprite
                    if (_move_h != 0) image_xscale = sign(_move_h);
                }
            }
        }
    }
    
    // ---------------------------------------------------------------------
    // B. LÓGICA DEL CLIENTE (Recibe estado del mundo)
    // ---------------------------------------------------------------------
    else if (network_mode == 2) 
    {
        // --- CASO 1: CONFIRMACIÓN DE CONEXIÓN ---
        if (_packet_type == NET_PACKET_TYPE.CONNECT_ACCEPT)
        {
            var _assigned_id = buffer_read(_buffer, buffer_u8);
            
            // >>> NUEVO: Guardar mi ID en el controlador para no olvidarlo al cambiar de Room <<<
            client_id = _assigned_id;
            
            // Intentar usar la referencia guardada en el Room Start (identidad segura)
            if (variable_instance_exists(id, "local_hero_reference") && instance_exists(local_hero_reference))
            {
                local_hero_reference.net_player_id = _assigned_id;
                local_hero_reference.is_local_player = true;
                show_debug_message("CLIENTE: ¡Conectado! Soy ID: " + string(_assigned_id));
            }
            else 
            {
                // Fallback: Buscar cualquier héroe sin ID (menos seguro pero funcional)
                var _h = instance_find(obj_hero, 0);
                if (instance_exists(_h)) {
                    _h.net_player_id = _assigned_id;
                    _h.is_local_player = true;
                }
            }
        }
        
        // --- CASO 2: ACTUALIZACIÓN DE POSICIONES (STATE UPDATE) ---
        else if (_packet_type == NET_PACKET_TYPE.PLAYER_STATE_UPDATE)
        {
            // Leer mientras haya datos en el buffer
            while(buffer_tell(_buffer) < buffer_get_size(_buffer))
            {
                var _uid = buffer_read(_buffer, buffer_u8);
                var _ux = buffer_read(_buffer, buffer_s16);
                var _uy = buffer_read(_buffer, buffer_s16);
                var _uscale = buffer_read(_buffer, buffer_s8);
                var _usprite_name = buffer_read(_buffer, buffer_string);
                var _uindex = buffer_read(_buffer, buffer_f32);
                
                var _found = false;
                
                // Buscar si este héroe ya existe en mi juego
                with(obj_hero) 
                {
                    if (variable_instance_exists(id, "net_player_id") && net_player_id == _uid) 
                    {
                        _found = true;
                        
                        // >>> LÓGICA DE MOVIMIENTO SUAVE <<<
                        if (is_local_player) 
                        {
                            // SI SOY YO: Solo acepto la posición del servidor si estoy MUY lejos (Lagazo)
                            // Si la diferencia es pequeña, ignoro al servidor y confío en mi predicción local.
                            if (point_distance(x, y, _ux, _uy) > 50) {
                                x = _ux;
                                y = _uy;
                            }
                        }
                        else 
                        {
                            // SI ES EL OTRO: Lo muevo suavemente hacia donde dice el servidor
                            x = lerp(x, _ux, 0.3);
                            y = lerp(y, _uy, 0.3);
                            
                            // Actualizar gráficos del remoto
                            image_xscale = _uscale;
                            var _spr = asset_get_index(_usprite_name);
                            if (_spr > -1) sprite_index = _spr;
                            image_index = _uindex;
                        }
                    }
                }
                
                // Si no existe, lo creamos (ej: acaba de entrar otro jugador)
                if (!_found) 
                {
                    var _new_h = instance_create_layer(_ux, _uy, "Instances", obj_hero);
                    _new_h.net_player_id = _uid;
                    _new_h.is_local_player = false; // Por defecto es remoto
                }
            }
        }
        
        // --- CASO 3: CAMBIO DE SALA ---
        else if (_packet_type == NET_PACKET_TYPE.CHANGE_ROOM)
        {
            var _target_room = buffer_read(_buffer, buffer_u16);
            room_goto(_target_room);
        }
    }
}