// Archivo: objects/obj_network_controller/Create_0.gml

// --- IMPORTANTE: HACERLO PERSISTENTE ---
// Esto evita que se desconecte todo al cambiar de sala o reiniciar
persistent = true; 

// Configuración inicial de red
network_mode = 0;       // 0: Ninguno, 1: Servidor, 2: Cliente
network_socket = -1;
client_id = -1;
server_ip = "";

// Almacenamiento de jugadores (solo para el Servidor)
player_sockets = ds_map_create();
player_count = 0;

client_ip_promise = -1;
local_hero_reference = noone;