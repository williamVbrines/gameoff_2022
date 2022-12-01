extends Node3D

@onready var error_notification: Sprite3D = $ErrorNotification

@onready var attack_audio: AudioStreamPlayer = $AttackAudio
@onready var heal_audio: AudioStreamPlayer = $HealAudio
@onready var heal_particles: GPUParticles3D = $HealParticles
@onready var player_mesh: MeshInstance3D = $PlayerMesh

@export var npc_res : Resource;
@export_node_path(MeshInstance3D) var npc_mesh;
@export_node_path(Area3D) var interactable_area;
@export_node_path(Camera3D) var camera;
var dialog_id : String = "wizard";

var selected : bool = false;

signal chest_opened();

func _on_dialog_eneded() -> void:
	if !SystemGlobals.in_battel:
		selected = false;
		_hovered();
		error_notification.show();
	else:
		SystemGlobals.opponent = name;
		SystemGlobals.in_battel = true;
		
#		EventManager.call_deferred.bind("emit_signal","start_combat",camera)
		EventManager.start_combat.emit(camera);
		player_mesh.show();
		selected = true;
		error_notification.hide();
		_unhovered();

func _ready() -> void:
	npc_mesh = get_node(npc_mesh) as MeshInstance3D;
	interactable_area = get_node(interactable_area) as InteractableArea3D;
	camera = get_node(camera) as Camera3D;
	if !npc_mesh || !camera || !interactable_area:
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
	EventManager.dialog_emit.connect(_on_dialog_emit);
	
	npc_res.selected_action.connect(_on_action_selected);
	
func _on_start_exploration() -> void:
	player_mesh.hide();
	error_notification.show();
	_hovered();
	selected = false;
	
	
func _hovered()->void:
	npc_mesh.get_active_material(0).get("next_pass").set("shader_parameter/str",1);
	
	
func _unhovered()->void:
	npc_mesh.get_active_material(0).get("next_pass").set("shader_parameter/str",300.0);
	
	
func _on_dialog_emit(cmd) -> void:
	
	if cmd == "StartBattle":
		SystemGlobals.opponent = name;
		SystemGlobals.in_battel = true
	
	
func _on_pressed() -> void:
	if !selected && get_tree().paused == false:
		error_notification.hide();
		_unhovered();
		SystemGlobals.opponent = name;
		EventManager.start_dialog.emit(dialog_id);
		selected = true;
	
	
func _on_action_selected(action) -> void:
	match action:
		NPCTactics.ATTACK:
			attack_audio.play_rand();

		NPCTactics.HEAL:
			heal_audio.play_rand();
			var tween = create_tween();
			tween.tween_callback(heal_particles.set_emitting.bind(true));
			tween.tween_interval(heal_audio.stream.get_length() + 0.5);
			tween.tween_callback(heal_particles.set_emitting.bind(false));
	
