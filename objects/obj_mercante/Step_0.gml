if (!instance_exists(obj_player)) exit;

var _apertou_confirmar = keyboard_check_pressed(ord("E"));
for (var _gp = 0; _gp < 4 && !_apertou_confirmar; _gp++) {
    if (gamepad_is_connected(_gp) && gamepad_button_check_pressed(_gp, gp_face1)) {
        _apertou_confirmar = true;
    }
}

var _dist = point_distance(x, y, obj_player.x, obj_player.y);

// Checa proximidade com o jogador (Permite interagir APENAS UMA VEZ)
if (_dist <= 160 && !falando && !dialogo_concluido) {
    pode_falar = true;
    
    if (_apertou_confirmar) {
        pode_falar = false;
        falando = true;
        
        // Trava o player durante a conversa
        obj_player.estado = obj_player.p_cutscene;
        obj_player.velh = 0;
        obj_player.velv = 0;
        obj_player.sprite_index = spr_player_idle;
        
        var _caixa = instance_create_depth(0, 0, -9999, obj_textbox);
        _caixa.falas = [
            { nome: "Mercante", texto: "Ora ora... O que traz um jovem sem transporte até o meu estabelecimento secreto?", maquina: true, tempo: 4 },
            { nome: "Tini", texto: "Um maluco chamado Vinícius acabou de roubar meu carro e fugiu pra Corbélia!", maquina: true, tempo: 4 },
            { nome: "Mercante", texto: "Ah, o jovem Vinícius... Ele sempre teve pressa pra pegar a estrada. Mas Corbélia é perigosa pra ir a pé e de mãos vazias!", maquina: true, tempo: 5 },
            { nome: "Mercante", texto: "Tome isso. Você vai precisar de poções fortes se quiser reaver seu possante!", maquina: true, tempo: 5 },
            { nome: "Tini", texto: "Valeu velhote! Agora aquele safado vai ver só!", maquina: true, tempo: 4 }
        ];
    }
} else {
    pode_falar = false;
}

// Quando a conversa do Mercante termina
if (falando && !instance_exists(obj_textbox)) {
    if (!dialogo_concluido) {
        // Entrega as poções estruturadas para o Tini se equipar
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
        
        dialogo_concluido = true;
        
        // Exibe o texto de instrução para ir até Corbélia de ônibus
        var _instrucao = instance_create_depth(0, 0, -9999, obj_textbox);
        _instrucao.falas = [
            { texto: "Pegue o ônibus no terminal e vá até Corbélia!", maquina: false, tempo: 5 }
        ];
        _instrucao.ignorar_inputs = true;
    }
    
    obj_player.estado = obj_player.p_idle;
    falando = false;
}

