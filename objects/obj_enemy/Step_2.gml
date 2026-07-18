// alterando a profundidade
depth = -bbox_bottom;

if (cooldown_dano > 0) {
	cooldown_dano--;
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
        
		if (vida <= 0) {
			instance_destroy();
			exit;
		}
	}
}

// MOVIMENTAÇÃO

move_and_collide(velh, velv, obj_colisao);