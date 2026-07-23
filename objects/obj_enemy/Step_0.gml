if (!variable_instance_exists(id, "estado")) {
    show_message("estado NÃO existe!");
}
var _estado = estado;
_estado();

// só usa velh para virar quando não há alvo definido
if (alvo == noone && velh != 0) {
	image_xscale = -sign(velh);
}

// garante que nunca clipa para fora
var _margem_x = 20;
var _margem_y = 20;
x = clamp(x, _margem_x, room_width - _margem_x);
y = clamp(y, _margem_y, room_height - _margem_y);