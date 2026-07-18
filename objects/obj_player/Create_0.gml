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
is_on_air = false; // Inicializa antes de usar em control_player

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
dice_cooldown	   = 0;

// --- VARIÁVEIS DE CONTROLE E INPUTS ---
up			= noone;
left		= noone;
down		= noone;
right		= noone;
jump		= noone;
attack		= noone;
roll_dice   = noone;

buffer_attack = false;
attack_sequence_id = 0;
combo_id = 0;
attack_started = false;
attack_cooldown = 0;
timer_fuga = 0;        // Cronômetro para disparar o evento do novo inimigo
tempo_limite_fuga = 5; // Tempo padrão (caso nenhuma cutscene defina um tempo diferente)
inimigo_ja_apareceu = false;
parede_invisivel_x = -10000;
atordoado = false;
timer_atordoado = 0;
perda_velocidade = 0;
roll_range = 0;


// Variáveis da Bicicleta
ta_de_bike = false;
vel_atual_bike = 0;       // Começa parada
vel_max_bike = 8;         // A velocidade máxima que ela atinge
aceleracao_bike = 0.2;    // O quão rápido ela embala
friccao_bike = 0.3;       // O quão rápido ela freia quando você solta o botão

// --- FUNÇÕES DE CONTROLE ---

// Função de controle padrão (Movimentação livre 8 direções)
control_player = function() {
	up			= keyboard_check(ord("W"));
	left		= keyboard_check(ord("A"));
	down		= keyboard_check(ord("S"));
	right		= keyboard_check(ord("D"));
	jump		= keyboard_check_pressed(vk_space);
	attack		= mouse_check_button_pressed(mb_left);
	roll_dice	= mouse_check_button(mb_right);

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
	var _airspeed = is_on_air ? 0.75 : 1; // por conta da velocidade no eixo y ficar maior durante o pulo
	velh = (right - left) * _speed;
	velv = (down - up) * _speed * _airspeed;
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
	if (attack && attack_cooldown <= 0) { estado = p_attack; }
	if (roll_dice && array_length(inventario) > 0 && dice_cooldown <= 0) { estado = p_dice_roll; }
}

p_walk = function() {
	sprite_index = spr_player_walk;
	
	control_player();
	
	if (velh == 0 and velv == 0) {
		estado = p_idle;
	}
	
	if (jump)   { estado = p_jump; }
	if (attack && attack_cooldown <= 0) { estado = p_attack; }
	if (roll_dice && array_length(inventario) > 0 && dice_cooldown <= 0) { estado = p_dice_roll; }
}

