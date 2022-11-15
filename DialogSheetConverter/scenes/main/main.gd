extends Control


@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var charm: LineEdit = $VBoxContainer/Charm
@onready var logic: LineEdit = $VBoxContainer/Logic
@onready var deception: LineEdit = $VBoxContainer/DECEPTION
@onready var intimidation: LineEdit = $VBoxContainer/INTIMIDATION

var timer = Timer.new();
var update_time = 0.1;

func _ready() -> void:
	add_child(timer);
	_make_connections();
	timer.start(update_time);
	
	
func _make_connections() -> void:
	charm.text = str(SystemGlobals.player_stats.CHARM);
	logic.text = str(SystemGlobals.player_stats.LOGIC);
	deception.text = str(SystemGlobals.player_stats.DECEPTION);
	intimidation.text = str(SystemGlobals.player_stats.INTIMIDATION);
	timer.timeout.connect(_on_time_out);
	
	
func _on_charm_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		SystemGlobals.player_stats.CHARM = new_text.to_float();
	
	
func _on_logic_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		SystemGlobals.player_stats.LOGIC = new_text.to_float();
	
	
func _on_deception_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		SystemGlobals.player_stats.DECEPTION = new_text.to_float();
	
	
func _on_intimidation_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		SystemGlobals.player_stats.INTIMIDATION = new_text.to_float();
	
	
func _on_time_out() -> void:
	rich_text_label.text = JSON.stringify(SystemGlobals.dialog_profiles,"\t");
	timer.start(update_time);
