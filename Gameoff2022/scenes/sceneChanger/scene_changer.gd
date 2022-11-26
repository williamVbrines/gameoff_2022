extends CanvasLayer

var _is_loading : bool = false; #When true the new thread is currently loading

var _trans_out : String = "Fade_Out_Of_Black";
var _trans_mid : String = "Nothing";
var _trans_in : String = "Fade_Into_Black";
#onready var percent_text = $Visuals/PercentText;

var current_scene : Node = null;
var res_path : String = "";

signal finished_loading();

@onready var bg: ColorRect = $BG

func _ready():
	pass
	
func set_current(scene : Node) -> void:
	current_scene = scene;
	
	
func _on_level_ready():
	if current_scene != null:
		if current_scene.ready.is_connected(_on_level_ready):
			current_scene.ready.disconnect(_on_level_ready);
			
	get_tree().paused = true;
	var tween_s = create_tween();
	tween_s.stop();
	var end = 0;
	var val = -20.0 ;
	var current =AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"));
	
	for i in 50:
		val = current - (i * ((current- end)/50))
		print(val)
		tween_s.tween_callback(AudioServer.call_deferred.bind("set_bus_volume_db",AudioServer.get_bus_index("Master"), val));
		tween_s.tween_interval(0.05);
	
	var tween = create_tween();
	tween.stop();
	tween.tween_property(bg.material,"shader_parameter/cuttoff", 1.0, 1);
	tween.tween_callback(bg.hide);
	tween.play();
	tween_s.play();
	await tween.finished;
	get_tree().paused = false;
	
	finished_loading.emit();
	
	
func _process(_delta):
	if _is_loading == true: #see if there is something needed to being loaded
#		if ResourceLoader.load_threaded_get_status(res_path) == ResourceLoader.THREAD_LOAD_LOADED:
			_is_loading = false;
			
			
			get_tree().paused = false;
			
			if current_scene != null:
				if !current_scene.is_queued_for_deletion():
					current_scene.queue_free();
					
			
		# Instance the new scene.
#			var result = ResourceLoader.load_threaded_get(res_path)#This is broken in 4.0 beta
			var result = load(res_path);
			
			current_scene = null;
			
			if result != null:
				if result is PackedScene:
					current_scene = result.instantiate();
			
			if current_scene != null:
				current_scene.ready.connect(_on_level_ready);
				
			get_tree().get_root().call_deferred("add_child",current_scene)
			get_tree().call_deferred("set_current_scene",current_scene)
	
	
func reload_level():
	if current_scene != null && _is_loading == false:
		load_level(res_path);
	
	
func reload_level_with_trans(trans_in : String = "Fade_Into_Black" , trans_mid : String = "Nothing",  trans_out : String = "Fade_Out_Of_Black") -> void:
	if current_scene != null && _is_loading == false:
		_trans_in = trans_in;
		_trans_mid = trans_mid;
		_trans_out = trans_out;
		load_level(res_path);
	
	
################################################################################
#Starts the procress of loading a new level. If the path is invalid the
################################################################################
func load_level(path : String) -> void:
	if _is_loading == true: return;
	
	
	
	res_path = path;
	
	
	
	var tween_s = create_tween();
	tween_s.stop();
	var end = -80.0;
	var val = -20.0 ;
	var current =AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"));
	
	for i in 50:
		val = current - (i * ((current- end)/50))
		print(val)
		tween_s.tween_callback(AudioServer.call_deferred.bind("set_bus_volume_db",AudioServer.get_bus_index("Master"), val));
		tween_s.tween_interval(0.05);
		
	tween_s.tween_callback(pause);
	
	var tween = create_tween();
	
	tween.stop();
	tween.tween_callback(bg.show);
	tween.tween_property(bg.material,"shader_parameter/cuttoff", 0.0, 1);
	tween.tween_interval(1)
	tween.play();
	tween_s.play();
	await tween.finished;

#	ResourceLoader.load_threaded_request(res_path,"",true);#This is broken in 4.0 beta right now
	
	_is_loading = true;
	
func pause():
	get_tree().paused = true;
################################################################################
#Loads level with a transition 
################################################################################
func load_level_with_trans(path : String, trans_in : String = "Fade_Into_Black" , trans_mid : String = "Nothing",  trans_out : String = "Fade_Out_Of_Black") -> void:
	if _is_loading == false:
		
		_trans_in = trans_in;
		_trans_mid = trans_mid;
		_trans_out = trans_out;
		load_level(path);
	
	
