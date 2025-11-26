// obj_network_controller - Step Event
if (network_mode == 1) // SERVIDOR
{
    // Preparamos el paquete de actualización
    var _buffer = buffer_create(1024, buffer_grow, 1);
    buffer_write(_buffer, buffer_u8, NET_PACKET_TYPE.PLAYER_STATE_UPDATE);

    // Escribimos los datos de CADA héroe
    with(obj_hero)
    {
        // IMPORTANTE: Usamos 'net_player_id', no 'player_id'
        if (variable_instance_exists(id, "net_player_id") && net_player_id != -1) 
        {
            buffer_write(_buffer, buffer_u8, net_player_id);
            buffer_write(_buffer, buffer_s16, x);
            buffer_write(_buffer, buffer_s16, y);
            buffer_write(_buffer, buffer_s8, image_xscale);
            // Enviamos nombre del sprite como string para evitar líos de índices
            buffer_write(_buffer, buffer_string, sprite_get_name(sprite_index));
            buffer_write(_buffer, buffer_f32, image_index);
        }
    }

    // Enviar a TODOS los clientes en la lista
    var _socket_key = ds_map_find_first(player_sockets);
    var _size = buffer_tell(_buffer);
    
    while (!is_undefined(_socket_key)) 
    {
        // Enviar por UDP
        network_send_udp(_socket_key, server_ip, NET_PORT, _buffer, _size);
        _socket_key = ds_map_find_next(player_sockets, _socket_key);
    }
    
    buffer_delete(_buffer);
}