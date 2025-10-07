// Not paused by default.
global.paused = false;

// Declare pause function.
function pause() 
{
    global.paused = true;

    with (all) 
    {
        // Solo si la instancia no es del sistema (como obj_upgrade_screen, obj_shop, botones, etc.)
        if (!is_undefined(speed))
        {
            // Guarda la velocidad y la animación si no existen
            if (!variable_instance_exists(id, "paused_speed")) paused_speed = speed;
            if (!variable_instance_exists(id, "paused_animation")) paused_animation = image_speed;

            // Detén la velocidad y la animación
            speed = 0;
            image_speed = 0;
        }
    }
}
