if (velh != 0) {
	image_xscale = sign(velh);
}

estado();

if (keyboard_check_pressed(ord("I")))
{
    mostrar_inventario = !mostrar_inventario;
}

if (mostrar_inventario && array_length(inventario) > 0)
{
    if (keyboard_check_pressed(vk_right))
    {
        indice_selecionado++;
    }

    if (keyboard_check_pressed(vk_left))
    {
        indice_selecionado--;
    }


    if (indice_selecionado >= array_length(inventario))
    {
        indice_selecionado = 0;
    }

    if (indice_selecionado < 0)
    {
        indice_selecionado = array_length(inventario)-1;
    }
}