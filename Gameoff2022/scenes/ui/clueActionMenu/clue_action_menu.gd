extends Control

const OPEN_SPEED : float = 0.1;

@onready var clues: VBoxContainer = $MenuBackground/Clues
@onready var menu_background: NinePatchRect = $MenuBackground
@onready var tag_button: Button = $TagButton

var clue_button_scene : PackedScene = preload("res://scenes/ui/cluesActionButton/clue_action_button.tscn")

var is_open : bool = false : set = set_is_open;
var box_size : Vector2 = Vector2(350,26 + 32);
var box_pos : Vector2 = Vector2(350,26 + 32);

signal opened();
signal closed();
signal pressed();

func set_is_open(val) -> void:
	if is_open != val:
		is_open = val;
		if is_open == true:
			_open();
		else:
			_close();
	
	
func _ready() -> void:
	_make_connections();
	box_pos = tag_button.position;
	
	
func _make_connections() -> void:
	EventManager.start_combat.connect(_on_start_combat);
	tag_button.pressed.connect(_on_tag_button_pressed);
	
	
func _on_tag_button_pressed() -> void:
#	is_open = !is_open;
	pressed.emit();
	tag_button.disabled = true;
	
	
func _close() -> void:
	var tween_p = create_tween();

	tween_p.set_ease(Tween.EASE_IN_OUT);
	tween_p.set_trans(Tween.TRANS_CUBIC);
	
	tween_p.set_parallel();
	tween_p.stop();
	tween_p.tween_property(menu_background,"size",  Vector2(box_size.x,0), OPEN_SPEED);
	tween_p.tween_property(menu_background,"position", menu_background.position + Vector2(0,box_size.y),OPEN_SPEED);
	tween_p.tween_property(tag_button,"position", tag_button.position + Vector2(0,box_size.y), OPEN_SPEED);
	tween_p.finished.connect(close_p2);

	tween_p.play();
	
	
func close_p2():
	var tween = create_tween();
	tween.set_ease(Tween.EASE_IN_OUT);
	tween.set_trans(Tween.TRANS_CUBIC);
	
	tween.stop();
	tween.tween_callback(menu_background.hide)
	tween.tween_callback(tag_button.set_disabled.bind(false));
	
	tween.tween_property(tag_button,"position", box_pos, OPEN_SPEED);
	tween.tween_callback(emit_signal.bind("closed"));
	
	tween.play();
	
	
func _open() -> void:
	var tween = create_tween();
	tween.stop();
	#Move Left most
	tween.tween_property(tag_button,"position", Vector2(0,tag_button.position.y), OPEN_SPEED);
	#Move to final
	tween.tween_property(tag_button,"position", Vector2(0,-box_size.y), OPEN_SPEED);
	tween.tween_property(menu_background,"position", menu_background.position - Vector2(0,box_size.y), 0);
#	tween.tween_interval(OPEN_SPEED);
	tween.tween_callback(_open_p2);
	tween.tween_interval(OPEN_SPEED);
	tween.tween_callback(tag_button.set_disabled.bind(false));
	tween.tween_callback(emit_signal.bind("opened"));
	
	tween.play();
	
	
func _open_p2() -> void:
	var tween_p = create_tween();
	tween_p.stop();
	tween_p.set_parallel();
	tween_p.tween_callback(menu_background.show)
	tween_p.tween_property(menu_background,"size", box_size, OPEN_SPEED);
	
	tween_p.play();
	
	
func _on_start_combat(_camera) -> void: 
	var height = 26;
	for child in clues.get_children():
		clues.remove_child(child);
		child.queue_free();
	
	for id in SystemGlobals.player_clues:
		
		if id != null:
			var new_clue = clue_button_scene.instantiate();
			new_clue.set_data(ResourceManager.get_clue_data(id));
			height = new_clue.size.y;
			clues.add_child(new_clue);
		
	
	box_size.y = clues.get_child_count() * (height + clues.get("theme_override_constants/separation")) +32;
	menu_background.hide();
	
	
