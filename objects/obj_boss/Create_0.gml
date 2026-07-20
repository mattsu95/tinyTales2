// Inherit the parent event
event_inherited();


mvSet = [];

dado = instance_create_layer(x, y - 25, "Instances", obj_d6);
dado.owner = id;

image_speed = 0.7;
image_xscale = 0.5;
image_yscale = 0.5;
sprite_index = spr_enemy_idle;


mvSet_melee = function() {
	dado.image_index = 0;
	estado();
}

mvSet_range = function() {}

mvSet_parry = function() {}

mvSet_darksouls = function() {}

mvSet_dash = function() {}

mvSet_cake = function() {}

// move set atual
mvSet = [mvSet_melee, mvSet_range, mvSet_parry, mvSet_darksouls, mvSet_dash, mvSet_cake];
move_set = mvSet[0];