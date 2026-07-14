// EVENTO STEP - Executa a cutscene de forma dinâmica e segura!
if (action < array_length(cutscene)) {
    var _current_action = cutscene[action];
    var _func = _current_action[0];
    
    // Copia todos os parâmetros (pulando a função no índice 0)
    var _args = [];
    array_copy(_args, 0, _current_action, 1, array_length(_current_action) - 1);
    
    // Executa a função passando a lista de argumentos perfeitamente
    script_execute_ext(_func, _args);
}