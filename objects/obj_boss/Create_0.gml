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
vida_max *= 5;
vida = vida_max;
vel_movimento_max = 1.5 * vel_movimento;
vel_ataque_max = 1.5 * vel_ataque;
cooldown_ataque_principal_max = game_get_speed(gamespeed_fps) * 3; // 3 segundos
timer_ataque = cooldown_ataque_principal_max;
tempo_recovery_max = game_get_speed(gamespeed_fps) * 1; // 1 segundo de parada

sprite_idle = spr_enemy_idle;
sprite_move = spr_enemy_move;
sprite_punch = spr_enemy_punch;
sprite_shoot = spr_enemy_punch;
sprite_taunt = spr_enemy_idle;
sprite_pulo = spr_enemy_idle;

projectile = obj_projectile;

// tempo em segundos pra cada troca
roll_timer_max = game_get_speed(gamespeed_fps) * 10;
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
			roll_timer_max = game_get_speed(gamespeed_fps) * 15;
			vel_movimento = vel_movimento_max;
			tempo_recovery = tempo_recovery_max;
			cooldown_ataque_principal = cooldown_ataque_principal_max;
	        estado = e_search;
	        break;

	    case mvSet_range:
			roll_timer_max = game_get_speed(gamespeed_fps) * 20;
			vel_movimento = vel_movimento_max;
			tempo_recovery = tempo_recovery_max;
			cooldown_ataque_principal = cooldown_ataque_principal_max;
	        estado = e_search;
	        break;

	    case mvSet_parry:
			roll_timer_max = game_get_speed(gamespeed_fps) * 8;
			vel_movimento = vel_movimento_max;
			tempo_recovery = tempo_recovery_max;
			cooldown_ataque_principal = cooldown_ataque_principal_max;
			som = audio_play_sound(evil_laugh, 1, false);
	        estado = e_taunt;
	        break;
			
		case mvSet_darksouls:
			roll_timer_max = game_get_speed(gamespeed_fps) * 10;
			vel_movimento = vel_movimento_max;
			tempo_recovery = tempo_recovery_max;
			cooldown_ataque_principal = cooldown_ataque_principal_max;
			actions = irandom(3) + 3;
			estado  = e_rage;
			break;
		case mvSet_berserker:
			roll_timer_max = game_get_speed(gamespeed_fps) * 20;
			vel_movimento *= 1.75;
			tempo_recovery *= 0.25;
			cooldown_ataque_principal *= 0.5;
			combo_max = 2;
			estado = e_search;
		case mvSet_cake:
			roll_timer_max = game_get_speed(gamespeed_fps) * 20;
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
	
	distancia_alvo	= 300 + irandom(50);
	estado();
	
	if (roll_timer <= 0 && !in_combo) {
		if (!dice_roll()) {
			rnd_move_set();
		}
	}
}

mvSet_darksouls = function() {
	dado.image_index = 3;
	
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

mvSet_berserker = function() {
	dado.image_index = 4;
	
	distancia_alvo	= 40 + irandom(30);
	estado();
	
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
mvSet = [mvSet_melee, mvSet_range, mvSet_parry, mvSet_darksouls, mvSet_berserker, mvSet_cake];
set_move_set(mvSet[1]);