// Move para a esquerda para dar sensação de velocidade
x -= velocidade_cenario;

// Se sumir completamente pela esquerda da câmera, se destrói sozinho para poupar memória
var _cam_x = camera_get_view_x(view_camera[0]);
if (x < _cam_x - 100) {
    instance_destroy();
}