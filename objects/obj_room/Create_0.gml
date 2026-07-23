// 0: Movimento, 1: Ensinar Ataque, 2: Atacar, 3: Derrotar Inimigo 1, 4: Pegar Itens, 5: Inventário, 6: Derrotar Inimigo 2, 7: Fim do tutorial
etapa_tutorial = 0;
audio_play_sound(forest_ambience, 1, true); // Toca em loop

// Barreiras físicas (spr_colisao tem origem no fundo Y=64, então posicionar em Y=320 com yscale=6 cobre de Y=-64 a Y=320)
barreira1 = instance_create_depth(750, 320, -100, obj_colisao);
barreira1.image_xscale = 1;
barreira1.image_yscale = 6;

barreira2 = instance_create_depth(1350, 320, -100, obj_colisao);
barreira2.image_xscale = 1;
barreira2.image_yscale = 6;

// Rastreamento dos inimigos do tutorial
inimigo1 = noone;
inimigo1_criado = false;

inimigo2 = noone;
inimigo2_criado = false;


