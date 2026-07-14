function cutscene_dialogue(_array_de_falas) {
    if (!instance_exists(obj_textbox)) {
        var _caixa = instance_create_layer(0, 0, "Player", obj_textbox);
        _caixa.falas = _array_de_falas;
    }
    
    // A cutscene fica pausada aqui até o jogador ler tudo e fechar a caixa
    if (!instance_exists(obj_textbox)) {
        action_end();
    }
}


