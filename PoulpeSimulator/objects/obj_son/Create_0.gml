function play_sound(snd, pitch_diff) {
    // Créer un nouvel émetteur audio
    var emitter = audio_emitter_create();

    // Générer un pitch aléatoire entre min_pitch et max_pitch
    var pitch = random_range(1-pitch_diff, 1+pitch_diff);

    // Créer l'instance sonore avec pitch modifié
   audio_emitter_pitch(emitter, pitch)
    // Jouer le son via l'émetteur (facultatif si position 3D pas nécessaire)
   audio_play_sound_on(emitter, snd, 0, false);
    
    //audio_emitter_free(emitter);
	var duration = audio_sound_length(snd) / pitch;
	
	var cleanup_inst = instance_create_layer(x, y, "ui", audio_emitter_cleanup);
    cleanup_inst.emitter = emitter;
    cleanup_inst.lifetime = duration;
}

function play_random_sound(sounds, pitch_diff) {
    // Créer un nouvel émetteur audio
	var index = irandom(array_length(sounds) - 1);
    var snd = sounds[index];
	
    var emitter = audio_emitter_create();

    // Générer un pitch aléatoire entre min_pitch et max_pitch
    var pitch = random_range(1-pitch_diff, 1+pitch_diff);

    // Créer l'instance sonore avec pitch modifié
   audio_emitter_pitch(emitter, pitch)
    // Jouer le son via l'émetteur (facultatif si position 3D pas nécessaire)
   audio_play_sound_on(emitter, snd, 0, false);
    
    //audio_emitter_free(emitter);
	var duration = audio_sound_length(snd) / pitch;
	
	var cleanup_inst = instance_create_layer(x, y, "ui", audio_emitter_cleanup);
    cleanup_inst.emitter = emitter;
    cleanup_inst.lifetime = duration;
}

function play_sound_myself(snd, boucle){
	    // Créer un nouvel émetteur audio
    var emitter = audio_emitter_create();
    // Jouer le son via l'émetteur (facultatif si position 3D pas nécessaire)
   audio_play_sound_on(emitter, snd, boucle, false);
    
	
	return emitter;
}