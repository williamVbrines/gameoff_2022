extends Control

@onready var health_bar_r: TextureRect = $HealthBar_R
@onready var health_bar_l: TextureRect = $HealthBar_L
@onready var fill_r: ColorRect = $HealthBar_R/Fill_R
@onready var fill_l: ColorRect = $HealthBar_L/Fill_L
@onready var player_portrait: TextureRect = $PlayerPortrait
@onready var enemy_portrait: TextureRect = $EnemyPortrait
@onready var center_skull: TextureRect = $CenterSkull

@onready var stress_up_audio: AudioStreamPlayer = $StressUPAudio
@onready var stress_down_audio: AudioStreamPlayer = $StressDownAudio
@onready var per_up_audio: AudioStreamPlayer = $PerUPAudio
@onready var per_down_audio: AudioStreamPlayer = $PerDownAudio

var or_bar_size : Vector2 = Vector2.ZERO;
const FILL_SPEED = 2.0;

func _ready() -> void:
	or_bar_size = health_bar_l.size;
	health_bar_l.size.x = 0;
	health_bar_r.size.x = 0;
	
	hide();
	_make_connections();
	
	_hide_anim();
	
	
func _make_connections() -> void:
	EventManager.enemy_portrait_changed.connect(_on_enemy_portrait_changed);
	
	EventManager.stress_changed.connect(_on_stress_changed);
	EventManager.persuasion_changed.connect(_on_persuasion_changed);
	
	EventManager.combat_state_changed.connect(_on_combat_state_changed);
	

func _on_combat_state_changed(state : String) ->void:
	match state.to_upper():
		"SET_UP":
			show();
			_show_anim();
		"SHUTTING_DOWN_COMBAT":
			_hide_anim();
	
	
func _on_enemy_portrait_changed(portrait : Texture) -> void:
	enemy_portrait.set_texture(portrait);
	
	
func _on_persuasion_changed(_val : float) -> void:
	var p = SystemGlobals.persuasion / 100.0;
	
	if  p > fill_r.scale.x:
		per_down_audio.play();
		
	if  p < fill_r.scale.x:
		per_up_audio.play();
		
	_change_persuasion_anim();
	
	
func _on_stress_changed(_val : float) -> void:
	var p = SystemGlobals.stress / 100.0;
	
	if  p > fill_l.scale.x:
		stress_down_audio.play();
	if  p < fill_l.scale.x:
		stress_up_audio.play();
		
	_change_stress_anim();
	
	
func _hide_anim() -> void:
	var tween = create_tween();
	var tween_p = create_tween();
	
	tween_p.set_parallel()
	
	tween.stop();
	tween_p.stop();
	
	
	tween.tween_callback(_fade_out_portraits);
	tween.tween_interval(0.5);
	tween.tween_callback(health_bar_r.hide);
	tween.tween_callback(health_bar_l.hide);
	tween.tween_property(center_skull, "modulate", Color(Color.WHITE, 0.0), 0.2);
	
	tween_p.tween_property(health_bar_r,"size", Vector2(1,or_bar_size.y), 0.5);
	tween_p.tween_property(health_bar_l,"size", Vector2(1,or_bar_size.y), 0.5);
	
	tween.play();
	tween_p.play();
	
	
func _show_anim() -> void:
	var tween = create_tween();
	var tween_p = create_tween();
	
	player_portrait.modulate = Color(Color.WHITE, 0.0);
	enemy_portrait.modulate = Color(Color.WHITE, 0.0);
	
	fill_l.scale.x = 0;
	fill_r.scale.x = 0;
	
	tween_p.set_parallel()
	tween_p.stop();
	tween.stop();
	
	tween.tween_property(center_skull, "modulate", Color(Color.WHITE, 1.0), 0.2);
	tween.tween_callback(health_bar_r.show);
	tween.tween_callback(health_bar_l.show);
	
	tween.tween_interval(0.5);
	tween.tween_callback(_fade_in_portraits);
	
	tween.tween_interval(0.5);
	tween.tween_callback(_change_stress_anim);
	tween.tween_callback(_change_persuasion_anim);
	
	health_bar_l.size.x = 0;
	health_bar_r.size.x = 0;
	
	tween_p.tween_property(health_bar_r,"size",or_bar_size, 0.5);
	tween_p.tween_property(health_bar_l,"size",or_bar_size, 0.5);
	
	tween_p.play();
	tween.play();
	
	
func _change_stress_anim() -> void:
	var tween = create_tween();
	tween.set_trans(Tween.TRANS_ELASTIC)
	
	tween.stop();
	
	var p = SystemGlobals.stress / 100.0;
		
	tween.tween_property(fill_l,"scale", Vector2(p,1),FILL_SPEED * p )
	
	tween.play();
	
	
func _change_persuasion_anim() -> void:
	var tween = create_tween();
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.stop();
	
	var p = SystemGlobals.persuasion / 100.0;
	
	tween.tween_property(fill_r,"scale", Vector2(p,1),FILL_SPEED * p  )
	
	tween.play();
	
	
func _fade_in_portraits() -> void :
	var tween_p = create_tween();
	tween_p.set_parallel()
	
	tween_p.tween_property(player_portrait, "modulate", Color(Color.WHITE, 1.0), 0.2);
	tween_p.tween_property(enemy_portrait, "modulate", Color(Color.WHITE, 1.0), 0.2);
	
	tween_p.play();
	
	
func _fade_out_portraits() -> void :
	
	var tween_p = create_tween();
	tween_p.set_parallel()
	
	tween_p.tween_property(player_portrait, "modulate", Color(Color.WHITE, 0.0), 0.2);
	tween_p.tween_property(enemy_portrait, "modulate", Color(Color.WHITE, 0.0), 0.2);
	
	tween_p.play();
