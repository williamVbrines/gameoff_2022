extends Control


@onready var slots: Control = $Slots
@onready var npc_block: TextureRect = $Slots/TurnBlockNpc
@onready var player_block: TextureRect = $Slots/TurnBlockPlayer
@onready var shift_audio: AudioStreamPlayer = $ShiftAudio

const BLOCK_SEPARATION : float = 8;
const FADE_TIME : float = 0.2;
const SHIFT_TIME : float = 0.2;

var queue = [0,0,0,0,0,0,0,0,0,0,]
var player_index = 0;
var enemy_index = 1;


func _ready() -> void:
	hide();
	_on_hide();
	
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
		EventManager.call_deferred("emit_signal","combat_state_changed","CHECK_WIN_OR_LOSS");
	else:
		_move_front_to(slots.get_child_count());
	
	
func _make_connections():
	EventManager.change_battel_queue.connect(_on_change_queue)
	EventManager.combat_state_changed.connect(_on_combat_state_changed)
	EventManager.start_exploration.connect(_on_exploration_started);
	
	
func _on_exploration_started() -> void:
	_on_hide();
	
	
	
func _on_combat_state_changed(state: String): 
	
	match state.to_upper():
		"SET_UP":
			show();
			_set_up();
		"CHECK_Q":
			_check_queue();
		"SHUTTING_DOWN_COMBAT":
			_on_hide();
	
	
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
		
	_on_show();
	
	EventManager.battel_queue_changed.emit(queue);
	
	
func _on_change_queue(_entity : String, pos_change : int) -> void:

	
	pos_change = clampi(pos_change,0, queue.size()-1);
	#2010#2
	
	while queue[pos_change] != 0:
		pos_change += 1;
	#2010#3

	
	if queue[0] == 1: 
		player_index = pos_change;
	elif queue[0] == 2: 
		enemy_index = pos_change;
		
	queue[pos_change] = queue[0];
	#2012#3
	
	queue[0] = 0;
	#0012#3

	#Move to next turn
	var next = enemy_index if player_index > enemy_index else player_index;
	
	queue[enemy_index] = 0;
	queue[player_index] = 0;
	
	#0000#3

	
	enemy_index = enemy_index - next;
	player_index = player_index - next;
	
	queue[enemy_index] = 2;
	queue[player_index] = 1;
	
	#1200#3
	
	_move_front_to(pos_change);
	
	
func _move_front_to(index : int):
	
	var tween = create_tween();
	var block_zero = null ;
	if index > slots.get_child_count()-1: index = slots.get_child_count()-1
	#Setup Tween
	tween.set_ease(Tween.EASE_IN_OUT);
	tween.set_trans(Tween.TRANS_CUBIC);
	tween.set_parallel(false);
	
	tween.stop();
	
	#Hold block in index zero;
	block_zero = slots.get_child(0);
	
	#Fade out block zero
	tween.tween_property(block_zero,"modulate",Color(Color.WHITE,0.0),FADE_TIME)
	tween.tween_callback(shift_audio.play_rand);
	
	#Move all blocks form 1 up to index left 1;
	for i in min(index+1, slots.get_child_count()):
		var block = slots.get_child(i);
		var next_pos = (block.size.x + BLOCK_SEPARATION) * (i-1);
		tween.tween_property(block,"position",Vector2(next_pos, 0),SHIFT_TIME);

	#Move block zero to index
	tween.tween_callback(slots.move_child.bind(block_zero,index));
	#Set block zeros pos to its new pos;
	var next_pos = (block_zero.size.x + BLOCK_SEPARATION) * (index);
	tween.tween_callback(block_zero.set_position.bind(Vector2(next_pos, 0)));
	#Fadein block zero
	tween.tween_property(block_zero,"modulate",Color(Color.WHITE,1.0),FADE_TIME);
	
	tween.tween_callback(_notifiy_queue_changed);
	
	tween.play();
	
	
func _on_hide() -> void:
	var tween = create_tween();
	tween.tween_property(self,"modulate", Color(Color.WHITE, 0.0),0.2);
	tween.tween_callback(hide);
	tween.play();
	
	
func _on_show() -> void:
	var tween = create_tween();
	show();
	tween.tween_property(self,"modulate", Color(Color.WHITE, 1.0),0.2);
	tween.play();
	
