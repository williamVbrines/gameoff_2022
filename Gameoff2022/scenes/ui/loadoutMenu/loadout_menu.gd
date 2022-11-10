extends Control

@onready var close_button: Button = $PoupPanel/CloseButton
@onready var slots_container: VBoxContainer = $PoupPanel/SlotsContainer
@onready var loadout_button: Button = $ChangeLoadoutButton
@onready var poup_panel: Panel = $PoupPanel
@onready var save_button: Button = $PoupPanel/SaveButton


func _ready() -> void:
	_make_connections();
	poup_panel.hide();

func _make_connections() -> void:
	loadout_button.pressed.connect(_on_change_loadout);
	close_button.pressed.connect(_on_close_loadout);
	save_button.pressed.connect(_on_save_loadout);
	
func _on_change_loadout() -> void:
	poup_panel.show();
	loadout_button.hide();
	
	
func _on_close_loadout() -> void:
	poup_panel.hide();
	loadout_button.show();
	
	
func _on_save_loadout() -> void:
	pass
