extends Control


@onready var slots: Control = $Slots
@onready var npc_block: TextureRect = $Slots/TurnBlockNpc
@onready var player_block: TextureRect = $Slots/TurnBlockPlayer

const BLOCK_SEPARATION : float = 8;
const FADE_TIME : float = 0.2;
const SHIFT_TIME : float = 0.2;

var queue = [0,0,0,0,0,0,0,0,0,0,]
var player_index = 0;
var enemy_index = 1;


func _ready() -> void:
	hide();
	
	queue = [0,0,0,0,0,0,0,0,0,0]
	
	player_index = 0;
	queue[player_index] = 1;
	
	enemy_index = 1;
	queue[enemy_index] = 2;
	
	slots.move_child(npc_block, enemy_index);
	slots.move_child(player_block, player_index);
	
	for index in slots.get_child_count():
		var block = slots.get_child(index) as TextureRect;
		block.position.x = (block.size.x + BLOCK_SEPARATION) * index;
		
	
	_make_connections();
	
	
func _notifiy_queue_changed():
	if slots.get_child(0) in [player_block, npc_block]:
		EventManager.battel_queue_changed.emit(queue);
		EventManager.call_deferred("emit_signal", "combat_state_changed","CHECK_WIN_OR_LOSS");
	else:
		_move_front_to(slots.get_child_count()-1);
	
	
func _make_connections():
	EventManager.change_battel_queue.connect(_on_change_queue)

	EventManager.start_combat.connect(_on_combat_started);
	EventManager.combat_state_changed.connect(_on_combat_state_changed)
	EventManager.start_exploration.connect(_on_exploration_started);
	
	
func _on_exploration_started() -> void:
	hide();
	
	
func _on_combat_started(_cam : Camera3D , ) : 
	_set_up();
	
	
func _on_combat_state_changed(state: String): 
	
	match state.to_upper():
		"CHECK_Q":
			_check_queue();
		"SHUTTING_DOWN_COMBAT":
			hide();
	
	
func _check_queue() ->void: 
	match queue[0]:
		0: EventManager.call_deferred("emit_signal", "combat_state_changed","ADJUST_Q");
		1: EventManager.call_deferred("emit_signal", "combat_state_changed","PLAYER_TURN");
		2: EventManager.call_deferred("emit_signal", "combat_state_changed","NPC_TURN");
		_:EventManager.call_deferred("emit_signal", "combat_state_changed","ERROR");
	
	
func _set_up()->void:
	queue = [1,2,0,0,0,0,0,0,0,0,]
	player_index = 0;
	enemy_index = 1;
	
	slots.move_child(npc_block, enemy_index);
	slots.move_child(player_block, player_index);
	
	for index in slots.get_child_count():
		var block = slots.get_child(index) as TextureRect;
		block.position.x = (block.size.x + BLOCK_SEPARATION) * index;
		
	show();
	
	EventManager.battel_queue_changed.emit(queue);
	
	
func _on_change_queue(_entity : String, pos_change : int) -> void:
	
	pos_change = clampi(pos_change,0, queue.size()-1);
	
	if queue[pos_change] != 0:
		if pos_change == queue.size()-1:
			queue[pos_change-1] = 2;
		else:
			pos_change += 1;
		
	if queue[0] == 1: 
		player_index = pos_change;
		queue[pos_change] = 1;
	else:
		enemy_index = pos_change;
		queue[pos_change] = 2;
	
	#Move to next turn
	var next = enemy_index if player_index > enemy_index else player_index;
	
	queue[enemy_index] = 0;
	queue[player_index] = 0;
	queue[enemy_index - next] = 2;
	queue[player_index - next] = 1;
	
	enemy_index = enemy_index - next;
	player_index = player_index - next;
	
	_move_front_to(pos_change);
	
	
func _move_front_to(index : int):
	index -= 1 if index > 1 else 0;
	var tween = create_tween();
	var block = slots.get_child(0) as TextureRect;
	tween.set_ease(Tween.EASE_IN_OUT);
	tween.set_trans(Tween.TRANS_CUBIC);
	
	tween.stop();
	#Fade out
	tween.tween_property(block,"self_modulate",Color(Color.WHITE,0.0),FADE_TIME)
	
	#Swap block
	slots.move_child(block,index);
	tween.tween_callback(block.set_position.bind(Vector2((block.size.x + BLOCK_SEPARATION) * (index),0)));
	
	#Rearange blocks
	for i in index:
		block = slots.get_child(i) as TextureRect;
		var next_pos = (block.size.x + BLOCK_SEPARATION) * (i);
		tween.tween_property(block,"position",Vector2(next_pos, 0),SHIFT_TIME);
		
	block = slots.get_child(index) as TextureRect;
	tween.tween_property(block,"self_modulate",Color(Color.WHITE,1.0),FADE_TIME);
	
	tween.tween_callback(_notifiy_queue_changed);
	
	tween.play();
	
	

