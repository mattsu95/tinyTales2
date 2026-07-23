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
		
		var espacamento = 28;
		var tx = cx;
		var ty = cy - ((menu_len - 1) * espacamento) / 2 + i * espacamento;

		var s = 0.5 * escala[i];

		var _wstr = string_width(menu_opt[i]) * s;
		var _hstr = string_height("I") * s;

		var x1 = tx - _wstr / 2;
		var y1 = ty - _hstr / 2;
		var x2 = tx + _wstr / 2;
		var y2 = ty + _hstr / 2;

	
		if (point_in_rectangle(_mx, _my, x1, y1, x2, y2)) {
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
	
		draw_text_transformed(tx, ty, menu_opt[i], s, s, 0);
	}


	draw_set_halign(-1);
	draw_set_valign(-1);
	draw_set_font(-1);
} else {
	global.in_menu = false;
}