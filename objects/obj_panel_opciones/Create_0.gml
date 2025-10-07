// Crear el botón cerrar en la esquina superior derecha del panel
var _boton = instance_create_layer(x + sprite_width/2 - 32, y - sprite_height/2 + 32, "GUI", obj_boton_cerrar);

// Guardar referencia al panel en el botón (para que sepa a quién cerrar)
_boton.panel_padre = id;
