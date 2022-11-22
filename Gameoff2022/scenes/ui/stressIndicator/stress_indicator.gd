extends Control
@onready var portrait: TextureRect = $Portrait
@onready var health_bar: TextureRect = $HealthBar
@onready var fill: TextureRect = $Fill

const FILL_SPEED : float = 0.5;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_make_connections();
	_on_stress_changed();
	
func _make_connections() -> void:
	EventManager.stress_changed.connect(_on_stress_changed)
	EventManager.start_combat.connect(_on_start_combat);
	EventManager.start_exploration.connect(_show_anim);
	
	EventManager.start_dialog.connect(_on_start_dialog);
	EventManager.dialog_ended.connect(_show_anim);
	
	
func _on_start_combat(_cam : Camera3D) -> void:
	_hide_anim();
	
func _on_start_dialog(_id : String) -> void:
	_hide_anim();
	
	
func _on_stress_changed():
	var tween = create_tween();
	tween.set_trans(Tween.TRANS_CUBIC)
	var p = (SystemGlobals.stress / 100.0 )- 0.001;
	
	tween.stop();
	
	tween.tween_property(fill.material,"shader_parameter/x_cutoff",p, p * FILL_SPEED)
	
	tween.play();
	
	
func _hide_anim() -> void:
	var p = (SystemGlobals.stress / 100.0 )- 0.001;
	
	var tween = create_tween();
	
	tween.pause();
	
	tween.tween_property(fill.material,"shader_parameter/x_cutoff",0.0, p * FILL_SPEED)
	
	tween.tween_property(health_bar,"scale", Vector2(0,1), 0.2);
	
	tween.tween_property(portrait,"modulate", Color(Color.WHITE, 0.0), 0.2);
	
	tween.tween_property(health_bar,"scale", Vector2(0,1), 0.2);
	
	tween.tween_callback(hide);
	
	tween.play()
	
func _show_anim() -> void:
	var p = (SystemGlobals.stress / 100.0 )- 0.001;
	var tween = create_tween();

	tween.pause();
	
	tween.tween_callback(show);
	
	tween.tween_property(portrait,"modulate", Color(Color.WHITE, 1.0), 0.2);
	
	tween.tween_property(health_bar,"scale", Vector2(1,1), 0.2);
	
	tween.tween_property(fill.material,"shader_parameter/x_cutoff",p, p * FILL_SPEED)
	
	
	
	tween.play()
	
	
	
	
	
