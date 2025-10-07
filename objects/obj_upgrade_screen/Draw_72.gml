// Fondo semiclaro del panel (NO tapa toda la pantalla)
draw_set_colour(make_colour_rgb(35, 36, 48));
draw_set_alpha(0.95);
draw_roundrect(180, 140, 1740, 930, false);

// Título y monedas
draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_font(fnt_large);
draw_set_halign(fa_center); draw_set_valign(fa_middle);
draw_text(1920/2, 180, "TIENDA");

draw_set_font(fnt_medium);
draw_set_colour(c_yellow);
draw_text(1920/2, 250, "MONEDAS: " + string(global.coins) + " 🪙");

draw_set_halign(fa_left); draw_set_valign(fa_top);
draw_set_colour(c_white);
