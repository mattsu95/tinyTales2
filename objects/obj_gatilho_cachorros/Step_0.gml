if (instance_exists(obj_player)) {
    
    // Checa se o player encostou ou passou da linha do gatilho
    if (place_meeting(x, y, obj_player) || obj_player.x >= x) {
        
        // 1. PARA o som da cidade! A paz acabou kkkk
        audio_stop_sound(city_sounds);
        
        // 2. Inicia a cutscene
        instance_create_layer(0, 0, "Instances_1", obj_cutscene_dog);
        
        // 3. Destrói o gatilho
        instance_destroy();
    }
}