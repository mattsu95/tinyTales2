// Move o cachorro
x += velocidade;

// Controla as animações usando os sprites sorteados individualmente!
if (velocidade != 0 || x != xprevious || y != yprevious) {
    sprite_index = meu_sprite_correndo;
} else {
    sprite_index = meu_sprite_parado;
}

// CHECAGEM DE COLISÃO COM O PLAYER DURANTE A FUGA
if (instance_exists(obj_player)) {
    var _is_front_dog = variable_instance_exists(id, "cachorro_da_frente") && cachorro_da_frente;
    
    if (!_is_front_dog && obj_player.estado == obj_player.p_fuga) {
        if (place_meeting(x, y, obj_player)) {
            trigger_dog_death();
        }
    }
}