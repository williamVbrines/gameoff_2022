extends Node

signal start_combat(with : String, camera : Camera3D);

signal attack(target : String, data : Dictionary, sender);

signal persuasion_changed(val : float);
signal annoyance_changed(val : float);
