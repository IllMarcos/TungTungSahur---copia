// Archivo: objects/obj_network_controller/Other_4.gml

// Si estamos en el juego y somos CLIENTE
if (room == rm_game && network_mode == 2)
{
    show_debug_message("--- CLIENTE INICIANDO: SALA DE JUEGO ---");

    // 1. CAPTURAR MI HÉROE LOCAL
    // Buscamos el héroe que pusiste en el editor de la sala. Ese es el nuestro.
    // Lo guardamos en una variable del controlador para usarlo luego.
    local_hero_reference = instance_find(obj_hero, 0);
    
    if (instance_exists(local_hero_reference))
    {
        // Le decimos temporalmente que es local para que la cámara lo siga (si tienes cámara)
        local_hero_reference.is_local_player = true; 
        show_debug_message("Héroe local identificado: " + string(local_hero_reference));
    }
    
    // 2. ENVIAR SALUDO AL SERVIDOR
    var _buffer = buffer_create(32, buffer_fixed, 1);
    buffer_write(_buffer, buffer_u8, NET_PACKET_TYPE.CONNECT_REQUEST);
    network_send_udp(network_socket, server_ip, NET_PORT, _buffer, buffer_tell(_buffer));
    buffer_delete(_buffer);
}