// Archivo: obj_button/Draw_64.gml
draw_self();

// Dibujar el texto centrado
draw_set_font(font_menu); // Asuma que tiene un asset de fuente
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(x, y, my_text);