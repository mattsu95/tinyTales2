event_inherited();

image_speed = 0.6;

vida_max = 20;
vida = vida_max;

dano_por_hit = 1;
cooldown_dano = 0;
cooldown_dano_max = 12;
ultimo_attack_id_recebido = -1;
foi_atingido = false;

dano_ataque = 20;
hit_this_swing = false;

stun_ativo = false;
timer_stun = 0;
timer_stun_max = game_get_speed(gamespeed_fps) * 0.4;
flash_timer = 0;
imunidade_stun = 0;
imunidade_stun_max = game_get_speed(gamespeed_fps) * 2;

alcance_hit = 36;
vel_movimento = 1.0;
vel_ataque = 1.8;

area_visao = 200;
area_perseguicao = 350;

alvo = noone;

// Sistema de ataque: 3 segundos entre ataques, 1 segundo de parada após ataque
cooldown_ataque_principal = game_get_speed(gamespeed_fps) * 3; // 3 segundos
timer_ataque = cooldown_ataque_principal;
tempo_recovery = game_get_speed(gamespeed_fps) * 1; // 1 segundo de parada
timer_recovery = 0;

// Sistema de combos: 2-3 socos em sequência
in_combo = false;
combo_count = 0;
combo_max = irandom_range(1, 2); // 1 ou 2 hits
combo_delay = game_get_speed(gamespeed_fps) * 0.3; // 0.3s entre hits do combo
combo_timer = 0;
attack_timeout = game_get_speed(gamespeed_fps) * 3; // timeout de 3s para sair de ataque
attack_timer = 0;

// Movimento circular ao redor do player
angulo_movimento = irandom(359);
velocidade_angular = random_range(1, 2); // graus por frame
distancia_alvo = 80 + irandom(30);

checa_area = function(_tamanho = 0, _alvo = noone) {
	if (_alvo == noone) { return false; }
	return collision_circle(x, y, _tamanho, _alvo, 0, 1);
}

set_sprite = function(_sprite) {
	if (sprite_index != _sprite) {
		sprite_index = _sprite;
		image_index  = 0;
	}
}

// ─── UTILITÁRIO: move suavemente para um ponto alvo ───────────────────────
mover_para = function(_tx, _ty, _spd) {
	var _dir = point_direction(x, y, _tx, _ty);
	velh = lengthdir_x(_spd, _dir);
	velv = lengthdir_y(_spd, _dir);
}

// ─── ESTADOS ──────────────────────────────────────────────────────────────

// Estado 1: Procurando pelo player
e_search = function() {
	set_sprite(spr_enemy_idle);
	velh = 0; velv = 0;
	
	alvo = checa_area(area_visao, obj_player);
	if (alvo && instance_exists(alvo)) {
		estado = e_circling;
	}
}

// Estado 2: Circulando ao redor do player (movimento aleatório em volta)
e_circling = function() {
	set_sprite(spr_enemy_move);
	
	alvo = checa_area(area_perseguicao, obj_player);
	if (!alvo || !instance_exists(alvo)) {
		estado = e_search;
		return;
	}
	
	// Reseta timers de ataque quando entra em circling
	attack_timer = 0;
	
	// Movimento aleatório ao redor do player
	angulo_movimento += random_range(-velocidade_angular, velocidade_angular);
	var _tx = alvo.x + lengthdir_x(distancia_alvo, angulo_movimento);
	var _ty = alvo.y + lengthdir_y(distancia_alvo, angulo_movimento);
	
	// Clamp para ficar dentro do mapa
	_tx = clamp(_tx, 40, room_width - 40);
	_ty = clamp(_ty, sprite_height/2 + 20, room_height - 40);
	
	mover_para(_tx, _ty, vel_movimento);
	image_xscale = (alvo.x < x) ? 1 : -1;
	
	// Decrementa timer de ataque
	timer_ataque--;
	if (timer_ataque <= 0) {
		estado = e_approach;
	}
}

