x += velh;
y += velv;
velv += grav;

// O SEGREDO DO PESO: Se ela atingiu o topo e começou a cair, 
// aumentamos um pouquinho a gravidade para ela não ficar boiando para sempre
if (velv > 0) {
    grav = 0.025; 
}

image_angle += rotacao_spd;

// O PONTO DE SUMIÇO: Adicionamos "+ 15" pixels abaixo do bueiro 
// para garantir que ela encoste no chão visualmente antes de desaparecer.
// (Se ela ainda sumir no ar, aumente esse 15 para 20 ou 30).
if (velv > 0 && y >= bueiro_y + 15) {
    instance_destroy();
}