extends Control

@export var fade_time : float = 1.0;
@onready var color_rect: ColorRect = $ColorRect
@onready var victory_audio: AudioStreamPlayer = $VictoryAudio
@onready var victory_screen: Control = $VictoryScreen
@onready var ui: Control = $UI

func _ready() -> void:
	_make_connetions();
	
	
func _make_connetions() -> void:
	EventManager.start_combat.connect(_on_start_combat);
	EventManager.combat_state_changed.connect(_on_combat_state_changed);
	EventManager.attack.connect(_on_attacked);
	
	
func _on_combat_state_changed(state : String) ->void:
	match state.to_upper():
		"SET_UP":
			EventManager.call_deferred("emit_signal", "combat_state_changed", "CHECK_Q")
		"CHECK_WIN_OR_LOSS":
			_check_win_or_loss();
		"WIN":
			_on_win();
		"LOSS":
			EventManager.call_deferred("emit_signal", "combat_state_changed","SHUTTING_DOWN_COMBAT");
		"NPC_TURN":
			EventManager.call_deferred("emit_signal", "combat_state_changed","NPC_ACTION_SELECT");
		"PLAYER_TURN":
			EventManager.call_deferred("emit_signal", "combat_state_changed","PLAYER_ACTION_SELECT");
		"SHUTTING_DOWN_COMBAT":
			_shut_down_combat();
	
func _on_win():
	var tween = create_tween();
	var hold = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("BGM"));
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), -80);
	victory_audio.play()
	tween.stop();
	tween.tween_property(ui, "modulate", Color(Color.WHITE, 0.0), 0.2);
	tween.tween_property(victory_screen, "modulate", Color(Color.WHITE, 1.0), 0.2);
	tween.tween_interval(victory_audio.stream.get_length()-2.5);
	
	tween.tween_callback(EventManager.call_deferred.bind("emit_signal", "combat_state_changed", "SHUTTING_DOWN_COMBAT"));
	tween.tween_property(victory_screen, "modulate", Color(Color.WHITE, 0.0), 0.2);
	tween.tween_property(ui, "modulate", Color(Color.WHITE, 1.0), 0.2);
	
	tween.tween_interval(2.3);
	tween.tween_callback(AudioServer.set_bus_volume_db.bind(AudioServer.get_bus_index("BGM"), hold));
	tween.play();
	
	
	
func _strat_exploration():
	EventManager.call_deferred("emit_signal","start_exploration");
	
	
func _check_win_or_loss():
	if SystemGlobals.persuasion  >= 100:
		SystemGlobals.in_battel = false;
		EventManager.call_deferred("emit_signal", "combat_state_changed","WIN");
	elif SystemGlobals.stress  >= 100:
		SystemGlobals.in_battel = false;
		EventManager.call_deferred("emit_signal", "combat_state_changed","LOSS");
	else:
		EventManager.call_deferred("emit_signal", "combat_state_changed","CHECK_Q");
	
	
func _on_attacked(target : String,data : Dictionary)->void:
	if target.to_upper() != "PLAYER": return;
	
	var damage = data.amt;

	damage = max(0,damage);

	SystemGlobals.stress += damage;

	EventManager.stress_changed.emit();

	EventManager.change_battel_queue.emit("NPC", data.cost)
	
	EventManager.combat_state_changed.emit("ADJUST_Q")
	
	
func _on_start_combat(camera : Camera3D) -> void:
	var tween = create_tween();
	
	tween.pause();
	tween.tween_property(color_rect,"color",Color(0, 0, 0, 1),fade_time);
	tween.tween_property(color_rect,"color",Color(0, 0, 0, 1),fade_time);
	
	tween.tween_callback(camera.set_current.bind(true));
	
	tween.tween_property(color_rect,"color",Color(0, 0, 0, 0),fade_time);
	
	tween.tween_callback(_change_state.bind("SET_UP"));
	
	tween.play();
	
	
func _shut_down_combat() -> void:
	var tween = create_tween();
	
	tween.pause();
	tween.tween_property(color_rect,"color",Color(0, 0, 0, 1),fade_time);
	tween.tween_property(color_rect,"color",Color(0, 0, 0, 1),fade_time);
	
	tween.tween_callback(_strat_exploration);
	
	tween.tween_property(color_rect,"color",Color(0, 0, 0, 0),fade_time);
	
	tween.play();
	
	
func _change_state(state : String): EventManager.call_deferred("emit_signal", "combat_state_changed", state);
	
	
