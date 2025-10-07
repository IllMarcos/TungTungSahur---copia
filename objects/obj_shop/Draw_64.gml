// ============================
// obj_shop - Draw GUI Event
// ============================

// Fondo oscuro que cubre todo
draw_set_alpha(0.7);
draw_set_color(c_black);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);
draw_set_color(c_white);

// Panel central
var panel_w = 700;
var panel_h = 500;
var panel_x1 = display_get_gui_width()/2 - panel_w/2;
var panel_y1 = display_get_gui_height()/2 - panel_h/2;
var panel_x2 = panel_x1 + panel_w;
var panel_y2 = panel_y1 + panel_h;

draw_set_color(make_color_rgb(40,40,60));
draw_rectangle(panel_x1, panel_y1, panel_x2, panel_y2, false);
draw_set_color(c_white);

// Título
draw_set_font(fnt_small);
draw_set_halign(fa_center);
draw_text((panel_x1+panel_x2)/2, panel_y1 + 30, "🏪 TIENDA DE MEJORAS 🏪");

// Posiciones de ítems
var row_y = panel_y1 + 100;
var row_gap = 100;
var buy_x = panel_x2 - 160;
var buy_w = 120;
var buy_h = 40;

// Dibujar ítems
for (var i = 0; i < ds_list_size(shop_items); i++) {
    var item = ds_list_find_value(shop_items, i);

    var titulo = item[? "title"];
    var desc   = item[? "description"];
    var precio = item[? "price"];
    var icono  = item[? "icon"];

    // Icono
    draw_sprite(icono, 0, panel_x1 + 60, row_y);

    // Texto
    draw_set_halign(fa_left);
    draw_text(panel_x1 + 120, row_y - 15, string_upper(titulo) + " (" + string(precio) + ")");
    draw_set_color(c_ltgray);
    draw_text(panel_x1 + 120, row_y + 10, desc);
    draw_set_color(c_white);

    // Botón Comprar
    draw_set_color(make_color_rgb(200,200,200));
    draw_rectangle(buy_x, row_y - 15, buy_x + buy_w, row_y - 15 + buy_h, false);
    draw_set_color(c_black);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(buy_x + buy_w/2, row_y - 15 + buy_h/2, "COMPRAR");

    row_y += row_gap;
}

// Mensaje de error o confirmación
if (error_timer > 0) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_red);
    draw_text(display_get_gui_width()/2, panel_y2 + 40, error_message);
    draw_set_color(c_white);
}

// Botón de cerrar (obj_boton_tienda se dibuja solo)
if (instance_exists(close_button)) {
    close_button.x = panel_x2 - 40;
    close_button.y = panel_y1 + 40;
}
