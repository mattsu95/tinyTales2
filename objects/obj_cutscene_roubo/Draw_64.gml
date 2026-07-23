if (mostra_prompt) {
    var _gw = display_get_gui_width();
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    
    var _texto = "CORRA ATRÁS DO SEU CARRO!";
    var _xx = _gw / 2;
    var _yy = 50;
    
    // Contorno preto para destaque
    draw_set_color(c_black);
    draw_text(_xx - 2, _yy, _texto);
    draw_text(_xx + 2, _yy, _texto);
    draw_text(_xx, _yy - 2, _texto);
    draw_text(_xx, _yy + 2, _texto);
    
    // Texto em vermelho/amarelo destacado
    draw_set_color(c_yellow);
    draw_text(_xx, _yy, _texto);
    
    // Reseta configurações de desenho
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}
