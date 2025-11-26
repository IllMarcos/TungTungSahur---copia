// Archivo: objects/obj_network_controller/Step_0.gml

if (network_mode == 1) // SERVIDOR
{
    var _buffer = buffer_create(1024, buffer_grow, 1);
    buffer_write(_buffer, buffer_u8, NET_PACKET_TYPE.PLAYER_STATE_UPDATE);

    // Escribir datos de todos los héroes
    with(obj_hero)
    {
        if (variable_instance_exists(id, "net_player_id") && net_player_id != -1) 
        {
            buffer_write(_buffer, buffer_u8, net_player_id);
            buffer_write(_buffer, buffer_s16, x);
            buffer_write(_buffer, buffer_s16, y);
            buffer_write(_buffer, buffer_s8, image_xscale);
            buffer_write(_buffer, buffer_string, sprite_get_name(sprite_index));
            buffer_write(_buffer, buffer_f32, image_index);
        }
    }

    // ENVIAR A CADA CLIENTE REGISTRADO
    // Ahora la "key" es el string "IP:PUERTO"
    var _key_str = ds_map_find_first(player_sockets);
    var _size = buffer_tell(_buffer);
    
    while (!is_undefined(_key_str)) 
    {
        // El Host tiene clave -1 o indefinida, lo saltamos si aparece
        if (is_string(_key_str))
        {
            // 1. Separar IP y PUERTO del string "127.0.0.1:5555"
            var _colon_pos = string_pos(":", _key_str);
            var _target_ip = string_copy(_key_str, 1, _colon_pos - 1);
            var _target_port_str = string_copy(_key_str, _colon_pos + 1, string_length(_key_str));
            var _target_port = real(_target_port_str);

            // 2. Enviar a la dirección específica del cliente
            network_send_udp(network_socket, _target_ip, _target_port, _buffer, _size);
        }
        
        _key_str = ds_map_find_next(player_sockets, _key_str);
    }
    
    buffer_delete(_buffer);
}