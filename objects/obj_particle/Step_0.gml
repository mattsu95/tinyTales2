life--;

z += velz;

image_alpha = life / game_get_speed(gamespeed_fps);

if (life <= 0)
    instance_destroy();