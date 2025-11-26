// Archivo: objects/obj_multiplayer_menu/Create_0.gml

// 1. Crear el controlador si no existe
if (!instance_exists(obj_network_controller)) {
    instance_create_layer(0, 0, "Instances", obj_network_controller);
}

// =========================================================
// 2. CORRECCIÓN DEL ERROR: ASIGNAR VARIABLE GLOBAL
// =========================================================
// Buscamos el objeto y lo guardamos en la variable global
global.network_controller = instance_find(obj_network_controller, 0);


// --- CONFIGURACIÓN DE INTERFAZ ---
var _margin_left = 160; 
var _margin_top = 80;   
var _sep = 100;         

// --- BOTÓN 1: HOST ---
var _btn_host = instance_create_layer(_margin_left, _margin_top, "Instances", obj_button);
_btn_host.button_text = "CREAR SALA (HOST)";
_btn_host.width = 280;
_btn_host.height = 60;

_btn_host.action_script = function() 
{
    // Ahora esta línea ya no dará error porque la variable existe
    global.network_controller.network_mode = 1;
    
    // Crear Servidor UDP
    global.network_controller.network_socket = network_create_server(network_socket_udp, 6510, 2);
    
    if (global.network_controller.network_socket < 0) {
        show_message("Error al crear servidor. ¿Puerto ocupado?");
    } else {
        room_goto(rm_game); 
    }
};

// --- BOTÓN 2: JOIN ---
var _btn_join = instance_create_layer(_margin_left, _margin_top + _sep, "Instances", obj_button);
_btn_join.button_text = "UNIRSE A IP";
_btn_join.width = 280;
_btn_join.height = 60;

_btn_join.action_script = function() 
{
    // Usamos get_string_ASYNC para que funcione en Android/iOS sin congelar el juego
    // Guardamos el "ID" del pedido en la variable del controlador
    var _mensaje = "Escribe la IP del Host (Ej: 192.168.1.X):";
    var _ip_defecto = "192.168.1."; 
    
    // IMPORTANTE: Asignamos esto a la variable que ya preparaste en el controlador
    global.network_controller.client_ip_promise = get_string_async(_mensaje, _ip_defecto);
};