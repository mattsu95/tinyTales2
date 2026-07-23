if (pode_falar) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);
    
    draw_text(_gw / 2, _gh - 20, "[E] Falar com o Mercante");
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
