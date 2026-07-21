// Inherit the parent event
event_inherited();


mvSet = [];

dado = instance_create_layer(x, y - 25, "Instances", obj_d6);
dado.owner = id;

image_speed = 0.7;
image_xscale = 0.5;
image_yscale = 0.5;
sprite_index = spr_enemy_idle;

// é um boss né
area_visao = 20000;
area_perseguicao = 35000;
vida_max *= 3;
vida = vida_max;
vel_movimento *= 1.5;
vel_ataque *= 1.5;

sprite_idle = spr_enemy_idle;
sprite_move = spr_enemy_move;
sprite_punch = spr_enemy_punch;
sprite_shoot = spr_enemy_punch;

// provocar no move_set de parry
sprite_taunt = spr_enemy_idle;

projectile = obj_projectile;

// tempo em segundos pra cada troca (pelo menos pra primeira)
roll_timer_max = game_get_speed(gamespeed_fps) * 5;
roll_timer = roll_timer_max;

// timer de 1 segundo pra troca de move_set
dice_roll_timer_max = game_get_speed(gamespeed_fps) * 1;
dice_roll_timer = dice_roll_timer_max;

// na troca de move_set faz uma pseudo-animação do dado girando
dice_roll = function() {
	dice_roll_timer--;
	rnd = irandom(dado.image_number - 1);
	dado.image_index = rnd;
	
	if (dice_roll_timer <= 0) {
		dice_roll_timer = dice_roll_timer_max;
		return false;
	}
	return true;
}

set_move_set = function(_mv) {

    move_set = _mv;

    switch (_mv) {
	    case mvSet_melee:
	        estado = e_search;
	        break;

	    case mvSet_range:
	        estado = e_search;
	        break;

	    case mvSet_parry:
	        estado = e_taunt;
	        break;
	}
}

// escolhe aleatoriamente um move set
rnd_move_set = function() {
    roll_timer = roll_timer_max;
    var rnd = irandom(array_length(mvSet) - 1);
    set_move_set(mvSet[rnd]);
}


mvSet_melee = function() {
	dado.image_index = 0;
	ranged = false;
	
	distancia_alvo	= 80 + irandom(30);
	estado_ofensivo = e_approach;
	estado_ataque   = e_attack;
	estado();
	
	if (roll_timer <= 0 && !in_combo) {
		if (!dice_roll()) {
			rnd_move_set();
		}
	}
}

mvSet_range = function() {
	dado.image_index = 1;
	
	ranged = true;
	distancia_alvo	= 300 + irandom(50);
	estado_ataque   = e_shoot;
	estado_ofensivo = estado_ataque; // ia fazer uma outra função mas aparentemente não é necessário
	estado();
	
	// DEIXAR MENOS TEMPO NESSE MOVE_SET PORQUE TÁ MEIO MERDA
	if (roll_timer <= 0 && !in_combo) {
		if (!dice_roll()) {
			rnd_move_set();
		}
	}
}

mvSet_parry = function() {
	dado.image_index = 2;
	
	estado();
	
	if (roll_timer <= 0 && !in_combo) {
		if (!dice_roll()) {
			rnd_move_set();
		}
	}
}

mvSet_darksouls = function() {
	dado.image_index = 3;
	
	if (roll_timer <= 0 && !in_combo) {
		if (!dice_roll()) {
			rnd_move_set();
		}
	}
}

mvSet_dash = function() {
	dado.image_index = 4;
	
	if (roll_timer <= 0 && !in_combo) {
		if (!dice_roll()) {
			rnd_move_set();
		}
	}
}

mvSet_cake = function() {
	dado.image_index = 5;
	
	if (roll_timer <= 0 && !in_combo) {
		if (!dice_roll()) {
			rnd_move_set();
		}
	}
}

// move set atual
mvSet = [mvSet_melee, mvSet_range, mvSet_parry, mvSet_darksouls, mvSet_dash, mvSet_cake];
set_move_set(mvSet[2]);