// Archivo: scripts/scr_network_constants/scr_network_constants.gml

// --- CONFIGURACIÓN DE RED ---
#macro NET_PORT 6510         // Puerto de comunicación (Debe ser el mismo en todos)
#macro MAX_PLAYERS 2         // Máximo de jugadores

// --- TIPOS DE PAQUETES (MENSAJES) ---
enum NET_PACKET_TYPE
{
    CONNECT_REQUEST,      // 0: Cliente pide entrar ("Toc Toc")
    CONNECT_ACCEPT,       // 1: Servidor dice "Pasa" y da ID
    
    MOVEMENT_INPUT,       // 2: Cliente -> Servidor ("Muevo joystick")
    PLAYER_STATE_UPDATE,  // 3: Servidor -> Clientes ("Estás en X,Y")
    
    ATTACK_REQUEST,       // 4: Cliente -> Servidor ("Quiero atacar")
    ATTACK_EXECUTE,       // 5: Servidor -> Clientes ("Ejecuten animación de ataque")
    
    CHANGE_ROOM           // 6: ¡NUEVO! Para sincronizar el cambio de nivel
}