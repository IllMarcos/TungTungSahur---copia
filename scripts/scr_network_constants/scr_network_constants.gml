// Archivo: scripts/scr_network_constants/scr_network_constants.gml

// --- CONFIGURACIÓN DE RED ---
#macro NET_PORT 6510         // El puerto debe ser el mismo en Cliente y Servidor
#macro MAX_PLAYERS 2         // Límite de jugadores para los bucles y arrays
#macro NETWORK_UPDATE_RATE 3 // (Opcional) Enviar actualizaciones cada 3 frames para no saturar

// --- TIPOS DE PAQUETES (MENSAJES) ---
// Usamos un enum para asignar números automáticamente (0, 1, 2...)
enum NET_PACKET_TYPE
{
    CONNECT_REQUEST,      // 0: Un cliente pide entrar
    CONNECT_ACCEPT,       // 1: El servidor acepta y le da datos iniciales
    
    // --- JUEGO: MOVIMIENTO ---
    MOVEMENT_INPUT,       // 2: CLIENTE -> SERVIDOR (Envía teclas/input: h_move, v_move)
    PLAYER_STATE_UPDATE,  // 3: SERVIDOR -> CLIENTES (Envía posición real: x, y, sprite, frame)
    
    // --- JUEGO: ACCIONES ---
    ATTACK_REQUEST,       // 4: CLIENTE -> SERVIDOR ("Quiero disparar")
    ATTACK_EXECUTE,       // 5: SERVIDOR -> CLIENTES ("El jugador X disparó, dibújalo")
    
    // --- GESTIÓN ---
    DISCONNECT            // 6: Aviso de desconexión
}