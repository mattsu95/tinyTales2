timer++;
angulo_raios += 0.8; // Gira os raios de sol

// Mantém o player parado no estado de cutscene enquanto a tela do desbloqueio estiver rodando
if (instance_exists(obj_player)) {
    obj_player.estado = obj_player.p_cutscene;
    obj_player.velh = 0;
    obj_player.velv = 0;
}

// Após exatos 4 segundos (240 frames)
if (timer >= max_timer) {
    if (instance_exists(obj_player)) {
        obj_player.ta_de_bike = false;          // Tira a bicicleta
        obj_player.estado = obj_player.p_idle;  // Devolve o controle normal do player andando a pé!
        obj_player.sprite_index = spr_player_idle; // Volta o sprite do player a pé
        obj_player.image_xscale = 1;            // Restaura o tamanho normal (não achatado)
        obj_player.image_yscale = 1;            // Restaura a altura normal
        obj_player.velh = 0;
        obj_player.velv = 0;
        
        // Posiciona o player logo à frente do local do acidente para seguir o jogo livremente!
        if (instance_exists(obj_gatilho_acidente)) {
            obj_player.x = max(obj_player.x, obj_gatilho_acidente.x + 50);
        } else {
            obj_player.x = max(obj_player.x, 5630);
        }
    }
    instance_destroy();
}
