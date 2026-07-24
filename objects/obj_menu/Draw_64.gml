

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);


// colocar outra fonte depois!
draw_set_font(Font1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);


var menu_len = array_length(menu_opt);
var espacamento = 60;
extra = 0;
for (var i = 0; i < menu_len; i++) {
	draw_set_color(c_white);
	var _wgui = display_get_gui_width();
	var _hgui = display_get_gui_height();
	
	
	var ty = _hgui / 2 + espacamento * i + extra;

	var _hstr = string_height("I");
	var _wstr = string_width(menu_opt[i]);
	
	var x1 = _wgui / 2 - _wstr / 2;
	var y1 = ty - _hstr / 2 ;
	var x2 = _wgui / 2 + _wstr / 2;
	var y2 = ty + _hstr / 2;
	
	var texto = menu_opt[i];
	if (menu_opt[i] == "Volume") {
		texto = "Volume: " + string(round(global.volume * 100)) + "%";
	}

	
	if (point_in_rectangle(_mx, _my, x1, y1, x2, y2) && menu_opt[i] != "Volume") {
		escala[i] = lerp(escala[i], 1.4, 0.15);
		
		if (device_mouse_check_button_pressed(0, mb_left)) {
			switch (menu_opt[i]) {
				case menu_opt[0]: // continuar
					if (variable_global_exists("checkpoint_room")) {
						room_goto(global.checkpoint_room);
					} else {
						room_goto(Floresta);
					}
					break;
				case menu_opt[1]: // jogar
					room_goto(Floresta);
					break;
				case menu_opt[2]: // opções
					break;
				case menu_opt[3]: // sair
					game_end();
					break;
			}
		}
	}
	else {
		escala[i] = lerp(escala[i], 1, 0.15);
	}
	
	draw_text_transformed(_wgui / 2, ty, texto, escala[i], escala[i], 0);
	
	if (menu_opt[i] == "Volume") {
	    var s = escala[i];
		extra += 30;

	    // Centro do texto
	    var tx = _wgui / 2;

	    // Barra
	    var barra_w = 120;
	    var barra_h = 16;

	    // Posição da barra (centralizada e abaixo do texto)
	    var barra_x = tx - barra_w / 2;
	    var barra_y = ty + (_hstr * s) / 2 + 8;

	    // Fundo
	    draw_set_color(c_dkgray);
	    draw_rectangle(
	        barra_x,
	        barra_y,
	        barra_x + barra_w,
	        barra_y + barra_h,
	        false
	    );

	    // Parte preenchida
	    draw_set_color(c_white);
	    draw_rectangle(
	        barra_x,
	        barra_y,
	        barra_x + barra_w * global.volume,
	        barra_y + barra_h,
	        false
	    );

	    // Bolinha
	    draw_set_color(c_yellow);
	    draw_circle(
	        barra_x + barra_w * global.volume,
	        barra_y + barra_h / 2,
	        10,
	        false
	    );

	    // Arrastar com o mouse
	    if (point_in_rectangle(
	        _mx, _my,
	        barra_x, barra_y,
	        barra_x + barra_w,
	        barra_y + barra_h))
	    {
	        if (device_mouse_check_button(0, mb_left))
	        {
	            global.volume = clamp((_mx - barra_x) / barra_w, 0, 1);
	            audio_master_gain(global.volume);
	        }
	    }
	}
}


draw_set_halign(-1);
draw_set_valign(-1);
draw_set_font(-1);
