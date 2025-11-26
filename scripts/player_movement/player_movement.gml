// Archivo: scripts/player_movement/player_movement.gml (CÓDIGO CORREGIDO Y REVISADO)

function player_movement() 
{
    // Solo el jugador local de esta máquina puede enviar input
    if (!is_local_player) exit; 

    // ... (Código de captura de input, hspeed, vspeed, y normalización es el mismo) ...

    // ========================
    // Animación y dirección (Actualización visual inmediata)
    // ========================
    if (hspeed != 0) {
        image_xscale = sign(hspeed); 
    }
    
    // CORRECCIÓN: Usar asset_get_index para evitar errores si la constante no es global.
    var _run_sprite = asset_get_index("spr_hero_run_22");
    var _idle_sprite = asset_get_index("spr_hero_idle");
    
    if (sprite_index != spr_hero_hit)
    {
        if (hspeed != 0 || vspeed != 0)
        {
            if (_run_sprite != -1) sprite_index = _run_sprite;
        }
        else
        {
            if (_idle_sprite != -1) sprite_index = _idle_sprite;
        }
    }

    // ========================
    // LÓGICA DE RED: Solo mover si es Servidor, o enviar input si es Cliente
    // ========================
    if (global.network_controller.network_mode == 1) // Si es el Servidor, aplica movimiento
    {
        x += hspeed;
        y += vspeed;
    }
    else if (global.network_controller.network_mode == 2) // Si es el Cliente, envía el input
    {
        // Enviar el input capturado (hspeed, vspeed) al Servidor
        var _buffer = buffer_create(64, buffer_fixed, 1);
        buffer_write(_buffer, buffer_u8, NET_PACKET_TYPE.MOVEMENT_INPUT);
        buffer_write(_buffer, buffer_u8, player_id);
        buffer_write(_buffer, buffer_s16, hspeed); 
        buffer_write(_buffer, buffer_s16, vspeed);
        
        network_send_udp(global.network_controller.network_socket, global.network_controller.server_ip, NET_PORT, _buffer, buffer_get_size(_buffer));
        buffer_delete(_buffer);
        
        // Mover localmente (predicción de cliente)
        x += hspeed; 
        y += vspeed;
    }
}