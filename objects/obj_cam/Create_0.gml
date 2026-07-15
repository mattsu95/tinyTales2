ideal_width = 1280; 
ideal_height = 720;

// Evita a distorção mantendo a proporção correta
aspect_ratio = ideal_width / ideal_height;

// Redimensiona a tela mantendo a proporção
if (display_get_width() < display_get_height()) {
    // Modo Retrato (vertical)
    window_set_size(ideal_width, ideal_width / aspect_ratio);
} else {
    // Modo Paisagem (horizontal)
    window_set_size(ideal_height * aspect_ratio, ideal_height);
}

// Centraliza a janela no monitor
window_center();