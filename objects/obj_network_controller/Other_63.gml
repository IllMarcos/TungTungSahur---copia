// Archivo: objects/obj_network_controller/Other_63.gml
var _id = ds_map_find_value(async_load, "id");

if (_id == client_ip_promise) 
{
    var _status = ds_map_find_value(async_load, "status");
    var _ip_input = ds_map_find_value(async_load, "result"); 

    if (_status) 
    {
        // Validación de longitud mínima
        if (string_length(_ip_input) < 7) 
        {
            show_message_async("Error: La dirección IP es demasiado corta.");
            exit; 
        }

        // --- 2. INTENTO DE CREACIÓN DEL SOCKET ---
        var _temp_socket = network_create_socket(network_socket_udp);
        if (_temp_socket < 0) 
        {
            show_message_async("Error crítico: No se pudo crear el sistema de red.");
            exit;
        }

        // --- CORRECCIÓN AQUÍ ---
        // Eliminamos 'network_connect'. No es necesario para UDP y causa el congelamiento.
        // Asumimos que si el socket se creó (_temp_socket >= 0), podemos intentar enviar.
        
        // --- 4. APLICAR CONFIGURACIÓN DIRECTAMENTE ---
        server_ip = _ip_input;
        network_mode = 2;
        network_socket = _temp_socket;

        // Enviar solicitud de conexión inmediata ("Toc Toc")
        var _buffer = buffer_create(64, buffer_fixed, 1);
        buffer_write(_buffer, buffer_u8, NET_PACKET_TYPE.CONNECT_REQUEST);
        
        // Enviamos el paquete a la IP que el usuario escribió
        // Si la IP no existe o está mal, el paquete simplemente se perderá (es la naturaleza de UDP),
        // pero el juego NO se congelará.
        network_send_udp(network_socket, server_ip, NET_PORT, _buffer, buffer_get_size(_buffer));
        buffer_delete(_buffer);

        // Crear héroe local y entrar al juego
        instance_create_layer(room_width/2, room_height/2, "Instances", obj_hero);
        room_goto(rm_game);
    }
}