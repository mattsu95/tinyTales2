other.vida -= 20;
other.invincivel_timer = other.invincivel_max * 0.4;
other.dano_flash_timer = other.dano_flash_max;

if (other.vida < 0) other.vida = 0;

instance_destroy();