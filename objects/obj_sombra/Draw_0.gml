// desenhando sombra
with (obj_entity) {
	var _escala = z * 0.003;
	draw_sprite_ext(spr_sombra, 0, x, y, 0.5 + _escala, 0.5 + _escala, 0, c_black, 0.4);
}