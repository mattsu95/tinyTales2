if (!instance_exists(obj_player)) exit;

var _cam = view_camera[0];

// 1. GATILHO: Player chega perto do bueiro
if (!ativado && obj_player.x >= x - 60) {
    ativado = true;
    
    // Trava o player no chão e reseta o sprite
    obj_player.estado = obj_player.p_cutscene;
    obj_player.velh = 0;
    obj_player.velv = 0;
    obj_player.sprite_index = spr_player_idle;
    
    timer = 0;
}

// 2. EXECUTANDO A CUTSCENE
if (ativado) {
    timer++;
    
    // --- LÓGICA DO ZOOM DA CÂMERA ---
    // Aproxima a câmera suavemente no Tini durante a cutscene (Etapas 0 a 3)
    if (etapa < 4) {
        cam_w_atual = lerp(cam_w_atual, cam_w_zoom, 0.05);
        cam_h_atual = lerp(cam_h_atual, cam_h_zoom, 0.05);
    } else {
        // Na Etapa 4, afasta a câmera de volta para o tamanho normal do jogo
        cam_w_atual = lerp(cam_w_atual, cam_w_padrao, 0.05);
        cam_h_atual = lerp(cam_h_atual, cam_h_padrao, 0.05);
    }
    
    // Aplica o Zoom e Centraliza a câmera no Player
    camera_set_view_size(_cam, cam_w_atual, cam_h_atual);
    camera_set_view_pos(_cam, obj_player.x - (cam_w_atual / 2), obj_player.y - (cam_h_atual / 2));

    
    // --- SEQUÊNCIA DOS EVENTOS ---
    switch (etapa) {
        
        // --- ETAPA 0: O TROPEÇO E O LANÇAMENTO ---
        case 0:
            audio_play_sound(simple_whoosh, 1, false);
            audio_play_sound(magic_surprise, 1, false);
            
            // Impulso do tropeço
            obj_player.x += 10;
            obj_player.z = -10; 
            obj_player.image_angle = -45; // Inclinado no ar
            
            // Lança as 4 cartas flutuantes
            for (var _i = 0; _i < 4; _i++) {
                var _carta = instance_create_depth(obj_player.x + 10, obj_player.y - 15, -999, obj_carta_cutscene);
                _carta.bueiro_x = x;
                _carta.bueiro_y = y;
            }
            
            timer = 0;
            etapa = 1;
            break;
            
        // --- ETAPA 1: CAI NO CHÃO (Rápido: ~0.25 segundos) ---
        case 1:
            if (timer >= 15) {
                audio_play_sound(impact_thud, 1, false); // PÁ!
                
                obj_player.z = 0;
                obj_player.image_angle = -90; // Deita de cara no chão
                
                timer = 0;
                etapa = 2;
            }
            break;
            
        // --- ETAPA 2: ESPERA AS CARTAS CAÍREM NO BUEIRO ---
        case 2:
            // A mágica: Em vez de um tempo fixo, a cutscene congela e ESPERA.
            // Ela só avança quando TODAS as cartas se destruírem no chão!
            if (!instance_exists(obj_carta_cutscene)) {
                
                audio_play_sound(metaldrop, 1, false); // Som metálico
                
                timer = 0;
                etapa = 3;
            }
            break;
            
        // --- ETAPA 3: PAUSA DRAMÁTICA CURTA (~0.4 Segundos) E FALA ---
        case 3:
            // Pausa bem curtinha de apenas 25 frames (~0.4s) para não parecer travado!
            if (timer >= 25) { 
                
                var _caixa = instance_create_depth(0, 0, -9999, obj_textbox);
                _caixa.falas = [
                    { nome: "Tini", texto: "NÃO... NÃO... NÃO!!", maquina: true, tempo: 2 },
                    { nome: "Tini", texto: "Shit, PERDI TUDO!", maquina: true, tempo: 2.5 },
                    { nome: "Tini", texto: "Meus poderes do jogo passado... foram TODOS pro ralo!", maquina: true, tempo: 3.5 },
                    { nome: "Tini", texto: "Ai minha vida...", maquina: true, tempo: 2 }
                ];
                
                etapa = 4;
            }
            break;
            
        // --- ETAPA 4: LEVANTA, RESETA ZOOM E LIBERA ---
        case 4:
            // Espera o diálogo acabar E o zoom da câmera voltar ao normal
            if (!instance_exists(obj_textbox) && abs(cam_w_atual - cam_w_padrao) < 2) {
                
                // Reseta a câmera para o tamanho original perfeitamente
                camera_set_view_size(_cam, cam_w_padrao, cam_h_padrao);
                
                // Levanta o Tini
                obj_player.image_angle = 0;
                obj_player.sprite_index = spr_player_idle;
                
                // Devolve o controle
                obj_player.estado = obj_player.p_idle;
                
                instance_destroy(); // Fim da cutscene!
            }
            break;
    }
}