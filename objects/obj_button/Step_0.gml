// Archivo: obj_button/Step_0.gml
var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);
var _hover = point_in_rectangle(_mouse_x, _mouse_y, 
                           x - sprite_width/2, y - sprite_height/2,
                           x + sprite_width/2, y + sprite_height/2);

if (_hover && mouse_check_button_released(mb_left))
{
    my_script();
    // Reemplace snd_click con su asset de sonido de clic si es diferente
    // audio_play_sound(snd_click, 0, false); 
}