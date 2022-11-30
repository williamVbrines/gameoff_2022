extends Button

const PRESSED_SCALE : Vector2 = Vector2(0.2,0.2)

@onready var tool_tip: Control = $ToolTip
@onready var tool_tip_label: Label = $ToolTip/Label
@onready var texture: TextureRect = $Texture
@onready var down_audio: AudioStreamPlayer = $DownAudio
@onready var up_audio: AudioStreamPlayer = $UpAudio
@onready var backing: TextureRect = $Texture/Backing
@onready var tactic_icon: TextureRect = $Texture/ICON

var data_id : String = "test" : set = set_data_id, get = get_data_id;
var data : Resource = null;

var is_draging : bool = false;
var orgin : Vector2 = Vector2.ZERO;

var slot_points : Array[Vector2] = [Vector2(60,200)] : set = set_slot_points;
const SLOT_MIN_DIST : float = 100;
const SLOTED_SCALE : Vector2 = Vector2(0.7,0.7)

var frames : Array = [
	preload("res://textures/ui/LoadoutAndPauseMenu/Diamond/Tactic List Diamond (Smaller)/Loadout_TacticList_Diamond_Lv1.png"),
	preload("res://textures/ui/LoadoutAndPauseMenu/Diamond/Tactic List Diamond (Smaller)/Loadout_TacticList_Diamond_Lv2.png"),
	preload("res://textures/ui/LoadoutAndPauseMenu/Diamond/Tactic List Diamond (Smaller)/Loadout_TacticList_Diamond_Lv3.png")
]

@export var colors : Array[Color];
@export var default_icons : Array[Texture];

signal sloted(id : String ,num : int);

func set_data_id( val :String) -> void:
	data_id = val;
	
	
func get_data_id() -> String:
	return data_id;
	
	
func set_slot_points(points : Array[Vector2])->void:
	slot_points = points.duplicate();
	
func _ready() -> void:
	orgin = global_position;
	if data == null:
		data = ResourceManager.get_tactic(data_id);
		data_id = data.name
	var tex = null;
	if data is TacticsData:
		print(data.name)
		match data.ratting:
			TacticsData.LOW: tex = frames[0];
			TacticsData.MED: tex = frames[1];
			TacticsData.HIGH: tex = frames[2];
		
		match data.stat:
			TacticsData.CHARM:
				backing.modulate = colors[1];
				tactic_icon.texture = default_icons[0];
			TacticsData.DECEPTION:
				backing.modulate = colors[2];
				tactic_icon.texture = default_icons[1];
			TacticsData.INTIMIDATION:
				backing.modulate = colors[3];
				tactic_icon.texture = default_icons[2];
			TacticsData.LOGIC:
				backing.modulate = colors[4];
				tactic_icon.texture = default_icons[3];
				
		if data.icon != null:
			tactic_icon.texture = data.icon;
			
			
		texture.set_texture(tex);
	
		tool_tip_label.set_text(data.discrtiption + " Cost: " + str(data.cost));
	
	_make_connections();
	
	
func _make_connections() -> void:
	button_down.connect(_on_pressed);
	button_up.connect(_on_up);
	mouse_entered.connect(_on_show_tooltip);
	mouse_exited.connect(_on_hide_tooltip);
	
func _on_up()->void:
	up_audio.play_rand();
	_on_released();
		
func _on_pressed() -> void:
	down_audio.play_rand();
	is_draging = true;
	texture.scale += PRESSED_SCALE;
	texture.position = -(texture.size * texture.scale)/2 + size/2
	_on_hide_tooltip()
	
	
func _on_released() ->void:
	
	is_draging = false;
	texture.scale = Vector2(1,1);
	texture.position = -(texture.size * texture.scale)/2 + size/2
	
	for index in slot_points.size():
		var point = slot_points[index]
		if (point - global_position).length() <= SLOT_MIN_DIST:
			global_position = point;
			texture.scale = Vector2.ONE + SLOTED_SCALE;
			texture.position = -(texture.size * texture.scale)/2 + size/2
			sloted.emit(data_id,index)
			return;
			
	_on_return_to_orgin();
	
	
func _input(event: InputEvent) -> void:
	if is_draging:
		if event is InputEventMouseMotion:
			global_position = event.position - size/2;
	
	
func _on_show_tooltip() -> void:
	var tween =create_tween();
	tween.stop();
	
	tween.tween_property(tool_tip,"scale",Vector2(1,1),0.1);
	
	tween.play()
	
	
func _on_hide_tooltip() -> void:
	var tween =create_tween();
	tween.stop();
	
	tween.tween_property(tool_tip,"scale",Vector2(1,0),0.1);
	
	tween.play()
	
	
func _on_return_to_orgin():
	var tween = create_tween();
	tween.stop();
	
	tween.tween_property(self,"global_position",orgin,(global_position - orgin).length() * 0.0005);
	
	tween.play();
	
	
func store_data() -> void:
	for index in slot_points.size():
		var point = slot_points[index]
		if (point - global_position).length() <= SLOT_MIN_DIST:
			match index:
				0:
					SystemGlobals.player_tactics["SLOT:1"] = data.name;
				1:
					SystemGlobals.player_tactics["SLOT:2"] = data.name;
				2:
					SystemGlobals.player_tactics["SLOT:3"] = data.name;
					
			return;
		
