extends Control

@export var data : Resource : set = set_data;
@onready var frame: TextureRect = $Frame
@onready var tag_button: Button = $TagButton
@onready var discription_label: Label = $TaticDiscriptionLabel
@onready var cost_counter_tag: Control = $TagButton/CostCounterTag
@onready var opt_select_audio: AudioStreamPlayer = $OptSelectAudio

var frames : Array = [
	preload("res://textures/ui/Battle/Menu/Menu Buttons/Diamond/BattleMenu_ListItem_Diamond_Lv1.png"),
	preload("res://textures/ui/Battle/Menu/Menu Buttons/Diamond/BattleMenu_ListItem_Diamond_Lv2.png"),
	preload("res://textures/ui/Battle/Menu/Menu Buttons/Diamond/BattleMenu_ListItem_Diamond_Lv3.png")
]

func _init(new_data : TacticsData = null) -> void:
	set_data(new_data if new_data else data);
	
	
func _ready() -> void:
	if !data: 
		queue_free();
		return;
	_make_connections();
	_set_up();
	
	
func _make_connections() -> void:
	EventManager.start_combat.connect(_on_start_combat);
	tag_button.pressed.connect(_on_pressed);
	
	
func _set_up() -> void:
	var tex : Texture = null;
	if data is TacticsData:
		match data.ratting:
			TacticsData.LOW: tex = frames[0];
			TacticsData.MED: tex = frames[1];
			TacticsData.HIGH: tex = frames[2];
		
		frame.set_texture(tex);
	
		discription_label.set_text(data.discrtiption);
	
		cost_counter_tag.set_cost(data.cost);
	
func _on_start_combat(_cam : Camera3D) -> void:
	if !data: 
		queue_free();
		return;
		
	set_data(data);
	
	
func set_data(new_data : TacticsData) -> void:
	if !new_data: return;
		
	data = new_data;
	
	
func _on_pressed() -> void:
	opt_select_audio.play_rand();
	_on_attack();
	
	
func _on_attack() -> void:
	EventManager.combat_state_changed.emit("PLAYER_ACTION_RESOLVE");
	EventManager.attack.emit(SystemGlobals.opponent, data.gen_attack_info());	
	
	
