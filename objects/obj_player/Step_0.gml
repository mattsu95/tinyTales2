if (place_meeting(x, y, obj_obstaculo)) {
    var _obstaculo = instance_place(x, y, obj_obstaculo);
    if (_obstaculo != noone) {
        instance_destroy(_obstaculo);
        
        if (!atordoado) {
            atordoado = true;
            timer_atordoado = 12;
            perda_velocidade = 2;
            image_blend = c_red;
        }
    }
}

if (atordoado) {
    timer_atordoado--;
    x -= 0.3;
    
    var _limite_esquerda = camera_get_view_x(view_camera[0]) + 40;
    if (x < _limite_esquerda) {
        x = _limite_esquerda;
    }
    
    if (timer_atordoado <= 0) {
        atordoado = false;
        perda_velocidade = 0;
        image_blend = c_white;
    }
}

if (velh != 0) {
	image_xscale = sign(velh);
}

if (attack_cooldown > 0) { attack_cooldown--; }

estado();

if (keyboard_check_pressed(vk_tab))
{
    mostrar_inventario = !mostrar_inventario;
}

if (mostrar_inventario && array_length(inventario) > 0)
{
    if (keyboard_check_pressed(vk_right))
    {
        indice_selecionado++;
    }

    if (keyboard_check_pressed(vk_left))
    {
        indice_selecionado--;
    }


    if (indice_selecionado >= array_length(inventario))
    {
        indice_selecionado = 0;
    }

    if (indice_selecionado < 0)
    {
        indice_selecionado = array_length(inventario)-1;
    }
}
else if (array_length(inventario) == 0)
{
    indice_selecionado = 0;
}

if (x < parede_invisivel_x) {
    x = parede_invisivel_x;
}