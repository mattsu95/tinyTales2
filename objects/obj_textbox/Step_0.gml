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
    
    // --- TECLAS PARA AVANÇAR / PULAR ---
    // Agora aceita ENTER (vk_enter), ESPAÇO (vk_space) e CLIQUE (mb_left)
    var _apertou_avancar = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || mouse_check_button_pressed(mb_left);
    
    if (!ignorar_inputs && _apertou_avancar) {
        if (caractere_atual < string_length(_texto_completo)) {
            // Se o texto ainda está escrevendo, completa ele instantaneamente
            caractere_atual = string_length(_texto_completo); 
        } else {
            // Se já escreveu tudo, passa para a próxima página ou fecha
            timer_auto_sumir = 0; 
            pagina_atual++;
            caractere_atual = 0; 
            
            if (pagina_atual >= array_length(falas)) {
                instance_destroy(); 
            }
        }
    }
}