extends Control

@export var fade_time : float = 1.0;
@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	_make_connetions();
	
	
func _make_connetions() -> void:
	EventManager.start_combat.connect(_on_start_combat);
	EventManager.combat_state_changed.connect(_on_combat_state_changed);
	EventManager.attack.connect(_on_attacked);
	
	
func _on_combat_state_changed(state : String) ->void:
	print(state); #TODO:Remove
	match state.to_upper():
		"CHECK_WIN_OR_LOSS":
			_check_win_or_loss();
		"WIN":
			EventManager.call_deferred("emit_signal", "combat_state_changed", "SHUTTING_DOWN_COMBAT")
		"LOSS":
			EventManager.call_deferred("emit_signal", "combat_state_changed","SHUTTING_DOWN_COMBAT");
		"NPC_TURN":
			EventManager.call_deferred("emit_signal", "combat_state_changed","NPC_ACTION_SELECT");
		"PLAYER_TURN":
			EventManager.call_deferred("emit_signal", "combat_state_changed","PLAYER_ACTION_SELECT");
		"SHUTTING_DOWN_COMBAT":
			_shut_down_combat();
	
	
func _strat_exploration():
	EventManager.call_deferred("emit_signal","start_exploration");
	
	
func _check_win_or_loss():
	if SystemGlobals.stress == 100:
		EventManager.combat_state_changed.emit("LOSS");
	else:
		EventManager.combat_state_changed.emit("CHECK_WIN");
	
	
func _on_attacked(target : String,data : Dictionary, _sender)->void:
	if target.to_upper() != "PLAYER": return;
	
	var damage = data.amt;

	damage = max(0,damage);

	SystemGlobals.stress += damage;

	EventManager.stress_changed.emit(SystemGlobals.stress);

	EventManager.change_battel_queue.emit("NPC", data.cost)
	
	EventManager.combat_state_changed.emit("ADJUST_Q")
	
	
func _on_start_combat(camera : Camera3D) -> void:
	var tween = create_tween();
	
	tween.pause();
	tween.tween_property(color_rect,"color",Color(0, 0, 0, 1),fade_time);
	tween.tween_property(color_rect,"color",Color(0, 0, 0, 1),fade_time);
	
	tween.tween_callback(camera.set_current.bind(true));
	
	tween.tween_property(color_rect,"color",Color(0, 0, 0, 0),fade_time);
	
	tween.tween_callback(_change_state.bind("CHECK_Q"));
	
	tween.play();
	
	
func _shut_down_combat() -> void:
	var tween = create_tween();
	
	tween.pause();
	tween.tween_property(color_rect,"color",Color(0, 0, 0, 1),fade_time);
	tween.tween_property(color_rect,"color",Color(0, 0, 0, 1),fade_time);
	
	tween.tween_callback(_strat_exploration);
	
	tween.tween_property(color_rect,"color",Color(0, 0, 0, 0),fade_time);
	
	tween.play();
	
	
func _change_state(state : String): EventManager.combat_state_changed.emit(state);
	
	
