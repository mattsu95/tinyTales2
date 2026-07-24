if (array_length(falas) == 0) exit;

var _fala_atual = falas[pagina_atual];
var _texto_completo = _fala_atual.texto;

// 1. Controle da máquina de escrever + Som de escrita
var _usar_maquina = struct_exists(_fala_atual, "maquina") ? _fala_atual.maquina : true;

if (_usar_maquina) {
    if (caractere_atual < string_length(_texto_completo)) {
        caractere_atual += velocidade_texto; 
    }
} else {
    caractere_atual = string_length(_texto_completo);
}

// 2. Cronômetro de tempo automático (caso a fala defina tempo)
var _tem_tempo_limite = struct_exists(_fala_atual, "tempo");

if (_tem_tempo_limite) {
    var _tempo_limite = _fala_atual.tempo;
    
    // Se o texto já escreveu tudo
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
}

// 3. Teclas de atalho para avançar (Enter, Espaço ou Clique)
var _apertou_avancar = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || mouse_check_button_pressed(mb_left);
for (var _gp = 0; _gp < 4 && !_apertou_avancar; _gp++) {
    if (gamepad_is_connected(_gp) && (gamepad_button_check_pressed(_gp, gp_face1) || gamepad_button_check_pressed(_gp, gp_start))) {
        _apertou_avancar = true;
    }
}

if (!ignorar_inputs && _apertou_avancar) {
    if (caractere_atual < string_length(_texto_completo)) {
        // Completa o texto instantaneamente
        caractere_atual = string_length(_texto_completo); 
    } else {
        // Avança página ou encerra
        timer_auto_sumir = 0; 
        pagina_atual++;
        caractere_atual = 0; 
        
        if (pagina_atual >= array_length(falas)) {
            instance_destroy(); 
        }
    }
}