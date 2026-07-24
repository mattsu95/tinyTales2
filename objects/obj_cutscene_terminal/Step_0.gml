if (!instance_exists(obj_player)) exit;

// 1. ETAPA 0: Ao entrar no Terminal, exibe a instrução "Pegue o primeiro ônibus"
if (etapa == 0) {
    if (!dialogo_inicial_feito) {
        dialogo_inicial_feito = true;
        
        var _caixa_init = instance_create_depth(0, 0, -9999, obj_textbox);
        _caixa_init.falas = [
            { texto: "Pegue o ônibus pra corbélia que está aqui no terminal sul", maquina: true, tempo: 3 }
        ];
    }
    
    // Quando o texto inicial sumir, o jogador pode andar até se aproximar dos pelegos
    if (dialogo_inicial_feito && !instance_exists(obj_textbox)) {
        etapa = 1;
    }
}

// 2. ETAPA 1: Player caminha livremente até X >= 1300 (perto dos pelegos)
if (etapa == 1) {
    if (obj_player.x >= 1300) {
        // Trava o controle do player para a cutscene
        obj_player.estado = obj_player.p_cutscene;
        obj_player.velh = 0;
        obj_player.velv = 0;
        etapa = 2;
    }
}

// 3. ETAPA 2: Tini anda sozinho até se aproximar totalmente dos pelegos (X >= 1420)
if (etapa == 2) {
    obj_player.estado = obj_player.p_cutscene;
    
    if (obj_player.x < 1420) {
        obj_player.x += 1.5; // Tini anda sozinho para a direita
        obj_player.sprite_index = spr_player_walk;
        obj_player.image_xscale = 1;
    } else {
        // Chegou perto dos pelegos! Para o player em idle
        obj_player.sprite_index = spr_player_idle;
        obj_player.velh = 0;
        
        // Inicia o diálogo de discussão
        var _caixa_briga = instance_create_depth(0, 0, -9999, obj_textbox);
        _caixa_briga.falas = [
            { nome: "Tini", texto: "Esse é o ônibus de Corbélia?", maquina: true, tempo: 3 },
            { nome: "Pelego", texto: "Sim, é esse sim.", maquina: true, tempo: 3 },
            { nome: "Tini", texto: "Você não vai tá querendo subir não???", maquina: true, tempo: 3 },
            { nome: "Pelego", texto: "Como assim subir??? Tá me tirando???", maquina: true, tempo: 3 }
        ];
        
        etapa = 3;
    }
}

// 4. ETAPA 3: Espera o diálogo de briga terminar e LIBERA O COMBATE!
if (etapa == 3) {
    if (!instance_exists(obj_textbox)) {
        // Devolve o controle ao player
        obj_player.estado = obj_player.p_idle;
        etapa = 4;
    }
}

// 5. ETAPA 4: Combate rolando! Aguarda a derrota dos 3 Pelegos
if (etapa == 4) {
    if (!instance_exists(pelego)) {
        // Trava o player para a cutscene pós-luta
        obj_player.estado = obj_player.p_cutscene;
        obj_player.velh = 0;
        obj_player.velv = 0;
        obj_player.sprite_index = spr_player_idle;
        
        var _caixa_pos = instance_create_depth(0, 0, -9999, obj_textbox);
        _caixa_pos.falas = [
            { nome: "Tini", texto: "Pronto, deitei esses pelegos! Agora sim, bora pegar o ônibus pra Corbélia!", maquina: true, tempo: 4 }
        ];
        
        etapa = 5;
    }
}

// 6. ETAPA 5: Espera a fala pós-luta terminar
if (etapa == 5) {
    obj_player.estado = obj_player.p_cutscene;
    
    if (!instance_exists(obj_textbox)) {
        etapa = 6;
    }
}

// 7. ETAPA 6: Tini caminha sozinho até a porta do ônibus (X >= 1620)
if (etapa == 6) {
    obj_player.estado = obj_player.p_cutscene;
    
    if (obj_player.x < 1620) {
        obj_player.x += 1.5;
        obj_player.sprite_index = spr_player_walk;
        obj_player.image_xscale = 1;
    } else {
        obj_player.sprite_index = spr_player_idle;
        obj_player.velh = 0;
        
        var _caixa_embarque = instance_create_depth(0, 0, -9999, obj_textbox);
        _caixa_embarque.falas = [
            { nome: "Tini", texto: "Flou rapaziada, fui pra Corbélia!", maquina: true, tempo: 3 }
        ];
        
        etapa = 7;
    }
}

// 8. ETAPA 7: Espera a fala de embarque terminar
if (etapa == 7) {
    obj_player.estado = obj_player.p_cutscene;
    
    if (!instance_exists(obj_textbox)) {
        etapa = 8;
    }
}

// 9. ETAPA 8: Tela escurecendo (fade out) -> enche inventário e vai pra room corbelia
if (etapa == 8) {
    obj_player.estado = obj_player.p_cutscene;
    
    alpha_preto = clamp(alpha_preto + 0.02, 0, 1);
    
    if (alpha_preto >= 1 && !trocando) {
        trocando = true;
        
        // Define o inventário com exatamente 4 poções de dano e 4 poções de cura para iniciar Corbélia
        obj_player.inventario = [];
        repeat (4) {
            array_push(obj_player.inventario, {
                nome: "Poção de Dano",
                sprite: spr_pocao_dano,
                objeto: obj_pocao,
                efeito: "dano"
            });
            array_push(obj_player.inventario, {
                nome: "Poção de Cura",
                sprite: spr_pocao,
                objeto: obj_pocao,
                efeito: "cura"
            });
        }
        
        room_goto(corbelia);
    }
}
