velocidade = 0;
z = 0;

// SISTEMA DE SORTEIO DE RAÇA DO CACHORRO
// Nós escolhemos aleatoriamente um "número" de raça (1 ou 2 por enquanto)
var _raca = choose(1, 2); 

if (_raca == 1) {
    meu_sprite_parado   = spr_dog1_idle;
    meu_sprite_correndo = spr_dog1_walk; // Usei walk porque você mencionou walk
} 
else if (_raca == 2) {
    meu_sprite_parado   = spr_dog2_idle;
    meu_sprite_correndo = spr_dog2_walk;
}

// Quando ele nasce, já veste o sprite correto dele parado
sprite_index = meu_sprite_parado;

