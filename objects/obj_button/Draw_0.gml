// Dimensiones a usar
var _w = (sprite_index != -1) ? sprite_width : width;
var _h = (sprite_index != -1) ? sprite_height : height;

// Aplicar escala
_w *= scale;
_h *= scale;

// 1. DIBUJAR FONDO (Si hay sprite se usa, si no, un rectángulo bonito)
if (sprite_index != -1)
{
    draw_sprite_ext(sprite_index, 0, x, y, scale, scale, 0, c_white, 1);
}
else
{
    // Fondo oscuro semitransparente
    draw_set_color(c_black);
    draw_set_alpha(0.5);
    draw_roundrect_ext(x - _w/2, y - _h/2, x + _w/2, y + _h/2, 20, 20, false);
    
    // Borde de color (Verde si está encima, Blanco si no)
    draw_set_alpha(1);
    var _color_borde = hovering ? c_lime : c_white;
    draw_set_color(_color_borde);
    draw_roundrect_ext(x - _w/2, y - _h/2, x + _w/2, y + _h/2, 20, 20, true);
}

// 2. DIBUJAR TEXTO
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(-1); // Usa tu fuente personalizada si tienes

// Sombra del texto
draw_set_color(c_black);
draw_text_transformed(x + 2, y + 2, button_text, scale, scale, 0);

// Texto principal
draw_set_color(hovering ? c_yellow : c_white);
draw_text_transformed(x, y, button_text, scale, scale, 0);

// Resetear colores
draw_set_color(c_white);