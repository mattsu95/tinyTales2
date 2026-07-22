life = game_get_speed(gamespeed_fps);

z = random(6);
velz = -0.05;

image_alpha = 1;
image_blend = c_lime;


image_index = irandom(image_number - 1);
image_angle = irandom(359);
image_xscale = random_range(0.7, 1.3);
image_yscale = image_xscale;