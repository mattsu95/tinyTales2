if (!instance_exists(obj_player)) exit;

// 1. ETAPA 0: Ao entrar em Corbélia, fala de introdução do Tini buscando seu carro
if (etapa == 0) {
    if (!dialogo_inicial_feito) {
        dialogo_inicial_feito = true;
        
        var _caixa_init = instance_create_depth(0, 0, -9999, obj_textbox);
        _caixa_init.falas = [
            { nome: "Tini", texto: "Finalmente cheguei em Corbélia... O Vinícius escondeu meu carro por aqui!", maquina: true, tempo: 4 }
        ];
    }
    
    // Quando o texto inicial sumir, o jogador pode andar até se aproximar do Vinícius
    if (dialogo_inicial_feito && !instance_exists(obj_textbox)) {
        etapa = 1;
    }
}

// 2. ETAPA 1: Player caminha livremente até X >= 450 (perto de Vinícius)
if (etapa == 1) {
    if (obj_player.x >= 450) {
        // Trava o controle do player para a cutscene
        obj_player.estado = obj_player.p_cutscene;
        obj_player.velh = 0;
        obj_player.velv = 0;
        etapa = 2;
    }
}

// 3. ETAPA 2: Tini anda sozinho até se posicionar perto de Vinícius (X >= 580)
if (etapa == 2) {
    obj_player.estado = obj_player.p_cutscene;
    
    if (obj_player.x < 580) {
        obj_player.x += 1.5; // Tini anda para a direita
        obj_player.sprite_index = spr_player_walk;
        obj_player.image_xscale = 1;
    } else {
        // Chegou no Vinícius! Para o player em idle
        obj_player.sprite_index = spr_player_idle;
        obj_player.velh = 0;
        
        // Inicia o diálogo de confronto com o Boss Vinícius
        var _caixa_boss = instance_create_depth(0, 0, -9999, obj_textbox);
        _caixa_boss.falas = [
            { nome: "Tini", texto: "Vinícius! Devolve a chave do meu carro agora, seu fih!", maquina: true, tempo: 3 },
            { nome: "Vinícius", texto: "Ora, ora... Tini! Achou mesmo que vir de ônibus até Corbélia ia te devolver seu carro?", maquina: true, tempo: 4 },
            { nome: "Tini", texto: "Desci a muleta nos pelegos do terminal e você é o próximo!", maquina: true, tempo: 3 },
            { nome: "Vinícius", texto: "Kkkkkkk! Quero ver você me parar! Vem pra cima!", maquina: true, tempo: 3 }
        ];
        
        etapa = 3;
    }
}

// 4. ETAPA 3: Espera o diálogo terminar e LIBERA A LUTA CONTRA O BOSS!
if (etapa == 3) {
    if (!instance_exists(obj_textbox)) {
        // Devolve o controle ao player
        obj_player.estado = obj_player.p_idle;
        etapa = 4;
    }
}

// 5. ETAPA 4: Combate do Boss rolando! Aguarda a derrota do Vinícius (obj_boss)
if (etapa == 4) {
    if (!instance_exists(obj_boss)) {
        // Trava o player para a cutscene pós-luta
        obj_player.estado = obj_player.p_cutscene;
        obj_player.velh = 0;
        obj_player.velv = 0;
        obj_player.sprite_index = spr_player_idle;
        
        if (!dialogo_pos_luta_feito) {
            dialogo_pos_luta_feito = true;
            var _caixa_pos = instance_create_depth(0, 0, -9999, obj_textbox);
            _caixa_pos.falas = [
                { nome: "Tini", texto: "Consegui! Deitei o Vinícius e recuperei a chave do meu carro!", maquina: true, tempo: 4 },
                { nome: "Tini", texto: "Partiu voltar pra casa.", maquina: true, tempo: 3 }
            ];
        }
        
        etapa = 5;
    }
}

// 6. ETAPA 5: Espera a fala pós-luta terminar e localiza o carro Uno
if (etapa == 5) {
    obj_player.estado = obj_player.p_cutscene;
    
    if (!instance_exists(obj_textbox)) {
        carro_inst = instance_nearest(731, 340, obj_carro_tini);
        if (!instance_exists(carro_inst)) {
            carro_inst = instance_create_depth(731, 340, -100, obj_carro_tini);
        }
        carro_y_base = carro_inst.y;
        
        etapa = 6;
    }
}

// 7. ETAPA 6: Tini caminha sozinho até a porta do carro Uno e entra nele
if (etapa == 6) {
    obj_player.estado = obj_player.p_cutscene;
    
    if (instance_exists(carro_inst)) {
        var _alvo_x = carro_inst.x - 15;
        if (obj_player.x < _alvo_x) {
            obj_player.x += 1.5;
            obj_player.sprite_index = spr_player_walk;
            obj_player.image_xscale = 1;
        } else {
            // Tini entra no Uno
            obj_player.visible = false;
            obj_player.x = carro_inst.x;
            timer_carro = 0;
            etapa = 7;
        }
    } else {
        etapa = 7;
    }
}

// 8. ETAPA 7: O motor do Uno liga (som car_engine) e o carro vibra
if (etapa == 7) {
    if (instance_exists(carro_inst)) {
        timer_carro++;
        
        // No 1º frame, toca o áudio do motor
        if (timer_carro == 1) {
            if (audio_exists(car_engine)) {
                audio_play_sound(car_engine, 1, false);
            }
        }
        
        // Vibração do carro por ~1 segundo enquanto o motor ronca
        carro_inst.y = carro_y_base + irandom_range(-1, 1);
        
        if (timer_carro >= 60) {
            carro_inst.y = carro_y_base;
            timer_carro = 0;
            vel_carro = 2.0;
            etapa = 8;
        }
    } else {
        etapa = 8;
    }
}

// 9. ETAPA 8: O Uno acelera e vai embora pra direita
if (etapa == 8) {
    if (instance_exists(carro_inst)) {
        carro_inst.x += vel_carro;
        
        if (vel_carro < 9.0) {
            vel_carro += 0.1;
        }
        
        if (carro_inst.x >= 1200) {
            etapa = 9;
        }
    } else {
        etapa = 9;
    }
}

// 10. ETAPA 9: Fade out final
if (etapa == 9) {
    obj_player.estado = obj_player.p_cutscene;
    
    alpha_preto = clamp(alpha_preto + 0.02, 0, 1);
    if (alpha_preto >= 1) {
        etapa = 10;
    }
}

// 11. ETAPA 10: Tela de Vitória com fundo do Menu e Botão para Voltar ao Menu
if (etapa == 10) {
    obj_player.estado = obj_player.p_cutscene;
    
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    
    // Configura a fonte para medir a string com o mesmo tamanho da tela
    if (font_exists(Font1)) {
        draw_set_font(Font1);
    } else if (font_exists(fnt_dialogo)) {
        draw_set_font(fnt_dialogo);
    }
    
    var _texto_btn = "Voltar para o Menu";
    var _scale_base = 0.32;
    var _wstr = string_width(_texto_btn) * _scale_base;
    var _hstr = string_height("I") * _scale_base;
    
    var ty = _gh / 2 + 35;
    var x1 = _gw / 2 - _wstr / 2 - 12;
    var y1 = ty - _hstr / 2 - 5;
    var x2 = _gw / 2 + _wstr / 2 + 12;
    var y2 = ty + _hstr / 2 + 5;
    
    var _hover = point_in_rectangle(_mx, _my, x1, y1, x2, y2);
    
    if ((_hover && mouse_check_button_pressed(mb_left)) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
        if (!trocando) {
            trocando = true;
            room_goto(Menu);
        }
    }
}
