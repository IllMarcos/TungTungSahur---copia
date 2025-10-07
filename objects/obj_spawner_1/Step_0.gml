if (!global.paused) {
    if (enemy_count > 0) {
        spawn_timer--;

        if (spawn_timer <= 0) {
            // Elegir un ángulo aleatorio alrededor del spawner
            var angle = irandom(359);
            
            // Elegir una distancia aleatoria entre min y max
            var dist = irandom_range(spawn_min_dist, spawn_max_dist);

            // Calcular posición con trigonometría
            var sx = x + lengthdir_x(dist, angle);
            var sy = y + lengthdir_y(dist, angle);

            // Crear enemigo en esa posición
            instance_create_layer(sx, sy, "Instances", enemy_type);

            // Restar al contador de enemigos
            enemy_count--;

            // Reiniciar temporizador
            spawn_timer = spawn_delay;
        }
    }
    else {
        // Cuando ya no tenga enemigos que generar, el spawner se destruye
        instance_destroy();
    }
}
