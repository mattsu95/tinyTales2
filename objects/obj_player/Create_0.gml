randomize();

// --- VARIÁVEIS DE MOVIMENTO E FÍSICA ---
velh = 0;
velv = 0;
velz = 0;

vel_walk = 2.0; // Velocidade padrão de caminhada
vel_run  = 3.5; // Velocidade de corrida (duplo toque)
vel_fuga = 3.5; // Velocidade fixa no modo fuga
vel_max  = vel_run; // Mantido para compatibilidade com outras rotinas
vel_jump = 5;   // Força do pulo
grav     = 0.2; // Gravidade aplicada no eixo Z
z        = 0;   // Altura do pulo
is_on_air = false;

tap_window = 12; // Janela (em frames) para detectar duplo toque
tap_left_timer  = 0;
tap_right_timer = 0;
tap_up_timer    = 0;
tap_down_timer  = 0;

is_running = false;
run_dir = 0; // 0=nenhuma, 1=left, 2=right, 3=up, 4=down

// --- SISTEMA DE INVENTÁRIO (Mesclado do Bloco 1) ---
inventario = [];
mostrar_inventario = false;
indice_selecionado = 0;

// --- VARIÁVEIS DE CONTROLE E INPUTS ---
up	   = noone;
left   = noone;
down   = noone;
right  = noone;
jump   = noone;
attack = noone;

buffer_attack = false;
attack_sequence_id = 0;
timer_fuga = 0;        // Cronômetro para disparar o evento do novo inimigo
tempo_limite_fuga = 5; // Tempo padrão (caso nenhuma cutscene defina um tempo diferente)
inimigo_ja_apareceu = false;
parede_invisivel_x = -10000;
atordoado = false;
timer_atordoado = 0;
perda_velocidade = 0;

// --- FUNÇÕES DE CONTROLE ---

// Função de controle padrão (Movimentação livre 8 direções)
control_player = function() {
	up	   = keyboard_check(ord("W"));
	left   = keyboard_check(ord("A"));
	down   = keyboard_check(ord("S"));
	right  = keyboard_check(ord("D"));
	jump   = keyboard_check_pressed(vk_space);
	attack = mouse_check_button_pressed(mb_left);

	if (tap_left_timer  > 0) tap_left_timer--;
	if (tap_right_timer > 0) tap_right_timer--;
	if (tap_up_timer    > 0) tap_up_timer--;
	if (tap_down_timer  > 0) tap_down_timer--;

	if (keyboard_check_pressed(ord("A"))) {
		if (tap_left_timer > 0) {
			is_running = true;
			run_dir = 1;
		}
		tap_left_timer = tap_window;
	}

	if (keyboard_check_pressed(ord("D"))) {
		if (tap_right_timer > 0) {
			is_running = true;
			run_dir = 2;
		}
		tap_right_timer = tap_window;
	}

	if (keyboard_check_pressed(ord("W"))) {
		if (tap_up_timer > 0) {
			is_running = true;
			run_dir = 3;
		}
		tap_up_timer = tap_window;
	}

	if (keyboard_check_pressed(ord("S"))) {
		if (tap_down_timer > 0) {
			is_running = true;
			run_dir = 4;
		}
		tap_down_timer = tap_window;
	}

	if ((left + right + up + down) == 0) {
		is_running = false;
		run_dir = 0;
	}

	if (is_running) {
		switch (run_dir) {
			case 1: if (!left)  is_running = false; break;
			case 2: if (!right) is_running = false; break;
			case 3: if (!up)    is_running = false; break;
			case 4: if (!down)  is_running = false; break;
		}
		if (!is_running) run_dir = 0;
	}

	var _speed = is_running ? vel_run : vel_walk;
	velh = (right - left) * _speed;
	velv = (down - up) * _speed;
}

// Função de controle exclusiva para o modo de fuga (Corrida infinita)
control_fuga = function() {
    up   = keyboard_check(ord("W"));
    down = keyboard_check(ord("S"));
    jump = keyboard_check_pressed(vk_space);

	var _vel_atual = vel_fuga - perda_velocidade;
	if (_vel_atual < 0) _vel_atual = 0;
	velh = _vel_atual;
    
    // Você controla o desvio vertical de forma suave (2)
    velv = (down - up) * 2; 
}


// --- ESTADOS (ANIMAÇÕES E COMPORTAMENTOS) DO PLAYER ---

p_idle = function() {
	sprite_index = spr_player_idle;
	
	control_player();
	
	if (velh != 0 or velv != 0) {
		estado = p_walk;
	}
	
	if (jump)   { estado = p_jump; }
	if (attack) { estado = p_attack; }
}

p_walk = function() {
	sprite_index = spr_player_walk;
	
	control_player();
	
	if (velh == 0 and velv == 0) {
		estado = p_idle;
	}
	
	if (jump)   { estado = p_jump; }
	if (attack) { estado = p_attack; }
}

p_attack = function() {
	velv = 0;
	velh = 0;
	
	var _attack = mouse_check_button_pressed(mb_left);
	
	if (buffer_attack == true) { _attack = true; } 
	else { buffer_attack = mouse_check_button_pressed(mb_left); }
	
	if (sprite_index != spr_player_punch1 && sprite_index != spr_player_punch2) {
		sprite_index = spr_player_punch1;
		image_index = 0;
		attack_sequence_id++;
	}
	
	if (_attack && image_index >= image_number - 1) {
		if (sprite_index == spr_player_punch1) {
			sprite_index = spr_player_punch2;
			image_index = 0;
			attack_sequence_id++;
			buffer_attack = false;
		}
	}
	
	// Saindo do estado de ataque
	if (image_index >= image_number - 1) {
		estado = p_idle;
		buffer_attack = false;
	}
}

p_jump = function() {
	if (sprite_index != spr_player_jump) {
		sprite_index = spr_player_jump;
		image_index = 0;
		velz = -vel_jump;
	}
	
	control_player();
	
	if (image_index >= 2) {
		image_index = 2;
	}
	
	if (velz > 1.5) {
		image_index = image_number - 2;
	}
	
	z += velz;
	
	if (z < 0) {
		velz += grav;
		is_on_air = true;
	} 
	else {
		velz = 0;
		z = 0;
		is_on_air = false;
		estado = p_idle;		
	}
}

p_cutscene = function() {
    // Trava as velocidades para ignorar o teclado completamente
    velh = 0;
    velv = 0;
    image_speed = 1; 
    
    // SÓ se liberta se AMBOS os controladores de cutscene não existirem mais!
    if (!instance_exists(obj_cutscene_dog) and !instance_exists(obj_cutscene_enemy)) {
        estado = p_idle;
    }
}
p_fuga = function() {
    sprite_index = spr_player_walk;
    
    control_fuga();
    
    if (jump) { 
        estado = p_jump_fuga; 
    }
}

p_jump_fuga = function() {
    if (sprite_index != spr_player_jump) {
        sprite_index = spr_player_jump;
        image_index = 0;
        velz = -vel_jump; 
    }
    
    control_fuga();
    
    if (image_index >= 2) {
        image_index = 2;
    }
    
    if (velz > 1.5) {
        image_index = image_number - 2;
    }
    
    z += velz;
    
    if (z < 0) {
        velz += grav;
        is_on_air = true;
    } 
    else {
        velz = 0;
        z = 0;
        is_on_air = false;
        estado = p_fuga; // Volta direto para a corrida de fuga sem parar!       
    }
}

// --- DEFINE O ESTADO INICIAL ---
estado = p_idle;