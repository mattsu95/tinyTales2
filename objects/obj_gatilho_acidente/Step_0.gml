if (!ativado) {
    // Checa se o player PASSOU do X desse objeto E se ele está de bicicleta
    if (instance_exists(obj_player) && obj_player.x >= x && obj_player.ta_de_bike) {
        
        ativado = true; // Trava para não rodar de novo
        
        // 1. Trava o player imediatamente
        with (obj_player) {
            estado = p_cutscene; // Joga ele pro estado que ignora o teclado
            vel_atual_bike = 0; 
            velh = 0;
            velv = 0;
            image_speed = 0; // Pausa a animação da rodinha girando
        }
        
        // 2. Toca o som do acidente! (ele vai continuar tocando mesmo com a tela preta)
        audio_play_sound(car_crash, 1, false);
        
        // 3. Cria o carro fora da tela, vindo da direita
        var _cam_x = camera_get_view_x(view_camera[0]);
        var _cam_w = camera_get_view_width(view_camera[0]);
        
        // Cria o carro um pouco fora da câmera pela direita, na mesma altura Y do player
        instance_create_layer(_cam_x + _cam_w + 100, obj_player.y, "Instances_1", obj_carro);
    }
} 
else {
    // Se o gatilho já foi ativado, começa a contar o tempo pro impacto
    timer++;
    
    // Calcula exatos 1.4 segundos baseado no FPS do seu jogo (ex: 60 fps)
    var _tempo_impacto = round(game_get_speed(gamespeed_fps) * 1);
    
    // Quando der os 1.4 segundos...
    if (timer == _tempo_impacto) {
        // Corta pra tela preta!
        instance_create_layer(0, 0, "Instances_1", obj_tela_preta);
        
        // (Opcional) Treme a tela pra dar um impacto extra no exato momento
        // Se quiser usar, você pode chamar aquela sua função de tremor aqui!
    }
}