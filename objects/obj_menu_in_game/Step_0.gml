var _pause_pressed = keyboard_check_pressed(vk_escape);
for (var _gp = 0; _gp < 4 && !_pause_pressed; _gp++) {
	if (gamepad_is_connected(_gp) && gamepad_button_check_pressed(_gp, gp_start)) {
		_pause_pressed = true;
	}
}

if (_pause_pressed && room != Menu) {
	desenhar = !desenhar;
}