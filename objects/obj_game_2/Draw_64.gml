// If an instance of obj_upgrade exists then
// that means we are on the upgrade screen...
if (instance_exists(obj_game_over))
{
    // Exit event, so we don't render the HUD.
    exit;
}

// If the upgrade screen is open...
// ⚠️ Ya no usamos upgrades automáticos, lo puedes comentar
/*
if (instance_exists(obj_upgrade))
{
    // Exit event, so we don't render the HUD.
    exit;
}
*/



// ==== Shooting ====
if (global.shooting[? "unlocked"]) {
    draw_sprite_ext(spr_shooting_attack_big, 0, 80, 60, 0.5, 0.5, 0, c_white, 1);
} else {
    draw_sprite_ext(spr_shooting_attack_small, 0, 80, 60, 1, 1, 0, c_gray, 0.5);
}

// ==== Trail ====
if (global.trail[? "unlocked"]) {
    draw_sprite_ext(spr_trail_attack_big, 0, 200, 60, 0.5, 0.5, 0, c_white, 1);
} else {
    draw_sprite_ext(spr_trail_attack_small, 0, 200, 60, 1, 1, 0, c_gray, 0.5);
}

// ==== Swipe ====
if (global.swipe[? "unlocked"]) {
    draw_sprite_ext(spr_arcing_attack_big, 0, 320, 60, 0.5, 0.5, 0, c_white, 1);
} else {
    draw_sprite_ext(spr_arcing_attack_small, 0, 320, 60, 1, 1, 0, c_gray, 0.5);
}









// ⚠️ Estas partes de íconos de armas puedes dejarlas si todavía quieres
// mostrar cuáles armas están desbloqueadas, si no quieres HUD de armas, coméntalo
//draw_sprite(spr_shooting_attack_small, global.shooting[? "unlocked"], 40, 20);
//draw_sprite(spr_trail_attack_small, global.trail[? "unlocked"], 40 + 120, 20);
//draw_sprite(spr_arcing_attack_small, global.swipe[? "unlocked"], 40 + 240, 20);










// ⚠️ Todo esto era de la barra de experiencia → ya no sirve
/*
draw_sprite_ext(spr_xpbar_back, 0, 400, 30, 1120 / 65, 1, 0, c_white, 1);

// Get how much the bar should be filled.
//var _fill = min(global.xp / global.xp_goal, 1);

// Draw the experince bar filling.
draw_sprite_ext(spr_xpbar_fill, 0, 407, 37, (1172 / 54) * _fill, 1, 0, c_white, 1);
*/

// Set the font.
draw_set_font(fnt_small);

// Center the text vertically and horizontally.
// ⚠️ Esto mostraba el nivel, ya no existe
/*
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(1450, 65, "LV: " + string(global.level));
*/

// Reset text alignments
draw_set_halign(fa_left);
draw_set_valign(fa_top);










if (global.dialogo_activo) {
    // Fondo del cuadro de diálogo
    var ancho = display_get_gui_width() - 200;
    var alto = 120;
    var pos_x = 100;
    var pos_y = display_get_gui_height() - alto - 50;

    draw_set_colour(c_black);
    draw_set_alpha(0.7);
    draw_roundrect(pos_x, pos_y, pos_x + ancho, pos_y + alto, false);
    draw_set_alpha(1);

    // Texto del diálogo
    draw_set_font(fnt_medium);
    draw_set_colour(c_white);
    draw_set_halign(fa_left);
    draw_text(pos_x + 20, pos_y + 40, global.dialogo_texto);
}
