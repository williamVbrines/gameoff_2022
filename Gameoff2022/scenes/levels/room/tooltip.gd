extends Control

@onready var label: Label = $RichTextLabel

var fallow : bool = false;
const FADE_TIME : float = 0.2;

func _ready() -> void:
	_make_connections();
	
	modulate = Color(Color.WHITE, 0.0);
	hide();
	
func _make_connections() -> void:
	EventManager.room_show_tooltip.connect(_on_show_tooltip);
	EventManager.room_hide_tooltip.connect(_on_hdie_tooltip);
	
	
func on_label_resized() -> void:
	label.position.x = -label.size.x/2.0
	
	
func _on_show_tooltip(text : String) -> void:
	label.set_text("");
	label.size.x = 1;
	label.set_text(text);
	call_deferred("on_label_resized" )
	fallow = true;
	_show_anim();
	
	
func _on_hdie_tooltip() -> void:
	fallow = false;
	_hide_anim();
	
	
func _input(event: InputEvent) -> void:
	if fallow == true:
		if event is InputEventMouseMotion:
			global_position = get_global_mouse_position();


func _show_anim() -> void:
	var tween = create_tween();
	tween.tween_callback(show);
	
	tween.stop();
	
	tween.tween_property(self, "modulate",Color(Color.WHITE, 1.0), FADE_TIME);
	
	tween.play();
	
	
func _hide_anim() -> void:
	var tween = create_tween();
	tween.stop();
	
	tween.tween_property(self, "modulate",Color(Color.WHITE, 0.0), FADE_TIME)
	tween.tween_callback(hide);
	tween.play();
	
	
