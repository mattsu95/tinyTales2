if (!instance_exists(obj_player)) exit;

// Quando o player passa do X = 5690 em direção ao X = 5990, a tela vai escurecendo gradualmente
if (obj_player.x >= 5690) {
    alpha_preto = clamp((obj_player.x - 5690) / 300, 0, 1);
    
    // Quando atinge X >= 5990 (totalmente escuro), troca de room para Terminal
    if (obj_player.x >= 5990 && alpha_preto >= 1 && !trocando) {
        trocando = true;
        room_goto(Terminal);
    }
} else {
    alpha_preto = 0;
}
