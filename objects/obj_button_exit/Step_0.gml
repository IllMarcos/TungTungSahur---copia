// If mouse is over the button, adjusting for GUI layer...
if (device_mouse_x_to_gui(0) > bbox_left && device_mouse_x_to_gui(0) < bbox_right && device_mouse_y_to_gui(0) > bbox_top && device_mouse_y_to_gui(0) < bbox_bottom)
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
		if (mouse_check_button_released(mb_left))
		{
			// Play click sound effect.
			audio_play_sound(snd_ui_select, 0, false);

			// ==========================================================
			// FIX MULTIJUGADOR: LIMPIEZA
			// ==========================================================
			// Si estamos online, debemos destruir la conexión antes de salir
			if (instance_exists(obj_network_controller))
			{
				// 1. Destruir el socket (Cerrar puertos)
				// Accedemos a la variable usando el objeto directamente o la global
				var _sock = variable_instance_get(instance_find(obj_network_controller, 0), "network_socket");
				if (!is_undefined(_sock) && _sock >= 0) {
					network_destroy(_sock);
				}
				
				// 2. Destruir el controlador persistente
				// Si no lo matamos aquí, aparecerá duplicado en el menú o dará errores
				instance_destroy(obj_network_controller);
			}
			// ==========================================================

			// Go to the main menu.
			room_goto(rm_menu);
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
		if (gamepad_button_check_pressed(0, gp_select))
		{
			// Play click sound effect.
			audio_play_sound(snd_ui_select, 0, false);
	
			// ==========================================================
			// FIX MULTIJUGADOR (Versión Gamepad)
			// ==========================================================
			if (instance_exists(obj_network_controller))
			{
				var _sock = variable_instance_get(instance_find(obj_network_controller, 0), "network_socket");
				if (!is_undefined(_sock) && _sock >= 0) network_destroy(_sock);
				instance_destroy(obj_network_controller);
			}
			// ==========================================================

			// Go to the main menu.
			room_goto(rm_menu);
		}
	}
}

// Lerp scale values to target scale.
image_xscale = lerp(image_xscale, target_scale, 0.1);
image_yscale = lerp(image_yscale, target_scale, 0.1);