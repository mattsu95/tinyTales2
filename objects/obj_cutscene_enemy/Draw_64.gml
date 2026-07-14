if (draw_flash) {
    // Desenha um retângulo branco cobrindo toda a resolução da interface de tela
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
}