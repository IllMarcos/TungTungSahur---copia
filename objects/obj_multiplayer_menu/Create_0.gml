// Archivo: obj_multiplayer_menu/Create_0.gml (COMPLETO)

// Crear el controlador de red (solo si no existe, y solo en la capa "Instances" o "GUI")
if (!instance_exists(obj_network_controller))
{
    instance_create_layer(0, 0, "Instances", obj_network_controller);
}
global.network_controller = instance_find(obj_network_controller, 0);

// Usar coordenadas de pantalla GUI para centrado
var _mid_x = display_get_gui_width() / 2;
var _mid_y = display_get_gui_height() / 2;
var _spacing = 100;

// Botón para iniciar como Servidor (TungTung1)
var _host_btn = instance_create_layer(_mid_x, _mid_y - _spacing, "GUI", obj_button);
_host_btn.my_text = "HOST (TungTung1)";
_host_btn.my_script = function()
{
    global.network_controller.network_mode = 1;
    // Crear socket UDP para el servidor (soporta 2 clientes/jugadores)
    global.network_controller.network_socket = network_create_server(network_socket_udp, NET_PORT, MAX_PLAYERS);
    
    // Crear el héroe local (TungTung1).
    instance_create_layer(room_width/2, room_height/2, "Instances", obj_hero);
    
    // Asumimos que su sala de juego se llama rm_game
    room_goto(rm_game); 
};

// Botón para iniciar como Cliente (TungTung2)
var _client_btn = instance_create_layer(_mid_x, _mid_y + _spacing, "GUI", obj_button);
_client_btn.my_text = "JOIN (TungTung2)";
_client_btn.my_script = function()
{
    // Usamos get_string_async para que el juego no se bloquee.
    // Guardamos la promesa del ID para el evento Async - Dialog.
    global.network_controller.client_ip_promise = get_string_async("IP del Host (ej: 192.168.1.10)", "127.0.0.1"); 
};