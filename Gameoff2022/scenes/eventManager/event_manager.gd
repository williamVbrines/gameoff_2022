extends Node

signal start_combat(with : String, camera : Camera3D);

signal combat_state_changed(state : String);

signal attack(target : String, data : Dictionary, sender);

signal persuasion_changed(val : float);
signal change_persuasion(val : float);

signal annoyance_changed(val : float);
signal changed_annoyance(val : float);

signal battel_queue_changed(new_q : Array);
signal change_battel_queue(entity : String,  pos_change : int);

