// Archivo: objects/obj_network_controller/Step_0.gml

if (network_mode == 1) // Solo el Servidor (Host) ejecuta esto
{
    // Crear el paquete de actualización de estado
    var _buffer = buffer_create(512, buffer_grow, 1);
    buffer_write(_buffer, buffer_u8, NET_PACKET_TYPE.PLAYER_STATE_UPDATE);

    // Iterar sobre todos los objetos obj_hero para enviar su estado
    with(obj_hero)
    {
        if (player_id != -1) 
        {
            buffer_write(_buffer, buffer_u8, player_id);
            buffer_write(_buffer, buffer_s16, x);
            buffer_write(_buffer, buffer_s16, y);
            buffer_write(_buffer, buffer_s8, image_xscale);
            buffer_write(_buffer, buffer_string, sprite_get_name(sprite_index));
            buffer_write(_buffer, buffer_f32, image_index);
        }
    }

    // Enviar a todos los clientes
    var _keys = ds_map_keys(player_sockets);
    var _buffer_size = buffer_get_size(_buffer); 
    
    for(var i = 0; i < ds_list_size(_keys); i++)
    {
        var _socket_id = ds_list_find_value(_keys, i); 
        
        // Si el socket es -1, es el jugador local (Host), no enviamos por red.
        if (_socket_id != -1) 
        {
            // CORRECCIÓN: network_send_packet requiere 4 argumentos: socket_principal, id_destino, buffer, tamaño
            network_send_packet(network_socket, _socket_id, _buffer, _buffer_size); 
        }
    }
    buffer_delete(_buffer);
    ds_list_destroy(_keys);
}