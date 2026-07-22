if (!instance_exists(obj_player)) exit;

var _cam = view_camera[0];

// 1. GATILHO DE ATIVAÇÃO
if (!ativado && obj_player.x >= x) {
    ativado = true;
    
    // Desliga o seguimento automático para a câmera voar livremente
    camera_set_view_target(_cam, noone);
    
    // Trava o jogador
    obj_player.estado = obj_player.p_cutscene;
    obj_player.velh = 0;
    obj_player.velv = 0;
    obj_player.sprite_index = spr_player_idle;
    
    // Pega a posição do Rizzi
    if (instance_exists(obj_rizzi)) {
        alvo_cam_x = obj_rizzi.x;
        alvo_cam_y = obj_rizzi.y;
    } else {
        alvo_cam_x = obj_player.x + 300; 
        alvo_cam_y = obj_player.y;
    }
}

// 2. EXECUTANDO O PAN/ZOOM DE CÂMERA
if (ativado) {
    
    switch (etapa) {
        
        // --- ETAPA 0: CÂMERA VOA E DÁ ZOOM NO RIZZI ---
        case 0:
            cam_w_atual = lerp(cam_w_atual, cam_w_zoom, 0.05);
            cam_h_atual = lerp(cam_h_atual, cam_h_zoom, 0.05);
            camera_set_view_size(_cam, cam_w_atual, cam_h_atual);
            
            var _cam_x = camera_get_view_x(_cam);
            var _cam_y = camera_get_view_y(_cam);
            
            // Calcula o centro do Rizzi TRAVANDO nas bordas do mapa (clamp)
            var _dest_x = clamp(alvo_cam_x - (cam_w_atual / 2), 0, room_width - cam_w_atual);
            var _dest_y = clamp(alvo_cam_y - (cam_h_atual / 2), 0, room_height - cam_h_atual);
            
            // Mover suavemente
            var _novo_x = lerp(_cam_x, _dest_x, 0.05);
            var _novo_y = lerp(_cam_y, _dest_y, 0.05);
            
            // Garante 100% que não vai mostrar o azul fora da sala
            _novo_x = clamp(_novo_x, 0, room_width - cam_w_atual);
            _novo_y = clamp(_novo_y, 0, room_height - cam_h_atual);
            
            camera_set_view_pos(_cam, _novo_x, _novo_y);
            
            if (point_distance(_cam_x, _cam_y, _dest_x, _dest_y) < 10) {
                var _caixa = instance_create_depth(0, 0, -9999, obj_textbox);
                _caixa.falas = [
                    { nome: "Rizzi", texto: "Acho que ninguém mais vem...", maquina: true, tempo: 2.5 }
                ];
                
                etapa = 1;
            }
            break;
            
        // --- ETAPA 1: VOLTA A CÂMERA PRO PLAYER (SEM VAZAR O MAPA) ---
        case 1:
            if (!instance_exists(obj_textbox)) {
                
                cam_w_atual = lerp(cam_w_atual, cam_w_padrao, 0.05);
                cam_h_atual = lerp(cam_h_atual, cam_h_padrao, 0.05);
                camera_set_view_size(_cam, cam_w_atual, cam_h_atual);
                
                var _cam_x = camera_get_view_x(_cam);
                var _cam_y = camera_get_view_y(_cam);
                
                // TRAVA O PLAYER NAS BORDAS DO MAPA! (Evita o fundo azul)
                var _alvo_player_x = clamp(obj_player.x - (cam_w_atual / 2), 0, room_width - cam_w_atual);
                var _alvo_player_y = clamp(obj_player.y - (cam_h_atual / 2), 0, room_height - cam_h_atual);
                
                var _novo_x = lerp(_cam_x, _alvo_player_x, 0.05);
                var _novo_y = lerp(_cam_y, _alvo_player_y, 0.05);
                
                _novo_x = clamp(_novo_x, 0, room_width - cam_w_atual);
                _novo_y = clamp(_novo_y, 0, room_height - cam_h_atual);
                
                camera_set_view_pos(_cam, _novo_x, _novo_y);
                
                // Quando encostar na posição travada do player
                if (point_distance(_cam_x, _cam_y, _alvo_player_x, _alvo_player_y) < 10) {
                    
                    camera_set_view_size(_cam, cam_w_padrao, cam_h_padrao);
                    
                    var _caixa = instance_create_depth(0, 0, -9999, obj_textbox);
                    _caixa.falas = [
                        { texto: "COMECE A CORRER!", maquina: false, tempo: 2 }
                    ];
                    _caixa.ignorar_inputs = true;
                    
                    etapa = 2;
                }
            }
            break;
            
        // --- ETAPA 2: FIM E LIBERA O PLAYER ---
        case 2:
            if (!instance_exists(obj_textbox)) {
                // Religa a câmera automática padrão do GameMaker
                camera_set_view_target(_cam, obj_player);
                
                // Devolve o controle ao jogador
                obj_player.estado = obj_player.p_idle;
                
                instance_destroy(); 
            }
            break;
    }
}