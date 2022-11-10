extends Control

func _ready() -> void:
	_make_connections();
	hide();
	
	
func _make_connections() -> void:
	EventManager.combat_state_changed.connect(_on_combat_state_changed);
	
	
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
	
	
