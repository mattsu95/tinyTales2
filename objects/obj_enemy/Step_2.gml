// alterando a profundidade
depth = -bbox_bottom;

if (cooldown_dano > 0) {
	cooldown_dano--;
}

if (imunidade_stun > 0) {
	imunidade_stun--;
}

var _player = instance_nearest(x, y, obj_player);

if (_player != noone) {
	var _ataque_ativo = (_player.sprite_index == spr_player_punch1 || _player.sprite_index == spr_player_punch2);
	var _distancia = point_distance(x, y, _player.x, _player.y);
    var _novo_ataque = (_player.attack_sequence_id != ultimo_attack_id_recebido);
    
	if (_ataque_ativo && _distancia <= alcance_hit && cooldown_dano <= 0 && _novo_ataque) {
		vida -= dano_por_hit;
		cooldown_dano = cooldown_dano_max;
        ultimo_attack_id_recebido = _player.attack_sequence_id;
        foi_atingido = true;

        // pisca vermelho em todo hit, independente de stun
        image_blend = merge_colour(c_white, c_red, 0.85);
        flash_timer = 8; // frames que fica vermelho antes de voltar ao normal

        // só stuna se não estiver em imunidade, stun já não estiver ativo
        // e NÃO estiver atacando
        var _hyper_armor = (estado == e_attack);
        if (!stun_ativo && imunidade_stun <= 0 && !_hyper_armor) {
            stun_ativo = true;
            timer_stun = timer_stun_max;
        }
		
		if (vida <= 0) {
			instance_destroy();
			exit;
		}
	}
}

// --- FLASH DE HIT (roda sempre, independente de stun) ---
if (flash_timer > 0) {
    flash_timer--;
    if (flash_timer <= 0 && !stun_ativo) {
        image_blend = c_white;
    }
}

// --- STUN ---
if (stun_ativo) {
    sprite_index = spr_enemy_idle;
    velh = 0;
    velv = 0;

    if (flash_timer mod 4 < 2) {
        image_blend = merge_colour(c_white, c_red, 0.7);
    } else {
        image_blend = c_white;
    }

    timer_stun--;
    if (timer_stun <= 0) {
        stun_ativo     = false;
        image_blend    = c_white;
        imunidade_stun = imunidade_stun_max;
        angulo_movimento = irandom(359);
        timer_ataque = cooldown_ataque_principal;
        estado = e_circling;
    }
}

// SEPARAÇÃO ENTRE INIMIGOS
var _sep_raio = 34;
with (obj_enemy) {
	if (id != other.id) {
		var _dx = x - other.x;
		var _dy = y - other.y;
		var _d  = sqrt(_dx * _dx + _dy * _dy);

		if (_d < _sep_raio) {
			// usa direção aleatória se sobrepostos exatos para evitar travar
			if (_d < 0.5) {
				_dx = lengthdir_x(1, irandom(359));
				_dy = lengthdir_y(1, irandom(359));
				_d  = 1;
			}
			var _forca = (_sep_raio - _d) / _sep_raio * 0.6; // reduzido de 1.2 para 0.6
			// cada inimigo empurra a SI MESMO para longe do outro
			x += (_dx / _d) * _forca;
			y += (_dy / _d) * _forca;
		}
	}
}

// MOVIMENTAÇÃO (SEM CLAMP ANTES - deixa fazer o movimento naturalmente)
var _margem_x = 20;
var _margem_y = 20;
move_and_collide(velh, velv, obj_colisao);

// Clamp final APENAS após movimento para garantir segurança
x = clamp(x, _margem_x, room_width - _margem_x);
y = clamp(y, _margem_y, room_height - _margem_y);