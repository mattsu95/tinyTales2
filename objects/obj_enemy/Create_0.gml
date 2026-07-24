event_inherited();

image_speed = 0.6;

grav     = 0.5;

vida_max = 30;
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

// pra deixar as funções mais genéricas
sprite_idle = spr_enemy_idle;
sprite_move = spr_enemy_move;
sprite_punch = spr_enemy_punch;
sprite_shoot = spr_enemy_punch;
sprite_taunt = spr_enemy_idle;
sprite_pulo = spr_enemy_idle;
sprite_morte = noone;

projectile = obj_projectile;

ranged = false;

parry_window_max = 150 + irandom(120);
parry_window     = parry_window_max;  // frames restantes de janela de parry
parry_stun_max   = game_get_speed(gamespeed_fps) * 3; // stun causado no player pelo parry
parry = false;

// Boss' specifics
darksouls = false; // flag que indica se tá no moveset darksouls
actions = 0;	   // Número de ações por estado de frenesi
action_timer_max = game_get_speed(gamespeed_fps) * 0.5;
action_timer = action_timer_max;
vel_pulo = 15;
jump_started = false;
destino_x = x;
destino_y = y;
n_dash = 0;
novo_destino = true;
ultimo_angulo = -1;
timer_dash_max = game_get_speed(gamespeed_fps) * 0.5;
timer_dash = 0;
som = noone;


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
	set_sprite(sprite_idle);
	velh = 0; velv = 0;
	
	alvo = checa_area(area_visao, obj_player);
	if (alvo && instance_exists(alvo)) {
		estado = e_circling;
	}
}

// Estado 2: Circulando ao redor do player (movimento aleatório em volta)
e_circling = function() {
	set_sprite(sprite_move);
	
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
	var _ty = ranged ? alvo.y + lengthdir_y(floor(distancia_alvo / 10), angulo_movimento)
					 : alvo.y + lengthdir_y(distancia_alvo, angulo_movimento);
	
	// Clamp para ficar dentro do mapa
	_tx = clamp(_tx, 40, room_width - 40);
	_ty = clamp(_ty, sprite_height/2 + 20, room_height - 40);
	
	mover_para(_tx, _ty, vel_movimento);
	image_xscale = (alvo.x < x) ? 1 : -1;
	
	// Decrementa timer de ataque
	timer_ataque--;
	if (timer_ataque <= 0) {
		estado = estado_ofensivo;
	}
}

// Estado 2.5: Aproximação rápida antes do ataque (com token check)
e_approach = function() {
	set_sprite(sprite_move);
	
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
		estado = estado_ataque;
	}
}



// Estado 3: Atacando (combo de 2-3 socos)
e_attack = function() {
	velh = 0; velv = 0;
	set_sprite(sprite_punch);
	
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
				audio_play_sound(parry_sfx, 1, false);
				alvo.image_blend = make_colour_rgb(255, 220, 50);
				alvo.parry_flash_timer = 8;
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
			}
		}
		combo_count++;
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

