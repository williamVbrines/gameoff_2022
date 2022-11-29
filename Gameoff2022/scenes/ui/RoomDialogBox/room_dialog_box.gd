extends Control

@onready var button: Button = $Button
@onready var text_label: Label = $Background/Text
@onready var background: NinePatchRect = $Background
@onready var player: VoiceBoxPlayer = $VoiceBoxPlayer

var disengageing : bool = false;
var in_dialog : bool = false;
var temp_data : Dictionary = { "cost" : 0, "dialog" : "Hello how are you are you feeling well. I sure hope so the potluck is the day affter today."};

var line : int = 0;

func _ready() -> void:
	make_connections();
	hide();
#	_on_display_dialog("ME", {"dialog" : ["Hello there", "Time to get to work"]})#Test

func make_connections()->void:
	EventManager.disengage.connect(_on_disengage);
	EventManager.display_dialog.connect(_on_display_dialog);
	
	
func _on_disengage(dialog : String) -> void:
	var data = {
		"dialog" : dialog
	}
	disengageing = true;
	_on_display_dialog("PLayer", data);
	
	
func _on_display_dialog(_actor : String,  data : Dictionary):
	in_dialog = true;
	temp_data = data;
	line = 0;
	text_label.text =  temp_data.dialog[line] if temp_data.dialog.size() != 0 else "";
	_show_dialog_box_anim();
	
func _on_dialog_exit() -> void:
	_hide_dialog_box_anim();
	text_label.text = "";
	in_dialog = false;
	
	if disengageing:
#		EventManager.call_deferred("emit_signal", "");
		disengageing = false;
#	else:
#		EventManager.change_battel_queue.emit(temp_actor, temp_data.cost);
#		EventManager.call_deferred("emit_signal", "combat_state_changed","ADJUST_Q");
	
	
func _on_button_pressed() -> void:
	if in_dialog:
		line += 1;
		if  line >= temp_data.dialog.size():
			_on_dialog_exit();
			return;
		text_label.visible_characters = 0;
		text_label.text =  temp_data.dialog[line] if temp_data.dialog.size() != 0 else "";
		player.play_text();
		
	
	
func _show_dialog_box_anim() -> void:
	var tween = create_tween();
	text_label.visible_characters = 0;
	
	show();
	tween.stop();
	tween.tween_callback(background.show);
	tween.tween_property(background,"modulate",Color(Color.WHITE, 1.0), 0.5)
	tween.tween_callback(player.play_text)
	tween.play();
	
	
func _hide_dialog_box_anim() -> void:
	var tween = create_tween();
	tween.stop();
	tween.tween_property(background,"modulate",Color(Color.WHITE, 0.0), 0.5)
	tween.tween_callback(background.hide);
	tween.tween_callback(hide);
	tween.play();

