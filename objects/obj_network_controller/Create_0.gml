// Archivo: objects/obj_network_controller/Create_0.gml

// Configuración inicial de red
network_mode = 0;       // 0: Ninguno, 1: Servidor (Host), 2: Cliente (Peer)
network_socket = -1;    // Socket de red
client_id = -1;         // ID del jugador local (-1 si no está asignado)
server_ip = "";         // IP del Host

// Almacenamiento de jugadores (solo para el Servidor)
player_sockets = ds_map_create(); // Mapea Socket de red -> ID de jugador
player_count = 0;

client_ip_promise = -1; // Para la entrada de texto asíncrona (join)
local_hero_reference = noone;