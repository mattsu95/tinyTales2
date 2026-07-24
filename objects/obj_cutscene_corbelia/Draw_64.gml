var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// 1. Fade preto durante a transição (Etapa 9)
if (etapa == 9 && alpha_preto > 0) {
    draw_set_color(c_black);
    draw_set_alpha(alpha_preto);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);
}

// 2. Tela de Encerramento e Vitória (Etapa 10)
if (etapa == 10) {
    // Fundo do Menu (spr_fundo_menu)
    if (sprite_exists(spr_fundo_menu)) {
        draw_sprite_stretched(spr_fundo_menu, 0, 0, 0, _gw, _gh);
    }
    
    // Overlay escuro transparente para dar legibilidade às letras
    draw_set_color(c_black);
    draw_set_alpha(0.65);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);
    
    // Configuração da Fonte da Room Menu (Font1)
    if (font_exists(Font1)) {
        draw_set_font(Font1);
    } else if (font_exists(fnt_dialogo)) {
        draw_set_font(fnt_dialogo);
    }
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Mensagem de vitória (escala ajustada para tamanho ideal)
    var _texto_vitoria = "Você derrotou o Vinícius e recuperou seu carro,\nmas a história continua...";
    var _scale_msg = 0.28;
    
    // Sombra do texto
    draw_set_color(c_black);
    draw_text_transformed(_gw / 2 + 1, _gh / 2 - 44, _texto_vitoria, _scale_msg, _scale_msg, 0);
    // Texto principal em amarelo
    draw_set_color(c_yellow);
    draw_text_transformed(_gw / 2, _gh / 2 - 45, _texto_vitoria, _scale_msg, _scale_msg, 0);
    
    // Desenho do Botão "Voltar para o Menu" (tamanho proporcional e compacto)
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    
    var _texto_btn = "Voltar para o Menu";
    var _scale_base = 0.32;
    var _wstr = string_width(_texto_btn) * _scale_base;
    var _hstr = string_height("I") * _scale_base;
    
    var ty = _gh / 2 + 35;
    var x1 = _gw / 2 - _wstr / 2 - 12;
    var y1 = ty - _hstr / 2 - 5;
    var x2 = _gw / 2 + _wstr / 2 + 12;
    var y2 = ty + _hstr / 2 + 5;
    
    var _hover = point_in_rectangle(_mx, _my, x1, y1, x2, y2);
    
    // Animação suave de escala no hover (0.32 normal, 0.40 hover)
    var _scale_btn = _hover ? 0.40 : 0.32;
    
    // Fundo do botão com destaque ao passar o mouse
    draw_set_color(_hover ? c_yellow : c_white);
    draw_set_alpha(_hover ? 0.35 : 0.15);
    draw_roundrect(x1, y1, x2, y2, false);
    draw_set_alpha(1);
    
    // Borda do botão
    draw_set_color(_hover ? c_yellow : c_white);
    draw_roundrect(x1, y1, x2, y2, true);
    
    // Texto do botão
    draw_set_color(_hover ? c_yellow : c_white);
    draw_text_transformed(_gw / 2, ty, _texto_btn, _scale_btn, _scale_btn, 0);
    
    // Reseta configurações de desenho
    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}
