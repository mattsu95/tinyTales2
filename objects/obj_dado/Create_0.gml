item = noone;
dir = noone;

velv = 0;
velh = 0;
z = 0;
velz = 0;

grav = 0.2;

roll = function() {
	
	if (sprite_index != spr_dado) {
		sprite_index = spr_dado;
		image_index = 0;
	}

	z += velz;
	
	if (z < 0) {
		velz += grav;
	} else {
		velz = 0;
		z = 0;
		
		instance_create_layer(x, y, "Instances", item.objeto);
		
		instance_destroy();
	}
}