// Archivo: objects/obj_network_controller/Async_Dialog.gml (CÓDIGO COMPLETO)

var _id = ds_map_find_value(async_load, "id");

// Verificar si la respuesta es de la promesa de IP que creamos
if (_id == client_ip_promise) 
{
    var _status = ds_map_find_value(async_load, "status");
    var _ip = ds_map_find_value(async_load, "result");

    if (_status) // Si el usuario presionó OK
    {
        server_ip = _ip;
        network_mode = 2;
        
        // 1. Creamos el socket
        network_socket = network_create_socket(network_socket_udp); 
        
        // 2. Conectar al Servidor (esto prepara el socket, pero no envía datos)
        network_connect_udp(network_socket, server_ip, NET_PORT);
        
        // 3. ENVIAR SOLICITUD DE CONEXIÓN INMEDIATAMENTE
        var _buffer = buffer_create(64, buffer_fixed, 1);
        buffer_write(_buffer, buffer_u8, NET_PACKET_TYPE.CONNECT_REQUEST);
        
        network_send_udp(network_socket, server_ip, NET_PORT, _buffer, buffer_get_size(_buffer));
        buffer_delete(_buffer);

        // 4. Crear el héroe local (aún sin ID, lo recibirá del servidor)
        instance_create_layer(room_width/2, room_height/2, "Instances", obj_hero);
        room_goto(rm_game); 
    }
}