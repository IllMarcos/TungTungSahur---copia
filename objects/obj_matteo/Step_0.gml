// Detectar si el héroe está en colisión
if (place_meeting(x, y, obj_hero)) {
    if (!collision_activa) {
        // 🔹 Comenzó la colisión (equivalente al evento Collision)
        global.dialogo_activo = true;
        global.dialogo_texto = "¡Hola, viajero! Bienvenido a mi tienda.";

        collision_activa = true;
    }
} else {
    if (collision_activa) {
        // 🔹 Terminó la colisión (equivalente al evento End Collision)
        global.dialogo_activo = false;

        collision_activa = false;
    }
}
