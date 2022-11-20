extends AudioStreamPlayer

@export var samples : Array[AudioStream]
@onready var label: RichTextLabel = $Label
@onready var line_edit: LineEdit = $LineEdit
var space_pause : float = 1.0;
var coma_pause : float = 2.0;

var queue : Array[int] = [];

func _ready() -> void:
	_make_connections();
	
	
func _make_connections() -> void:
	finished.connect(_on_finnish);
	
	
func _on_finnish():
	play_next();
	
	
func _on_text_submitted(new_text: String) -> void:
	label.visible_characters = 0;
	label.set_text(new_text);
	_gen_sample_q(new_text);
	play_next();
	
	
func _gen_sample_q(text: String)->void:
	queue = [];
	
	text = text.to_upper();
	
	if playing:
		stop();

	var word : String = "";
	var end_of_word = false;
	var index = 0;

	while index < text.length():
		if text[index] in [" ",'\n','\t',",",";","."]:
			if !end_of_word:
				queue.append(hash(word)  % samples.size());
				print(word);
				word = "";
			queue.append((- [" ",",",";","."].find(text[index])) - 1);
			end_of_word = true
		else:
			end_of_word = false;
			
			word += text[index];
		index += 1;
	
	if word != "":
		queue.append(hash(word)  % samples.size());
	
	print(queue)
	
func play_next()->void:
	if queue.size() <= 0: return;
	stop();
	
	#Show next word
	if queue[0] != 0:
		for i in range(label.visible_characters,label.text.length()):
			print(label.text[i])
			label.visible_characters += 1;
			if label.text[i] in [" ",'\n','\t',",",";","."] || i == label.text.length() :
				break;
				
	var index = queue.pop_front();
	
	if index <= 0:
		var time = 0.1;
		
		match index:
			-1:
				time = space_pause;
			-2,-3,-4,-5:
				time = coma_pause;
				
				
		var tween = create_tween()
		tween.tween_interval(time);
		tween.tween_callback(_on_finnish);
		tween.play();
		
	else:
		stream = samples[index];
		play();
	
	

