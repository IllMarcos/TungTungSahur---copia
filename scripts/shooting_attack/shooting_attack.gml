// Archivo: scripts/shooting_attack/shooting_attack.gml

// CORRECCIÓN: El nombre de la función debe coincidir con el del archivo
function shooting_attack() 
{
    // Verificar cooldown
    if (hero_shoot_cooldown <= 0)
    {
	    if (instance_exists(nearest_enemy))
	    {
	        var _direction = point_direction(x, y, nearest_enemy.x, nearest_enemy.y);
	        var _angle_difference = (global.shooting[? "number_of_shots"] - 1) * 20;
	        var _angle = -_angle_difference / 2;
            
	        audio_play_sound(snd_lightning_throw, 0, false);
	    
	        repeat (global.shooting[? "number_of_shots"])
	        {
	            var _bullet = instance_create_layer(x, y, "Instances", obj_hero_bullet);
	            with (_bullet) 
	            {
	                direction = _direction + _angle;
	                speed = 15;
	                image_angle = direction;
	            }
	            _angle += 20;
	        }

            // Reiniciar Cooldown
            // Verificar si existe la variable max, si no, usar default
            if (variable_instance_exists(id, "hero_shoot_cooldown_max")) {
                 hero_shoot_cooldown = hero_shoot_cooldown_max;
            } else {
                hero_shoot_cooldown = 30;
            }
	    }
    }
}