randomize();

// --- VARIÁVEIS DE MOVIMENTO E FÍSICA ---
velh = 0;
velv = 0;
velz = 0;

vel_max	 = 3.5; // Velocidade máxima de corrida
vel_jump = 5;   // Força do pulo
grav     = 0.2; // Gravidade aplicada no eixo Z
z        = 0;   // Altura do pulo
is_on_air = false;

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
timer_fuga = 0;        // Cronômetro para disparar o evento do novo inimigo
tempo_limite_fuga = 5; // Tempo padrão (caso nenhuma cutscene defina um tempo diferente)
inimigo_ja_apareceu = false;
// Guarda a coordenada X da nossa parede invisível (começa com um valor negativo para não atrapalhar o início do jogo)
parede_invisivel_x = -10000;
atordoado = false;
timer_atordoado = 0;
perda_velocidade = 0; // O quanto ele perde de velocidade ao bater


// --- FUNÇÕES DE CONTROLE ---

// Função de controle padrão (Movimentação livre 8 direções)
control_player = function() {
	up	   = keyboard_check(ord("W"));
	left   = keyboard_check(ord("A"));
	down   = keyboard_check(ord("S"));
	right  = keyboard_check(ord("D"));
	jump   = keyboard_check_pressed(vk_space);
	attack = mouse_check_button_pressed(mb_left);

	velh = (right - left) * vel_max;
	velv = (down - up) * vel_max;
}

// Função de controle exclusiva para o modo de fuga (Corrida infinita)
control_fuga = function() {
    up   = keyboard_check(ord("W"));
    down = keyboard_check(ord("S"));
    jump = keyboard_check_pressed(vk_space);

    // Se estiver atordoado, subtrai a perda de velocidade do limite máximo
    var _vel_atual = vel_max - perda_velocidade;
    
    // Força o X a correr na velocidade atual calculada
    velh = _vel_atual; 
    
    // Controle vertical de desvio
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
	}
	
	if (_attack && image_index >= image_number - 1) {
		if (sprite_index == spr_player_punch1) {
			sprite_index = spr_player_punch2;
			image_index = 0;
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

// CÓDIGO LIMPO DO P_FUGA NO OBJ_PLAYER
p_fuga = function() {
    sprite_index = spr_player_walk;
    
    control_fuga();
    
    if (jump) { 
        estado = p_jump_fuga; 
    }
    // Repare que sumiu todo aquele bloco de IF com cronômetro daqui!
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