// Archivo: objects/obj_network_controller/Other_4.gml

// 1. SI SOMOS EL CLIENTE (JUGADOR QUE SE UNIÓ)
if (network_mode == 2)
{
    // Si acabamos de llegar a la sala de juego inicial (rm_game)
    // enviamos la petición de conexión como hacías antes.
    if (room == rm_game && client_id == -1)
    {
        show_debug_message("--- CLIENTE: Pidiendo entrar al Servidor ---");
        
        // Intentar capturar el héroe que ya esté puesto en el editor
        local_hero_reference = instance_find(obj_hero, 0);
        
        var _buffer = buffer_create(32, buffer_fixed, 1);
        buffer_write(_buffer, buffer_u8, NET_PACKET_TYPE.CONNECT_REQUEST);
        network_send_udp(network_socket, server_ip, NET_PORT, _buffer, buffer_tell(_buffer));
        buffer_delete(_buffer);
    }
    // SI YA ESTAMOS JUGANDO (Tenemos ID) y cambiamos de sala (ej: entramos a una cueva)
    else if (client_id != -1)
    {
        // Verificamos si nuestro héroe sobrevivió al cambio de sala
        if (!instance_exists(local_hero_reference))
        {
            // Si no existe, LO CREAMOS de nuevo (Reencarnación)
            // Puedes ajustar las coordenadas (x,y) según necesites, o usar puntos de spawn
            var _start_x = 100; 
            var _start_y = 100;
            
            // Si hay un objeto "player_start" en la sala, usamos su posición (opcional)
            if (instance_exists(obj_base)) { // Ejemplo: usar obj_base como referencia
                _start_x = obj_base.x;
                _start_y = obj_base.y;
            }

            local_hero_reference = instance_create_layer(_start_x, _start_y, "Instances", obj_hero);
            
            // LE DEVOLVEMOS SU IDENTIDAD
            local_hero_reference.net_player_id = client_id;
            local_hero_reference.is_local_player = true;
            
            show_debug_message("CLIENTE: Héroe recreado en nueva sala.");
        }
    }
}

// 2. SI SOMOS EL HOST (SERVIDOR)
else if (network_mode == 1)
{
    // El Host también necesita recrearse si su muñeco desapareció
    if (!instance_exists(obj_hero))
    {
        var _h = instance_create_layer(200, 200, "Instances", obj_hero);
        _h.is_local_player = true;
        // El Host suele ser el ID 0, o puedes gestionarlo como quieras
        _h.net_player_id = 0; 
    }
}