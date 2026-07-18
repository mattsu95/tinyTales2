event_inherited();

vida_max = 3;
vida = vida_max;

dano_por_hit = 1;
cooldown_dano = 0;
cooldown_dano_max = 12;
ultimo_attack_id_recebido = -1;

alcance_hit = 36;

// área de visão e perseguição
area_visao = 100;
area_perseguicao = 260;

alvo = noone;

// tempo pra mudar de estado
espera_estado = game_get_speed(gamespeed_fps) * 2;
timer_estado = espera_estado;
timer_ataque = 0;

// verifica se o player tá dentro da área de visão
checa_area = function(_tamanho = 0, _alvo = noone) {
	if (_alvo == noone) { return false; }
	
	return collision_circle(x, y, _tamanho, _alvo, 0, 1);
}

// ESTADOS DO INIMIGO
set_sprite = function(_sprite) {
	if (sprite_index != _sprite) {
		sprite_index = _sprite;
		image_index = 0;
	}
}

e_idle = function() {
	set_sprite(spr_enemy_idle);

	velh = 0;
	velv = 0;

	timer_estado--;

	if (timer_estado <= 0) {
		timer_estado = espera_estado;
		estado = choose(e_idle, e_move);
		return;
	}

	alvo = checa_area(area_visao, obj_player);

	if (alvo) {
		estado = e_chase;
		return;
	}
}

e_move = function() {
	if (sprite_index != spr_enemy_move) {
		set_sprite(spr_enemy_move);

		velh = random_range(-0.5, 0.5);
		velv = random_range(-0.5, 0.5);
	}

	timer_estado--;

	if (timer_estado <= 0) {
		timer_estado = espera_estado;
		estado = choose(e_idle, e_move);
		return;
	}

	alvo = checa_area(area_visao, obj_player);

	if (alvo) {
		estado = e_chase;
		return;
	}
}

e_chase = function() {
	set_sprite(spr_enemy_move);

	alvo = checa_area(area_perseguicao, obj_player);

	if (!alvo) {
		timer_ataque = 0;
		estado = e_idle;
		return;
	}

	timer_ataque--;

	var _dist = point_distance(x, y, alvo.x, alvo.y);
	var _dist_x = abs(alvo.x - x);
	var _dist_y = abs(alvo.bbox_top - y);

	// move na direção do player evitando outros inimigos
	var dir_player = point_direction(x, y, alvo.x, alvo.y);

	var vx = lengthdir_x(1, dir_player);
	var vy = lengthdir_y(1, dir_player);

	with (obj_enemy)
	{
		if (id != other.id)
		{
		    var d = point_distance(x, y, other.x, other.y);

		    if (d < 24)
		    {
		        var dir = point_direction(x, y, other.x, other.y);

		        vx += lengthdir_x(0.5, dir);
		        vy += lengthdir_y(0.5, dir);
		    }
		}
	}
	
	var dir = point_direction(0,0,vx,vy);

	velh = lengthdir_x(1,dir);
	velv = lengthdir_y(1,dir);

	/*velh = lengthdir_x(_dist_x < 20 ? 0 : 1, _dir);
	velv = lengthdir_y(_dist_y < 20 ? 0 : 1, _dir);*/

	if (_dist <= alcance_hit) {
		if (timer_ataque <= 0) {
			timer_ataque = espera_estado;
			estado = e_attack;
			return;
		}

		velh = 0;
		velv = 0;
	}
}

e_attack = function() {
	velh = 0;
	velv = 0;

	set_sprite(spr_enemy_punch);

	if (image_index > image_number - 1) {
		estado = e_chase;
		return;
	}
}

estado = e_idle;