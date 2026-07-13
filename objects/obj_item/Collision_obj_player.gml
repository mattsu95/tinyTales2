array_push(other.inventario, {
    nome: nome_item,
    sprite: spr_pocao
});

show_debug_message("Item coletado: " + nome_item);

instance_destroy();