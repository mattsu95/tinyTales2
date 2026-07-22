item = noone;
dir = noone;

velv = 0;
velh = 0;
z = 0;
velz = 0;
velang = 0;

grav = 0.2;

roll = function() {
	
	if (sprite_index != spr_dado) {
		sprite_index = spr_dado;
		image_index = 0;
	}

	image_angle -= velang;

	z += velz;
	
	if (z < 0) {
		velz += grav;
	} else {
		velz = 0;
		z = 0;
		
		thr_item = instance_create_layer(x, y, "Instances", item.objeto);
		thr_item.efeito = item.efeito;
		thr_item.init();		
		
		instance_destroy();
	}
}