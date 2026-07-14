function action_end(){
    action++;
        
    if action >= array_length(cutscene){
        instance_destroy();
    }
}
	
function cutscene_walk_right(_segundos, _spd){
    // Muda o sprite para andar
    obj_player.sprite_index = spr_player_walk;
    // Você também pode espelhar o sprite se tiver xscale:
    obj_player.image_xscale = 1; 

    obj_player.x += _spd;
    timer++;
    
    if timer >= game_get_speed(gamespeed_fps) * _segundos{
        timer = 0;
        action_end();
    }
}

function cutscene_walk_left(_segundos, _spd){
    // Muda o sprite para andar
    obj_player.sprite_index = spr_player_walk;
    // Se quiser virar o sprite para a esquerda:
    obj_player.image_xscale = -1;

    obj_player.x -= _spd;
    timer++;
    
    if timer >= game_get_speed(gamespeed_fps) * _segundos{
        timer = 0;
        action_end();
    }
}

function cutscene_wait(_segundos){
    // Na espera, ele fica parado
    obj_player.sprite_index = spr_player_idle;

    timer++;
    
    if timer >= game_get_speed(gamespeed_fps) * _segundos{
        timer = 0;
        action_end();
    }
}




// 1. Move o player até uma posição X específica da tela (ex: o meio da tela)
// Move o player até uma posição X e Y específica da tela (permite alinhar na estrada)
function cutscene_move_player_to_pos(_target_x, _target_y, _spd) {
    // Descobre as direções
    var _dir_x = sign(_target_x - obj_player.x);
    var _dir_y = sign(_target_y - obj_player.y);
    
    obj_player.sprite_index = spr_player_walk;
    
    // Move nos dois eixos
    if (abs(obj_player.x - _target_x) > _spd) obj_player.x += _dir_x * _spd;
    if (abs(obj_player.y - _target_y) > _spd) obj_player.y += _dir_y * _spd;
    
    // Se chegou perto o suficiente de ambos os pontos, finaliza e alinha perfeitamente
    if (abs(obj_player.x - _target_x) <= _spd and abs(obj_player.y - _target_y) <= _spd) {
        obj_player.x = _target_x;
        obj_player.y = _target_y;
        action_end();
    }
}

// 2. Faz os cachorros aparecerem na esquerda, fora da tela
function cutscene_spawn_dogs(_quantidade) {
    // Trava anti-duplicação
    if (instance_exists(obj_dog)) {
        action_end();
        exit;
    }

    var _pos_nascimento_x = obj_player.x - 230; 
    var _pos_nascimento_y = obj_player.y;
    
    var _i = 0;
    repeat(_quantidade) {
        // Distância horizontal (X) entre eles na corrida
        var _distancia_x = (_i * 25); // 40px mantém eles bem coladinhos como matilha
        
        // --- ESPALHANDO OS 5 CACHORROS NO EIXO Y ---
        var _distancia_y = 0;
        if (_i == 0) _distancia_y = -55; // Linha de cima (Extrema)
        if (_i == 1) _distancia_y = 30;  // Linha de baixo (Extrema)
        if (_i == 2) _distancia_y = 0;   // Centro exato
        if (_i == 3) _distancia_y = -25; // Entre o centro e o topo
        if (_i == 4) _distancia_y = 25;  // Entre o centro e a base
        
        var _final_x = _pos_nascimento_x - _distancia_x - irandom(5);
        var _final_y = _pos_nascimento_y + _distancia_y + irandom_range(-3, 3);
        
        instance_create_layer(_final_x, _final_y, "Instances_1", obj_dog);
        
        _i++;
    }
    
    action_end();
}

// 3. Faz o player e os cachorros correrem juntos por um tempo
// Novo parâmetro: _segundos_gameplay (quanto tempo o jogador joga antes do vilão aparecer)
function cutscene_the_chase(_segundos, _player_spd, _dog_spd, _segundos_gameplay) {
    // Durante a cena: player corre a 1.5 e dogs a 3.5 para eles se aproximarem
    obj_player.sprite_index = spr_player_walk;
    obj_player.x += _player_spd;
    
    with(obj_dog) {
        velocidade = _dog_spd; 
    }
    
    timer++;
    
    if (timer >= game_get_speed(gamespeed_fps) * _segundos) {
        timer = 0;
        
        // --- TRANSIÇÃO EM ALTA VELOCIDADE ---
        // Passa o tempo dinâmico que você configurou na array para o player!
        obj_player.tempo_limite_fuga = _segundos_gameplay;
        obj_player.estado = obj_player.p_fuga;
        
        // Os cachorros mantêm a velocidade de 3.5 de forma constante
        with(obj_dog) {
            velocidade = _dog_spd; 
        }
        
        action_end();
    }
}

