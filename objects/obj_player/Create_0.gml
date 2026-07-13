velh = 0;
velv = 0;
velz = 0;

vel_max	 = 2;
vel_jump = 5;

estado = noone;

// gravidade
grav = 0.2;

// pulo
z = 0;

// variaveis de controle
up	     = noone;
left	 = noone;
down	 = noone;
right	 = noone;
jump	 = noone;
attack	 = noone;

buffer_attack = false;


// função de controle
control_player = function() {
	
	up		= keyboard_check(ord("W"));
	left	= keyboard_check(ord("A"));
	down	= keyboard_check(ord("S"));
	right	= keyboard_check(ord("D"));
	jump	= keyboard_check_pressed(vk_space);
	attack  = mouse_check_button_pressed(mb_left);

	velh = (right - left) * vel_max;
	velv = (down - up) * vel_max;
}


// estados (animações) do player
p_idle = function() {
	sprite_index = spr_player_idle;
	
	control_player();
	
	if (velh != 0 or velv != 0) {
		estado = p_walk;
	}
	
	if (jump) {	estado = p_jump; }
	
	if (attack) { estado = p_attack; }
}

p_walk = function(){
	sprite_index = spr_player_walk;
	
	control_player();
	
	if (velh == 0 and velv == 0) {
		estado = p_idle;
	}
	
	if (jump) {	estado = p_jump; }
	
	if (attack) { estado = p_attack; }
}

p_attack = function() {
	
	velv = 0;
	velh = 0;
	
	var _attack = mouse_check_button_pressed(mb_left);
	
	if (buffer_attack = true) { _attack = true; } 
	else {	buffer_attack = mouse_check_button_pressed(mb_left); }
	
	if (sprite_index != spr_player_punch1 && sprite_index != spr_player_punch2) {
		sprite_index = spr_player_punch1;
		image_index = 0;
	}
	
	if (_attack && image_index >= image_number -1) {
		if (sprite_index == spr_player_punch1) {
			sprite_index = spr_player_punch2;
			image_index = 0;
			buffer_attack = false;
		}
		
		/*if (sprite_index == spr_player_punch2 && buffer_attack) {
			sprite_index = spr_player_punch1;
			image_index = 0;
			buffer_attack = false;
		}*/
	}
	
	// saindo do estado
	if (image_index >= image_number - 1) {
		estado = p_idle;
		buffer_attack = false;
	}
}

p_jump = function(){
	
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
		image_index = image_number -2;
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

estado = p_idle;