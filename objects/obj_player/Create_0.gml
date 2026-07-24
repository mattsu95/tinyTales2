sprite_punch1 = spr_player_punch1;
sprite_punch2 = spr_player_punch2;

// --- SISTEMA DE CHECKPOINT DA ROOM ---
if (!variable_global_exists("checkpoint_room") || global.checkpoint_room != room) {
    global.checkpoint_room = room;
    global.checkpoint_x    = x;
    global.checkpoint_y    = y;
}

pego_pelos_dogs  = false;
timer_morte_dogs = 0;

image_speed = 0.7; // velocidade das animações (1 = padrão, menor = mais devagar)

// --- VIDA DO PLAYER ---
vida_max = 100;
vida     = vida_max;
invincivel_timer = 0;
invincivel_max   = game_get_speed(gamespeed_fps) * 0.3; // reduzido para permitir combos inimigos pegarem
game_over = false;

// --- EFEITO DE DANO NA HUD ---
dano_flash_timer = 0;
dano_flash_max = 8; // frames que a barra fica vermelha/vibrando

defendendo = false; // true enquanto F estiver pressionado
defendendo_prev = false;
parry_window     = 0;  // frames restantes de janela de parry
parry_window_max = 15; // ~0.25s a 60fps — janela ativa logo ao pressionar F
parry_stun_max   = game_get_speed(gamespeed_fps) * 1.5; // stun causado no inimigo pelo parry

timer_stun = 0;
parry_flash_timer = 0;

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

tap_window = 25; // Janela (em frames) para detectar duplo toque (ficou mais fácil e natural correr)
tap_left_timer  = 0;
tap_right_timer = 0;
tap_up_timer    = 0;
tap_down_timer  = 0;

is_running = false;
run_dir = 0; // 0=nenhuma, 1=left, 2=right, 3=up, 4=down

// --- SISTEMA DE INVENTÁRIO (Mesclado do Bloco 1) ---
inventario = [];
if (room == Terminal) {
    array_push(inventario, {
        nome: "Poção de Dano",
        sprite: spr_pocao_dano,
        objeto: obj_pocao,
        efeito: "dano"
    });
    array_push(inventario, {
        nome: "Poção de Cura",
        sprite: spr_pocao,
        objeto: obj_pocao,
        efeito: "cura"
    });
} else if (room == corbelia) {
    repeat (4) {
        array_push(inventario, {
            nome: "Poção de Dano",
            sprite: spr_pocao_dano,
            objeto: obj_pocao,
            efeito: "dano"
        });
        array_push(inventario, {
            nome: "Poção de Cura",
            sprite: spr_pocao,
            objeto: obj_pocao,
            efeito: "cura"
        });
    }
}
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

// --- GAMEPAD (DualSense/PS5 e outros) ---
gp_device = -1;
gp_deadzone = 0.35;

refresh_gamepad_device = function() {
	if (gp_device >= 0 && gamepad_is_connected(gp_device)) {
		return;
	}

	gp_device = -1;
	for (var _i = 0; _i < 4; _i++) {
		if (gamepad_is_connected(_i)) {
			gp_device = _i;
			break;
		}
	}
}

gp_connected = function() {
	refresh_gamepad_device();
	return gp_device >= 0;
}

gp_check = function(_button) {
	if (!gp_connected()) return false;
	return gamepad_button_check(gp_device, _button);
}

gp_pressed = function(_button) {
	if (!gp_connected()) return false;
	return gamepad_button_check_pressed(gp_device, _button);
}

gp_axis = function(_axis) {
	if (!gp_connected()) return 0;
	var _value = gamepad_axis_value(gp_device, _axis);
	if (abs(_value) < gp_deadzone) return 0;
	return _value;
}

// --- FUNÇÕES DE CONTROLE ---

