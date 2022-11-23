extends Node

signal start_exploration();


#Dialog Combat signals##########################################################
signal start_combat(camera : Camera3D);
signal combat_state_changed(state : String);

#Player and NPC action
signal attack(target : String, data : Dictionary);
#Player Action
signal disengage(dialog : String);

signal display_dialog(actor : String ,  data : Dictionary);

signal battel_queue_changed(new_q : Array);
signal change_battel_queue(entity : String,  pos_change : int);

signal persuasion_changed(val : float);
signal change_persuasion(val : float);

#Status bar ####################################################################
signal stress_changed(val : float);
signal changed_stress(val : float);

signal enemy_portrait_changed(tex : Texture);


#Saveing signals################################################################
signal store_data();#Tells the system to store all its data, perparinging it to be saved
signal save_data();#Tells the system to save all its data
signal load_data(data : Dictionary);

#Dialog Window signals#################################################################
signal start_dialog(id : String);
signal dialog_ended();
signal dialog_emit(val : String);

#Pause Menu####################################################################
signal pause_menu_opened();
signal pause_menu_closed();


#Room ##########################################################################
signal room_show_tooltip(text : String);
signal room_hide_tooltip();

signal room_show_confirm(text : String);
signal room_hide_confirm();

