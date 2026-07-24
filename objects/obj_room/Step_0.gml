// Vincula e configura a vida dos inimigos do tutorial se ainda não foram vinculados
if (!inimigo1_criado) {
    var _in1 = instance_nearest(672, 160, obj_enemy);
    if (instance_exists(_in1) && point_distance(_in1.x, _in1.y, 672, 160) < 150) {
        inimigo1 = _in1;
        inimigo1.vida_max = 10;
        inimigo1.vida = 10;
        inimigo1_criado = true;
    }
}

if (!inimigo2_criado) {
    var _in2 = instance_nearest(1152, 160, obj_enemy);
    if (instance_exists(_in2) && point_distance(_in2.x, _in2.y, 1152, 160) < 150) {
        inimigo2 = _in2;
        inimigo2.vida_max = 20;
        inimigo2.vida = 20;
        inimigo2_criado = true;
    }
}

if (instance_exists(obj_player)) {
    
    // --- ETAPA 1: MOVIMENTAÇÃO E CORRIDA (Ao passar do pixel 50) ---
    if (etapa_tutorial == 0 && obj_player.x > 50) {
        if (instance_exists(obj_textbox)) instance_destroy(obj_textbox);

        var _caixa = instance_create_depth(0, 0, -9999, obj_textbox);
        _caixa.falas = [{ texto: "Use W A S D para se movimentar e toque 2x numa direção para correr.", maquina: false, tempo: 6 }];
        _caixa.ignorar_inputs = true;
        
        etapa_tutorial = 1; 
    } 
    
    // --- ETAPA 2: ENSINA A ATACAR (Ao se aproximar do 1º inimigo - pixel 450) ---
    else if (etapa_tutorial == 1 && obj_player.x > 450) {
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
    
    // --- ETAPA 3: DERROTA DO INIMIGO 1 (Apenas avança e destrói a barreira 1 quando o monstro morrer) ---
    else if (etapa_tutorial == 3 && inimigo1_criado && !instance_exists(inimigo1)) {
        if (instance_exists(barreira1)) instance_destroy(barreira1);
        if (instance_exists(obj_textbox)) instance_destroy(obj_textbox);

        var _caixa = instance_create_depth(0, 0, -9999, obj_textbox);
        _caixa.falas = [{ texto: "Muito bem! Agora pegue os itens do chão!", maquina: false, tempo: 4 }];
        _caixa.ignorar_inputs = true;
        
        etapa_tutorial = 4; 
    }
    
    // --- ETAPA 4: INVENTÁRIO (Ao pegar o item do chão) ---
    else if (etapa_tutorial == 4 && (!obj_player.inventario_vazio() || obj_player.x > 800)) {
        if (instance_exists(obj_textbox)) instance_destroy(obj_textbox);

        var _caixa = instance_create_depth(0, 0, -9999, obj_textbox);
        _caixa.falas = [{ texto: "Agora você pode ver os itens no seu inventário apertando TAB.", maquina: false, tempo: 5 }];
        _caixa.ignorar_inputs = true;
        
        etapa_tutorial = 5; 
    }
    
    // --- ETAPA 5: ENSINA A JOGAR/USAR CONSUMÍVEL DA POÇÃO ---
    else if (etapa_tutorial == 5 && (obj_player.mostrar_inventario || obj_player.x > 950)) {
        if (instance_exists(obj_textbox)) instance_destroy(obj_textbox);

        var _caixa = instance_create_depth(0, 0, -9999, obj_textbox);
        _caixa.falas = [{ texto: "Segure e solte o Botão Direito do mouse para rolar o dado e jogar a poção no inimigo!", maquina: false, tempo: 6 }];
        _caixa.ignorar_inputs = true;
        
        etapa_tutorial = 6; 
    }
    
    // --- ETAPA 6: DERROTA DO INIMIGO 2 (Apenas avança e destrói a barreira 2 quando o inimigo 2 for morto) ---
    else if (etapa_tutorial == 6 && inimigo2_criado && !instance_exists(inimigo2)) {
        if (instance_exists(barreira2)) instance_destroy(barreira2);
        if (instance_exists(obj_textbox)) instance_destroy(obj_textbox);

        var _caixa = instance_create_depth(0, 0, -9999, obj_textbox);
        _caixa.falas = [{ texto: "Excelente! Você derrotou os monstrengos e aprendeu o básico!", maquina: false, tempo: 5 }];
        _caixa.ignorar_inputs = true;
        
        etapa_tutorial = 7; // Fim do tutorial!
    }
}