extends Control

@onready var tatics: Control = $Tatics
@onready var clue_action_menu: Control = $ClueActionMenu
@onready var item_action_menu: Control = $ItemActionMenu

var tattics_scene : PackedScene = preload("res://scenes/ui/taticsActionButton/tactic_button.tscn");

func _ready() -> void:
	_make_connections();
	_on_hide();
	
	
func _make_connections() -> void:
	EventManager.combat_state_changed.connect(_on_combat_state_changed);
	EventManager.start_combat.connect(_on_start_combat);
	clue_action_menu.pressed.connect(_on_clue_pressed);
	item_action_menu.pressed.connect(_on_item_pressed);
	
	
func _on_combat_state_changed(state : String) ->void:
	match state.to_upper():
		"PLAYER_TURN":
			_on_show();
		"NPC_TURN", "IN_DIALOG", "SHUTTING_DOWN_COMBAT":
			_on_hide();
	
	
func _on_start_combat(_camera : Camera3D) -> void:
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
		
	
func _on_item_pressed() -> void:
	if !item_action_menu.is_open:
		_hide_all_but(item_action_menu,item_action_menu.set_is_open.bind(true))
	else:
		_show_all();
		item_action_menu.set_is_open(false);
		
		
func _on_clue_pressed() -> void:
	if !clue_action_menu.is_open:
		_hide_all_but(clue_action_menu,clue_action_menu.set_is_open.bind(true))
	else:
		_show_all();
		clue_action_menu.set_is_open(false);
	
func _on_hide() -> void:
	if visible:
		item_action_menu.set_is_open(false);
		clue_action_menu.set_is_open(false);
		
		var tween = create_tween();
		tween.stop();
		for index in get_child_count():
			var child = get_child(get_child_count()-1 - index);
			tween.tween_property(child,"modulate",Color(Color.WHITE,0.0), 0.02);
		tween.tween_callback(hide);
		tween.play();
	
func _on_show() -> void:
	if !visible:
		var tween = create_tween();
		tween.stop();
		tween.tween_callback(show);
		for index in get_child_count():
			var child = get_child(index);
			tween.tween_property(child,"modulate",Color(Color.WHITE,1.0), 0.04);
		
		tween.play();
	
	
func _hide_all_but(exclude : Control, callable : Callable ,fade_speed : float = 0.02)->void:
	var tween = create_tween();
	tween.stop();
	for index in get_child_count():
		var child = get_child(get_child_count()-1 - index);
		if child != exclude:
			tween.tween_property(child,"modulate",Color(Color.WHITE,0.0),fade_speed);
#	tween.finished.connect(callable);
	callable.call();
	tween.play();
	
func _show_all(fade_speed : float = 0.1)->void:
	var tween = create_tween();
	tween.stop();
	
	for index in get_child_count():
		var child = get_child(index);
		tween.tween_property(child,"modulate",Color(Color.WHITE,1.0),fade_speed);
			
	tween.play();
