// Fondo de la carta
draw_set_colour(make_colour_rgb(70,70,90));
draw_set_alpha(0.9);
draw_roundrect(x - 150, y - 220, x + 150, y + 220, false);

// Glow si está seleccionada
if (mouse_over) {
    draw_set_colour(c_white);
    draw_set_alpha(0.2);
    draw_roundrect(x - 160, y - 230, x + 160, y + 230, false);
}

// Icono
draw_sprite(upgrade_data[? "icon"], 0, x, y - 120);

// Nombre
draw_set_font(fnt_card_name);
draw_set_colour(c_white);
draw_set_halign(fa_center);
draw_text(x, y - 20, string(upgrade_data[? "weapon_name"]));

// Descripción
draw_set_font(fnt_card_description);
draw_set_colour(c_gray);
draw_text(x, y + 30, string(upgrade_data[? "description"]));

// Precio
draw_set_font(fnt_medium);
if (global.coins >= upgrade_data[? "price"]) {
    draw_set_colour(c_lime);
} else {
    draw_set_colour(c_red);
}
draw_text(x, y + 120, "Costo: " + string(upgrade_data[? "price"]) + " 🪙");

// Reset
draw_set_colour(c_white);
draw_set_halign(fa_left);