// Variação Estado 3: Ataque à distância
e_shoot = function() {
	velh = 0; velv = 0;
	set_sprite(sprite_shoot)
	
	image_xscale = (alvo.x < x) ? 1 : -1;
	
	alvo = checa_area(area_perseguicao, obj_player);
	if (!alvo || !instance_exists(alvo)) {
		in_combo = false;
		combo_count = 0;
		attack_timer = 0;
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
	
	// dispara em algum frame da animação
	if (!hit_this_swing && image_index >= floor(image_number * 0.5)) {
		hit_this_swing = true;
		
		// modificadores no x e y pra parecer sair da mão => AUTOMATIZAR ISSO DEPOIS
		var projetil = instance_create_layer(x + 5 * image_xscale, y - 10, "Instances", projectile);
		
		// IMPLEMENTAR!!!!!!!
		projetil.dir = -sign(image_xscale);
		projetil.velh = 5;
		projetil.owner = id;
	}
	
	if (image_index > image_number - 1) {
		combo_count++;
		hit_this_swing = false;
		
		// Se fez todos os disparos do combo, volta para recovery
		if (combo_count >= combo_max) {
			in_combo = false;
			combo_count = 0;
			attack_timer = 0;
			timer_recovery = tempo_recovery;
			estado = e_recovery;
		} else {
			// Reinicia animação para próximo hit
			image_index = 0;
			combo_timer = combo_delay;
		}
	}
}

// Estado 4: Recovery - parado por 1 segundo após ataque
e_recovery = function() {
	set_sprite(sprite_idle);
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

// Estado boss: provocar ataque
e_taunt = function(){
	set_sprite(sprite_taunt);
	velh = 0; velv = 0;
	
	alvo = checa_area(area_perseguicao, obj_player);
	if (!alvo || !instance_exists(alvo)) {
		estado = e_search;
		return;
	}
	
	image_xscale = (alvo.x < x) ? 1 : -1;
	
	if (parry_window > 0) {
		parry = true;
		parry_window--;
	}
	else {
		parry = false;
		parry_window = parry_window_max;
		estado = e_dash;
	}
}

// Estado boss: combo de n hits (dava pra só refatorar a função de ataque normal, mas nah)
e_combo = function() {

    velh = 0;
    velv = 0;

    set_sprite(sprite_punch);

    alvo = checa_area(area_perseguicao, obj_player);

    if (!alvo || !instance_exists(alvo)) {
        in_combo = false;
        combo_count = 0;
        attack_timer = 0;

        estado = darksouls? e_rage: e_recovery;
		parry = false;
        return;
    }

    image_xscale = (alvo.x < x) ? 1 : -1;

    attack_timer++;
    if (attack_timer > attack_timeout * 2) {
        in_combo = false;
        combo_count = 0;
        attack_timer = 0;

        timer_recovery = tempo_recovery;
        estado = e_recovery;
		parry = false;
        return;
    }

    // inicia combo
    if (!in_combo) {
        in_combo = true;
        combo_count = 0;
        attack_timer = 0;
    }

    if (!hit_this_swing && image_index >= floor(image_number * 0.5)) {
        hit_this_swing = true;

        var _dist = point_distance(x, y, alvo.x, alvo.y);
        if (_dist <= alcance_hit) {
            if (alvo.parry_window > 0) {
				audio_play_sound(parry_sfx, 1, false);
                alvo.image_blend = make_colour_rgb(255,220,50);
				alvo.parry_flash_timer = 8;
                alvo.invincivel_timer = alvo.invincivel_max;

                stun_ativo = true;
                timer_stun = alvo.parry_stun_max;

                hit_this_swing = false;
                in_combo = false;
                combo_count = 0;
                attack_timer = 0;

                timer_recovery = tempo_recovery;
                estado = e_recovery;
				parry = false;
                return;
            }

            var dano = alvo.defendendo ? dano_ataque * 0.5 : dano_ataque;
            alvo.vida -= dano;
            alvo.invincivel_timer = alvo.invincivel_max * 0.4;
            alvo.dano_flash_timer = alvo.dano_flash_max;

            if (alvo.vida < 0)
                alvo.vida = 0; 
        }
		combo_count++;
    }

    // fim da animação
    if (image_index > image_number - 1) {
        hit_this_swing = false;
		
        if (combo_count >= combo_max) {
            in_combo = false;
			parry = false;
            combo_count = 0;
            attack_timer = 0;
            timer_recovery = tempo_recovery;
            estado = darksouls? e_rage: e_recovery;
			image_speed = 0.6;
        } else {
            image_index = 0;
            combo_timer = combo_delay;
        }
    }
}

// Estado Boss: dash rapidão até o player
e_dash = function() {
    set_sprite(sprite_move);

    alvo = checa_area(area_perseguicao, obj_player);
    if (!alvo || !instance_exists(alvo)) {
        estado = darksouls? e_rage: e_search;
        return;
    }

    image_xscale = (alvo.x < x) ? 1 : -1;
	
	if (!in_combo) {
        in_combo = true;
		
		dash_x = alvo.x;
		dash_y = alvo.y;
    }
	
	// DAR ALGUM AVISO, TIPO UMA PISCADA NA TELA OU UMA ANIMAÇÃO DIFERENTE 

    // Dash muito rápido
    mover_para(dash_x, dash_y, vel_movimento * 5);

    var _dist = point_distance(x, y, alvo.x, alvo.y);

    if (_dist <= alcance_hit) {
        attack_timer = 0;
        in_combo = false;
        combo_count = 0;
		combo_max = 1;
        estado = e_combo;
		image_speed = 1.5;
    }
}

// Estado Boss: frenesi de ataques inspirados em ornstein e smough
e_rage = function() {
	set_sprite(sprite_idle);
	darksouls = true;
	action_timer--;
	
	if (action_timer <= 0) {
		action_timer = action_timer_max;
		if (actions > 0) {
			actions--;
			in_combo = false;
			estado = choose(e_dash, e_smash, e_flank);
			return;
		}
	}
	
	if (actions == 0) {
		in_combo = false;
        combo_count = 0;
        attack_timer = 0;
        timer_recovery = tempo_recovery;
        estado = e_recovery;
		darksouls = false;
		image_speed = 0.6;
	}
}

// Estado Boss: ataque Smough-like (um pulão, basicamente)
e_smash = function() {
    set_sprite(sprite_pulo);
	
    alvo = checa_area(area_perseguicao, obj_player);
    if (!alvo || !instance_exists(alvo)) {
        jump_started = false;
        estado = e_rage;
        return;
    }

    image_xscale = (alvo.x < x) ? 1 : -1;
	
	if (!in_combo) {
        in_combo = true;
    }

    if (!jump_started) {
        jump_started = true;
        velh = 0;
        velv = 0;
        velz = -vel_pulo;

        var ang = point_direction(alvo.x, alvo.y, x, y);
		destino_x = alvo.x + lengthdir_x(random_range(20,50), ang);
		destino_y = alvo.y + lengthdir_y(random_range(20,50), ang);
    }

    // Movimento horizontal durante o salto
    mover_para(destino_x, destino_y, vel_movimento * 2.5);
    z += velz;
    velz += grav;

    if (z >= 0) {
		audio_play_sound(ground_impact, 1, false);
        z = 0;
        velz = 0;
        jump_started = false;

        var alcance = 60;
        var dist = point_distance(x, y, alvo.x, alvo.y);
        if (dist <= alcance) {
            alvo.vida -= dano_ataque;
            alvo.invincivel_timer = alvo.invincivel_max * 0.4;
            alvo.dano_flash_timer = alvo.dano_flash_max;

            if (alvo.vida < 0) alvo.vida = 0;

            // Pequeno empurrão
            var ang = point_direction(x, y, alvo.x, alvo.y);

            alvo.x += lengthdir_x(20, ang);
            alvo.y += lengthdir_y(20, ang);
        }

        estado = e_rage;
    }
}

e_flank = function() {
	set_sprite(sprite_move);
	
	alvo = checa_area(area_perseguicao, obj_player);
    if (!alvo || !instance_exists(alvo)) {
        jump_started = false;
        estado = e_rage;
        return;
    }

    image_xscale = (alvo.x < x) ? 1 : -1;
	if (!in_combo) {
        in_combo = true;
		n_dash = irandom(5);
        novo_destino = true;
    }
	
	if (novo_destino) {
        novo_destino = false;
		timer_dash = timer_dash_max;
		
        var ang;
        do {
            ang = irandom(7) * 45;
        } until (ang != ultimo_angulo);

        ultimo_angulo = ang;
		
        var dist = 50;
        destino_x = alvo.x + lengthdir_x(dist, ang);
        destino_y = alvo.y + lengthdir_y(dist, ang);
		destino_x = clamp(destino_x,40,room_width-40);
		destino_y = clamp(destino_y,40,room_height-40);
    }
	
	mover_para(destino_x, destino_y, vel_movimento * 3);
	
	 if (point_distance(x, y, destino_x, destino_y) < 15) {
		timer_dash--;
        n_dash--;
		
		if (timer_dash <= 0) {
	        if (n_dash <= 0) {
				in_combo = false;
	            estado = e_dash;
	        } else {
	            novo_destino = true;
	        }
		}
    }
}

estado_morte = function() {
	set_sprite(sprite_morte);
	
	if (image_index >= image_number - 1) {
		instance_destroy();
		exit;
	}
}

estado = e_search;

// estados genéricos de ataque
estado_ofensivo = e_approach;
estado_ataque   = e_attack;