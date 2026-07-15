// No evento de Colisão do obj_dialog_trigger com obj_player:
if (!instance_exists(obj_textbox)) {
    // Cria o textbox na mesma layer do trigger para garantir que a layer existe em qualquer room.
    var _layer_name = layer_get_name(layer);
    var _caixa = instance_create_layer(x, y, _layer_name, obj_textbox);
    _caixa.falas = meu_dialogo; 
    
    instance_destroy(); 
}