// 1. Toca qualquer som passado por parâmetro
function cutscene_play_sound(_sound_id, _priority, _loop) {
    // Se o som já não estiver tocando, executa (evita tocar duplicado se a ação repetir)
    if (!audio_is_playing(_sound_id)) {
        audio_play_sound(_sound_id, _priority, _loop);
    }
    
    action_end();
}

// 2. Para qualquer som passado por parâmetro
function cutscene_stop_sound(_sound_id) {
    if (audio_is_playing(_sound_id)) {
        audio_stop_sound(_sound_id);
    }
    
    action_end();
}

function cutscene_screen_shake(_segundos, _forca) {
    var _cam = view_camera[0];
    
    // No primeiro frame da tremida, guardamos a posição e desativamos o foco automático
    if (timer == 0) {
        original_cam_x = camera_get_view_x(_cam);
        original_cam_y = camera_get_view_y(_cam);
        
        // Desativa temporariamente o seguimento automático do player
        camera_set_view_target(_cam, noone);
    }
    
    // Escolhe valores aleatórios baseados na força para chacoalhar a tela
    var _shake_x = original_cam_x + random_range(-_forca, _forca);
    var _shake_y = original_cam_y + random_range(-_forca, _forca);
    
    // Aplica a tremida na câmera
    camera_set_view_pos(_cam, _shake_x, _shake_y);
    
    timer++;
    
    // Quando o tempo acabar
    if (timer >= game_get_speed(gamespeed_fps) * _segundos) {
        timer = 0;
        
        // Devolve a câmera exatamente para a posição original dela
        camera_set_view_pos(_cam, original_cam_x, original_cam_y);
        
        // REATIVA o seguimento automático do player!
        camera_set_view_target(_cam, obj_player);
        
        action_end();
    }
}



// 1. Para todo mundo e faz a tela piscar em branco rapidamente
function cutscene_flash_and_stop(_segundos, _frequencia) {
    // Para o player imediatamente
    obj_player.velh = 0;
    obj_player.velv = 0;
    obj_player.sprite_index = spr_player_idle;
    
    // Para todos os cachorros imediatamente
    with(obj_dog) {
        velocidade = 0;
        sprite_index = meu_sprite_parado;
    }
    
    timer++;
    
    // Faz a tela piscar ativando e desativando a variável de desenho na cutscene
    // Usamos o operador de resto (%) para alternar o flash baseado na frequência
    if (timer % _frequencia == 0) {
        draw_flash = !draw_flash; 
    }
    
    if (timer >= game_get_speed(gamespeed_fps) * _segundos) {
        timer = 0;
        draw_flash = false; // Garante que o flash apaga no final
        action_end();
    }
}

// 2. Cria o novo inimigo fora da tela à direita e faz ele andar devagar para a esquerda
function cutscene_spawn_and_move_enemy(_distancia_para_entrar, _spd) {
    var _cam = view_camera[0];
    var _cam_x = camera_get_view_x(_cam);
    var _cam_w = camera_get_view_width(_cam);
    
    // 1. Se o inimigo ainda não existe, cria ele escondido bem na direita da tela
    if (!instance_exists(obj_enemy)) {
        var _spawn_x = _cam_x + _cam_w + 50; // 50 pixels fora da tela à direita
        var _spawn_y = obj_player.y;         // Alinhado na altura da estrada
        
        instance_create_layer(_spawn_x, _spawn_y, "Instances_1", obj_enemy);
    }
    
    // 2. Move o inimigo para a esquerda (entrando na tela devagar)
    with(obj_enemy) {
        sprite_index = spr_enemy_idle; 
        x -= _spd; // Move para a esquerda
        
        // Ponto de parada: quando ele andar o suficiente para dentro do campo de visão
        var _ponto_parada = (_cam_x + _cam_w) - _distancia_para_entrar;
        if (x <= _ponto_parada) {
            x = _ponto_parada;
            sprite_index = spr_enemy_idle; // Fica parado encarando o player
            
            // Fim da ação!
            with(other) { action_end(); } 
        }
    }
}


function cutscene_dialogueDog(_array_de_falas) {
    // Usamos o 'timer' do próprio objeto da cutscene como uma variável de controle temporária.
    // Se o timer for 0, significa que é o primeiríssimo frame que essa ação está rodando!
    if (timer == 0) {
        var _caixa = instance_create_layer(0, 0, "Instances_1", obj_textbox);
        _caixa.falas = _array_de_falas;
        
        timer = 1; // Ativamos o "gatilho" para não recriar a caixa no próximo frame!
    }
    
    // A cutscene fica pausada aqui esperando a caixa sumir.
    // Só quando a caixa deixar de existir, finalizamos a ação de verdade!
    if (!instance_exists(obj_textbox)) {
        timer = 0; // Reseta o timer para ser usado limpo na próxima ação/diálogo!
        action_end();
    }
}



