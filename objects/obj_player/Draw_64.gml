// Centro da tela
var centro_x = display_get_gui_width() / 2;
var centro_y = display_get_gui_height() / 2;

// Distância dos itens do centro
var raio = 120;


if (mostrar_inventario)
{
    var total = array_length(inventario);

    // Fundo escurecido sempre que o inventário estiver aberto.
    draw_set_alpha(0.5);
    draw_set_color(c_black);
    draw_rectangle(
        0,
        0,
        display_get_gui_width(),
        display_get_gui_height(),
        false
    );

    draw_set_alpha(1);
    draw_set_color(c_white);

    if (total > 0)
    {
        // Desenha os itens em círculo
        for (var i = 0; i < total; i++)
        {
            var angulo = i * (360 / total);

            var px = centro_x + lengthdir_x(raio, angulo);
            var py = centro_y + lengthdir_y(raio, angulo);


            // Destaque do item selecionado
            if (i == indice_selecionado)
            {
                draw_set_color(c_yellow);
                draw_circle(px, py, 40, false);
            }


            // Sprite do item
            draw_set_color(c_white);

            draw_sprite(
                inventario[i].sprite,
                0,
                px,
                py
            );
        }
    }
    else
    {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(centro_x, centro_y, "Inventario vazio");
        draw_text(centro_x, centro_y + 24, "Colete itens para preencher");
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
}