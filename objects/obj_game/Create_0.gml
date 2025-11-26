// TungTungSahur/objects/obj_game/Create_0.gml

global.dialogo_activo = false;
global.dialogo_texto = "";

// Contador de monedas
// global.coins = 0; <--- ELIMINAR O COMENTAR ESTA LÍNEA

// Start the game music on a loop
audio_play_sound(snd_music_game, 0, true);
// El juego comienza sin estar en pausa
global.paused = false;
// Multiplicador de vida de los enemigos (puedes mantenerlo si lo quieres usar)
global.enemy_health_bonus = 1;

// Crear al héroe en el centro de la sala
instance_create_layer(room_width / 2, room_height / 2, "Instances", obj_hero);
//instance_create_layer(50, 50, "Instances", obj_hero);

// Resetear los valores de las armas
// weapon_shooting_reset(); <--- ELIMINAR O COMENTAR ESTA LÍNEA
// weapon_swipe_reset(); <--- ELIMINAR O COMENTAR ESTA LÍNEA
// weapon_trail_reset(); <--- ELIMINAR O COMENTAR ESTA LÍNEA

// Botón de pausa
instance_create_layer(1820, 20, "UpgradeScreen", obj_pause_button);