// Define una función para ejecutar el ataque de disparo.
function hero_shoot() // Cambié el nombre de la función a 'hero_shoot' para coincidir con tu obj_hero/Step_0.gml
{
    // Verificar si el cooldown ha terminado (DEBE SER LA PRIMERA COMPROBACIÓN)
    if (hero_shoot_cooldown <= 0)
    {
	    // Si se encuentra un enemigo...
	    if (instance_exists(nearest_enemy))
	    {
	        // Obtener la dirección del héroe al enemigo.
	        var _direction = point_direction(x, y, nearest_enemy.x, nearest_enemy.y);
	    
	        // Obtener la diferencia de ángulo para los múltiples disparos.
	        var _angle_difference = (global.shooting[? "number_of_shots"] - 1) * 20;
	    
	        // El ángulo inicial.
	        var _angle = -_angle_difference / 2;
	    
	        // Reproducir el efecto de sonido.
	        audio_play_sound(snd_lightning_throw, 0, false);
	    
	        // Repetir el siguiente código para cada bala que necesitamos generar.
	        repeat (global.shooting[? "number_of_shots"])
	        {
	            // Crear una bala y asignarla a la variable temporal _bullet.
	            var _bullet = instance_create_layer(x, y, "Instances", obj_hero_bullet);
	        
	            // Cambiar los valores de la bala...
	            with (_bullet) 
	            {
	                // Establecer la dirección de la bala.
	                direction = _direction + _angle;
	            
	                // Establecer la velocidad de la bala.
	                speed = 15;
	            
	                // Rotar la bala para que mire en su dirección de movimiento.
	                image_angle = direction;
	            }
	        
	            // Incrementar el ángulo para la siguiente bala.
	            _angle += 20;
	        }

            // REINICIAR EL COOLDOWN DEL DISPARO DEL HÉROE
            // Asumiendo que existe una variable para el valor máximo del cooldown,
            // si no, usa un valor fijo como 30 para 0.5 segundos (30 frames)
            if (variable_instance_exists(id, "hero_shoot_cooldown_max")) {
                hero_shoot_cooldown = hero_shoot_cooldown_max;
            } else {
                hero_shoot_cooldown = 30; // Valor predeterminado de ejemplo
            }
	    }
    }
}