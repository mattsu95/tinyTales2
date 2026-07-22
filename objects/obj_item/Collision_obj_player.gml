array_push(other.inventario, {
    nome: nome_item,
    sprite: asset_get_index(sprite_item),
	objeto: asset_get_index(objeto_item),
	efeito: efeito_item
});

show_debug_message("Item coletado: " + nome_item);

instance_destroy();