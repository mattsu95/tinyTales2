if (!instance_exists(obj_player)) exit;

// 1. GATILHO: Dispara APENAS após o fim dos diálogos da UNIOESTE e quando o carro estiver visível na câmera (X >= x, que é 3660)
if (!ativado && !instance_exists(obj_gatilho_unioeste) && !instance_exists(obj_textbox) && obj_player.x >= x) {
    ativado = true;
    
    // Trava o player para assistir a cutscene
    obj_player.estado = obj_player.p_cutscene;
    obj_player.velh = 0;
    obj_player.velv = 0;
    obj_player.sprite_index = spr_player_idle;
    
    // Localiza ou cria o carro do Tini (posicionado em X = 3840)
    carro_inst = instance_nearest(3840, 128, obj_carro_tini);
    if (!instance_exists(carro_inst)) {
        carro_inst = instance_create_depth(3840, 128, -100, obj_carro_tini);
    }
    
    // Localiza o Vinicius que já está parado no mapa perto do carro (em X=3740)
    vini_inst = instance_nearest(3740, 148, obj_vinicius);
    if (!instance_exists(vini_inst)) {
        vini_inst = instance_create_depth(carro_inst.x - 100, carro_inst.y + 20, -100, obj_vinicius);
    }
    vini_inst.sprite_index = spr_boss_walk;
    vini_inst.image_xscale = -1; // Virado para a direita (em direção ao carro)
    
    timer_cutscene = 0;
    
    // Fala do Vinícius ao iniciar a cutscene
    var _caixa_vini = instance_create_depth(0, 0, -9999, obj_textbox);
    _caixa_vini.falas = [
        { nome: "Vinícius", texto: "Fihh, isso aqui não é de bolo fihh! Tô indo pra Corbélia agora fihh!", maquina: true, tempo: 4 }
    ];
    
    etapa = 1;
}


// 2. ETAPA 1: Vinicius caminha devagar e visivelmente até o carro
if (etapa == 1) {
    if (instance_exists(vini_inst) && instance_exists(carro_inst)) {
        vini_inst.x += 0.9; // Caminhada mais devagar para ser vista com clareza
        vini_inst.sprite_index = spr_boss_walk;
        
        // Quando Vinicius chega bem perto da porta do carro
        if (vini_inst.x >= carro_inst.x - 20) {
            vini_inst.sprite_index = spr_boss_walk;
            timer_cutscene++;
            
            // Pausa de 0.5s na porta antes de entrar
            if (timer_cutscene >= 30) {
                instance_destroy(vini_inst);
                vini_inst = noone;
                
                timer_cutscene = 0;
                etapa = 2;
            }
        }
    } else {
        etapa = 2;
    }
}

// 3. ETAPA 2: O motor do carro liga e ronca antes de arrancar
if (etapa == 2) {
    if (instance_exists(carro_inst)) {
        timer_cutscene++;
        
        // No 1º frame, toca o áudio do motor
        if (timer_cutscene == 1) {
            if (audio_exists(car_engine)) {
                audio_play_sound(car_engine, 1, false);
            }
        }
        
        // Pequena vibração do carro por 1 segundo enquanto o motor ronca
        carro_inst.y = 128 + irandom_range(-1, 1);
        
        // Após 1 segundo de motor ligando, inicia o movimento
        if (timer_cutscene >= 60) {
            carro_inst.y = 128;
            timer_cutscene = 0;
            vel_carro = 2.0;
            etapa = 3;
        }
    } else {
        etapa = 3;
    }
}

// 4. ETAPA 3: Carro acelera gradualmente e foge para a direita
if (etapa == 3) {
    if (instance_exists(carro_inst)) {
        carro_inst.x += vel_carro;
        
        // Aceleração suave e visível
        if (vel_carro < 8.0) {
            vel_carro += 0.08;
        }
        
        // Quando o carro sai completamente da tela
        if (carro_inst.x >= obj_player.x + 650) {
            instance_destroy(carro_inst);
            carro_inst = noone;
            etapa = 4;
        }
    } else {
        etapa = 4;
    }
}

// 5. ETAPA 4: Ativa o aviso "CORRA ATRÁS DO SEU CARRO!" e devolve o controle ao player
if (etapa == 4) {
    mostra_prompt = true;
    
    // Libera o player para correr
    obj_player.estado = obj_player.p_idle;
    distancia_inicial = obj_player.x;
    timer_espera = 0;
    
    etapa = 5;
}

// 6. ETAPA 5: Jogador corre um trecho tentando alcançar o carro que já sumiu
if (etapa == 5) {
    timer_espera++;
    
    // Quando o player avança 250 pixels para a direita (ou após 5 segundos)
    if (obj_player.x >= distancia_inicial + 250 || timer_espera >= 300) {
        mostra_prompt = false;
        
        // Trava o player para a fala de lamentação
        obj_player.estado = obj_player.p_cutscene;
        obj_player.velh = 0;
        obj_player.velv = 0;
        obj_player.sprite_index = spr_player_idle;
        
        // Diálogo do Tini lamentando ter perdido o carro
        var _caixa = instance_create_depth(0, 0, -9999, obj_textbox);
        _caixa.falas = [
            { nome: "Tini", texto: "NOSSA MAIS ESSA AINDA", maquina: true, tempo: 3 },
            { nome: "Tini", texto: "Ja fui mal na prova e agora nem carro tenho pra voltar pra casa", maquina: true, tempo: 4 }
        ];
        
        etapa = 6;
    }
}

// 7. ETAPA 6: Finaliza a cutscene após o diálogo sumir
if (etapa == 6) {
    if (!instance_exists(obj_textbox)) {
        // Libera o player para seguir o jogo
        obj_player.estado = obj_player.p_idle;
        instance_destroy();
    }
}

