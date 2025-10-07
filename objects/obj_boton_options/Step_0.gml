// If mouse is over this instance, adjusting for the GUI layer...
if (device_mouse_x_to_gui(0) > bbox_left && device_mouse_x_to_gui(0) < bbox_right && device_mouse_y_to_gui(0) < bbox_bottom && device_mouse_y_to_gui(0) > bbox_top)
{
    // Reduce target scale size.
    target_scale = 0.95;
    
    // If left mouse button is pressed...
    if (mouse_check_button_pressed(mb_left))
    {
        // Play click sound effect.
        audio_play_sound(snd_click, 0, false);
        
        // Sets click state to true.
        is_clicked = true;
        
        // Reduce target scale size further.
        target_scale = 0.9;
    }
    
    // Checks if mouse has been clicked on this button.
    if (is_clicked)
    {
        // Reduce target scale size further.
        target_scale = 0.9;
        
        // If left mouse button is released...
        if ( mouse_check_button_released(mb_left))
        {       
            // Play click sound effect.
            audio_play_sound(snd_ui_select, 0, false);
            
            // ====== AQUI VA LO QUE HACE EL BOTON ======
            // Crear el panel de opciones en el centro de la room
            instance_create_layer(room_width/2, room_height/2, "GUI", obj_panel_opciones);
        }
    }
}
else
{
    // Reset target scale size.
    target_scale = 1.0;    
}

// Stores how many gamepad count.
var _max_pads = gamepad_get_device_count();

// Checks when at least 1 gamepad is present.
if (_max_pads > 0)
{
    // Checks the gamepad is connected.
    if (gamepad_is_connected(0))
    {
        // Checks if gamepad button has been pressed.
        if (gamepad_button_check_pressed(0, gp_start))
        {
            // Play click sound effect.
            audio_play_sound(snd_ui_select, 0, false);
            
            // ====== AQUI VA LO QUE HACE EL BOTON CON GAMEPAD ======
            instance_create_layer(room_width/2, room_height/2, "GUI", obj_panel_opciones);
        }
    }
}

// Lerp scale values to target scale.
image_xscale = lerp(image_xscale, target_scale, 0.1);
image_yscale = lerp(image_yscale, target_scale, 0.1);
