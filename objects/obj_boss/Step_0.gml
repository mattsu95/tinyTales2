// Se a cutscene inicial de Corbélia estiver rodando, o Boss Vinícius aguarda parado em idle
if (instance_exists(obj_cutscene_corbelia) && obj_cutscene_corbelia.etapa < 4) {
    sprite_index = sprite_idle;
    velh = 0;
    velv = 0;
    if (instance_exists(obj_player)) {
        image_xscale = (x > obj_player.x) ? 1 : -1;
    }
    exit;
}

move_set();

// só usa velh para virar quando não há alvo definido
if (alvo == noone && velh != 0) {
	image_xscale = -sign(velh);
}

// decrementa o cronometro de rolagem de dado
if (roll_timer > 0) {
	roll_timer--;
}

// garante que nunca clipa para fora
var _margem_x = 20;
var _margem_y = 20;
x = clamp(x, _margem_x, room_width - _margem_x);
y = clamp(y, _margem_y, room_height - _margem_y);