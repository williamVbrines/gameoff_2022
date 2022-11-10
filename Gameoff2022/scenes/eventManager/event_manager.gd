extends Node

signal start_combat(with : String, camera : Camera3D);
signal start_exploration();

signal combat_state_changed(state : String);

#Player and NPC action
signal attack(target : String, data : Dictionary, sender);
#Player Action
signal disengage(dialog : String);

signal display_dialog(actor : String ,  data : Dictionary);

signal persuasion_changed(val : float);

signal change_persuasion(val : float);

signal annoyance_changed(val : float);
signal changed_annoyance(val : float);

signal battel_queue_changed(new_q : Array);
signal change_battel_queue(entity : String,  pos_change : int);

