extends Control
@onready var button: Button = $Button
@onready var text_label: Label = $Text

var disengageing : bool = false;
var in_dialog : bool = false;
var temp_data : Dictionary = {};
var temp_actor : String = "";

func _ready() -> void:
	make_connections();
	hide();

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
	show();
	
	EventManager.combat_state_changed.emit("IN_DIALOG");
	in_dialog = true;
	temp_data = data;
	temp_actor = actor;
	
	text_label.text = temp_data.dialog if temp_data.dialog != "" else "NOTHING";
	
func _on_dialog_exit() -> void:
	hide();
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
