var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// 1. DESENHA O AVISO [E] NA TELA
if (pode_entrar) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);
    
    // Desenha centralizado no rodapé
    draw_text(_gw / 2, _gh - 20, "[E] Entrar na UNIOESTE");
    
    // Reseta o alinhamento
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// 2. DESENHA A TELA PRETA (FADE OUT) COBRINDO TUDO
if (alpha_preto > 0) {
    draw_set_alpha(alpha_preto);
    draw_set_color(c_black);
    
    // Desenha um retângulo preto cobrindo a tela toda
    draw_rectangle(0, 0, _gw, _gh, false);
    
    draw_set_alpha(1); // Reseta a transparência padrão
}