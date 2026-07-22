if (!instance_exists(obj_player)) exit;

// 1. GATILHO: Player chega perto do Rizzi
if (!ativado && obj_player.x >= x - 40) {
    ativado = true;
    
    // Trava o player
    obj_player.estado = obj_player.p_cutscene;
    obj_player.velh = 0;
    obj_player.velv = 0;
    obj_player.sprite_index = spr_player_idle;
    
    // Fala do Rizzi
    var _caixa = instance_create_depth(0, 0, -9999, obj_textbox);
    _caixa.falas = [
        { nome: "Rizzi", texto: "Olha só... o Batman resolveu aparecer!", maquina: true, tempo: 3 }
    ];
    
    etapa = 1;
}

// 2. Espera a fala terminar para mostrar o prompt de apertar [E]
if (etapa == 1 && !instance_exists(obj_textbox)) {
    pode_entrar = true;
    
    // Quando o jogador apertar E para entrar
    if (keyboard_check_pressed(ord("E"))) {
        pode_entrar = false; // Esconde o texto da tela
        tela_preta  = true;  // Inicia o Fade Out
        etapa       = 2;
    }
}

// 3. Efeito de Escurecer a Tela (Fade Out gradual)
if (tela_preta) {
    if (alpha_preto < 1) {
        alpha_preto += 0.02; // Aumenta a opacidade da tela preta suavemente
    }
}