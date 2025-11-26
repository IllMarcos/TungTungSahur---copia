// Archivo: objects/obj_network_controller/Other_63.gml
// Evento: Async - Dialog

var _id = ds_map_find_value(async_load, "id");

// Verificar si la respuesta es de la promesa de IP que creamos en el menú
if (_id == client_ip_promise) 
{
    var _status = ds_map_find_value(async_load, "status");
    var _ip_input = ds_map_find_value(async_load, "result"); // Guardamos lo que escribió el usuario

    if (_status) // Si el usuario presionó OK
    {
        // --- 1. VALIDACIÓN BÁSICA DE TEXTO ---
        // Si escribió muy poco texto, no puede ser una IP válida (mínimo "0.0.0.0")
        if (string_length(_ip_input) < 7) 
        {
            show_message_async("Error: La dirección IP es demasiado corta o inválida.");
            exit; // Detenemos todo aquí
        }

        // --- 2. INTENTO DE CREACIÓN DEL SOCKET ---
        var _temp_socket = network_create_socket(network_socket_udp);
        
        if (_temp_socket < 0) 
        {
            show_message_async("Error crítico: No se pudo crear el sistema de red.");
            exit;
        }

        // --- 3. INTENTO DE CONEXIÓN PROTEGIDO ---
        // network_connect devuelve < 0 si falla (ej: IP con letras raras o formato inválido)
        // NOTA: Usamos 'network_connect', no existe '_udp' para esta función.
        var _conexion_exitosa = network_connect(_temp_socket, _ip_input, NET_PORT);
        
        if (_conexion_exitosa < 0)
        {
            // Si falló, destruimos el socket, mostramos mensaje y NO cambiamos de sala
            network_destroy(_temp_socket);
            show_message_async("Error: Formato de IP inválido.\nAsegúrate de usar números y puntos (Ej: 192.168.1.15)");
        }
        else
        {
            // --- 4. ÉXITO: APLICAR CONFIGURACIÓN ---
            // Si llegamos aquí, la IP tiene el formato correcto y el socket está listo
            server_ip = _ip_input;
            network_mode = 2;
            network_socket = _temp_socket;

            // Enviar solicitud de conexión inmediata ("Toc Toc")
            var _buffer = buffer_create(64, buffer_fixed, 1);
            buffer_write(_buffer, buffer_u8, NET_PACKET_TYPE.CONNECT_REQUEST);
            
            // Enviamos el paquete a la IP validada
            network_send_udp(network_socket, server_ip, NET_PORT, _buffer, buffer_get_size(_buffer));
            buffer_delete(_buffer);

            // Crear héroe local (temporalmente sin ID, lo recibirá del servidor)
            // Esto asegura que al entrar a la sala ya exista nuestro personaje
            instance_create_layer(room_width/2, room_height/2, "Instances", obj_hero);
            
            // Ir al juego
            room_goto(rm_game); 
        }
    }
}