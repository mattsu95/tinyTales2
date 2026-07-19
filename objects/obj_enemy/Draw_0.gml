draw_self();

// --- BARRA DE VIDA (só aparece após levar o 1º hit) ---
if (foi_atingido) {
    var _barra_w = 24;
    var _barra_h = 3;
    var _barra_x = x - _barra_w / 2;
    var _barra_y = y - sprite_height + sprite_yoffset - 4;

    var _proporcao = vida / vida_max;

    draw_set_color(c_dkgray);
    draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_w, _barra_y + _barra_h, false);

    var _cor = merge_colour(c_red, c_lime, _proporcao);
    draw_set_color(_cor);
    draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_w * _proporcao, _barra_y + _barra_h, false);

    draw_set_color(c_black);
    draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_w, _barra_y + _barra_h, true);

    draw_set_color(c_white);
}