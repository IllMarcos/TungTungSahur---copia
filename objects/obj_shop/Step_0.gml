// ============================
// obj_shop - Step Event
// ============================

// Control de error message
if (error_timer > 0) {
    error_timer--;
}

// Detección de click en botones de compra
if (mouse_check_button_pressed(mb_left)) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    var panel_w = 700;
    var panel_h = 500;
    var panel_x1 = display_get_gui_width()/2 - panel_w/2;
    var panel_y1 = display_get_gui_height()/2 - panel_h/2;
    var panel_x2 = panel_x1 + panel_w;

    var row_y = panel_y1 + 100;
    var row_gap = 100;
    var buy_x = panel_x2 - 160;
    var buy_w = 120;
    var buy_h = 40;

    for (var i = 0; i < ds_list_size(shop_items); i++) {
        if (mx > buy_x && mx < buy_x + buy_w && my > row_y - 15 && my < row_y - 15 + buy_h) {
            var item = ds_list_find_value(shop_items, i);
            var precio = item[? "price"];

            if (global.coins >= precio) {
                // ✅ Compra realizada
                global.coins -= precio;

                // Aquí aplicas la mejora, ej: aumentar daño
                if (item[? "title"] == "SPEED") {
                    global.shooting[? "attack_speed"] = max(5, global.shooting[? "attack_speed"] - 5);
                }
                if (item[? "title"] == "DAMAGE") {
                    global.shooting[? "damage"] += 0.5;
                }

                error_message = "✔ ¡Mejora comprada!";
                error_timer = 90;
            } else {
                // ❌ No alcanza
                error_message = "❌ No tienes suficientes monedas!";
                error_timer = 90;
            }
        }
        row_y += row_gap;
    }
}
