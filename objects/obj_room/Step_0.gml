if (instance_exists(obj_player)) {
    
    // Etapa 1: Aprender a andar (Ex: quando passar do pixel 200)
    if (etapa_tutorial == 0 && obj_player.x > 0) {
        var _caixa = instance_create_layer(0, 0, "Instances_1", obj_textbox);
        _caixa.falas = [{ texto: "Use W A S D para se movimentar.", maquina: false, tempo: 4.5 }];
        etapa_tutorial = 1; // Avança a etapa para não criar o texto de novo
    } 
    
    // Etapa 2: Aprender a atacar (Ex: quando passar do pixel 600)
    else if (etapa_tutorial == 1 && obj_player.x > 600) {
        var _caixa = instance_create_layer(0, 0, "Instances_1", obj_textbox);
        _caixa.falas = [{ texto: "Use o Botão Esquerdo do mouse para atacar.", maquina: false, tempo: 4.5 }];
        etapa_tutorial = 2;
    } 
    
    // Etapa 3: Inventário e Dado 
    else if (etapa_tutorial == 2 && obj_player.x > 900) {
        var _caixa = instance_create_layer(0, 0, "Instances_1", obj_textbox);
        _caixa.falas = [{ texto: "Use TAB para abrir o inventário e o Botão Direito para rolar o dado.", maquina: false, tempo: 4.5 }];
        etapa_tutorial = 3;
    }
}