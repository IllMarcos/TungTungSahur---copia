// Archivo: objects/obj_hero/Step_0.gml (CORREGIDO)

// Si el juego está pausado, salir
if (global.paused) exit;

var _is_networked = instance_exists(global.network_controller);

// ====================================================================
// 1. GESTIÓN DE INPUT (SOLO JUGADOR LOCAL)
// ====================================================================
if (is_local_player) 
{
    // Capturar input y moverse (funciona Offline y Online)
    player_movement();

    // Mantener dentro de la sala (Solo Servidor u Offline)
    var _mode = 0;
    if (_is_networked) _mode = global.network_controller.network_mode;
    
    if (_mode == 1 || _mode == 0) 
    {
        keep_in_room();
    }
}
// Si es Cliente remoto, evitar movimiento fantasma si no hay datos
else if (_is_networked && global.network_controller.network_mode == 2 && !is_local_player)
{
    hspeed = 0;
    vspeed = 0;
}

// ====================================================================
// 2. LÓGICA DE COMBATE Y COOLDOWNS
// ====================================================================
// Ejecutar lógica si soy el Servidor (1) O si estoy jugando solo (Offline/0)
var _run_logic = false;
if (!_is_networked) _run_logic = true;
else if (global.network_controller.network_mode != 2) _run_logic = true;

if (_run_logic)
{
    depth = -y; 
    nearest_enemy = instance_nearest(x, y, obj_enemy); 
    nearest_distance = 1000;

    if (nearest_enemy) 
    {
        nearest_distance = point_distance(x, y, nearest_enemy.x, nearest_enemy.y);
    }

    // --- AQUÍ ESTABA EL ERROR DEL DISPARO ---
    // Debemos restar el cooldown del disparo manual frame a frame
    if (hero_shoot_cooldown > 0) hero_shoot_cooldown--; 
    
    // Cooldowns automáticos
    hero_swipe_cooldown--; 
    hero_trail_cooldown--;

    if (hero_swipe_cooldown <= 0) hero_swipe();
    if (hero_trail_cooldown <= 0) hero_trail();	
}