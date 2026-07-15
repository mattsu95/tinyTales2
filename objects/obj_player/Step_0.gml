// --- SISTEMA DE COLISÃO COM OBSTÁCULO ---
if (place_meeting(x, y, obj_obstaculo)) {
    var _obstaculo = instance_place(x, y, obj_obstaculo);
    if (_obstaculo != noone) {
        instance_destroy(_obstaculo);

        if (!atordoado) {
            atordoado = true;
            timer_atordoado = 12; // REDUZIDO! Fica atordoado por pouquíssimos frames
            perda_velocidade = 2; // Perda de velocidade rápida
            image_blend = c_red;
        }
    }
}

// Gerencia o recuo fixo e curto
if (atordoado) {
    timer_atordoado--;

    // Recua de forma sutil e constante a cada frame
    x -= 0.3; // Bem baixinho para ele não ir muito para trás!

    // Garante que ele não saia da borda esquerda da tela
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

// --- TRAVA DE RETORNO (PAREDE INVISÍVEL) ---
// Se o jogador tentar andar para trás além da parede, nós empurramos ele de volta!
if (x < parede_invisivel_x) {
    x = parede_invisivel_x;
}
