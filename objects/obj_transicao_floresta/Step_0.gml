if (!instance_exists(obj_player)) exit;

// Quando o player passa do X = 5000 em direção ao X = 5300, a tela vai escurecendo gradualmente
if (obj_player.x >= 5000) {
    alpha_preto = clamp((obj_player.x - 5000) / 300, 0, 1);
    
    // Quando atinge X >= 5300 (totalmente escuro), troca de room para Unioeste1
    if (obj_player.x >= 5300 && alpha_preto >= 1 && !trocando) {
        trocando = true;
        room_goto(Unioeste1);
    }
} else {
    alpha_preto = 0;
}
