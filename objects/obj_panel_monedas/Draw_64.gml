// 📌 Evento: Draw GUI de obj_panel_monedas

// Posición fija en la esquina superior derecha de la pantalla
var panel_x = display_get_gui_width() - 600;
var panel_y = 30;

// --- Dibujar el sprite del panel (ícono de la moneda) ---
draw_sprite(spr_panel_monedas, 0, panel_x, panel_y);

// --- Dibujar el número de monedas al lado ---
draw_set_font(fnt_medium);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_colour(c_white);

// Texto a la derecha del ícono
draw_text(panel_x + 110, panel_y + 60, string(global.coins));

// Reset
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
