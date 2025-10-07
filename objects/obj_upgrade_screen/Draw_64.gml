/*// Fondo semi-transparente
draw_set_colour(c_black);
draw_set_alpha(0.7);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

// Panel
draw_set_alpha(1);
draw_set_colour(make_colour_rgb(40,40,50));
draw_roundrect(150, 80, display_get_gui_width()-150, display_get_gui_height()-150, false);

// Título
draw_set_font(fnt_large);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_colour(c_white);
draw_text(display_get_gui_width()/2, 150, "TIENDA");

// Monedas
draw_set_font(fnt_medium);
draw_set_colour(c_yellow);
draw_text(display_get_gui_width()/2, 230, "Monedas: " + string(global.coins) + " 🪙"); */
