extends Control

@onready var back_ground: Control = $BackGround
@onready var labels: Control = $BackGround/Labels
@onready var selection: Control = $Selection
@onready var open_audio: AudioStreamPlayer = $OpenAudio
@onready var close_audio: AudioStreamPlayer = $CloseAudio
@onready var pressed_audio: AudioStreamPlayer = $PressedAudio

var clue_scene = preload("res://scenes/ui/itemsSelectable/item_selectable.tscn");

signal closed();

var open : bool = false : get = is_open;

func set_open(val : bool) -> void:
	open = val;
	
func is_open() -> bool:
	return open;
	
func _ready() -> void:
	_make_connections();
	
#	open_loadout();
	
func _make_connections() -> void:
	pass
	
	
func open_loadout() -> void:
	
	gen_selection();
	
	_open_anim()
	
	
func close_loadout() -> void:
	
	_close_anim();
	
	
	
func _store_data() -> void:
	SystemGlobals.player_items = [];
	
	for child in selection.get_children():
		child.store_data();
	
	
func _open_anim() -> void:
	var tween = create_tween();
	back_ground.scale = Vector2(0,1);
	back_ground.show();
	
	tween.stop();
	tween.tween_callback(open_audio.play_rand)
	tween.tween_property(back_ground,"scale", Vector2(1,1), 0.2);
	
	for label in labels.get_children():
		tween.tween_property(label, "modulate", Color(Color.WHITE,1.0), 0.05);
		
	for child in selection.get_children():
		tween.tween_property(child, "modulate", Color(Color.WHITE, 1.0), 0.03);
			
	
	tween.tween_callback(set_open.bind(true));
		
	tween.play();

func _close_anim() -> void:
	var tween = create_tween();
	back_ground.scale = Vector2(1,1);
	back_ground.show();
	
	tween.stop();
	for type_index in selection.get_child_count():
		var type = selection.get_child(selection.get_child_count() - type_index -1)
		for tex_index in type.get_child_count():
			var tex = type.get_child(type.get_child_count() - tex_index -1)
			tween.tween_property(tex, "modulate", Color(Color.WHITE, 0.0), 0.03);
		
	for label_index in labels.get_child_count() :
		var label = labels.get_child(labels.get_child_count() - label_index -1)
		tween.tween_property(label, "modulate", Color(Color.WHITE,0.0), 0.05);
	
	tween.tween_callback(close_audio.play_rand)
	tween.tween_property(back_ground,"scale", Vector2(0,1), 0.2);
	tween.tween_callback(back_ground.hide);
	tween.tween_callback(call_deferred.bind("emit_signal", "closed"));
	
	tween.tween_callback(_store_data);
	
	tween.tween_callback(set_open.bind(false));
		
	tween.play();
	
func gen_selection()->void:
	
	for child in selection.get_children():
		selection.remove_child(child);
		child.queue_free();

	for id in SystemGlobals.player_items:
		var new_clue = clue_scene.instantiate();
		new_clue.set_data(ResourceManager.get_item_data(id));
		selection.add_child(new_clue);


