// Enviar saludo al entrar a la sala de juego
if (room == rm_game && network_mode == 2)
{
    show_debug_message("--- ENVIANDO SALUDO AL SERVIDOR ---");
    
    // Crear paquete de 'Solicitud de Conexión'
    var _buffer = buffer_create(32, buffer_fixed, 1);
    buffer_write(_buffer, buffer_u8, NET_PACKET_TYPE.CONNECT_REQUEST);
    
    // Enviar a la IP y Puerto guardados
    network_send_udp(network_socket, server_ip, NET_PORT, _buffer, buffer_tell(_buffer));
    
    buffer_delete(_buffer);
}