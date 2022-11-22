extends Control

@onready var pause_button: TextureButton = $PauseButton
@onready var resume_button: Button = $SideBar/Selection/ResumeButton
@onready var side_bar: Control = $SideBar
@onready var selection: VBoxContainer = $SideBar/Selection
@onready var back_ground: Control = $SideBar/BackGround

@onready var load_out_button: Button = $SideBar/Selection/LoadOutButton
@onready var loadout_menu: Control = $LoadoutMenu

func _ready() -> void:
	_make_connections();
	process_mode = Node.PROCESS_MODE_ALWAYS;
	
func _make_connections() -> void:
	pause_button.pressed.connect(_on_pause_pressed);
	resume_button.pressed.connect(_on_resume_pressed);
	load_out_button.toggled.connect(_on_loadout_toggled);
	
	EventManager.start_combat.connect(_on_start_combat);
	EventManager.start_exploration.connect(_show_anim);
	
	EventManager.start_dialog.connect(_on_start_dialog);
	EventManager.dialog_ended.connect(_show_anim);
	
	
func _on_start_combat(_cam : Camera3D) -> void:
	if get_tree().paused == false:
		_hide_anim();
	
	
func _on_start_dialog(_id : String) -> void:
	if get_tree().paused == false:
		_hide_anim();
	
	
func _hide_anim() -> void:
	var tween = create_tween()
	tween.stop();
	
	tween.tween_property(self,"modulate", Color(Color.WHITE, 0.0), 0.5);
	
	tween.play();
	
	
func _show_anim() -> void:
	var tween = create_tween()
	tween.stop();
	
	tween.tween_property(self,"modulate", Color(Color.WHITE, 1.0), 0.5);
	
	tween.play();
	
	
func _on_pause_pressed() -> void:
	get_tree().paused = true;
	
	pause_button.set_disabled(true);
	
	EventManager.pause_menu_opened.emit();
	
#	Engine.time_scale = 0;
	
	
	var tween = create_tween();
	
	back_ground.scale.y = 0;
	pause_button.hide();
	back_ground.show();
	
	tween.stop();
	
	tween.tween_property(back_ground,"scale",Vector2(1, 1), 0.2);
	tween.tween_callback(set_sidebar_buttons_to_deafult);
	tween.tween_callback(selection.show);
	
	for button in selection.get_children():
		if button is Button:
			tween.tween_property(button,"modulate",Color(Color.WHITE,1.0), 0.05);
	
	tween.play()
	
	
func _on_resume_pressed() ->void:
	resume_button.set_disabled(true);
	
	
	if loadout_menu.is_open():
		loadout_menu.close_loadout();
		load_out_button.set_pressed_no_signal(false);
		if !loadout_menu.closed.is_connected(_on_resume_pressed):
			loadout_menu.closed.connect(_on_resume_pressed);
		return;
	elif loadout_menu.closed.is_connected(_on_resume_pressed):
		loadout_menu.closed.disconnect(_on_resume_pressed);
	
	var tween = create_tween();
	
	back_ground.scale.y = 1;
	pause_button.hide();
	
	back_ground.show();
	
	tween.stop();
	
	for index in selection.get_child_count():
		tween.tween_property(selection.get_child(selection.get_child_count() - index-1),"modulate",Color(Color.WHITE,0.0), 0.05);
			
			
	tween.tween_callback(selection.hide);
	tween.tween_property(back_ground,"scale",Vector2(1, 0), 0.2);
	
	tween.tween_callback(back_ground.hide);
	
	tween.tween_callback(pause_button.set_disabled.bind(false));
	tween.tween_callback(pause_button.show);
	tween.tween_callback(EventManager.call.bind("emit_signal","pause_menu_closed"));

#	Engine.time_scale = 1;
	get_tree().paused = false;
	
	tween.play()
	
	
func set_sidebar_buttons_to_deafult() -> void:
	for button in selection.get_children():
		if button is Button:
			button.set_disabled(false);
	
	
func _on_loadout_toggled(button_pressed: bool) -> void:
	if button_pressed:
		loadout_menu.open_loadout();
	else:
		loadout_menu.close_loadout();
