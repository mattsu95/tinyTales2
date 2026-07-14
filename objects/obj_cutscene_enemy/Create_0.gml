action = 0;
timer = 0;
draw_flash = false; // Variável usada pela função para desenhar o flash branco

// Trava o player no modo de cutscene de novo
obj_player.estado = obj_player.p_cutscene;

// Lista de ações da entrada dramática
cutscene = [
    // 1. Treme e pisca a tela por 1.5 segundos, piscando a cada 5 frames e parando todo mundo
    [cutscene_flash_and_stop, 1.5, 5], 
    
    // 2. Pequena pausa de suspense em silêncio antes dele aparecer
    [cutscene_wait, 1],
    
    // 3. Cria o inimigo e move ele para dentro da tela (80 pixels para dentro) bem devagar a 0.8 de velocidade
    [cutscene_spawn_and_move_enemy, 80, 0.8],
    
    // 4. Espera 1 segundo
    [cutscene_wait, 1],
    
    // 5. Diálogos dramáticos e engraçados com as respostas do Tini!
    [cutscene_dialogueDog, [
        { nome: "Jogador", texto: "Calma, Tini!!!", maquina: true, tempo: 1.5 }
    ]],
    [cutscene_dialogueDog, [
        { nome: "Jogador", texto: "Eu te salvo dessa!", maquina: true, tempo: 1.8 }
    ]],
    [cutscene_dialogueDog, [
        { nome: "Tini", texto: "Oloco, fi, sério?", maquina: true, tempo: 1.5 }
    ]],
    [cutscene_dialogueDog, [
        { nome: "Tini", texto: "Boto fé!", maquina: true, tempo: 1.5 }
    ]],
    
    // 6. Pausa dramática de 3 segundos (como você pediu!)
    [cutscene_wait, 3],
    
    // 7. Continua a conversa rápida
    [cutscene_dialogueDog, [
        { nome: "Jogador", texto: "Já pode correr, Tini.", maquina: true, tempo: 1.8 }
    ]],
    [cutscene_dialogueDog, [
        { nome: "Tini", texto: "Han?", maquina: true, tempo: 1.2 }
    ]],
    [cutscene_dialogueDog, [
        { nome: "Jogador", texto: "Corre, FI!", maquina: true, tempo: 1.2 }
    ]],
    [cutscene_dialogueDog, [
        { nome: "Tini", texto: "Mas já é para correr?!", maquina: true, tempo: 2 }
    ]],
    
    // 8. Pausa final de 1 segundo e fim da cutscene!
    [cutscene_wait, 1]
];