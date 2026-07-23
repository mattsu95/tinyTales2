x += velh * dir;
image_angle += dir * velang;

if (abs(owner.x - x) > 500) {
	instance_destroy();
}