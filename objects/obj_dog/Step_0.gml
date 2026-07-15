// Move o cachorro
x += velocidade;

// Controla as animações usando os sprites sorteados individualmente!
if (velocidade > 0) {
    sprite_index = meu_sprite_correndo;
} else {
    sprite_index = meu_sprite_parado;
}