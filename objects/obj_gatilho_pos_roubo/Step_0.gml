if (!instance_exists(obj_player)) exit;

// Dispara quando o jogador passa do ponto do gatilho e a cutscene anterior já terminou
if (!ativado && !instance_exists(obj_cutscene_roubo) && obj_player.x >= x) {
    ativado = true;
    
    if (instance_exists(obj_textbox)) instance_destroy(obj_textbox);
    
    var _caixa = instance_create_depth(0, 0, -9999, obj_textbox);
    _caixa.ignorar_inputs = true;
    
    if (x < 4200) {
        _caixa.falas = [
            { texto: "Vinícius levou seu carro para Corbélia!", maquina: false, tempo: 3 },
            { texto: "Vá atrás e recupere ele!", maquina: false, tempo: 4 }
        ];
    } else {
        _caixa.falas = [
            { texto: "Se equipe falando com o mercante.", maquina: false, tempo: 3 }
        ];
    }
    
    instance_destroy();
}

