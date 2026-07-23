if (alpha_preto > 0) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    
    draw_set_alpha(alpha_preto);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);
}
