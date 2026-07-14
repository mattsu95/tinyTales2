if (array_length(falas) == 0) exit;

var _fala_atual = falas[pagina_atual];
var _texto_completo = _fala_atual.texto;

// 1. Controle da máquina de escrever
var _usar_maquina = struct_exists(_fala_atual, "maquina") ? _fala_atual.maquina : true;

if (_usar_maquina) {
    if (caractere_atual < string_length(_texto_completo)) {
        caractere_atual += velocidade_texto; 
    }
} else {
    caractere_atual = string_length(_texto_completo);
}

// 2. Verifica se essa fala específica tem um tempo definido para sumir
var _tem_tempo_limite = struct_exists(_fala_atual, "tempo");

if (_tem_tempo_limite) {
    var _tempo_limite = _fala_atual.tempo;
    
    // Se o texto já terminou de aparecer por completo...
    if (caractere_atual >= string_length(_texto_completo)) {
        timer_auto_sumir++;
        
        // Quando o tempo acabar, avança ou fecha
        if (timer_auto_sumir >= game_get_speed(gamespeed_fps) * _tempo_limite) {
            timer_auto_sumir = 0;
            pagina_atual++;
            caractere_atual = 0; 
            
            if (pagina_atual >= array_length(falas)) {
                instance_destroy(); 
                exit;
            }
        }
    }
    
    // O clique/espaço SÓ funciona se o texto tiver tempo limite (para pular o tempo dele)
    if (keyboard_check_pressed(vk_space) or mouse_check_button_pressed(mb_left)) {
        if (caractere_atual < string_length(_texto_completo)) {
            caractere_atual = string_length(_texto_completo); 
        } else {
            timer_auto_sumir = 0; 
            pagina_atual++;
            caractere_atual = 0; 
            
            if (pagina_atual >= array_length(falas)) {
                instance_destroy(); 
            }
        }
    }
}