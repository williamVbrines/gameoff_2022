extends Control

@onready var label: Label = $Options/Label
@onready var label_button: Button = $Options/Label/Background/Button
@onready var label_background: NinePatchRect = $Options/Label/Background

@onready var cancel_button: Button = $Options/CancelText/Background/Button
@onready var cancel_background: NinePatchRect = $Options/CancelText/Background

@onready var fade: ColorRect = $Fade

@export var hovor_color : Color = Color.WHITE;
@export var normal_color : Color  = Color.WHITE;
@export var pressed_color : Color  = Color.WHITE;
@onready var options: Control = $Options

@onready var monitor_camera: Camera3D = $"../../Room3D/MonitorCamera"
@onready var room_camera: Camera3D = $"../../Room3D/RoomCamera"

@onready var computer_on_audio: AudioStreamPlayer = $ComputerONAudio
@onready var door_audio: AudioStreamPlayer = $DoorAudio
@onready var bed_audio: AudioStreamPlayer = $bedAudio

var action : String = "";
const FADE_TIME : float = 0.5;
var in_use : bool = false;
var stat_boot : float = 2.0;
var door_bad : Array = [
	["You run into thief and lost 100 dollars", "Time passed and you feel more stressd"],
	["A car nearly hit you", "Time passed and you feel winded and stressd"],
	["It began to rain and you got soaked on your walk", "Time passed and you feel more stressd"],
	["Someone fallowed you home and is watching", "Time passed and you feel more stressd and paranoid"],
	["You stub your tow on a rock", "You feel more stressd and a bit in pain"]
]
var door_good : Array = [
	["You had a pleasant walk","Time passed and you feel less stressd"],
	["See a cute animal on your walk","Time passed and you feel more happy"],
	["You went the extra mile","Time passed and you feel accomplished"],
	["Found some coin on the ground","Time passed and you feel luck and less stressd"],
	["It was sunny and beautiful out","Time passed and you feel less stressd"]
]

var bed_dialog : Array = [
	["You had a good nights sleep","A night passes, you feel rested"],
	["Dreams of bight days and grassy medows","You wake up, you feel at ease"],
	["As if binking you wake up","Time sliped by in an instant, you feel rested..","but stange"],
	["You did it you finished all your work...","You won the game...","Wait what were you doing? Well nevermind must of been a dream","A night passed","you feel rested and like you missed someting"],
	["A squid like moster makes a deal with you","Time flows like a feeling of vertigo","Your very well rested and powerful?"],
]

var book_dialog : Array = [
	["You read, How to Speek to Your Boss","You feel more confident"],
	["A book called LOGOS, Might as well read it","Your head hurts"],
	["Titled: Pathos - the way to the heart","Seems to be full of flowery writing","You... Feel?"],
	["You pick up the book","You glair at the book","You put it back down","You start writing a book instead"],
	["Ethos, Doctors say its a good book to read","Time passes, you feel like you are more self-aware"]
]

var eat_dialog : Array = [
	["You order out tonight","Its Pizza you could not finish it thoe","You feel full"],
	["Pizza again","There is always leftovers","I should order out less"],
	["You ate a filling meal"],
	["After eating you crahed due to the carbs","You feel a bit rested"],
	["Today you ate at your desk","After an hour you look at your food","and wonder how am I not done with it","You feel puzzled at the pizza"]
]
func _ready() -> void:
	_make_connections();
	
	options.modulate = Color(Color.WHITE, 0.0);
	options.hide();
	
	cancel_background.modulate = normal_color;
	label_background.modulate = normal_color;
	
	
func _make_connections() -> void:
	EventManager.room_show_confirm.connect(_on_show_confirm);
	
	cancel_button.pressed.connect(_on_cancel_pressed);
	cancel_button.mouse_entered.connect(_on_cancel_mouse_entered);
	cancel_button.mouse_exited.connect(_on_cancel_mouse_exited);
	cancel_button.button_down.connect(_on_cancel_down);
	cancel_button.button_up.connect(_on_cancel_up);
	
	label_button.pressed.connect(_on_label_button_pressed);
	label_button.mouse_entered.connect(_on_label_button_mouse_entered);
	label_button.mouse_exited.connect(_on_label_button_mouse_exited);
	label_button.button_down.connect(_on_label_button_down);
	label_button.button_up.connect(_on_label_button_up);
	
	EventManager.monitor_startup_complete.connect(_on_monitor_startup_complete);
	
	
