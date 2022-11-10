extends Control
@onready var button: Button = $Button
@onready var text_label: Label = $Text

var disengageing : bool = false;
var in_dialog : bool = false;
var temp_data : Dictionary = {};
var temp_actor : String = "";

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
	show();
	
	EventManager.combat_state_changed.emit("IN_DILOG");
	in_dialog = true;
	temp_data = data;
	temp_actor = actor;
	
func _on_dialog_exit() -> void:
	hide();
	text_label.text = "";
	in_dialog = false;
	
	if disengageing:
		EventManager.combat_state_changed.emit("SHUTTING_DOWN_COMBAT");
	else:
		EventManager.change_battel_queue.emit(temp_actor, temp_data.cost)
		if temp_actor.to_upper() == "PLAYER":
			EventManager.combat_state_changed.emit("CHECK_WIN");
		else :
			EventManager.combat_state_changed.emit("CHECK_LOSS");


func _on_button_pressed() -> void:
	if in_dialog:
		_on_dialog_exit();
