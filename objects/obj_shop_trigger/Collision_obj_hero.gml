hero_in_shop = true;

// Si no existe la tienda, crearla
if (!instance_exists(obj_upgrade_screen)) {
    instance_create_layer(1920/2, 1080/2, "shopUI", obj_upgrade_screen);
}


//instance_create_layer(1920/2, 1080/2, "UpgradeScreen", obj_shop);

//instance_create_layer(0, 0, "Instances", obj_upgrade_screen);

