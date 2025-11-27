// Archivo: objects/obj_hero/Step_0.gml

// 1. SISTEMA DE PAUSA
if (global.paused) exit;

var _is_networked = instance_exists(global.network_controller);

// ====================================================================
// 2. LÓGICA DE MUERTE SINCRONIZADA (CORREGIDO EL ERROR DE CRASH)
// ====================================================================
if (hitpoints <= 0)
{
    // CASO A: SOY EL HOST (1) -> Tengo el poder de reiniciar la partida para todos
    if (_is_networked && global.network_controller.network_mode == 1)
    {
        // 1. Crear paquete de cambio de sala
        var _buff = buffer_create(32, buffer_fixed, 1);
        buffer_write(_buff, buffer_u8, NET_PACKET_TYPE.CHANGE_ROOM);
        buffer_write(_buff, buffer_u16, room); 
        
        // 2. Enviar a todos los clientes (SIN USAR WITH PARA EVITAR EL CRASH)
        // Accedemos directamente a las variables del controlador global
        var _socket_map = global.network_controller.player_sockets;
        var _server_socket = global.network_controller.network_socket;
        
        var _k = ds_map_find_first(_socket_map);
        
        while(!is_undefined(_k)) 
        {
            if (is_string(_k)) { // Es un cliente real (IP:Puerto)
                // Desglosar IP y Puerto
                var _col = string_pos(":", _k);
                var _ip = string_copy(_k, 1, _col-1);
                var _port_str = string_copy(_k, _col+1, string_length(_k));
                var _port = real(_port_str);
                
                // Enviar usando el socket del controlador
                network_send_udp(_server_socket, _ip, _port, _buff, buffer_tell(_buff));
            }
            _k = ds_map_find_next(_socket_map, _k);
        }
        
        buffer_delete(_buff);
        
        // 3. Reiniciar mi juego
        room_restart();
    }
    // CASO B: SOY OFFLINE O SINGLEPLAYER
    else if (!_is_networked || global.network_controller.network_mode == 0) 
    {
        room_restart();
    }
    
    // CASO C: SOY CLIENTE (2) -> Solo me destruyo y espero a que el Host me reinicie
    instance_destroy();
    exit;
}

// ====================================================================
// 3. MOVIMIENTO Y RED (AUTORIDAD DEL CLIENTE)
// ====================================================================
if (is_local_player)
{
    // A. Calcular física local (Script actualizado)
    player_movement();

    // B. Sincronización de Red: Enviar Posición ABSOLUTA (X, Y)
    // Esto elimina el "parpadeo" y el lag, porque el servidor no adivina, solo obedece.
    if (_is_networked && global.network_controller.network_mode == 2)
    {
        // Solo enviar si nos movemos para ahorrar ancho de banda
        if (hspeed != 0 || vspeed != 0) 
        {
            var _buff_mov = buffer_create(32, buffer_fixed, 1);
            buffer_write(_buff_mov, buffer_u8, NET_PACKET_TYPE.MOVEMENT_INPUT);
            buffer_write(_buff_mov, buffer_u8, net_player_id); // Quién soy
            buffer_write(_buff_mov, buffer_s16, x);            // X REAL
            buffer_write(_buff_mov, buffer_s16, y);            // Y REAL
            buffer_write(_buff_mov, buffer_s8, image_xscale);  // Dirección
            
            // Enviar al Host
            network_send_udp(global.network_controller.network_socket, global.network_controller.server_ip, NET_PORT, _buff_mov, buffer_tell(_buff_mov));
            buffer_delete(_buff_mov);
        }
    }
}
// Si es un jugador remoto (que veo en mi pantalla), detengo su física local automática
// para que solo se mueva cuando reciba datos del servidor.
else if (_is_networked && global.network_controller.network_mode == 2 && !is_local_player)
{
    hspeed = 0;
    vspeed = 0;
}

// ====================================================================
// 4. LÓGICA DE COMBATE Y COOLDOWNS
// ====================================================================
// Esta lógica solo la corre el "Dueño del Mundo" (Host o Singleplayer)
var _run_logic = false;
if (!_is_networked) _run_logic = true;
else if (global.network_controller.network_mode != 2) _run_logic = true;

if (_run_logic)
{
    // Profundidad visual
    depth = -y; 
    
    // Buscar enemigo más cercano
    nearest_enemy = instance_nearest(x, y, obj_enemy); 
    nearest_distance = 1000;
    if (nearest_enemy) 
    {
        nearest_distance = point_distance(x, y, nearest_enemy.x, nearest_enemy.y);
    }

    // Gestión de Cooldowns
    if (hero_shoot_cooldown > 0) hero_shoot_cooldown--;
    hero_swipe_cooldown--; 
    hero_trail_cooldown--;

    // Ejecutar ataques automáticos
    if (hero_swipe_cooldown <= 0) hero_swipe();
    if (hero_trail_cooldown <= 0) hero_trail();	
}