p_attack = function() {
	velv = 0;
	velh = 0;
	
	
	if (!attack_started) {
	    attack_started = true;

	    switch(combo_id) {
	        case 0: // primeiro ataque
	            sprite_index = spr_player_punch1;
	            break;

	        case 1: // segundo ataque
	            sprite_index = spr_player_punch2;
	            break;
			
			default:
				estado = p_idle;
				buffer_attack = false;
				attack_started = false;
				combo_id = 0;
				attack_cooldown = game_get_speed(gamespeed_fps) * 0.25;
				return;
	    }

	    image_index = 0;
	    attack_sequence_id++;
	}
	
	
	if (mouse_check_button_pressed(mb_left)) { 
		buffer_attack = true; 
	}
	
	var janela_combo = image_index >= image_number * 0.7;
	if (janela_combo && buffer_attack) { 
		combo_id++; 
		attack_started = false;
		buffer_attack = false;
	}
	
	// Saindo do estado de ataque
	if (image_index >= image_number - 1) {
		estado = p_idle;
		buffer_attack = false;
		attack_started = false;
		combo_id = 0;
		attack_cooldown = game_get_speed(gamespeed_fps) * 0.25;
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

p_bike = function() {
   
    sprite_index = tinicleta; 
	
	image_yscale = 0.1;
    // Pega a direção que o Step definiu (1 ou -1) e transforma em 0.1 ou -0.1
    image_xscale = sign(image_xscale) * 0.1;

    // --- 1. CAMPAINHA ---
    if (keyboard_check_pressed(ord("E"))) {
        audio_play_sound(bell, 1, false);
    }

    // --- 2. INPUTS DE MOVIMENTO ---
    var _right = keyboard_check(ord("D"));
    var _left  = keyboard_check(ord("A"));
    var _up    = keyboard_check(ord("W"));
    var _down  = keyboard_check(ord("S"));
    
    var _input_x = _right - _left;

    // --- 3. ACELERAÇÃO E FRICÇÃO (HORIZONTAL) ---
    if (_input_x != 0) {
        // Acelera gradualmente
        vel_atual_bike += aceleracao_bike * _input_x;
        vel_atual_bike = clamp(vel_atual_bike, -vel_max_bike, vel_max_bike);
        
        // Toca o som da corrente/pedal em loop se não estiver tocando
        if (!audio_is_playing(bicycle)) {
            audio_play_sound(bicycle, 1, true);
        }
    } else {
        // Freia gradualmente quando solta o botão (Fricção)
        if (vel_atual_bike > 0) vel_atual_bike -= friccao_bike;
        if (vel_atual_bike < 0) vel_atual_bike += friccao_bike;
        
        // Evita que a bike fique deslizando com 0.01 de velocidade
        if (abs(vel_atual_bike) < friccao_bike) vel_atual_bike = 0;
        
        // Para o som quando a bicicleta parar totalmente
        if (vel_atual_bike == 0 && audio_is_playing(bicycle)) {
            audio_stop_sound(bicycle);
        }
    }

    // --- 4. APLICA AS VELOCIDADES ---
    velh = vel_atual_bike;
    
    // Permite que a bicicleta desvie para cima e para baixo (eixo Y)
    // Coloquei velocidade 4, mas você pode ajustar se quiser mais rápido ou mais devagar
    velv = (_down - _up) * 4; 
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

// ROLA O DADO PARA USAR UM ITEM ALEATÓRIO DO INVENDADO
p_dice_roll = function () {
	
	if (image_index >= image_number -1 || dice_cooldown > 0) {
		estado = p_idle;
		roll_range = 0;
		return;
	}
	
	velv = 0;
	velh = 0;
	
	kleft		= keyboard_check(ord("A"));
	kright		= keyboard_check(ord("D"));
	if (kleft) { image_xscale = -1; }
	if (kright) { image_xscale = 1; }
	
	if (sprite_index != spr_player_punch1) {
		sprite_index = spr_player_punch1;
		image_index = 0;
	}
	
	
	if (mouse_check_button(mb_right)) {
		if (roll_range < 25) roll_range++;
		image_index = 0;
	} 
	
	if (mouse_check_button_released(mb_right)) {
		// modificadores no x e y pra parecer sair da mão => AUTOMATIZAR ISSO DEPOIS
		var dado = instance_create_layer(x + 5, y - 20, "Instances", obj_dado);
		
		dice_cooldown = game_get_speed(gamespeed_fps) * 2;
		
		dado.dir = image_xscale;
		dado.velh = image_xscale * (roll_range * 0.1);
		dado.velz = -(2 + roll_range * 0.1);
		dado.item = escolhe_item();
		
		dado.roll();
	}
	
	
}

// --- DEFINE O ESTADO INICIAL ---
estado = p_idle;

// UTILS

// ESCOLHE ALEATORIAMENTE O ITEM A SER USADO
escolhe_item = function() {
	// IMPLEMENTAR MODIFICADOR (dado viciado)
	
	slots_ocupados = [];
	for (i = 0; i < array_length(inventario); i++) {
		if (inventario[i]) { array_push(slots_ocupados, i); }
	}
	var sorteado = irandom(array_length(slots_ocupados) - 1);
	var indice = slots_ocupados[sorteado];

	var item = inventario[indice];
	inventario[indice] = noone;

	return item;
}