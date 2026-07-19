if (ativado && !atendeu) {
    // Um ciclo de 150 frames = 2.5 segundos (a 60 FPS)
    // Se o resto da divisão for menor que 30, significa que ele vibra no primeiro meio segundo do ciclo
    if (timer_celular % 150 < 30) {
        var _cam = view_camera[0];
        var _cam_x = camera_get_view_x(_cam);
        var _cam_y = camera_get_view_y(_cam);
        
        // Adiciona um micro-tremor à câmera
        camera_set_view_pos(_cam, _cam_x + random_range(-1.5, 1.5), _cam_y + random_range(-1.5, 1.5));
    }
}