var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw / 2;
var _cy = _gh / 2;

// 1. Fundo 100% Preto
draw_set_color(c_black);
draw_set_alpha(1.0);
draw_rectangle(0, 0, _gw, _gh, false);

// 2. Efeito de Raios de Sol Rotação ("Frufruzinho" / Sunburst)
var _num_raios = 12;
var _raio_tamanho = max(_gw, _gh) * 1.2;

draw_set_color(make_colour_rgb(255, 215, 0)); // Dourado
draw_set_alpha(0.20 + sin(timer * 0.05) * 0.05); // Pulsar suave de brilho

for (var _i = 0; _i < _num_raios; _i++) {
    var _a1 = angulo_raios + (_i * (360 / _num_raios));
    var _a2 = _a1 + (180 / _num_raios);
    
    var _x1 = _cx + lengthdir_x(_raio_tamanho, _a1);
    var _y1 = _cy + lengthdir_y(_raio_tamanho, _a1);
    var _x2 = _cx + lengthdir_x(_raio_tamanho, _a2);
    var _y2 = _cy + lengthdir_y(_raio_tamanho, _a2);
    
    draw_triangle(_cx, _cy, _x1, _y1, _x2, _y2, false);
}

// 3. Brilho central circular
draw_set_color(c_yellow);
draw_set_alpha(0.25);
draw_circle(_cx, _cy - 10, 80 + sin(timer * 0.1) * 10, false);

// 4. Sprite da Arma (usando sprite tinicleta como fundo da muleta por enquanto)
draw_set_alpha(1.0);
draw_set_color(c_white);

var _sprite_arma = muleta;
if (sprite_exists(_sprite_arma)) {
    var _sw = sprite_get_width(_sprite_arma);
    var _sh = sprite_get_height(_sprite_arma);
    var _xo = sprite_get_xoffset(_sprite_arma);
    var _yo = sprite_get_yoffset(_sprite_arma);
    
    var _scale = 0.45; // Escala ajustada para o tamanho da tinicleta (556x447)
    var _offset_float_y = sin(timer * 0.08) * 8;
    
    draw_sprite_ext(
        _sprite_arma, 0, 
        _cx - (_sw / 2 - _xo) * _scale, 
        _cy - (_sh / 2 - _yo) * _scale + _offset_float_y, 
        _scale, _scale, 0, c_white, 1.0
    );
}

// 5. Textos "Nova arma desbloqueada" e "Muleta"
draw_set_font(fnt_dialogo);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Texto Superior: Nova arma desbloqueada
draw_set_color(c_yellow);
draw_text_transformed(_cx, _cy - 85, "Nova arma desbloqueada", 1.1, 1.1, 0);

// Texto Inferior: Muleta (Sombra + Texto principal)
draw_set_color(c_black);
draw_text_transformed(_cx + 2, _cy + 77, "Muleta", 1.5, 1.5, 0);
draw_set_color(make_colour_rgb(255, 220, 50)); // Amarelo Dourado
draw_text_transformed(_cx, _cy + 75, "Muleta", 1.5, 1.5, 0);

// Reseta padrões de desenho
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
draw_set_alpha(1.0);

global.muleta = true;