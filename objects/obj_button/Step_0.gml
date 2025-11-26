// Obtenemos coordenadas del mouse en la GUI
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// Si tenemos sprite, usamos su tamaño. Si no, usamos el manual.
var _w = (sprite_index != -1) ? sprite_width : width;
var _h = (sprite_index != -1) ? sprite_height : height;

// Calcular bordes (asumiendo que la posición x,y es el CENTRO del botón)
var _half_w = (_w * scale) / 2;
var _half_h = (_h * scale) / 2;

// 1. DETECCIÓN DE MOUSE
if (_mx > x - _half_w && _mx < x + _half_w && _my > y - _half_h && _my < y + _half_h)
{
    hovering = true;
    scale = lerp(scale, 1.1, 0.1); // Efecto de crecer
    
    // 2. DETECCIÓN DE CLIC
    if (device_mouse_check_button_pressed(0, mb_left)) 
    {
        audio_play_sound(snd_click, 1, false); // Si tienes sonido
        if (is_method(action_script)) 
        {
            action_script();
        }
    }
}
else
{
    hovering = false;
    scale = lerp(scale, 1.0, 0.1); // Volver a tamaño normal
}