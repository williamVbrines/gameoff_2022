extends Node

signal start_exploration();


#Dialog Combat signals##########################################################
signal start_combat(with : String, camera : Camera3D);
signal combat_state_changed(state : String);

#Player and NPC action
#TODO: Determin if sender is nessesary
signal attack(target : String, data : Dictionary, sender);
#Player Action
signal disengage(dialog : String);

signal display_dialog(actor : String ,  data : Dictionary);

signal battel_queue_changed(new_q : Array);
signal change_battel_queue(entity : String,  pos_change : int);

signal persuasion_changed(val : float);
signal change_persuasion(val : float);

signal annoyance_changed(val : float);
signal changed_annoyance(val : float);


#Saveing signals################################################################
signal store_data();#Tells the system to store all its data, perparinging it to be saved
signal save_data();#Tells the system to save all its data
signal load_data(data : Dictionary);

#Dialog Window signals#################################################################
signal start_dialog(id : String);
signal dialog_ended();
signal dialog_emit(val : String);

