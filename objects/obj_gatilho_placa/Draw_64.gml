if (ativado && !atendeu) {
    draw_set_halign(fa_center);
    // Aparece no meio da tela avisando o jogador
    draw_text(display_get_gui_width() / 2, display_get_gui_height() - 100, "[E] Atender Celular");
    draw_set_halign(fa_left);
}