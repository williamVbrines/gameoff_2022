extends Label

var queue = [0,0,0,0,0,0,0,0,0,0,]
var player_index = 0;
var enemy_index = 1;


func _ready() -> void:
	hide();
	
	queue = [0,0,0,0,0,0,0,0,0,0,]
	
	player_index = 0;
	queue[player_index] = 1;
	
	enemy_index = 1;
	queue[enemy_index] = 2;
	
	set_text(str(queue).replace("1", "P").replace("2", "N"));
	
	_make_connections();
	
	
func _make_connections():
	EventManager.change_battel_queue.connect(_on_change_queue)

	EventManager.start_combat.connect(_on_combat_started);
	EventManager.combat_state_changed.connect(_on_combat_state_changed)
	EventManager.start_exploration.connect(_on_exploration_started);
	
	
func _on_exploration_started() -> void:
	hide();
	
	
func _on_combat_started(_with : String , _cam : Camera3D , ) : 
	show();
	
	
func _on_combat_state_changed(state: String): 
	
	match state.to_upper():
		"SET_UP":
			_set_up();
		"CHECK_Q":
			_check_queue();
		"ADJUST_Q":
			_adjust_queue();
		"SHUTTING_DOWN_COMBAT":
			hide();
	
	
func _adjust_queue() -> void:
	var pos = -1;
#	[0,0,0,0,0,1,0,0,2]
#	[0,2,1,0,0,0,0,0,0]
	for index in queue.size():
		if queue[index] != 0:
			pos = -index;
			break;
			
	if pos == 1: printerr("NOTHING IN Q");
	
	for index in queue.size():
		if queue[index] == 1:
			_on_change_queue("PLAYER", pos);
		elif queue[index] == 2:
			_on_change_queue("NPC", pos);

	EventManager.call_deferred("emit_signal", "combat_state_changed","CHECK_Q");
	
	
func _check_queue() ->void: 
	
	await(get_tree().create_timer(0.5).timeout)#TO:DO Remove later
	match queue[0]:
		0: EventManager.call_deferred("emit_signal", "combat_state_changed","ADJUST_Q");
		1: EventManager.call_deferred("emit_signal", "combat_state_changed","PLAYER_TURN");
		2: EventManager.call_deferred("emit_signal", "combat_state_changed","NPC_TURN");
		_:EventManager.call_deferred("emit_signal", "combat_state_changed","ERROR");
	
	
func _set_up()->void:
	queue = [1,2,0,0,0,0,0,0,0,0,]
	player_index = 6;
	enemy_index = 10;
	set_text(str(queue).replace("1", "P").replace("2", "N"));
	show();
	EventManager.battel_queue_changed.emit(queue);
	
	
func _on_change_queue(entity : String, pos_change : int) -> void:
	var place = -1;
	
	match entity.to_upper():
		"PLAYER" : 
			place = player_index;
		"NPC" :
			place = enemy_index;
		_:
			return;
			
	queue[min(queue.size()-1,place)] = 0;
	place = min(queue.size()-1, place + pos_change);
	place = max(0, place);
	
	if queue[place] != 0:
		if place == queue.size()-1:
			queue[place-1] = 2;
		else:
			place += 1;
		
	
	match entity.to_upper():
		"PLAYER" : 
			player_index = place;
			queue[place] = 1;
		"NPC" :
			enemy_index = place;
			queue[place] = 2;
		_:
			return;
	
	
	set_text(str(queue).replace("1", "P").replace("2", "N"));
	
	EventManager.battel_queue_changed.emit(queue);
	
	