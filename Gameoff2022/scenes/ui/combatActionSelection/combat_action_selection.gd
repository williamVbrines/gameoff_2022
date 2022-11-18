extends Control

@onready var tatics: Control = $Tatics

var tattics_scene : PackedScene = preload("res://scenes/ui/taticsActionButton/tactic_button.tscn");

func _ready() -> void:
	_make_connections();
	hide();
	
	
func _make_connections() -> void:
	EventManager.combat_state_changed.connect(_on_combat_state_changed);
	EventManager.start_combat.connect(_on_start_combat);
	
func _on_combat_state_changed(state : String) ->void:
	match state.to_upper():
		"WIN":
			hide();
		"LOSS":
			hide();
		"NPC_TURN":
			hide();
		"PLAYER_TURN":
			show();
		"IN_DIALOG":
			hide();
		"SHUTTING_DOWN_COMBAT":
			hide();
	
	
func _on_start_combat(_name : String, _camera : Camera3D) -> void:
	for child in tatics.get_children():
		child.queue_free();
	
	for id in \
		[SystemGlobals.player_tactics.get("SLOT:1")\
		,SystemGlobals.player_tactics.get("SLOT:2")\
		,SystemGlobals.player_tactics.get("SLOT:3")]:
		
		if id != null:
			var new_tatic = tattics_scene.instantiate();
			new_tatic.set_data(ResourceManager.get_tactic(id));
		
			tatics.add_child(new_tatic);
		
	
	
	
