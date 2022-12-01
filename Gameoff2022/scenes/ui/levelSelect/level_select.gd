extends Control

@onready var exit_button: TextureButton = $BackGround/ExitButton
@onready var start_button: TextureButton = $BackGround/StartButton

func _ready() -> void:
	_make_connections();
	
	
func _make_connections() -> void:
	exit_button.pressed.connect(_on_exit_pressed);
	start_button.pressed.connect(_on_start_pressed);
	
	
func _on_exit_pressed() -> void:
	exit_button.disabled = true;
	exit_anim();
	
	
func _on_start_pressed() -> void:
	start_button.disabled = true;
	SceneChanger.load_level("res://scenes/levels/village/village.tscn");
	
	
func exit_anim() -> void:
	var tween = create_tween();
	self.modulate = Color(Color.WHITE, 1.0);
	show();
	tween.stop();
	tween.tween_property(self,"modulate",Color(Color.WHITE, 0.0), 0.5);
	tween.tween_callback(hide);
	tween.play();
	
func open_anim() -> void:
	
	var tween = create_tween();
	self.modulate = Color(Color.WHITE, 0.0);
	show();
	tween.stop();
	tween.tween_property(self,"modulate",Color(Color.WHITE, 1.0), 0.5);
	tween.tween_callback(exit_button.set_disabled.bind(false));
	tween.tween_callback(start_button.set_disabled.bind(false));
	tween.play();
	
	
func start_anim() -> void:
	var tween = create_tween();
	tween.stop();
	
	tween.play();
