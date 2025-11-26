// scripts/scr_new_game_init/scr_new_game_init.gml
//------------------------------------------------------------
// PASO 1: CREAR LAS ESTRUCTURAS DE DATOS GLOBALES (DS MAPS)
// Es CRUCIAL hacer esto antes de llamar a los resets.
// ¡Este es el paso que faltaba y causaba el error!
global.shooting = ds_map_create();
global.swipe = ds_map_create();
global.trail = ds_map_create();
//------------------------------------------------------------


// 2. Inicializar monedas a 0
global.coins = 0;

// 3. Inicializar habilidades a sus valores base (ahora las funciones de reset funcionarán)
weapon_shooting_reset(); // <-- Ahora sí puede modificar global.shooting
weapon_swipe_reset();
weapon_trail_reset();

// Otras inicializaciones de variables de juego 
global.dialogo_activo = false;
global.dialogo_texto = "";
global.paused = false; 
global.enemy_health_bonus = 1; 

global.game_active = true;