if (!instance_exists(obj_player)) exit;

// Se o limite_x já foi definido (etapa >= 5), impede fisicamente o player de andar para trás (esquerda)
if (etapa >= 5 && limite_x > 0) {
    if (obj_player.x < limite_x) {
        obj_player.x = limite_x;
        if (obj_player.velh < 0) obj_player.velh = 0;
    }
}

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
        { nome: "Professor", texto: "Olha só... o Batman resolveu aparecer!", maquina: true, tempo: 3 }
    ];
    
    etapa = 1;
}

// 2. Espera a fala do Rizzi terminar para mostrar o prompt de apertar [E]
if (etapa == 1 && !instance_exists(obj_textbox)) {
    pode_entrar = true;
    
    // Quando o jogador apertar E para entrar
    if (keyboard_check_pressed(ord("E"))) {
        pode_entrar = false; // Esconde o texto da tela
        fade_tipo   = 1;     // Inicia o Fade Out (escurecer)
        etapa       = 2;
        
        // Toca o áudio 'escrevendo' em loop durante o período de tela preta
        if (audio_exists(escrevendo) && !audio_is_playing(escrevendo)) {
            audio_play_sound(escrevendo, 1, true);
        }
    }
}

// 3. Efeito de Fade Out gradual (Escurece a tela)
if (fade_tipo == 1) {
    if (alpha_preto < 1) {
        alpha_preto += 0.02;
    } else {
        alpha_preto = 1;
        fade_tipo = 0; // Pausa o fade
        
        // Sumir com o Rizzi se ele ainda existir
        if (instance_exists(obj_rizzi)) {
            instance_destroy(obj_rizzi);
        }
    }
}

// Quando a tela fica 100% preta na Etapa 2
if (etapa == 2 && alpha_preto >= 1 && fade_tipo == 0) {
    timer_preto_inicial++;
    
    // Espera 2 segundos (120 frames) na tela preta antes de iniciar o diálogo
    if (timer_preto_inicial >= 120) {
        etapa = 3;
        
        var _caixa_sala = instance_create_depth(0, 0, -9999, obj_textbox);
        _caixa_sala.falas = [
            { nome: "Professor", texto: "TÁ NA 1 AINDA??", maquina: true, tempo: 2 },
            { nome: "Tini", texto: "To não psor", maquina: true, tempo: 2 }
        ];
    }
}

// 4. Espera o diálogo da tela preta terminar e aguarda 2s adicionais
if (etapa == 3 && !instance_exists(obj_textbox)) {
    timer_preto_final++;
    
    // Espera mais 2 segundos (120 frames) na tela preta antes de dar o Fade In
    if (timer_preto_final >= 120) {
        fade_tipo = 2; // Inicia o Fade In (clarear)
        etapa = 4;
    }
}

// 5. Efeito de Fade In gradual (Clareia a tela suavemente)
if (fade_tipo == 2) {
    if (alpha_preto > 0) {
        alpha_preto -= 0.02;
    } else {
        alpha_preto = 0;
        fade_tipo = 0;
        
        // Para o áudio 'escrevendo' assim que a tela clareia totalmente
        if (audio_exists(escrevendo) && audio_is_playing(escrevendo)) {
            audio_stop_sound(escrevendo);
        }
        
        // Define o limite X atrás do player para ele não poder recuar
        limite_x = obj_player.x - 20;
        
        // Cria uma coluna de objetos obj_colisao de cima a baixo para garantir colisão física rígida
        for (var _yy = -200; _yy <= room_height + 200; _yy += 64) {
            instance_create_depth(limite_x - 32, _yy, depth, obj_colisao);
        }
        
        // MANTÉM O PLAYER PARADO para as duas primeiras frases
        obj_player.estado = obj_player.p_cutscene;
        obj_player.velh = 0;
        obj_player.velv = 0;
        obj_player.sprite_index = spr_player_idle;
        
        // Diálogo do Tini reclamando da prova (com o player parado)
        var _caixa_reclama = instance_create_depth(0, 0, -9999, obj_textbox);
        _caixa_reclama.falas = [
            { nome: "Tini", texto: "Mas que prova foi essa...", maquina: true, tempo: 2 },
            { nome: "Tini", texto: "Vou trancar essa caramba", maquina: true, tempo: 2 }
        ];
        
        etapa = 5;
    }
}

// 6. Espera as duas primeiras frases terminarem e LIBERA O PLAYER PARA ANDAR
if (etapa == 5) {
    if (!instance_exists(obj_textbox)) {
        // Libera o player para andar livremente
        obj_player.estado = obj_player.p_idle;
        timer_pos_fade = 0;
        etapa = 6;
    }
}

// 7. Espera 1 segundo enquanto o player JÁ PODE ANDAR e exibe a frase "Hora de ir para casa primeiro"
if (etapa == 6) {
    timer_pos_fade++;
    
    if (timer_pos_fade >= 60) { // 1 segundo
        var _caixa_casa = instance_create_depth(0, 0, -9999, obj_textbox);
        _caixa_casa.falas = [
            { nome: "Tini", texto: "Hora de ir para casa primeiro", maquina: true, tempo: 2 }
        ];
        
        etapa = 7;
    }
}

// 8. Quando o diálogo "Hora de ir para casa primeiro" terminar, destrói o gatilho
if (etapa == 7) {
    if (!instance_exists(obj_textbox)) {
        if (audio_exists(escrevendo) && audio_is_playing(escrevendo)) {
            audio_stop_sound(escrevendo);
        }
        instance_destroy();
    }
}