array_push(other.inventario, {
    nome: nome_item,
    sprite: spr_pocao,
	objeto: obj_pocao,
	efeito: efeito_item
});

show_debug_message("Item coletado: " + nome_item);

instance_destroy();