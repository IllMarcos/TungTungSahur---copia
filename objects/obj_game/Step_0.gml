// If the game is NOT over...
if (!instance_exists(obj_game_over))
{
    // Si el héroe se queda sin vida
    if (obj_hero.hitpoints <= 0)
    {
        // Destruir al jugador
        with (obj_hero) instance_destroy();
    
        // Destruir balas
        with (obj_hero_bullet) instance_destroy();
    
        // Destruir enemigos
        with (obj_enemy) instance_destroy();
    
        // Destruir monedas (antes XP)
        with (obj_collectable) instance_destroy();
    
        // Destruir corazones
        with (obj_heart) instance_destroy();
    
        // Pausar todo
        pause();
        
        // Crear pantalla de Game Over
        instance_create_layer(1920 / 2, 1080 / 2 - 150, "UpgradeScreen", obj_game_over);
    }
}

// ⚠️ Todo este bloque de upgrades automáticos ya no se usa, lo comentamos:
/*
if (!instance_exists(obj_upgrade) && !instance_exists(obj_template_complete))
{
    if (global.xp >= global.xp_goal)
    {
        with (obj_enemy) instance_destroy();
        with (obj_hero_bullet) instance_destroy();
        with (obj_collectable) instance_destroy();
        with (obj_heart) instance_destroy();
        
        if (global.level == 10)
        {
            instance_create_layer(1920 / 2, 1080 / 2, "UpgradeScreen", obj_template_complete);
        }
        else
        {
            global.level += 1;
            next_wave();
            instance_create_layer(0, 0, "Instances", obj_upgrade_screen);
        }
    }
}
*/

// ⚠️ También quitamos el spawner automático, ahora usas obj_enemy_spawner
/*
if (!global.paused)
{
    spawn_enemy_cooldown--;
    if (spawn_enemy_cooldown <= 0)
    {
        spawn_enemy();    
    }
}
*/
