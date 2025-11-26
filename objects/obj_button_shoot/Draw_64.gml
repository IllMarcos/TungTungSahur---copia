// Archivo: obj_button_shoot/Draw_64.gml

// Dibujar el botón en la capa de GUI
draw_sprite_ext(sprite_index, image_index, gui_x, gui_y, image_xscale, image_yscale, 0, c_white, 1);

// Opcional: dibujar el ícono de la bala sobre el botón
// draw_sprite(spr_shooting_attack_small, 0, gui_x, gui_y);


// Opcional: Dibujar texto o un ícono de bala en el centro
// draw_set_halign(fa_center);
// draw_set_valign(fa_middle);
// draw_set_font(fnt_small); // Usar una fuente existente
// draw_text(gui_x, gui_y, "FIRE");