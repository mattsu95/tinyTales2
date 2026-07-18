// Pinta a tela inteira de preto
draw_set_color(c_black);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

// Reseta a cor para não bugar outras coisas depois
draw_set_color(c_white);