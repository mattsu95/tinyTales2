// --- EFEITO DE DANO NA HUD ---
if (dano_flash_timer > 0) {
    dano_flash_timer--;
}

var _restart_pressed = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || gp_pressed(gp_face1) || gp_pressed(gp_start);
var _inv_toggle_pressed = keyboard_check_pressed(vk_tab) || gp_pressed(gp_select);
var _inv_right_pressed = keyboard_check_pressed(vk_right) || gp_pressed(gp_padr);
var _inv_left_pressed = keyboard_check_pressed(vk_left) || gp_pressed(gp_padl);

// --- GAME OVER ---
if (game_over) {
    velh = 0;
    velv = 0;
    sprite_index = spr_player_idle;
    if (_restart_pressed) {
        game_restart();
    }
    exit;
}

// --- MORTE PELOS DOGS ---
if (pego_pelos_dogs) {
    velh = 0;
    velv = 0;
    sprite_index = spr_player_idle;
    timer_morte_dogs--;
    
    if (timer_morte_dogs <= 0 || ((240 - timer_morte_dogs > 30) && _restart_pressed)) {
        pego_pelos_dogs = false;
        respawn_player_checkpoint();
    }
    exit;
}

// --- DEFESA ---
var _defend_now = keyboard_check(ord("C")) || gp_check(gp_face2);

// parry: ativa janela no primeiro frame de pressionar F
if (_defend_now && !defendendo_prev) {
    parry_window = parry_window_max;
}
defendendo = _defend_now;
defendendo_prev = _defend_now;
if (parry_window > 0) parry_window--;

if (defendendo) {
    // dourado durante a janela de parry, azul depois
    if (parry_window > 0) {
        image_blend = make_colour_rgb(255, 220, 50);
    } else {
        image_blend = make_colour_rgb(80, 160, 255);
    }
} else if (invincivel_timer <= 0) {
    image_blend = c_white;
}

if (invincivel_timer > 0) {
    invincivel_timer--;
    // pisca o player durante a invencibilidade
    image_alpha = (invincivel_timer mod 6 < 3) ? 0.4 : 1.0;
} else {
    image_alpha = 1.0;
    // verifica morte
    if (vida <= 0) {
        game_over = true;
    }
}

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

if (dice_cooldown > 0) { dice_cooldown--; }


estado();

// Para o som da bicicleta se o player não estiver pedalando
if (estado != p_bike || !ta_de_bike) {
    if (audio_is_playing(bicycle)) {
        audio_stop_sound(bicycle);
    }
}

if (_inv_toggle_pressed)
{
    mostrar_inventario = !mostrar_inventario;
}

if (mostrar_inventario && array_length(inventario) > 0)
{
    if (_inv_right_pressed)
    {
        indice_selecionado++;
    }

    if (_inv_left_pressed)
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

// BARREIRA DA BICICLETA EM UNIOESTE1: Impede avanço a pé se a bicicleta ainda estiver no chão
if (room == Unioeste1 && !ta_de_bike && instance_exists(obj_bicicleta) && x >= 5150) {
    x = 5150;
    if (velh > 0) velh = 0;
}

// Flash amarelo no parry bem-sucedido
if (parry_flash_timer > 0) {
    parry_flash_timer--;
    image_blend = make_colour_rgb(255, 220, 50);
} else if (!defendendo && invincivel_timer <= 0 && !atordoado) {
    image_blend = c_white;
}