// Função de controle padrão (Movimentação livre 8 direções)
control_player = function() {
	var _axis_h = gp_axis(gp_axislh);
	var _axis_v = gp_axis(gp_axislv);

	up			= keyboard_check(ord("W")) || gp_check(gp_padu) || (_axis_v < -0.5);
	left		= keyboard_check(ord("A")) || gp_check(gp_padl) || (_axis_h < -0.5);
	down		= keyboard_check(ord("S")) || gp_check(gp_padd) || (_axis_v > 0.5);
	right		= keyboard_check(ord("D")) || gp_check(gp_padr) || (_axis_h > 0.5);
	jump		= false; // Pulo desativado
	attack		= mouse_check_button_pressed(mb_left) || gp_pressed(gp_face1);
	roll_dice	= mouse_check_button(mb_right) || gp_check(gp_shoulderr);

	var _left_pressed = keyboard_check_pressed(ord("A")) || gp_pressed(gp_padl);
	var _right_pressed = keyboard_check_pressed(ord("D")) || gp_pressed(gp_padr);
	var _up_pressed = keyboard_check_pressed(ord("W")) || gp_pressed(gp_padu);
	var _down_pressed = keyboard_check_pressed(ord("S")) || gp_pressed(gp_padd);
	

	if (tap_left_timer  > 0) tap_left_timer--;
	if (tap_right_timer > 0) tap_right_timer--;
	if (tap_up_timer    > 0) tap_up_timer--;
	if (tap_down_timer  > 0) tap_down_timer--;

	if (_left_pressed) {
		if (tap_left_timer > 0) {
			is_running = true;
			run_dir = 1;
		}
		tap_left_timer = tap_window;
	}

	if (_right_pressed) {
		if (tap_right_timer > 0) {
			is_running = true;
			run_dir = 2;
		}
		tap_right_timer = tap_window;
	}

	if (_up_pressed) {
		if (tap_up_timer > 0) {
			is_running = true;
			run_dir = 3;
		}
		tap_up_timer = tap_window;
	}

	if (_down_pressed) {
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
	var _axis_v = gp_axis(gp_axislv);

	up   = keyboard_check(ord("W")) || gp_check(gp_padu) || (_axis_v < -0.5);
	down = keyboard_check(ord("S")) || gp_check(gp_padd) || (_axis_v > 0.5);
    jump = false; // Pulo desativado

	var _vel_atual = vel_fuga - perda_velocidade;
	if (_vel_atual < 0) _vel_atual = 0;
	velh = _vel_atual;
    
    // Você controla o desvio vertical de forma suave (2)
    velv = (down - up) * 2; 
}


// --- ESTADOS (ANIMAÇÕES E COMPORTAMENTOS) DO PLAYER ---

p_idle = function() {
	sprite_index = spr_player_idle;
	
	if (defendendo) { estado = p_defend; return; }

	control_player();
	
	if (velh != 0 or velv != 0) {
		estado = p_walk;
	}
	
	menu = variable_global_exists("in_menu") ? global.in_menu : false;
	
	if (attack && attack_cooldown <= 0 && !menu) { estado = p_attack; }
	if (roll_dice && !inventario_vazio() && dice_cooldown <= 0) { estado = p_dice_roll; }
}

p_walk = function() {
	sprite_index = spr_player_walk;
	
	if (defendendo) { estado = p_defend; return; }

	control_player();
	
	if (velh == 0 and velv == 0) {
		estado = p_idle;
	}
	
	menu = variable_global_exists("in_menu") ? global.in_menu : false;
	if (attack && attack_cooldown <= 0 && menu) { estado = p_attack; }
	if (roll_dice && !inventario_vazio() && dice_cooldown <= 0) { estado = p_dice_roll; }
}

p_defend = function() {
	sprite_index = spr_player_idle;
	velh = 0;
	velv = 0;

	// sai da defesa quando soltar F
	if (!defendendo) {
		estado = p_idle;
	}
}

p_attack = function() {
	velv = 0;
	velh = 0;
	
	if (global.muleta) {
		sprite_punch1 = spr_player_muleta1;
		sprite_punch2 = spr_player_muleta2;
	}
	
	
	if (!attack_started) {
	    attack_started = true;

	    switch(combo_id) {
	        case 0: // primeiro ataque
	            sprite_index = sprite_punch1;
	            break;

	        case 1: // segundo ataque
	            sprite_index = sprite_punch2;
	            break;

	        case 2: // terceiro ataque
	            sprite_index = sprite_punch1;
	            break;
			
			default:
				// combo de 3 hits completo — cooldown maior para nao stun-lokar
				estado = p_idle;
				buffer_attack = false;
				attack_started = false;
				combo_id = 0;
				attack_cooldown = game_get_speed(gamespeed_fps) * 1.0;
				return;
	    }

	    image_index = 0;
	    attack_sequence_id++;
	}
	
	
	if (mouse_check_button_pressed(mb_left) || gp_pressed(gp_face1)) { 
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
		if (combo_id >= 2) {
			// terminou o 3º hit sem continuar — cooldown completo
			estado = p_idle;
			buffer_attack = false;
			attack_started = false;
			combo_id = 0;
			attack_cooldown = game_get_speed(gamespeed_fps) * 1.0;
		} else {
			estado = p_idle;
			buffer_attack = false;
			attack_started = false;
			combo_id = 0;
			attack_cooldown = game_get_speed(gamespeed_fps) * 0.25;
		}
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
   
    sprite_index = bici; 
	
    image_yscale = 1;
    image_xscale = sign(image_xscale);

    // --- 1. CAMPAINHA ---
	if (keyboard_check_pressed(ord("E")) || gp_pressed(gp_face1)) {
        audio_play_sound(bell, 1, false);
    }

    // --- 2. INPUTS DE MOVIMENTO ---
	var _axis_h = gp_axis(gp_axislh);
	var _axis_v = gp_axis(gp_axislv);

	var _right = keyboard_check(ord("D")) || gp_check(gp_padr) || (_axis_h > 0.5);
	var _left  = keyboard_check(ord("A")) || gp_check(gp_padl) || (_axis_h < -0.5);
	var _up    = keyboard_check(ord("W")) || gp_check(gp_padu) || (_axis_v < -0.5);
	var _down  = keyboard_check(ord("S")) || gp_check(gp_padd) || (_axis_v > 0.5);
    
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
    velh = 0;
    velv = 0;
    image_speed = 1; 
    
    // Trava o player se QUALQUER um dos gatilhos/cutscenes existir!
    if (!instance_exists(obj_cutscene_dog) and !instance_exists(obj_cutscene_enemy) and !instance_exists(obj_cutscene_bueiro) and !instance_exists(obj_gatilho_unioeste) and !instance_exists(obj_cutscene_roubo) and !instance_exists(obj_cutscene_terminal)) {
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
		if (roll_range < 50) roll_range++;
		image_index = 0;
	} 
	
	if (mouse_check_button_released(mb_right)) {
		// modificadores no x e y pra parecer sair da mão => AUTOMATIZAR ISSO DEPOIS
		var dado = instance_create_layer(x + 5 * image_xscale, y - 20, "Instances", obj_dado);
		
		dice_cooldown = game_get_speed(gamespeed_fps) * 2;
		
		dado.dir	= image_xscale;
		dado.velh	= image_xscale * (roll_range * 0.5 * 0.1);
		dado.velz	= -(2 + roll_range * 0.5 * 0.1);
		dado.item	= escolhe_item();
		dado.velang = image_xscale * (roll_range * 0.75 * random_range(0.5, 0.9)); 
		
		dado.roll();
	}
	
	
}

p_stunned = function() {
    sprite_index = spr_player_idle;
    velh = 0;
    velv = 0;

    timer_stun--;
    if (timer_stun <= 0) {
        image_blend    = c_white;
        estado = p_idle;
		parry_flash_timer = 20;
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
		if (inventario[i] != noone) { array_push(slots_ocupados, i); }
	}
	var sorteado = irandom(array_length(slots_ocupados) - 1);
	var indice = slots_ocupados[sorteado];

	var item = inventario[indice];
	inventario[indice] = noone;

	return item;
}

inventario_vazio = function() {
	if (array_length(inventario) <= 0) {
		return true;
	}
	
	// checa se todos os itens são noone
	if (array_all(inventario, function(_item, _index) { return (_item == noone); })) {
		return true;
	}
	
	return false;
}