func _on_monitor_startup_complete() -> void:
	var tween = create_tween();
	tween.stop();
	var end = SystemGlobals.bgmVol;
	var val = -80.0;
	for i in 50:
		val = -80  - (i * ((-80 - end)/50))
		tween.tween_callback(AudioServer.call_deferred.bind("set_bus_volume_db",AudioServer.get_bus_index("BGM"), val));
		tween.tween_interval(0.05);
	tween.play();
	
func _on_label_button_down() -> void:
	label_background.modulate = pressed_color;

func _on_label_button_up() -> void:
	label_background.modulate = normal_color;
	
func _on_label_button_mouse_entered() ->void:
	label_background.modulate = hovor_color;
	
func _on_label_button_mouse_exited() -> void:
	label_background.modulate = normal_color;
	
func _on_label_button_pressed() -> void:
	_parce_action();
	
func _on_cancel_down() -> void:
	cancel_background.modulate = pressed_color;

func _on_cancel_up() -> void:
	cancel_background.modulate = normal_color;
	
func _on_cancel_mouse_entered() ->void:
	cancel_background.modulate = hovor_color;
	
func _on_cancel_mouse_exited() -> void:
	cancel_background.modulate = normal_color;
	
func _on_cancel_pressed() -> void:
	action = "";
	_hide_anim();
	
	
func _show_anim() -> void:
	var tween = create_tween();
	tween.tween_callback(options.show);
	
	tween.stop();
	tween.tween_callback(on_label_resized);
	tween.tween_property(options, "modulate",Color(Color.WHITE, 1.0), FADE_TIME);
	
	tween.play();
	
	
func _hide_anim() -> void:
	var tween = create_tween();
	tween.stop();
	
	tween.tween_property(options, "modulate",Color(Color.WHITE, 0.0), FADE_TIME)
	tween.tween_callback(options.hide);
	tween.tween_callback(set_in_use.bind(false));
	tween.play();
	
func set_in_use(val : bool) ->void:
	in_use = val;
	
func _parce_action():
	
	match action.to_upper():
		"BED":
			_bed_action()
		"MONITOR":
			
			EventManager.show_save_screen.emit();
			
			computer_on_audio.play_rand();
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
			
			_trans_to_monitor();
		"DOOR":
			_door_action();
		"BOOK":
			_book_action();
		"EAT":
			_eat_action();
			
	action = "";
	_hide_anim()
	
	
func _on_show_confirm(text : String, new_action : String) -> void:
	if in_use == false:
		action = new_action;
		label.set_text("");
		label.size.x = 1;
		label.set_text(text);
		_show_anim();
		in_use = true;
	
	
func on_label_resized() -> void:
	label.position.x = (1920/2.0) - (label.size.x / 2.0);
	
	
func _fade_out():
	var tween = create_tween();
	tween.stop();
	fade.show();
	tween.tween_property(fade, "modulate",Color(Color.BLACK, 1.0), FADE_TIME)
	tween.play();
	
	
func _fade_in():
	var tween = create_tween();
	tween.stop();

	tween.tween_property(fade, "modulate",Color(Color.BLACK, 0.0), FADE_TIME)
	tween.tween_callback(fade.hide);
	tween.play();
	
	
func _trans_to_monitor() -> void:

	
	var tween = create_tween();
	
	tween.stop();
	tween.tween_callback(_fade_out);
	tween.tween_interval(FADE_TIME);
	tween.tween_callback(monitor_camera.set_current.bind(true));
	tween.tween_callback(EventManager.call_deferred.bind("emit_signal", "moved_to_monitor"));
	tween.tween_callback(_fade_in);
	tween.tween_callback(set_in_use.bind(false));
	tween.play();
	
	
