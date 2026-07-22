array_push(other.inventario, {
    nome: nome_item,
    sprite: sprite_item,
	objeto: objeto_item,
	efeito: efeito_item
});

show_debug_message("Item coletado: " + nome_item);

instance_destroy();