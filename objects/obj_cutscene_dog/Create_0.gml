// --- VARIÁVEIS DE CONTROLE DA CUTSCENE ---
action = 0; // Índice da ação atual (qual linha da lista está rodando)
timer = 0;  // Cronômetro em frames para controlar o tempo das ações

// Âncoras para guardar a posição da câmera antes do terremoto
original_cam_x = 0; 
original_cam_y = 0; 

// Força o player a entrar no modo de cutscene (bloqueia o teclado)
obj_player.estado = obj_player.p_cutscene;

// --- SEQUÊNCIA DE AÇÕES DA CUTSCENE ---
cutscene = [
  
    
    // Alinha o player na estrada: [função, X_alvo, Y_alvo, velocidade]
    [cutscene_move_player_to_pos, 300, 180, 0.8],
	[cutscene_play_sound, CachorroLatindo, 1, false],
	[cutscene_dialogueDog, [
        { texto: "O que é isso?", maquina: true, tempo: 2 }
    ]],
    [cutscene_wait, 2],
    // Terremoto de suspense: [função, segundos_tremendo, força_do_chacoalho]
    [cutscene_screen_shake, 2, 6], 
	[cutscene_dialogueDog, [
        { texto: "AH NÃO!!!!!", maquina: true, tempo: 2 }
    ]],
	[cutscene_wait, 1],
	[cutscene_play_sound, Bad_Piggies_Theme, 1, false],
    [cutscene_spawn_dogs, 5],
    // [função, segundos_correndo, vel_player, vel_dogs]
    [cutscene_the_chase, 3.8, 3, 3.5, 8], 
];