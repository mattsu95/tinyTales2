velh = 0;
velv = 0;
velz = 0;

vel_max = 2;

estado = noone;

// função de controle
control_player = function() {
	var _up, _down, _left, _right, _jump, _attack;

	_up		= keyboard_check(ord("W"));
	_left	= keyboard_check(ord("A"));
	_down	= keyboard_check(ord("S"));
	_right	= keyboard_check(ord("D"));
	
	_attack = mouse_check_button_pressed(mb_left)


	velh = (_right - _left) * vel_max;
	velv = (_down - _up) * vel_max;
	
	if (_attack) {
		estado = p_attack;
	}
	
}


// estados (animações) do player
p_idle = function() {
	sprite_index = spr_player_idle;
	
	control_player();
	
	if (velh != 0 or velv != 0) {
		estado = p_walk;
	}
}

p_walk = function(){
	sprite_index = spr_player_walk;
	
	control_player();
	
	if (velh == 0 and velv == 0) {
		estado = p_idle;
	}
}

p_attack = function() {
	
	var _attack = mouse_check_button_pressed(mb_left);
	
	if (sprite_index != spr_player_punch1 && sprite_index != spr_player_punch2) {
		image_index = 0;
		sprite_index = spr_player_punch1;
	}
	
	if (_attack) {
		if (sprite_index == spr_player_punch1) {
			image_index = 0;
			sprite_index = spr_player_punch2;
		}
	}
	
	if (image_index >= image_number - 1) {
		estado = p_idle;
	}
}

estado = p_idle;