extends Node3D

var dialog_id : String = "smith";
@onready var npc_mesh: MeshInstance3D = $RootNode/Skeleton3D/unamed
@onready var interactable_area: Area3D = $InteractableArea3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var selected : bool = false;

func _ready() -> void:
	animation_player.play("idel");
	if !npc_mesh || !interactable_area:
		printerr("BAD NODE PATH!!!")
		queue_free();
		return;
		
	_make_connections();
	
	
func _make_connections() -> void:
	interactable_area.area_unhovered.connect(_unhovered);
	interactable_area.area_hovered.connect(_hovered);
	interactable_area.area_pressed.connect(_on_pressed);
	
	EventManager.start_exploration.connect(_on_start_exploration);
	EventManager.dialog_ended.connect(_on_dialog_eneded);
	
	
func _on_dialog_eneded() -> void:
	selected = false;
	
	
func _on_start_exploration() -> void:
	selected = false;
	
func _hovered()->void:
	npc_mesh.get_active_material(0).get("next_pass").set("shader_parameter/str",1);
	
	
func _unhovered()->void:
	npc_mesh.get_active_material(0).get("next_pass").set("shader_parameter/str",300.0);
	
	
func _on_pressed() -> void:
	if !selected:
		EventManager.start_dialog.emit(dialog_id);
		selected = true;
	