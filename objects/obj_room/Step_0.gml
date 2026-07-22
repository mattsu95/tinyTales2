if (instance_exists(obj_player)) {
    
    // --- ETAPA 1: MOVIMENTAÇÃO E PULO (Ao passar do pixel 50) ---
    if (etapa_tutorial == 0 && obj_player.x > 50) {
        if (instance_exists(obj_textbox)) instance_destroy(obj_textbox);

        var _caixa = instance_create_depth(0, 0, -9999, obj_textbox);
        _caixa.falas = [{ texto: "Use W A S D para se movimentar e ESPAÇO para pular.", maquina: false, tempo: 5 }];
        _caixa.ignorar_inputs = true;
        
        etapa_tutorial = 1; 
    } 
    
    // --- ETAPA 2: ENSINA A ATACAR (Ao passar do pixel 660) ---
    else if (etapa_tutorial == 1 && obj_player.x > 660) {
        if (instance_exists(obj_textbox)) instance_destroy(obj_textbox);

        var _caixa = instance_create_depth(0, 0, -9999, obj_textbox);
        _caixa.falas = [{ texto: "Use o Botão Esquerdo do mouse para atacar.", maquina: false, tempo: 4 }];
        _caixa.ignorar_inputs = true;
        
        etapa_tutorial = 2; 
    } 
    
    // --- ETAPA 2.5: ORDEM DE COMBATE (Quando entra no estado de ataque) ---
    else if (etapa_tutorial == 2 && obj_player.estado == obj_player.p_attack) {
        if (instance_exists(obj_textbox)) instance_destroy(obj_textbox);

        var _caixa = instance_create_depth(0, 0, -9999, obj_textbox);
        _caixa.falas = [{ texto: "Isso! Agora MATE O MONSTRO!", maquina: false, tempo: 3.5 }];
        _caixa.ignorar_inputs = true;
        
        etapa_tutorial = 3; 
    }
    
    // --- ETAPA 3: PEGAR ITENS DO CHÃO (Ao passar do pixel 900) ---
    else if (etapa_tutorial == 3 && obj_player.x > 900) {
        if (instance_exists(obj_textbox)) instance_destroy(obj_textbox);

        var _caixa = instance_create_depth(0, 0, -9999, obj_textbox);
        _caixa.falas = [{ texto: "Pegue os itens do chão!", maquina: false, tempo: 4 }];
        _caixa.ignorar_inputs = true;
        
        etapa_tutorial = 4; 
    }
    
    // --- ETAPA 4: INVENTÁRIO E DADO (Ao passar do pixel 1000) ---
    else if (etapa_tutorial == 4 && obj_player.x > 1000) {
        if (instance_exists(obj_textbox)) instance_destroy(obj_textbox);

        var _caixa = instance_create_depth(0, 0, -9999, obj_textbox);
        _caixa.falas = [{ texto: "Use TAB para abrir o inventário e o Botão Direito para rolar o dado.", maquina: false, tempo: 5 }];
        _caixa.ignorar_inputs = true;
        
        etapa_tutorial = 5; // Fim do tutorial!
    }
}