extends Node3D

@onready var chest = $Chest
@onready var background: NinePatchRect = $Background


func _ready() -> void:
	chest.chest_opend.connect(_on_chest_opend);
	
func _on_chest_opend() -> void:
	if !SystemGlobals.dialog_profiles.has("player"):
		SystemGlobals.dialog_profiles["player"] = {}
	
	SystemGlobals.dialog_profiles["player"]["HasFlowers"] = true;
	
	var tween  = create_tween();
	tween.stop();
	
	tween.tween_property(background, "modulate", Color(Color.WHITE, 1.0), 0.5);
	tween.tween_interval(2);
	tween.tween_property(background, "modulate", Color(Color.WHITE, 0.0), 0.5);
	
	tween.play();
	
