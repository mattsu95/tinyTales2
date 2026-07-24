// Se a cutscene do terminal estiver rodando, o pelego fica parado encarando o Tini
if (instance_exists(obj_cutscene_terminal)) {
    sprite_index = spr_enemy_idle;
    image_xscale = 1; // Virado para a esquerda (direção de quem vem do início)
    velh = 0;
    velv = 0;
    exit;
}

// Quando a cutscene termina (obj_cutscene_terminal deixa de existir), executa o comportamento normal de inimigo
event_inherited();
