// --- VARIÁVEIS DE CONTROLE DA CUTSCENE ---
action = 0; 
timer = 0;  
draw_flash = false; 

// Âncoras do terremoto
original_cam_x = 0; 
original_cam_y = 0; 

// Trava o player no modo de cutscene no primeiro frame
obj_player.estado = obj_player.p_cutscene;

// --- O ROTEIRO COMPLETO (TUDO EM UM LUGAR SÓ) ---
cutscene = [
    
    // --- PARTE 1: A AMEAÇA DOS CACHORROS ---
    [cutscene_move_player_to_pos, 300, 180, 0.8],
    [cutscene_play_sound, CachorroLatindo, 1, false],
    [cutscene_dialogueDog, [{ texto: "O que é isso?", maquina: true, tempo: 2 }]],
    [cutscene_wait, 2],
    [cutscene_screen_shake, 2, 6], 
    [cutscene_dialogueDog, [{ texto: "AH NÃO!!!!!", maquina: true, tempo: 2 }]],
    [cutscene_wait, 1],
    [cutscene_play_sound, Bad_Piggies_Theme, 1, false],
    [cutscene_spawn_dogs, 5],
    [cutscene_the_chase, 3.8, 3, 3.5], 
    
    // --- PARTE 2: GAMEPLAY INTERATIVA COM TUTORIAL CORRENDO ---
    // Você já corre e desvia por 8 segundos enquanto o aviso discreto aparece e some no topo!
    [cutscene_gameplay_fuga_com_dialogo, 15, [{ texto: "Use W e S para se movimentar e desviar dos objetos", maquina: false, tempo: 3.5 }]],
    
    // --- PARTE 3: O INIMIGO APARECE ---
    [cutscene_play_sound, thunder, 1, false],
    [cutscene_flash_and_stop, 1.5, 5], 
    [cutscene_stop_sound, thunder],
    [cutscene_wait, 1],
    [cutscene_spawn_and_move_enemy, 80, 0.8],
    [cutscene_wait, 1],
    
    // --- PARTE 4: A CONVERSA FIADA ---
    [cutscene_dialogueDog, [{ nome: "Jogador", texto: "Calma, Tini!!!", maquina: true, tempo: 1.5 }]],
    [cutscene_dialogueDog, [{ nome: "Jogador", texto: "Eu te salvo dessa!", maquina: true, tempo: 1.8 }]],
    [cutscene_dialogueDog, [{ nome: "Tini", texto: "Oloco, fi, sério?", maquina: true, tempo: 1.5 }]],
    [cutscene_dialogueDog, [{ nome: "Tini", texto: "Boto fé!", maquina: true, tempo: 1.5 }]],
    [cutscene_wait, 3],
    [cutscene_dialogueDog, [{ nome: "Jogador", texto: "Já pode correr, Tini.", maquina: true, tempo: 1.8 }]],
    [cutscene_dialogueDog, [{ nome: "Tini", texto: "Han?", maquina: true, tempo: 1.2 }]],
    [cutscene_dialogueDog, [{ nome: "Jogador", texto: "Corre, FI!", maquina: true, tempo: 1.2 }]],
    [cutscene_dialogueDog, [{ nome: "Tini", texto: "Mas já é para correr?!", maquina: true, tempo: 2 }]],
    [cutscene_wait, 1],
    
    // --- PARTE 5: FUGA FINAL E LIBERDADE ---
    // Corre sozinho por 2 segundos a 3.5x, inimigo ou cachorro (0x) fica pra trás
    [cutscene_the_chase, 2.0, 3.5, 0], 
    [cutscene_liberar_player],
	[cutscene_stop_sound, Bad_Piggies_Theme],
];