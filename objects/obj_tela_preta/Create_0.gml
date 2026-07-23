timer = 0;
max_timer = 240; // 4 segundos a 60fps
angulo_raios = 0;

// Toca o som do desbloqueio (shine, magic_surprise ou bell)
if (audio_exists(asset_get_index("shine"))) {
    audio_play_sound(asset_get_index("shine"), 1, false);
} else if (audio_exists(asset_get_index("magic_surprise"))) {
    audio_play_sound(asset_get_index("magic_surprise"), 1, false);
} else if (audio_exists(asset_get_index("bell"))) {
    audio_play_sound(asset_get_index("bell"), 1, false);
}
