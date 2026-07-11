//draw_self();

var _escala = z * 0.003;

// desenhando sombra
draw_sprite_ext(spr_sombra, 0, x, y, 0.5 + _escala, 0.5 + _escala, 0, c_black, 0.4);

// desenhando o player com o eixo z
draw_sprite_ext(sprite_index, image_index, x, y + z, image_xscale,
				image_yscale, image_angle, image_blend, image_alpha);