extends Control

@export var fade_time : float = 1.0;
@onready var color_rect: ColorRect = $ColorRect
@onready var attack_comand: LineEdit = $UI/AttackComand

@onready var ui: Control = $UI

@onready var pers_label: Label = $UI/VBoxContainer/PersLabel
@onready var annoy_label: Label = $UI/VBoxContainer/AnnoyLabel

func _ready() -> void:
	ui.visible = false;
	
	EventManager.start_combat.connect(_on_start_combat);
	attack_comand.text_submitted.connect(_on_attack_entered);
	attack_comand.text_changed.connect(_on_attack_line_changed);
	
func _on_start_combat(camera : Camera3D) -> void:
	var tween = create_tween();
	tween.pause();
	tween.tween_property(color_rect,"color",Color(0, 0, 0, 1),fade_time);
	tween.tween_property(color_rect,"color",Color(0, 0, 0, 1),fade_time);
	tween.tween_callback(camera.set_current.bind(true));
	
	tween.tween_property(color_rect,"color",Color(0, 0, 0, 0),fade_time);
	tween.tween_callback(set_attack_useable.bind(true));
	tween.tween_callback(ui.set_visible.bind(true));
	
	tween.play();
	
	
func set_attack_useable(val : bool) -> void:
	print("ready for combat")
	attack_comand.set_editable(true);
	
	
	
func _on_attack_line_changed(text : String) -> void:
	text = "{" + text + "}";
	var data = JSON.parse_string(text);
	
	var color = Color.RED;
	
	
	if data:
		if data.size() == 2 && data.has_all(["type","amount"]):
			color = Color.LAWN_GREEN;
	
	attack_comand.set("theme_override_colors/font_color", color);
		
		

func _on_attack_entered(text : String) -> void:
	
	text = "{" + text + "}";
	var data = JSON.parse_string(text);
	print("!!Attack!!")
	print(data)
	if data.size() == 2 && data.has_all(["type","amount"]):
		EventManager.attack.emit("Player", data, self);
		attack_comand.set_text("");
		