func _door_action() -> void:
	
	var tween = create_tween();
	
	if randi() % 100 <= 30:
		EventManager.display_dialog.emit("NON", {"dialog" : door_bad[randi() % door_bad.size()] })
		SystemGlobals.stress += 50;
		SystemGlobals.player_stats.INTIMIDATION += stat_boot;
	else:
		EventManager.display_dialog.emit("NON", {"dialog" : door_good[randi() % door_good.size()]})
		SystemGlobals.stress -= 50;
		
		SystemGlobals.player_stats.CHARM += stat_boot/2.0;
		
	SystemGlobals.stress = clamp(SystemGlobals.stress, 0 , 100);
	
	SystemGlobals.day += 0.5;
	
	
	
	door_audio.play();
	
	tween.stop();
	fade.show();
	tween.tween_property(fade, "modulate",Color(Color.BLACK, 1.0), FADE_TIME);
	tween.tween_interval(1);
	tween.tween_property(fade, "modulate",Color(Color.BLACK, 0.0), FADE_TIME);
	tween.tween_callback(EventManager.call_deferred.bind("emit_signal", "stress_changed"));
	tween.tween_callback(fade.hide);
	
	tween.play();
	
	
func _bed_action() -> void:
	var tween = create_tween();
	
	EventManager.display_dialog.emit("NON", {"dialog" : bed_dialog[randi() % bed_dialog.size()]})
	SystemGlobals.stress = clamp(SystemGlobals.stress * 0.20, 0, 100);
	
	SystemGlobals.player_stats.DECEPTION += stat_boot/2.0;
	SystemGlobals.player_stats.CHARM += stat_boot/2.0;
	
	SystemGlobals.day += 1;
	
	bed_audio.play_rand();
	
	tween.stop();
	fade.show();
	tween.tween_property(fade, "modulate",Color(Color.BLACK, 1.0), FADE_TIME);
	tween.tween_interval(1);
	tween.tween_property(fade, "modulate",Color(Color.BLACK, 0.0), FADE_TIME);
	tween.tween_callback(EventManager.call_deferred.bind("emit_signal", "stress_changed"));
	tween.tween_callback(fade.hide);
	
	tween.play();
	
	
func _book_action() -> void:
	var tween = create_tween();
	

	EventManager.display_dialog.emit("NON", {"dialog" : book_dialog[randi() % book_dialog.size()] })
	
	SystemGlobals.stress = clamp(SystemGlobals.stress - 0.5, 0 , 100);
	
	SystemGlobals.day += 0.5;
	
	SystemGlobals.player_stats.LOGIC += stat_boot;
	
	door_audio.play();
	
	tween.stop();
	fade.show();
	tween.tween_property(fade, "modulate",Color(Color.BLACK, 1.0), FADE_TIME);
	tween.tween_interval(1);
	tween.tween_property(fade, "modulate",Color(Color.BLACK, 0.0), FADE_TIME);
	tween.tween_callback(EventManager.call_deferred.bind("emit_signal", "stress_changed"));
	tween.tween_callback(fade.hide);
	
	tween.play();
	
	
func _eat_action() -> void:
	var tween = create_tween();
	
	EventManager.display_dialog.emit("NON", {"dialog" : eat_dialog[randi() % eat_dialog.size()] })
	
	SystemGlobals.stress = clamp(SystemGlobals.stress - randf_range(0.3,5), 0 , 100);
	
	SystemGlobals.day += 0.5;
	
	match randi() % 4:
		0:
			SystemGlobals.player_stats.CHARM += stat_boot/2 ;
		1:
			SystemGlobals.player_stats.DECEPTION += stat_boot/2;
		2:
			SystemGlobals.player_stats.LOGIC += stat_boot/2;
		3:
			SystemGlobals.player_stats.INTIMIDATION += stat_boot/2;
	
	tween.stop();
	fade.show();
	tween.tween_property(fade, "modulate",Color(Color.BLACK, 1.0), FADE_TIME);
	tween.tween_interval(1);
	tween.tween_property(fade, "modulate",Color(Color.BLACK, 0.0), FADE_TIME);
	tween.tween_callback(EventManager.call_deferred.bind("emit_signal", "stress_changed"));
	tween.tween_callback(fade.hide);
	
	tween.play();
