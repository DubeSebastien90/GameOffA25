lifetime -= delta_time / 1000000; // Convertir microsecondes en secondes
if (lifetime <= 0) {
    audio_emitter_free(emitter);
    instance_destroy();
}