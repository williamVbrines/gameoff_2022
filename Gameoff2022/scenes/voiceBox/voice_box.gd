extends AudioStreamPlayer
class_name VoiceBoxPlayer

@export var samples : Array[AudioStream]
@export var label: RichTextLabel;

@export var short_pause : float = 0.00;
@export var long_pause : float = 0.000;

var queue : Array[int] = [];

signal complete();

func _ready() -> void:
	_make_connections();
	
	
func _make_connections() -> void:
	finished.connect(_on_finnish);
	
	
func _on_finnish():
	play_next();
	
	
func play_text() -> void:
	label.visible_characters = 0;
	_gen_sample_q(label.text);
	play_next();
	
	
func _gen_sample_q(new_text: String)->void:
	queue = [];
	
	new_text = new_text.to_upper();
	
	if playing:
		stop();

	var word : String = "";
	var end_of_word = false;
	var index = 0;

	while index < new_text.length():
		if new_text[index] in [" ",'\n','\t',",",";","."]:
			if !end_of_word:
				queue.append(randi() % samples.size());
				word = "";
			queue.append((- [" ",",",";","."].find(new_text[index])) - 1);
			end_of_word = true
		else:
			end_of_word = false;
			
			word += new_text[index];
		index += 1;
	
	if word != "":
		queue.append(hash(word)  % samples.size());
	
	
func play_next()->void:
	if queue.size() <= 0: 
		complete.emit(); 
		return;
		
		
	var index = queue.pop_front();
#	

	#Show next word
	if index >= 0:
		var new_vis = label.visible_characters;
		
		for i in range(label.visible_characters,label.text.length()):
			
			if label.text[i] in [" ",'\n','\t',",",";","."] \
			|| i == label.text.length():
				
				break;
				
			
			new_vis += 1;
		
		label.visible_characters = new_vis; 
		#Hello how are you are you dooing well or are you good.
#		
		pitch_scale = 1 + sin(Time.get_ticks_usec()* 0.01) * 0.1
		
		stream = samples[index];
		call_deferred("play");
	#Show Spaceing 
	else:
		
		label.visible_characters += 1;
		
		var time = 0.0;
		
		match index:
			-1:
				time = short_pause;
			-2,-3,-4,-5:
				time = long_pause;
				
		
		var tween = create_tween()
		tween.tween_interval(time);
		tween.tween_callback(_on_finnish);
		tween.play();

	
	

