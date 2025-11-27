// Archivo: objects/obj_hero/Create_0.gml

// --- 1. INICIALIZACIÓN DE RED Y ESTATUS ---
// Inicializar referencia al controlador de red
global.network_controller = instance_find(obj_network_controller, 0);

// Por defecto no somos nadie hasta comprobar lo contrario
net_player_id = -1; 
is_local_player = false;

// --- COMPROBACIÓN DE IDENTIDAD ---
if (instance_exists(global.network_controller))
{
    var _mode = global.network_controller.network_mode;

    // CASO A: SOY EL HOST (1) O ESTOY OFFLINE (0) PERO EL OBJETO EXISTE
    if (_mode == 1 || _mode == 0) 
    {
        is_local_player = true;
        net_player_id = 0; // El Host/Singleplayer siempre es ID 0
        
        // Si somos específicamente el HOST, nos registramos en el mapa de sockets
        if (_mode == 1) {
            var _map = global.network_controller.player_sockets;
            _map[? -1] = net_player_id; 
            global.network_controller.player_count++;
        }
    }
    // CASO B: SOY CLIENTE (2)
    else if (_mode == 2)
    {
        is_local_player = false;
        // Esperamos a que el servidor nos mande el paquete CONNECT_ACCEPT para volvernos true
    }
}
else
{
    // CASO C: NO EXISTE EL CONTROLADOR (Singleplayer puro sin obj_network_controller)
    is_local_player = true;
    net_player_id = 0;
}

// --- 2. ESTADÍSTICAS DEL HÉROE ---
hitpoints_max = 10;
hitpoints = hitpoints_max;

nearest_enemy = undefined;
nearest_distance = 1000;

// Cooldowns de habilidades
hero_shoot_cooldown = 0;
hero_swipe_cooldown = 30;
hero_trail_cooldown = 30;

// --- 3. FUNCIONES DE ATAQUE ---

// A. Disparo manual
handle_manual_shoot = function()
{
    if (!is_local_player) exit;

    if (nearest_distance < 1000)
    {
        if (global.shooting[? "unlocked"])
        {
            // Verificamos si el controlador existe Y qué modo es
            var _net_mode = 0;
            if (instance_exists(global.network_controller)) _net_mode = global.network_controller.network_mode;

            // Si es Offline (0) o Servidor (1), disparamos directo
            if (_net_mode == 0 || _net_mode == 1) 
            {
                shooting_attack();
            }
            else 
            {
                // Si soy cliente (2), pido permiso al servidor
                var _buffer = buffer_create(64, buffer_fixed, 1);
                buffer_write(_buffer, buffer_u8, NET_PACKET_TYPE.ATTACK_REQUEST);
                buffer_write(_buffer, buffer_u8, net_player_id); 
                network_send_udp(global.network_controller.network_socket, global.network_controller.server_ip, NET_PORT, _buffer, buffer_tell(_buffer));
                buffer_delete(_buffer);
            }
        }
    }
}

// B. Ataque Swipe (Golpe circular)
hero_swipe = function()
{
    // Si estamos en MP (Modo 2) y NO somos el servidor, salir.
    // Si es Modo 0 (Offline) o 1 (Host), permitimos que corra.
    if (instance_exists(global.network_controller) && global.network_controller.network_mode == 2) exit;

    if (nearest_distance < 250)
	{
		hero_swipe_cooldown = max(global.swipe[? "attack_speed"], 1);
		if (global.swipe[? "unlocked"]) swipe_attack();
	}
	else hero_swipe_cooldown = 1;
}

// C. Ataque Trail (Rastro)
hero_trail = function()
{
    // Misma restricción: Solo Host u Offline calculan esto
    if (instance_exists(global.network_controller) && global.network_controller.network_mode == 2) exit;

    if(nearest_distance < 300)
	{
		hero_trail_cooldown = max(global.trail[? "attack_speed"], 1);
		if(global.trail[? "unlocked"]) attack_trail();
	}
	else hero_trail_cooldown = 1;
}

// --- 4. CREACIÓN DE LA SOMBRA (CON PROTECCIÓN DE CAPA) ---

// Definimos la capa ideal
var _target_layer = "Shadows";

// Verificamos si existe en la sala actual (evita crash en rm_menu)
if (!layer_exists(_target_layer))
{
    // Si "Shadows" no existe, usamos la capa actual del héroe
    _target_layer = layer;
}

// Creamos la sombra de forma segura
var _shadow = instance_create_layer(x, y, _target_layer, obj_shadow);
_shadow.owner_object = self;