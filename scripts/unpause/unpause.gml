// Declare unpause function.
function unpause() 
{
    global.paused = false;

    with (all) 
    {
        // Restaura solo si la instancia tiene las variables
        if (variable_instance_exists(id, "paused_speed"))
        {
            speed = paused_speed;
        }

        if (variable_instance_exists(id, "paused_animation"))
        {
            image_speed = paused_animation;
        }
    }
}
