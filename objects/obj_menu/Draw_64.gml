

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);


// colocar outra fonte depois!
draw_set_font(Font1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);


var menu_len = array_length(menu_opt);
for (var i = 0; i < menu_len; i++) {
	var _wgui = display_get_gui_width();
	var _hgui = display_get_gui_height();

	var _hstr = string_height("I");
	var _wstr = string_width(menu_opt[i]);
	
	var x1 = _wgui / 2 - _wstr / 2;
	var y1 = _hgui / 2 - _hstr / 2 + _hstr * i;
	var x2 = _wgui / 2 + _wstr / 2;
	var y2 = _hgui / 2 + _hstr / 2 + _hstr * i;

	
	if (point_in_rectangle(_mx, _my, x1, y1, x2, y2)) {
		escala[i] = lerp(escala[i], 1.4, 0.15);
		
		if (device_mouse_check_button_pressed(0, mb_left)) {
			switch (menu_opt[i]) {
				case menu_opt[0]: // jogar
					room_goto(Floresta);
					break;
				case menu_opt[1]: // opções
					show_message("você é bagre!");
					break;
				case menu_opt[2]: // créditos
					show_message("Grupo do Bolo™");
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
	
	draw_text_transformed(_wgui / 2, _hgui / 2 + _hstr * i, menu_opt[i], escala[i], escala[i], 0);
}


draw_set_halign(-1);
draw_set_valign(-1);
draw_set_font(-1);
