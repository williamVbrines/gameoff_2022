extends Control

@onready var exit_button: TextureButton = $BackGround/WindowBar/ExitButton
@onready var full_screened_box: CheckBox = $BackGround/Display/FullScreenedBox
@onready var windowed_check_box: CheckBox = $BackGround/Display/WindowedCheckBox2
@onready var master_volume_slider: HSlider = $BackGround/Audio/MasterVolumeSlider

func _ready() -> void:
	_make_connections();
	
	
	
func _make_connections() -> void:
	exit_button.pressed.connect(_on_exit_pressed);
	windowed_check_box.toggled.connect(_on_windowed_check_box_2_toggled)
	full_screened_box.toggled.connect(_on_full_screened_box_toggled)
	
	
func _on_exit_pressed() -> void:
	exit_button.disabled = true;
	
	exit_anim();
	
	
func exit_anim() -> void:
	var tween = create_tween();
	self.modulate = Color(Color.WHITE, 1.0);
	show();
	tween.stop();
	tween.tween_callback(EventManager.call.bind("emit_signal","show_save_screen"));
	tween.tween_property(self,"modulate",Color(Color.WHITE, 0.0), 0.5);
	
	tween.tween_callback(hide);
	tween.play();
	
	
func open_anim() -> void:
	_setup();
	var tween = create_tween();
	self.modulate = Color(Color.WHITE, 0.0);
	show();
	tween.stop();
	tween.tween_property(self,"modulate",Color(Color.WHITE, 1.0), 0.5);
	tween.tween_callback(exit_button.set_disabled.bind(false));
	tween.play();
	
	
func start_anim() -> void:
	var tween = create_tween();
	tween.stop();
	
	tween.play();


func _setup() -> void:
	windowed_check_box.set_pressed_no_signal(SystemGlobals.windowed);
	full_screened_box.set_pressed_no_signal(!SystemGlobals.windowed)
	master_volume_slider.set_value(SystemGlobals.masterVol);
	
	
	
func _on_full_screened_box_toggled(button_pressed: bool) -> void:
	windowed_check_box.set_pressed_no_signal(!button_pressed);
	SystemGlobals.windowed = !button_pressed;
	
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
		
func _on_windowed_check_box_2_toggled(button_pressed: bool) -> void:
	full_screened_box.set_pressed_no_signal(!button_pressed)
	SystemGlobals.windowed = button_pressed;
	
	if !button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_master_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value);
	SystemGlobals.masterVol = value;
