if (array_length(falas) == 0) exit;

var _fala = falas[pagina_atual];
var _texto_para_desenhar = string_copy(_fala.texto, 1, floor(caractere_atual));

// Coordenadas baseadas na GUI pequena de 480x270
var _gui_w = 480;

// --- AJUSTE DA FONTE E TAMANHO DA CAIXA ---
var _escala_fonte = 0.75;
draw_set_font(-1); // Usa a fonte atual do jogo

// Calcula a largura real do texto já escalado em 0.75
var _largura_do_texto = string_width(_fala.texto) * _escala_fonte;

// Se o texto for muito longo, limitamos a largura máxima do balão e permitimos quebra de linha
var _largura_maxima_balao = 280; 
var _largura_caixa = clamp(_largura_do_texto + 24, 100, _largura_maxima_balao);

// Altura perfeita de 42 pixels (cabe 2 linhas com folga sem vazar)
var _altura_caixa = 42;   
var _caixa_x = (_gui_w - _largura_caixa) / 2; // Centraliza perfeitamente na tela
var _caixa_y = 12;                            // Margem do topo

// 1. Desenha o fundo preto minimalista
draw_set_color(c_black);
draw_set_alpha(0.85);
draw_rectangle(_caixa_x, _caixa_y, _caixa_x + _largura_caixa, _caixa_y + _altura_caixa, false);

// Desenha a borda branca fina
draw_set_color(c_white);
draw_set_alpha(1);
draw_rectangle(_caixa_x, _caixa_y, _caixa_x + _largura_caixa, _caixa_y + _altura_caixa, true);

// 2. Configura a fonte para desenhar o texto centralizado dentro do balão
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Calculamos o centro exato da caixa preta para desenhar o texto lá
var _centro_x = _caixa_x + (_largura_caixa / 2);
var _centro_y = _caixa_y + (_altura_caixa / 2);

// 3. Desenha o texto perfeitamente alinhado e centralizado
// Limitamos a largura do texto para quebrar linha se passar da largura da caixa (com margem de 16px)
var _largura_limite_texto = (_largura_caixa - 16) / _escala_fonte;

draw_text_ext_transformed(
    _centro_x, 
    _centro_y, 
    _texto_para_desenhar, 
    14,                    // Espaçamento entre as linhas
    _largura_limite_texto, // Onde o texto deve quebrar linha
    _escala_fonte,         // Escala X
    _escala_fonte,         // Escala Y
    0                      // Sem rotação
);

// Reseta os alinhamentos padrões do GameMaker para não bugar outros textos do jogo!
draw_set_halign(fa_left);
draw_set_valign(fa_top);