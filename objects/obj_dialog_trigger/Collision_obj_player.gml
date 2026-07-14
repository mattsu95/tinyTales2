// No evento de Colisão do obj_dialog_trigger com obj_player:
if (!instance_exists(obj_textbox)) {
    // Forçamos a criação na camada "Instances" que sempre fica visível,
    // ou use a sua camada mais alta da Room!
    var _caixa = instance_create_layer(x, y, "Instances", obj_textbox);
    _caixa.falas = meu_dialogo; 
    
    instance_destroy(); 
}