// Archivo: objects/obj_hero/Create_0.gml

// Inicializar controlador de red
global.network_controller = instance_find(obj_network_controller, 0); 

// CORRECCIÓN: Usamos 'net_player_id' para evitar conflicto con variable del sistema
net_player_id = -1; 
is_local_player = false; 

if (instance_exists(global.network_controller))
{
    if (global.network_controller.network_mode == 1) // Modo Servidor
    {
        net_player_id = 0; // Host es ID 0
        is_local_player = true; 
        
        // Registrar Host
        var _map = global.network_controller.player_sockets;
        _map[? -1] = net_player_id; 
        global.network_controller.player_count++;
    }
}
else
{
    // Modo Singleplayer / Offline
    is_local_player = true;
    net_player_id = 0;
}

hitpoints_max = 10;
hitpoints = hitpoints_max;

nearest_enemy = undefined;
nearest_distance = 1000;

// Cooldowns
hero_shoot_cooldown = 0;
hero_swipe_cooldown = 30;
hero_trail_cooldown = 30;

// Disparo manual
handle_manual_shoot = function()
{
    if (!is_local_player) exit;
    
    if (nearest_distance < 1000)
    {
        if (global.shooting[? "unlocked"])
        {
            if (!instance_exists(global.network_controller) || global.network_controller.network_mode == 1) 
            {
                // Si soy servidor o offline, disparo directo
                shooting_attack(); 
            }
            else 
            {
                // Si soy cliente, pido permiso
                var _buffer = buffer_create(64, buffer_fixed, 1);
                buffer_write(_buffer, buffer_u8, NET_PACKET_TYPE.ATTACK_REQUEST);
                buffer_write(_buffer, buffer_u8, net_player_id); 
                network_send_udp(global.network_controller.network_socket, global.network_controller.server_ip, NET_PORT, _buffer, buffer_tell(_buffer));
                buffer_delete(_buffer);
            }
        }
    }
}

// Ataque swipe (Solo Servidor lo gestiona en MP)
hero_swipe = function()
{
    // Si estamos en MP y NO somos el servidor, salir
    if (instance_exists(global.network_controller) && global.network_controller.network_mode == 2) exit;

    if (nearest_distance < 250)
	{
		hero_swipe_cooldown = max(global.swipe[? "attack_speed"], 1);
		if (global.swipe[? "unlocked"]) swipe_attack();
	}
	else hero_swipe_cooldown = 1;
}

// Ataque trail (Solo Servidor lo gestiona en MP)
hero_trail = function()
{
    if (instance_exists(global.network_controller) && global.network_controller.network_mode == 2) exit;

    if(nearest_distance < 300)
	{
		hero_trail_cooldown = max(global.trail[? "attack_speed"], 1);
		if(global.trail[? "unlocked"]) attack_trail();
	}
	else hero_trail_cooldown = 1;
}

var _shadow = instance_create_layer(x, y, "Shadows", obj_shadow);
_shadow.owner_object = self;