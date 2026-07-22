if (apply) {
	gen_particle();
} else {
	show_potion();
}

if (timer_apply > 0) {
	timer_apply--;
}

if (apply && timer_apply <= 0) {
	timer_apply = timer_apply_max;
	apply_effect();
}

duracao--;

if (duracao <= 0) {
    instance_destroy();
}