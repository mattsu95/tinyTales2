// Centro da tela
var centro_x = display_get_gui_width() / 2;
var centro_y = display_get_gui_height() / 2;

// Distância dos itens do centro
var raio = 120;


if (mostrar_inventario)
{
    var total = array_length(inventario);

    if (total > 0)
    {
        // Fundo escurecido
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
}