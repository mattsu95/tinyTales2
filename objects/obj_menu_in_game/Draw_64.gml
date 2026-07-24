if (desenhar) {
	if (!variable_global_exists("in_menu") || global.in_menu != true ) {
	    global.in_menu = true;
	}
	var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();

    var cx = gui_w / 2;
    var cy = gui_h / 2;

    var largura = 200;
    var altura = 100;

    draw_set_alpha(0.8);
    draw_set_color(c_black);
    draw_rectangle(
        cx - largura/2,
        cy - altura/2,
        cx + largura/2,
        cy + altura/2,
        false
    );
	
	

	var _mx = device_mouse_x_to_gui(0);
	var _my = device_mouse_y_to_gui(0);


	// colocar outra fonte depois!
	draw_set_font(Font1);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);


	draw_set_alpha(1);
    draw_set_color(c_white);
	var menu_len = array_length(menu_opt);
	for (var i = 0; i < menu_len; i++) {
		draw_set_color(c_white);
		
		var espacamento = 28;
		var tx = cx;
		var ty = cy - ((menu_len - 1) * espacamento) / 2 + i * espacamento;

		var s = 0.35 * escala[i];

		var _wstr = string_width(menu_opt[i]) * s;
		var _hstr = string_height("I") * s;

		var x1 = tx - _wstr / 2;
		var y1 = ty - _hstr / 2;
		var x2 = tx + _wstr / 2;
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
						desenhar = false;
						break;
					case menu_opt[1]: // opções
						show_message("você é bagre!");
						break;
					case menu_opt[2]: // sair
						desenhar = false;
						room_goto(Menu)
						break;
				}
			}
		}
		else {
			escala[i] = lerp(escala[i], 1, 0.15);
		}
	
		draw_text_transformed(tx, ty, texto, s, s, 0);
		
		if (menu_opt[i] == "Volume") {


	    // Barra
	    var barra_w = 120;
	    var barra_h = 4;

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
	        5,
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
} else {
	global.in_menu = false;
}