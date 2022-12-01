extends Node3D

@export var item : String = "rock";
@export var msg : String = "?You got a Rock?";
@onready var chest = $Chest
@onready var background: NinePatchRect = $Background
@onready var text: Label = $Background/Text


func _ready() -> void:
	text.text = msg;
	chest.chest_opend.connect(_on_chest_opend);
	
func _on_chest_opend() -> void:
	
	SystemGlobals.player_items.append(item);
	
	var tween  = create_tween();
	tween.stop();
	
	tween.tween_property(background, "modulate", Color(Color.WHITE, 1.0), 0.5);
	tween.tween_interval(2);
	tween.tween_property(background, "modulate", Color(Color.WHITE, 0.0), 0.5);
	
	tween.play();
	
