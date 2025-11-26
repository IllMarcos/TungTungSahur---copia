// Archivo: objects/obj_hero/Create_0.gml (CÓDIGO COMPLETO CORREGIDO)

// AGREGADO PARA RED: Variables de identificación
global.network_controller = instance_find(obj_network_controller, 0); 
player_id = -1; 
is_local_player = false; 

if (instance_exists(global.network_controller))
{
    if (global.network_controller.network_mode == 1) // Si el modo es Servidor (Host)
    {
        // El Host es TungTung1 (ID 0)
        player_id = 0; 
        is_local_player = true; 
        
        // Registrar al Host como un jugador local en el controlador
        var _map = global.network_controller.player_sockets;
        // La clave es el ID del socket, el valor es el ID del jugador
        _map[? -1] = player_id; // -1 indica que es el socket local/Host
        global.network_controller.player_count++;
    }
}
else
{
    // Modo de un solo jugador (sin red) - Si no existe el controlador, asume modo local.
    is_local_player = true;
    player_id = 0;
}

// Set the maximum hitpoints that the player can have.
hitpoints_max = 10;
// Set the starting hitpoints of the player (to the max).
hitpoints = hitpoints_max;

// Variables for tracking enemies.
nearest_enemy = undefined;
nearest_distance = 1000;

// Cooldowns for the weapon attacks (from frames to seconds).
hero_shoot_cooldown = 0;
hero_swipe_cooldown = 30;
hero_trail_cooldown = 30;

// Function for the shooting weapon (SIN COOLDOWN)
handle_manual_shoot = function()
{
    // Solo el jugador local (esta instancia) puede iniciar la solicitud.
    if (!is_local_player) exit;
    
    // Si el nearest enemy is within 1000 pixels...
    if (nearest_distance < 1000)
    {
        // Si esta arma está desbloqueada...
        if (global.shooting[? "unlocked"])
        {
            // Ejecutar o solicitar ataque
            if (global.network_controller.network_mode == 1) // Si es el Servidor, ejecuta inmediatamente
            {
                shooting_attack(); 
                // TODO: El servidor debe enviar un paquete ATTACK_EXECUTE a todos los clientes.
            }
            else // Si es Cliente, envía la solicitud al Servidor
            {
                var _buffer = buffer_create(64, buffer_fixed, 1);
                buffer_write(_buffer, buffer_u8, NET_PACKET_TYPE.ATTACK_REQUEST);
                buffer_write(_buffer, buffer_u8, player_id);
                network_send_udp(global.network_controller.network_socket, global.network_controller.server_ip, NET_PORT, _buffer, buffer_get_size(_buffer));
                buffer_delete(_buffer);
            }
        }
    }
}

// Function for the swiping weapon (Automática, solo el SERVIDOR la ejecuta)
hero_swipe = function()
{
    // Solo el Servidor gestiona las armas automáticas
    if (global.network_controller.network_mode != 1) exit;
    
	if (nearest_distance < 250)
	{
		hero_swipe_cooldown = max(global.swipe[? "attack_speed"], 1);

		if (global.swipe[? "unlocked"])
		{
			swipe_attack();
		}
	}
	else
	{
		hero_swipe_cooldown = 1;
	}
}

// Function for the trail weapon (Automática, solo el SERVIDOR la ejecuta)
hero_trail = function()
{
    // Solo el Servidor gestiona las armas automáticas
    if (global.network_controller.network_mode != 1) exit;
    
	if(nearest_distance < 300)
	{
		hero_trail_cooldown = max(global.trail[? "attack_speed"], 1);

		if(global.trail[? "unlocked"])
		{
			attack_trail();
		}
	}
	else
	{
		hero_trail_cooldown = 1;
	}
}

// Create shadow object to follow.
var _shadow = instance_create_layer(x, y, "Shadows", obj_shadow);
// Set shadow owner.
_shadow.owner_object = self;