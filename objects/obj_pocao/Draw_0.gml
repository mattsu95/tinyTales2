if (apply) {
	draw_set_alpha(0.05);
	draw_set_color(c_ltgrey);

	draw_circle(x, y, raio, false);

	draw_set_alpha(1);
	draw_set_color(c_white);
} else {
	draw_sprite_ext(sprite_index, image_index, x, y + z, image_xscale / 4,
				image_yscale / 4, image_angle, image_blend, image_alpha);
}