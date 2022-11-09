extends Control

@export var fade_time : float = 1.0;
@onready var color_rect: ColorRect = $ColorRect
@onready var attack_comand: LineEdit = $UI/AttackComand

@onready var ui: Control = $UI

@onready var pers_label: Label = $UI/PersLabel
@onready var annoy_label: Label = $UI/AnnoyLabel
var opponent : String = "";
var annoyance := 0;

func _ready() -> void:
	ui.visible = false;
	connect_signals();
	
func connect_signals() -> void:
	EventManager.start_combat.connect(_on_start_combat);
	EventManager.persuasion_changed.connect(_on_persuasion_changed);
	EventManager.annoyance_changed.connect(_on_annoyance_changed)
	EventManager.combat_state_changed.connect(_on_combat_state_changed);
	EventManager.attack.connect(_on_attack);
	
	attack_comand.text_submitted.connect(_on_attack_entered);
	attack_comand.text_changed.connect(_on_attack_line_changed);
	
	

func _on_combat_state_changed(state : String) ->void:
	
	match state.to_upper():
		"NPC_TURN":
			_hide_player_actions();
		"PLAYER_TURN":
			_show_player_actions();
		"CHECK_LOSS":
			_check_if_enraged();
		
func _check_if_enraged() -> void:
	if annoyance == 100:
		EventManager.combat_state_changed.emit("LOSS");
	else:
		EventManager.combat_state_changed.emit("CHECK_Q");
		
func _on_attack(target : String,data : Dictionary, sender)->void:
	if target.to_upper() != "PLAYER": return;
	
	var damage = data.amt;
	
#	if damage_dist.has(data.type):
#		damage *= damage_dist.get(data.type);
#		damage += damage_dist.get(data.type + "_f");
#
	damage = max(0,damage);

	annoyance += damage;

	EventManager.annoyance_changed.emit(annoyance);

	EventManager.change_battel_queue.emit("NPC", data.cost)
	
	EventManager.combat_state_changed.emit("CHECK_LOSS")
	
func _show_player_actions() -> void:
	set_attack_useable(true);
	EventManager.combat_state_changed.emit("PLAYER_ACTION_SELECT");
	
	
func _hide_player_actions() -> void:
	set_attack_useable(false);
	EventManager.combat_state_changed.emit("NPC_ACTION_SELECT");
	
func _on_start_combat(with : String, camera : Camera3D) -> void:
	var tween = create_tween();
	
	opponent = with;
	
	tween.pause();
	tween.tween_property(color_rect,"color",Color(0, 0, 0, 1),fade_time);
	tween.tween_property(color_rect,"color",Color(0, 0, 0, 1),fade_time);
	
	tween.tween_callback(camera.set_current.bind(true));
	tween.tween_callback(set_attack_useable.bind(false));
	tween.tween_callback(ui.set_visible.bind(true));
	
	tween.tween_property(color_rect,"color",Color(0, 0, 0, 0),fade_time);
	
	tween.tween_callback(_change_state.bind("CHECK_Q"));
	
	tween.play();
	
	
func set_attack_useable(val : bool) -> void:
	attack_comand.set_editable(val);
	attack_comand.set_visible(val);
	
	
func _on_attack_line_changed(text : String) -> void:
	text = "{" + text + "}";
	var data = JSON.parse_string(text);
	
	var color = Color.RED;
	
	if data:
		if data.size() == 3 && data.has_all(["type","amt","cost"]):
			color = Color.LAWN_GREEN;
	
	attack_comand.set("theme_override_colors/font_color", color);
	
	
func _on_attack_entered(text : String) -> void:
	
	text = "{" + text + "}";
	var data = JSON.parse_string(text);
#	"type" : "charm", "amt" : 100, "cost" : 2
	if data.size() == 3 && data.has_all(["type","amt","cost"]):
		set_attack_useable(false);
		attack_comand.set_text("");
		
		EventManager.combat_state_changed.emit("PLAYER_ACTION_RESOLVE");
		EventManager.attack.emit(opponent, data, self);
		
	
	
	
func _on_persuasion_changed(val : float) -> void:
	pers_label.set_text("Persuasion " + str(val));
	
func _on_annoyance_changed(val : float) -> void:
	annoy_label.set_text("Annoyance " + str(val));
	
	

func _change_state(state : String): EventManager.combat_state_changed.emit(state);
	
	
