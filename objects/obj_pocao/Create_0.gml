objeto = obj_pocao;

efeito = noone;

grav = 0.2;
z = 0;
velz = 0;

cor_particula = noone;
apply = false

raio = 50;

duracao = game_get_speed(gamespeed_fps) * 10;
timer_apply_max = game_get_speed(gamespeed_fps) * 2; // tempo pra cada aplicação de efeito
timer_apply = 0;

init = function() {
	switch (efeito) {
		case "cura":
			sprite_index = spr_pocao;
			cor_particula = c_fuchsia;
			break;
		case "dano":
			sprite_index = spr_pocao_dano;
			cor_particula = c_black;
			break;
	}
	velz = -3;
}

// poção aparecendo
show_potion = function() {
	z += velz;
	
	if (z < 0) {
		velz += grav;
	} else {
		audio_play_sound(bottle_crashing, 1, false);
		apply = true;
	}
}

//cria particulas
gen_particle = function() {	
	repeat(2) {
	    var ang = random(360);
	    var dist = random(raio);

	    var px = x + lengthdir_x(dist, ang);
	    var py = y + lengthdir_y(dist, ang);

	    var p = instance_create_layer(px, py, "Instances", obj_particle);
		p.image_blend = cor_particula;
	}
}

// aplica o efeito (cura, dano, etc)
apply_effect = function() {
	var lista = ds_list_create();

	collision_circle_list(x, y, raio, obj_entity, false, true, lista, true);
	
	for(var i = 0; i < ds_list_size(lista); i++) {
	    var ent = lista[| i];

	    switch(efeito) {
	        case "cura":
	            ent.vida += 10;
				if (ent.vida > ent.vida_max) { ent.vida = ent.vida_max; }
	            break;

	        case "dano":
	            ent.vida -= 15;
				if (ent.vida < 0) { ent.vida = 0; }
	            break;
	    }
	}

	ds_list_destroy(lista);
}