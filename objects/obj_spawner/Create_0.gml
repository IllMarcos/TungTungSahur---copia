// Número de enemigos que va a generar este spawner
enemy_count = 10;

// Tipo de enemigo que generará
enemy_type = obj_pigun; // cámbialo por el enemigo que quieras

// Tiempo entre spawns (frames, 90 = 1.5 segundos)
spawn_delay = 90; 

// Contador interno
spawn_timer = spawn_delay;

// Distancia mínima y máxima de aparición respecto al spawner
spawn_min_dist = 96;
spawn_max_dist = 160;
