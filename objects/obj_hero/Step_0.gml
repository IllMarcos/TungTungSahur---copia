// Archivo: objects/obj_hero/Step_0.gml (CÓDIGO COMPLETO CORREGIDO)

// If the game is paused...
if (global.paused)
{
	// Exit this event while paused.
	exit;
}

var _is_networked = instance_exists(global.network_controller);

// ====================================================================
// 1. GESTIÓN DE INPUT (SOLO JUGADOR LOCAL)
// ====================================================================
if (is_local_player && _is_networked && global.network_controller.network_mode != 0)
{
    // Ejecutar función de movimiento para capturar input y mover (si es Servidor) o enviar input (si es Cliente)
    player_movement(); 

    // Ejecutar función que mantiene al jugador en la habitación.
    // Solo el Servidor tiene la autoridad de mantener el personaje dentro de la habitación
    if (global.network_controller.network_mode == 1) 
    {
        keep_in_room();
    }
}
// Si el héroe es una instancia del cliente remoto en modo cliente
else if (_is_networked && global.network_controller.network_mode == 2 && !is_local_player)
{
    // Forzamos 0 para que no haya movimiento fantasma antes de la sincronización del servidor
    hspeed = 0;
    vspeed = 0;
}


// ====================================================================
// 2. LÓGICA DEL JUEGO (SOLO SERVIDOR)
// ====================================================================
if (_is_networked && global.network_controller.network_mode == 1)
{
    // Set depth to minus our y position.
    depth = -y; 

    // Find the nearest enemy.
    nearest_enemy = instance_nearest(x, y, obj_enemy); 
    nearest_distance = 1000;

    // If an enemy instance is found.
    if (nearest_enemy) 
    {
        // Get the distance to that enemy.
        nearest_distance = point_distance(x, y, nearest_enemy.x, nearest_enemy.y);
    }

    // Reduce cooldown timer for attacks.
    hero_swipe_cooldown--; 
    hero_trail_cooldown--; 

    // Check if function cooldown is finished (WEAPONS AUTOMÁTICAS).
    if (hero_swipe_cooldown <= 0) 
    {
        hero_swipe();	
    }

    // Check if function cooldown is finished (WEAPONS AUTOMÁTICAS).
    if (hero_trail_cooldown <= 0) 
    {
        hero_trail();	
    }
}