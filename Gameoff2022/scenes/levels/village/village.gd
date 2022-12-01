extends Node
@onready var bgm_audio_normal: AudioStreamPlayer = $BGMAudioNormal
@onready var bgm_audio_battle: AudioStreamPlayer = $BGMAudioBattle


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), SystemGlobals.bgmVol);
	bgm_audio_normal.play();
	bgm_audio_battle.play()
	EventManager.start_combat.connect(_on_start_combat);
	EventManager.start_exploration.connect(_on_start_exploration);
	
func _on_start_combat(_cam) -> void:
	var tween = create_tween();
	tween.stop();
	
	tween.tween_property(bgm_audio_normal,"volume_db", -80,0.5);
	tween.tween_property(bgm_audio_battle,"volume_db", 0,0.5);
	
	tween.play();
	
func _on_start_exploration() ->  void:
	var tween = create_tween();
	tween.stop();
	
	tween.tween_property(bgm_audio_battle,"volume_db", -80,0.5);
	tween.tween_property(bgm_audio_normal,"volume_db", 0,0.5);
	
	tween.play();
	
