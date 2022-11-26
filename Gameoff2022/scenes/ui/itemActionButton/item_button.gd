extends Control
@export var disabled_color : Color = Color.BROWN
@export var data : Resource : set = set_data;
@onready var button: Button = $Button
@onready var pressed_audio: AudioStreamPlayer = $PressedAudio


var is_used : bool = false;

func _init(new_data : ItemData = null) -> void:
	set_data(new_data if new_data else data);
	
	
func _ready() -> void:
	if !data: 
		queue_free();
		return;
	_make_connections();
	_set_up();
	
	
func _make_connections() -> void:
	EventManager.start_combat.connect(_on_start_combat);
	button.pressed.connect(_on_pressed);
	
	
func _set_up() -> void:
	if data is ItemData:
		button.set_text(data.discrtiption);
	
func _on_start_combat(_cam : Camera3D) -> void:
	if !data: 
		queue_free();
		return;
		
	set_data(data);
	
	
func set_data(new_data : ItemData) -> void:
	if !new_data: return;
		
	data = new_data;
	
	
func _on_pressed() -> void:
	pressed_audio.play_rand();
	_on_attack();
	
	
func _on_attack() -> void:
	EventManager.combat_state_changed.emit("PLAYER_ACTION_RESOLVE");
	data.activate_effect(SystemGlobals.opponent);
	is_used = true;
	
	var index = SystemGlobals.player_items.find(data.name)

	if index != -1:
		SystemGlobals.player_items[index] = SystemGlobals.player_items[SystemGlobals.player_items.size()-1];
		SystemGlobals.player_items.pop_back();
		
		
	queue_free();
	button.set_disabled(true);
	
	
