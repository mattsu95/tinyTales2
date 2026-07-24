if (instance_exists(obj_player)) {
    var _apertou_confirmar = keyboard_check_pressed(ord("E"));
    for (var _gp = 0; _gp < 4 && !_apertou_confirmar; _gp++) {
        if (gamepad_is_connected(_gp) && gamepad_button_check_pressed(_gp, gp_face1)) {
            _apertou_confirmar = true;
        }
    }
    
    // 1. INICIA A LIGAÇÃO
    if (!ativado && obj_player.x >= x) {
        ativado = true;
        audio_play_sound(ToqueMotorola, 1, true); // Toca em loop
    }

    // 2. ENQUANTO ESTÁ TOCANDO
    if (ativado && !atendeu) {
        timer_celular++;
        
        // --- CONDIÇÃO PARA ATENDER ---
        var _apertou_e = _apertou_confirmar;
        var _estourou_tempo = (timer_celular >= tempo_limite);
        
        if (_apertou_e || _estourou_tempo) {
            atendeu = true;
            audio_stop_sound(ToqueMotorola);
            
            // Trava o player E zera as velocidades e o sprite!
            obj_player.estado = obj_player.p_cutscene;
            obj_player.velh = 0;
            obj_player.velv = 0;
            obj_player.sprite_index = spr_player_idle; // <-- FORÇA O PLAYER A FICAR PARADO
            
            // Cria o diálogo na frente de tudo (Depth -9999)
            var _caixa = instance_create_depth(0, 0, -9999, obj_textbox);
            _caixa.falas = [
                { nome: "Tini", texto: "Fala, fih! Que foi?", maquina: true, tempo: 2 },
                { nome: "thigas (Celular)", texto: "Mano, CADÊ VOCÊ?! O professor já tá fechando a sala!", maquina: true, tempo: 3.5 },
                { nome: "Tini", texto: "Mentira! Já tô chegando no portão principal!", maquina: true, tempo: 2.5 },
                { nome: "thigas (Celular)", texto: "Vem voando, desgraça! Se o portão fechar, já era!", maquina: true, tempo: 3 }
            ];
        }
    }
    
    // 3. FIM DA LIGAÇÃO (Libera o player)
    if (atendeu && !instance_exists(obj_textbox)) {
        obj_player.estado = obj_player.p_idle; 
        instance_destroy(); 
    }
}