// Estado 2.5: Aproximação rápida antes do ataque (com token check)
e_approach = function() {
	set_sprite(spr_enemy_move);
	
	alvo = checa_area(area_perseguicao, obj_player);
	if (!alvo || !instance_exists(alvo)) {
		estado = e_search;
		return;
	}
	
	// Reseta attack_timer ao entrar em approach
	attack_timer = 0;
	
	// Verifica se outro inimigo já está atacando (token system)
	var _ja_atacando = false;
	with (obj_enemy) {
		if (id != other.id && estado == e_attack) {
			_ja_atacando = true;
			break;
		}
	}
	
	// Se outro está atacando, volta para circling e espera
	if (_ja_atacando) {
		timer_ataque = cooldown_ataque_principal * random_range(0.3, 0.7); // espera um pouco
		estado = e_circling;
		return;
	}
	
	// Se movimenta rápido em direção ao player
	mover_para(alvo.x, alvo.y, vel_movimento * 2.5);
	image_xscale = (alvo.x < x) ? 1 : -1;
	
	// Quando chega perto o suficiente, ataca
	var _dist = point_distance(x, y, alvo.x, alvo.y);
	if (_dist <= alcance_hit) {
		estado = e_attack;
	}
}

// Estado 3: Atacando (combo de 2-3 socos)
e_attack = function() {
	velh = 0; velv = 0;
	set_sprite(spr_enemy_punch);
	
	alvo = checa_area(area_perseguicao, obj_player);
	if (!alvo || !instance_exists(alvo)) {
		in_combo = false;
		combo_count = 0;
		attack_timer = 0;
		estado = e_recovery;
		return;
	}
	
	image_xscale = (alvo.x < x) ? 1 : -1;
	
	// Timeout de segurança: se ficar muito tempo atacando, força saída
	attack_timer++;
	if (attack_timer > attack_timeout) {
		in_combo = false;
		combo_count = 0;
		attack_timer = 0;
		timer_recovery = tempo_recovery;
		estado = e_recovery;
		return;
	}
	
	// No primeiro frame do ataque, inicia combo
	if (!in_combo) {
		in_combo = true;
		combo_count = 0;
		combo_max = irandom_range(1, 2);
		attack_timer = 0;
	}
	
	// Aplica dano no meio da animação do soco
	if (!hit_this_swing && image_index >= floor(image_number * 0.5)) {
		hit_this_swing = true;
		var _dist = point_distance(x, y, alvo.x, alvo.y);
		if (_dist <= alcance_hit) {
			// Checa PARRY - se der parry, cancela TODO o combo
			if (alvo.parry_window > 0) {
				alvo.image_blend = make_colour_rgb(255, 220, 50);
				alvo.invincivel_timer = alvo.invincivel_max;
				stun_ativo = true;
				timer_stun = alvo.parry_stun_max;
				flash_timer = 0;
				hit_this_swing = false;
				in_combo = false;
				combo_count = 0;
				attack_timer = 0;
				// Volta para recovery após parry
				timer_recovery = tempo_recovery;
				estado = e_recovery;
				return;
			} else {
				// Aplica dano (defesa reduz a 0.5)
				var _dano_final = alvo.defendendo ? dano_ataque * 0.5 : dano_ataque;
				alvo.vida -= _dano_final;
				alvo.invincivel_timer = alvo.invincivel_max * 0.4; // Reduz immunity para combo pegar
				alvo.dano_flash_timer = alvo.dano_flash_max; // Ativa efeito visual de dano na HUD
				if (alvo.vida < 0) alvo.vida = 0;
				combo_count++;
			}
		}
	}
	
	// Termina a animação de 1 soco
	if (image_index > image_number - 1) {
		hit_this_swing = false;
		
		// Se fez todos os hits do combo, volta para recovery
		if (combo_count >= combo_max) {
			in_combo = false;
			combo_count = 0;
			attack_timer = 0;
			timer_recovery = tempo_recovery;
			estado = e_recovery;
		} else {
			// Reinicia animation para próximo hit
			image_index = 0;
			combo_timer = combo_delay;
		}
	}
}

// Estado 4: Recovery - parado por 1 segundo após ataque
e_recovery = function() {
	set_sprite(spr_enemy_idle);
	velh = 0; velv = 0;
	
	alvo = checa_area(area_perseguicao, obj_player);
	if (!alvo || !instance_exists(alvo)) {
		estado = e_search;
		return;
	}
	
	image_xscale = (alvo.x < x) ? 1 : -1;
	
	timer_recovery--;
	if (timer_recovery <= 0) {
		// Muda ligeiramente o ângulo de movimento para não ficar previsível
		angulo_movimento = irandom(359);
		timer_ataque = cooldown_ataque_principal;
		in_combo = false;
		combo_count = 0;
		attack_timer = 0;
		estado = e_circling;
	}
}

estado = e_search;