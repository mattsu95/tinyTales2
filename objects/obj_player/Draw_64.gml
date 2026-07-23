// --- HUD DE VIDA ESTILO ARCADE ---
var _margem_x = 10;
var _margem_y = 10;
var _largura_barra = 120;
var _altura_barra = 16;

// Calcula a vida em percentual
var _vida_perc = vida / vida_max;

// Define a cor baseado na vida (verde → amarelo → vermelho)
var _cor_vida;
if (_vida_perc > 0.6) {
    _cor_vida = make_colour_rgb(50, 255, 50); // Verde
} else if (_vida_perc > 0.3) {
    _cor_vida = make_colour_rgb(255, 255, 50); // Amarelo
} else {
    _cor_vida = make_colour_rgb(255, 50, 50); // Vermelho
}

// Efeito de vibração quando toma dano
var _offset_x = 0;
var _offset_y = 0;
if (dano_flash_timer > 0) {
    _offset_x = irandom_range(-2, 2);
    _offset_y = irandom_range(-1, 1);
}

// Fundo preto da barra
draw_set_color(c_black);
draw_set_alpha(0.8);
draw_rectangle(_margem_x + _offset_x, _margem_y + _offset_y, _margem_x + _largura_barra + _offset_x, _margem_y + _altura_barra + _offset_y, false);

// Borda muda de cor quando toma dano
var _cor_borda;
if (dano_flash_timer > 0 && dano_flash_timer mod 2 == 0) {
    _cor_borda = make_colour_rgb(255, 50, 50); // Vermelho
} else {
    _cor_borda = make_colour_rgb(255, 200, 0); // Amarelo/laranja
}

draw_set_color(_cor_borda);
draw_set_alpha(1);
draw_rectangle(_margem_x + _offset_x, _margem_y + _offset_y, _margem_x + _largura_barra + _offset_x, _margem_y + _altura_barra + _offset_y, true);
draw_rectangle(_margem_x - 1 + _offset_x, _margem_y - 1 + _offset_y, _margem_x + _largura_barra + 1 + _offset_x, _margem_y + _altura_barra + 1 + _offset_y, true);

// Barra de vida (com preenchimento)
var _vida_width = _largura_barra * _vida_perc - 2;
draw_set_color(_cor_vida);
draw_set_alpha(0.9);
draw_rectangle(_margem_x + 2 + _offset_x, _margem_y + 2 + _offset_y, _margem_x + 2 + _vida_width - 2 + _offset_x, _margem_y + _altura_barra - 2 + _offset_y, false);

// Efeito de brilho na barra (scanlines arcade)
draw_set_color(c_white);
draw_set_alpha(0.3);
for (var _i = 0; _i < _altura_barra; _i += 2) {
    draw_line(_margem_x + 2 + _offset_x, _margem_y + 2 + _offset_y + _i, _margem_x + 2 + _vida_width - 2 + _offset_x, _margem_y + 2 + _offset_y + _i);
}

// Texto com HP (pisca quando toma dano)
if (dano_flash_timer > 0 && dano_flash_timer mod 2 == 1) {
    draw_set_alpha(0.5);
}

draw_set_color(c_white);
draw_set_alpha(1);
draw_set_font(fnt_dialogo);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(_margem_x + _largura_barra / 2 + _offset_x, _margem_y + _altura_barra / 2 + _offset_y, string(ceil(vida)) + "/" + string(vida_max), 0.65, 0.65, 0);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
draw_set_alpha(1);

// --- GAME OVER ---
if (game_over) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    // fundo escuro semi-transparente
    draw_set_alpha(0.7);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);

    // sprite Gameover esticado para preencher a tela toda
    var _sw = sprite_get_width(Gameover);
    var _sh = sprite_get_height(Gameover);
    var _escala_x = _gw / _sw;
    var _escala_y = _gh / _sh;
    draw_sprite_ext(Gameover, 0, 0, 0, _escala_x, _escala_y, 0, c_white, 1);

    // instrucao de reinicio centralizada na tela
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(_gw / 2, _gh * 0.85, "Pressione ENTER ou ESPAÇO para reiniciar");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    exit;
}

// --- TELA DE MORTE PELOS DOGS ---
if (pego_pelos_dogs) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    // 1. Fundo 100% preto
    draw_set_color(c_black);
    draw_set_alpha(1.0);
    draw_rectangle(0, 0, _gw, _gh, false);

    // 2. Sprite do cachorro no fundo da tela (ampliado no centro)
    if (sprite_exists(spr_dog1_idle)) {
        var _subimg = (current_time / 180) mod sprite_get_number(spr_dog1_idle);
        draw_sprite_ext(spr_dog1_idle, _subimg, _gw / 2, _gh / 2 - 25, 4.0, 4.0, 0, c_white, 0.75);
    }

    // 3. Frase centralizada
    draw_set_font(fnt_dialogo);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Sombra do texto
    draw_set_color(c_red);
    draw_text_transformed(_gw / 2 + 2, _gh / 2 + 55, "Você foi pego pelos dogs!", 1.25, 1.25, 0);
    
    // Texto principal
    draw_set_color(c_white);
    draw_text_transformed(_gw / 2, _gh / 2 + 53, "Você foi pego pelos dogs!", 1.25, 1.25, 0);
    
    // Reseta configurações de desenho
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
    draw_set_alpha(1.0);
    exit;
}

// Centro da tela
var centro_x = display_get_gui_width() / 2;
var centro_y = display_get_gui_height() / 2;

// Distância dos itens do centro
var raio = 120;


if (mostrar_inventario)
{
    var total = array_length(inventario);

    // Fundo escurecido sempre que o inventário estiver aberto.
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
    draw_set_color(c_white);

    if (total > 0)
    {
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

			if (inventario[i]) {
	            draw_sprite(
	                inventario[i].sprite,
	                0,
	                px,
	                py
	            );
			}
        }
    }
    else
    {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(centro_x, centro_y, "Inventario vazio");
        draw_text(centro_x, centro_y + 24, "Colete itens para preencher");
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
}