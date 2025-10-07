if (fading == 1) {              // Fade out
    alpha += 0.05;
    if (alpha >= 1) {
        room_goto(next_room);
        fading = 2;             // Pasamos al fade in
    }
} else if (fading == 2) {       // Fade in
    alpha -= 0.05;
    if (alpha <= 0) {
        instance_destroy();     // Ya terminó el efecto
    }
}
