if (instance_exists(obj_player)) {
    // BARREIRA: Impede fisicamente o player de avançar a pé além da bicicleta
    if (!obj_player.ta_de_bike && obj_player.x >= x + 45) {
        obj_player.x = x + 45;
        if (obj_player.velh > 0) obj_player.velh = 0;
        
        if (!instance_exists(obj_textbox) && !texto_criado) {
            var _caixa_barreira = instance_create_layer(0, 0, "Instances_1", obj_textbox);
            _caixa_barreira.falas = [{ texto: "Você precisa pegar a bicicleta para continuar!", maquina: false, tempo: 3 }];
            texto_criado = true;
        }
    }

    var _dist = point_distance(x, y, obj_player.x, obj_player.y);

    if (_dist <= distancia_interacao) {
        
        // 1. Cria a sua caixa de texto UMA VEZ quando chega perto
        if (!texto_criado) {
            var _caixa = instance_create_layer(0, 0, "Instances_1", obj_textbox);
            _caixa.falas = [{ texto: "Aperte [E] para subir na bicicleta!", maquina: false, tempo: 3 }];
            
            texto_criado = true; // Trava para não criar de novo
        }

        // 2. Quando o jogador apertar E
        if (keyboard_check_pressed(ord("E"))) {
            
            with (obj_player) {
                ta_de_bike = true;
                estado = p_bike; 
            }
            
            // DESTRÓI a caixa do "E" imediatamente se ela ainda estiver na tela
            if (instance_exists(obj_textbox)) {
                instance_destroy(obj_textbox);
            }
            
            // BÔNUS: Já manda outro texto do seu sistema ensinando a pedalar!
            var _caixa_tutorial = instance_create_layer(0, 0, "Instances_1", obj_textbox);
            _caixa_tutorial.falas = [{ texto: "Use A e D para pedalar, e E para buzinar!", maquina: false, tempo: 5 }]; // Aumentei o tempo para 5!
            
            instance_destroy(); // Destrói a bicicleta do chão
        }
        
    } else {
        // Se o player afastar, destrava para poder avisar de novo caso ele volte
        texto_criado = false; 
    }
}