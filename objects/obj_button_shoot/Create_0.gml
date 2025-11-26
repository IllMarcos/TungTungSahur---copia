// Archivo: obj_button_shoot/Create_0.gml

sprite_index = spr_button_small;
image_speed = 0;
image_index = 0; // Estado normal

// Coordenadas en la capa de GUI
// Esto posiciona el botón a 80px del borde derecho y 80px del borde inferior de la pantalla.
gui_x = display_get_gui_width() - 200; 
gui_y = display_get_gui_height() - 200;

// Variables para animación de pulsación
scale_target = 1;
scale_speed = 0.2;