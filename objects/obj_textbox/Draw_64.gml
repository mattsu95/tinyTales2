if (array_length(falas) == 0) exit;

var _fala = falas[pagina_atual];
var _texto_para_desenhar = string_copy(_fala.texto, 1, floor(caractere_atual));

// Coordenadas baseadas na GUI de 490x270
var _gui_w = 490;

var _escala_fonte = 0.75;
draw_set_font(fnt_dialogo);

// Verifica se tem nome do personagem
var _tem_nome = struct_exists(_fala, "nome") && (_fala.nome != "");
var _nome = _tem_nome ? _fala.nome : "";

// Largura do texto
var _largura_do_texto = string_width(_fala.texto) * _escala_fonte;
var _largura_maxima_balao = 310; 
var _largura_caixa = clamp(_largura_do_texto + 28, 140, _largura_maxima_balao);
var _altura_caixa = 46;   

var _caixa_x = (_gui_w - _largura_caixa) / 2; 
var _caixa_y = 14;                            

// Cores temáticas do balão
var _cor_fundo  = make_colour_rgb(12, 14, 22);  // Escuro estilo pixel art arcade
var _cor_borda  = make_colour_rgb(255, 200, 50); // Dourado metálico
var _cor_borda_sec = make_colour_rgb(60, 65, 85); // Sombra interna

// Cor da Placa de Nome dependendo de quem fala
var _cor_nome_fundo = make_colour_rgb(30, 35, 50);
var _cor_nome_borda = make_colour_rgb(255, 200, 50);
if (_nome == "Rizzi") {
    _cor_nome_borda = make_colour_rgb(255, 90, 60); // Laranja/Vermelho
} else if (_nome == "Professor") {
    _cor_nome_borda = make_colour_rgb(180, 80, 255); // Roxo
} else if (_nome == "Tini") {
    _cor_nome_borda = make_colour_rgb(50, 220, 100); // Verde Esmeralda
}

// 1. SOMBRA PROJETADA DO BALÃO (Efeito de profundidade)
draw_set_color(c_black);
draw_set_alpha(0.4);
draw_rectangle(_caixa_x + 3, _caixa_y + 3, _caixa_x + _largura_caixa + 3, _caixa_y + _altura_caixa + 3, false);

// 2. FUNDO DO BALÃO DE DIÁLOGO
draw_set_color(_cor_fundo);
draw_set_alpha(0.92);
draw_rectangle(_caixa_x, _caixa_y, _caixa_x + _largura_caixa, _caixa_y + _altura_caixa, false);

// 3. BORDAS DUPLAS ESTILO RETRO/ARCADE
draw_set_color(_cor_borda_sec);
draw_set_alpha(1);
draw_rectangle(_caixa_x - 1, _caixa_y - 1, _caixa_x + _largura_caixa + 1, _caixa_y + _altura_caixa + 1, true);

draw_set_color(_cor_borda);
draw_rectangle(_caixa_x, _caixa_y, _caixa_x + _largura_caixa, _caixa_y + _altura_caixa, true);

// 4. DESENHA A PLACA DO NOME DO PERSONAGEM (se houver)
if (_tem_nome) {
    var _largura_nome = (string_width(_nome) * 0.65) + 16;
    var _altura_nome  = 16;
    var _nome_x = _caixa_x + 6;
    var _nome_y = _caixa_y - 11;
    
    // Fundo da plaquinha de nome
    draw_set_color(_cor_nome_fundo);
    draw_set_alpha(0.95);
    draw_rectangle(_nome_x, _nome_y, _nome_x + _largura_nome, _nome_y + _altura_nome, false);
    
    // Borda da plaquinha de nome
    draw_set_color(_cor_nome_borda);
    draw_set_alpha(1);
    draw_rectangle(_nome_x, _nome_y, _nome_x + _largura_nome, _nome_y + _altura_nome, true);
    
    // Texto do Nome
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text_transformed(_nome_x + (_largura_nome / 2), _nome_y + (_altura_nome / 2), _nome, 0.65, 0.65, 0);
}

// 5. TEXTO DO DIÁLOGO CENTRALIZADO
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_set_alpha(1);

var _centro_x = _caixa_x + (_largura_caixa / 2);
var _centro_y = _caixa_y + (_altura_caixa / 2) + (_tem_nome ? 2 : 0);
var _largura_limite_texto = (_largura_caixa - 18) / _escala_fonte;

draw_text_ext_transformed(
    _centro_x, 
    _centro_y, 
    _texto_para_desenhar, 
    14, 
    _largura_limite_texto, 
    _escala_fonte, 
    _escala_fonte, 
    0
);

// Reset de alinhamentos
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
draw_set_alpha(1);