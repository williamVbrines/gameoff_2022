extends Control

@onready var tag_button: Button = $TagButton
@export var dialog : String = "";
@onready var pressed_audio: AudioStreamPlayer = $PressedAudio

func _ready() -> void:
	_make_connections();
	
	
func _make_connections() -> void:
	EventManager.start_combat.connect(_on_start_combat);
	tag_button.pressed.connect(_on_pressed);
	
		
func _on_start_combat(_cam : Camera3D) -> void:
	tag_button.set_disabled(false);
	
	
func _on_pressed() -> void:
	tag_button.set_disabled(true);
	_on_flee();
	
	
func _on_flee() -> void:
	pressed_audio.play_rand();
#	EventManager.combat_state_changed.emit("PLAYER_ACTION_RESOLVE");
#	EventManager.disengage.emit(dialog);
	EventManager.call_deferred("emit_signal", "combat_state_changed","SHUTTING_DOWN_COMBAT");

	
