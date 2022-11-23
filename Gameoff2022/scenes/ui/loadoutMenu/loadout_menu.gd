extends Control

@onready var slots: VBoxContainer = $pointTextuers/Slots
@onready var back_ground: Control = $BackGround
@onready var labels: Control = $BackGround/Labels
@onready var selection: Control = $pointTextuers/Selection
var dragable_scene = preload("res://scenes/ui/pauseMenu/tatic_darg_able/tatic_drag_able.tscn")
@onready var dragables: Control = $Dragables

var slot_points : Array[Vector2] = [];

signal closed();

var open : bool = false : get = is_open;

func is_open() -> bool:
	return open;
	
func set_open(val : bool) -> void:
	open = val;
	
func _ready() -> void:
	_make_connections();
	for slot in slots.get_children():
		slot_points.append(slot.global_position + slot.size/5)
	
#	open_loadout();
	
func _make_connections() -> void:
	pass
	
	
func open_loadout() -> void:
	
	gen_dragables();
	_open_anim()
	
	
func close_loadout() -> void:
	_close_anim();
	_store_loadout();
	
	
func _store_loadout() -> void:
	SystemGlobals.player_tactics["SLOT:1"] = "";
	SystemGlobals.player_tactics["SLOT:2"] = "";
	SystemGlobals.player_tactics["SLOT:3"] = "";
	
	for t in dragables.get_children():
		for child in t.get_children():
			child.store_data();


func _open_anim() -> void:
	var tween = create_tween();
	back_ground.scale = Vector2(0,1);
	back_ground.show();
	
	tween.stop();
	
	tween.tween_property(back_ground,"scale", Vector2(1,1), 0.2);
	
	for label in labels.get_children():
		tween.tween_property(label, "modulate", Color(Color.WHITE,1.0), 0.05);
	
	for slot in slots.get_children():
		tween.tween_property(slot, "modulate", Color("b5b5b5b5", 0.7), 0.05);
		
	for type in selection.get_children():
		for tex in type.get_children():
			tween.tween_property(tex, "modulate", Color("b5b5b5b5", 0.7), 0.03);
			
	for t in dragables.get_children():
		for child in t.get_children():
			tween.tween_property(child, "modulate", Color(Color.WHITE, 1.0), 0.1);
			
	tween.tween_callback(set_open.bind(true));
	tween.play();
	

func _close_anim() -> void:
	var tween = create_tween();
	back_ground.scale = Vector2(1,1);
	back_ground.show();
	
	tween.stop();
	
	for t in dragables.get_children():
		for child in t.get_children():
			tween.tween_property(child, "modulate", Color(Color.WHITE, 0.0), 0.1);
			
	for type_index in selection.get_child_count():
		var type = selection.get_child(selection.get_child_count() - type_index -1)
		for tex_index in type.get_child_count():
			var tex = type.get_child(type.get_child_count() - tex_index -1)
			tween.tween_property(tex, "modulate", Color("b5b5b5b5", 0.0), 0.03);
	
	for slot_index in slots.get_child_count():
		var slot = slots.get_child(slots.get_child_count() - slot_index -1)
		tween.tween_property(slot, "modulate", Color("b5b5b5b5", 0.0), 0.05);
		
	for label_index in labels.get_child_count() :
		var label = labels.get_child(labels.get_child_count() - label_index -1)
		tween.tween_property(label, "modulate", Color(Color.WHITE,0.0), 0.05);
		
	tween.tween_property(back_ground,"scale", Vector2(0,1), 0.2);
	tween.tween_callback(back_ground.hide);
	tween.tween_callback(call_deferred.bind("emit_signal", "closed"));
	tween.tween_callback(set_open.bind(false));
	tween.play();
	
	
func gen_dragables()->void:
	for t in dragables.get_children():
		for child in t.get_children():
			t.remove_child(child);
			child.queue_free();

	for id in SystemGlobals.player_tactics.AVAILABLE:
		if id == SystemGlobals.player_tactics.get("SLOT:1"):
			set_up_sloted(ResourceManager.get_tactic(id),0);
		elif id == SystemGlobals.player_tactics.get("SLOT:2"):
			set_up_sloted(ResourceManager.get_tactic(id),1);
		elif id == SystemGlobals.player_tactics.get("SLOT:3"):
			set_up_sloted(ResourceManager.get_tactic(id),2);
		else:
			set_up_nonsloted(ResourceManager.get_tactic(id));

func set_up_nonsloted(data):
	var new_dargable = dragable_scene.instantiate();
	new_dargable.slot_points = slot_points;
	
	match data.stat:
		TacticsData.CHARM:
			new_dargable.global_position = selection.get_child(0).get_child(dragables.get_child(1).get_child_count()).global_position
			dragables.get_child(1).add_child(new_dargable);
		TacticsData.LOGIC:
			new_dargable.global_position = selection.get_child(1).get_child(dragables.get_child(2).get_child_count()).global_position
			dragables.get_child(2).add_child(new_dargable);
		TacticsData.DECEPTION:
			new_dargable.global_position = selection.get_child(2).get_child(dragables.get_child(3).get_child_count()).global_position
			dragables.get_child(3).add_child(new_dargable);
		TacticsData.INTIMIDATION:
			new_dargable.global_position = selection.get_child(3).get_child(dragables.get_child(4).get_child_count()).global_position
			dragables.get_child(4).add_child(new_dargable);

	new_dargable._on_released();
	
func set_up_sloted(data , slot_num):
	var p = Vector2.ZERO;
	var new_dargable = dragable_scene.instantiate();
	
	match data.stat:
		TacticsData.CHARM:
			p = selection.get_child(0).get_child(dragables.get_child(1).get_child_count()).global_position
		TacticsData.LOGIC:
			p = selection.get_child(1).get_child(dragables.get_child(2).get_child_count()).global_position
		TacticsData.DECEPTION:
			p = selection.get_child(2).get_child(dragables.get_child(3).get_child_count()).global_position
		TacticsData.INTIMIDATION:
			p = selection.get_child(3).get_child(dragables.get_child(4).get_child_count()).global_position
	
	new_dargable.global_position = p;
	new_dargable.slot_points = slot_points;
	dragables.get_child(0).add_child(new_dargable);
	new_dargable.global_position = slots.get_child(slot_num).global_position;
	
	new_dargable._on_released();
