// Archivo: objects/obj_button_shoot/Step_0.gml

// ==========================================================
// 1. Manejar la Animación de Escala (Pulsación Visual)
// ==========================================================
image_xscale = lerp(image_xscale, scale_target, scale_speed);
image_yscale = lerp(image_yscale, scale_target, scale_speed);

// No hacer nada si el juego está pausado o si el héroe no existe
if (global.paused || !instance_exists(obj_hero)) 
{
    // Asegurar que el botón regrese a escala normal si se presiona durante la pausa
    scale_target = 1.0;
    exit;
}

// ==========================================================
// 2. Detección de Entrada (Toque o Clic)
// ==========================================================
var _pressed = false;

// Obtener las dimensiones del sprite y calcular el Bounding Box en la capa GUI
var _spr_w = sprite_get_width(sprite_index);
var _spr_h = sprite_get_height(sprite_index);

// Asumiendo que gui_x y gui_y son el centro del botón (típico en Draw GUI)
var _left = gui_x - _spr_w / 2;
var _top = gui_y - _spr_h / 2;
var _right = gui_x + _spr_w / 2;
var _bottom = gui_y + _spr_h / 2;

// Iterar sobre toques (índice 0 es el mouse/primer toque)
if (device_mouse_check_button(0, mb_left)) 
{
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    
    // Comprobar si el toque está dentro del área del botón (Bounding Box)
    if (point_in_rectangle(_mx, _my, _left, _top, _right, _bottom)) 
    {
        _pressed = true;
        
        // Si se acaba de presionar, iniciamos la animación de escala de "presionado" y el sonido
        if (device_mouse_check_button_pressed(0, mb_left)) 
        {
            scale_target = 0.8;
            audio_play_sound(snd_click, 0, false); // Reproducir sonido al presionar
        }
        
        // Llamar a la función de disparo del héroe.
        // ESTO SE EJECUTA CADA FRAME MIENTRAS EL BOTÓN ESTÉ PRESIONADO,
        // lo que asegura el disparo continuo (sin cooldown en handle_manual_shoot).
        with (obj_hero) 
        {
            handle_manual_shoot(); // <-- Usamos la función corregida.
        }
    }
}

// 3. Reiniciar la escala si ya no está siendo presionado
if (!_pressed) 
{
    scale_target = 1.0;
}