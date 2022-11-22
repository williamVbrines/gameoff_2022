extends Control
@onready var button: Button = $Button
@onready var text_label: RichTextLabel = $Background/Text
@onready var background: NinePatchRect = $Background
@onready var player: VoiceBoxPlayer = $VoiceBoxPlayer
@onready var name_label: RichTextLabel = $Background/Name

var disengageing : bool = false;
var in_dialog : bool = false;
var temp_data : Dictionary = { "cost" : 0, "dialog" : "Hello how are you are you feeling well. I sure hope so the potluck is the day affter today."};
var temp_actor : String = "";

const box_size : Vector2 = Vector2(1920,270);

func _ready() -> void:
	make_connections();
	

func make_connections()->void:
	EventManager.disengage.connect(_on_disengage);
	EventManager.display_dialog.connect(_on_display_dialog);
	
	
func _on_disengage(dialog : String) -> void:
	var data = {
		"dialog" : dialog
	}
	disengageing = true;
	_on_display_dialog("PLayer", data);
	
	
func _on_display_dialog(actor : String,  data : Dictionary):
	
	
	EventManager.combat_state_changed.emit("IN_DIALOG");
	in_dialog = true;
	temp_data = data;
	temp_actor = actor;
	name_label.text = actor;
	text_label.text = temp_data.dialog if temp_data.dialog != "" else "NOTHING";
	_show_dialog_box_anim();
	
func _on_dialog_exit() -> void:
	_hide_dialog_box_anim();
	text_label.text = "";
	in_dialog = false;
	
	if disengageing:
		EventManager.call_deferred("emit_signal", "combat_state_changed","SHUTTING_DOWN_COMBAT");
		disengageing = false;
	else:
		EventManager.change_battel_queue.emit(temp_actor, temp_data.cost);
		EventManager.call_deferred("emit_signal", "combat_state_changed","ADJUST_Q");
	
	
func _on_button_pressed() -> void:
	if in_dialog:
		_on_dialog_exit();
	
	
func _show_dialog_box_anim() -> void:
	var tween = create_tween();
	text_label.visible_characters = 0;
	
	show();
	tween.stop();
	tween.tween_property(background,"position",Vector2(0, 1080 - box_size.y), 0.5)
	tween.tween_callback(player.play_text)
	tween.play();
	
	
func _hide_dialog_box_anim() -> void:
	var tween = create_tween();
	tween.stop();
	tween.tween_property(background,"position",Vector2(0, 1080 + box_size.y), 0.5)
	tween.tween_callback(hide);
	tween.play();
