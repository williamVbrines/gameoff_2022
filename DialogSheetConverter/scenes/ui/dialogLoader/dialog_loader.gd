extends Control

@onready var line_edit: LineEdit = $LineEdit
@onready var convert_button: Button = $ConvertButton
@onready var label: RichTextLabel = $Label
@onready var file_dialog: FileDialog = $FileDialog
@onready var file_lookup_button: Button = $LineEdit/FileLookupButton
@onready var test_button: Button = $TestButton
@onready var load_button: Button = $LoadButton

var err : int = 0;
	
func _ready() -> void:
	test_button.disabled = true;
	convert_button.disabled = true;
	load_button.disabled = true;
	_make_connections();
	
	
func _make_connections() -> void:
	convert_button.pressed.connect(_on_convert_pressed);
	file_lookup_button.pressed.connect(_on_file_lookup_pressed);
	file_dialog.file_selected.connect(_on_file_selected);
	line_edit.text_changed.connect(_on_line_edit_changed)
	test_button.pressed.connect(_on_test_pressed);
	EventManager.start_dialog.connect(_on_start_dialog);
	EventManager.dialog_ended.connect(_on_dialog_ended);
	load_button.pressed.connect(_on_prelaod_pressed);
	
func _on_prelaod_pressed() -> void:
	var path = line_edit.text;
	
	var key = path.substr(path.rfind("/") + 1);
	key = key.substr(0,key.rfind("."));
	
	label.text = "[color=green]Preloaded: " + key + "[/color]";
	line_edit.text = "";
	
	ResourceManager.add_resource("dialog_data", path, key);
	
	_on_line_edit_changed(line_edit.text);
	
	
	
func _on_dialog_ended() -> void:
	test_button.disabled = true;
	load_button.disabled = true;
	convert_button.disabled = true;
	
	label.text = "[color=red]DIALOG ENDED[/color]";
	line_edit.text = "";
	show();
	
	
func _on_start_dialog(_id : String ) -> void:
	hide();
	
	
func _on_test_pressed() -> void:
	EventManager.start_dialog.emit(line_edit.text);
	
	
func _on_line_edit_changed(text : String) -> void:
	if text.substr(text.rfind(".")) == ".tres":
		test_button.disabled = false;
		load_button.disabled = false;
	else:
		test_button.disabled = true;
		load_button.disabled = true;
		
	
	if text.substr(text.rfind(".")) == ".tsv" && FileAccess.file_exists(text):
		convert_button.disabled = false;
		
	else:
		convert_button.disabled = true;
	
	
func _on_convert_pressed():
	err = 0;
	label.text = "Processing" + line_edit.text;
	
	var raw = load_file(line_edit.text);
	var new_content = null
	
	if err == 0:
		new_content = _convert_to_json(raw);
		
	if err == 0:
		save_data(new_content);
		
	if err == 0:
		label.text += "\n[color=green]Converted[/color]"
	
	
func _on_file_lookup_pressed():
	if $FileDialog.visible == true:
		$FileDialog.hide();
	else: 
		$FileDialog.popup(Rect2(0,0,0,0))
	
	
func _on_file_selected(path):
	$LineEdit.text = path;
	_on_line_edit_changed(path);
	
	
func load_file(path : String) -> String:
	$Label.text += "\nAccsessing File" + path + "\n";
	var file = FileAccess.open(path, FileAccess.READ)
	var data = "";
	
	if file == null:
		err = 20;
		$Label.text += "\n[color=red]!!Error : could not open file " + path + "[/color]";
		return "";
	else:
		data = file.get_as_text();
		
	return data;
	
	
func save_data(s_data : String) -> void:
	label.text += "\nSaving...";
	print(s_data)
	var dialog_data = DialogData.new();
	
	var json : JSON = JSON.new();
	var data = json.parse_string(s_data);
	var path : String = line_edit.text;
	
	if s_data == "":
		err = 10;
		label.text += "\n[color=red]Can not save nothing error[/color=red]"
		return;
		
	if data == null:
		err = 10;
		label.text += "\n[color=red]" + json.get_error_message() + "[/color]"
		return;
		
	path =  path.substr(0, path.rfind(".")) + ".tres";
	label.text += "\nSaving to :" + path;
	dialog_data.data = data;
	
	ResourceSaver.save(dialog_data, path);
	
	
func _convert_to_json(data : String) -> String:
	var out = "{\n";

	var tabNum : int = 0; 
	var index = 0;
	
	var lineNum = 0;
	var tag;
	var con;
	var act;
	var def;
	var order = [];
	var time = Time.get_ticks_msec();
	var time_cap = 60;
	
	while index < data.length():
		if Time.get_ticks_msec() - time >= time_cap:
			print(Time.get_ticks_msec() - time);
			err = 4;
			label.text += "\n[color=red]Formating error see INF time:" +str(tag)+ "[/color]";
			return "";
			
		if tabNum == 0:
			tabNum = 1;
			tag = "";
			tag = data.substr(index, data.find("\t", index) - index);
			
			if tag == "":
				tag = str(lineNum);
				lineNum += 1;
			else:
				index = data.find("\t", index+1);
				
			out += "\t\"" + tag + "\":{\n";
			
			
			if order.has(tag):
				err = 3;
				label.text += "\n[color=red]Repetitive Tag names, On/before/affter Line: " + tag + "[/color]"
				return "";
			
			
			order.append(tag);
			
		elif data[index] == '\t':
			match tabNum:
				1:#Con
					tabNum = 2;
					con = "";
					index += 1;
					
					con = data.substr(index , data.find("\t", index) - index);
					index = data.find("\t",index);
					if con == "T":
						con = "true";
					if con == "F":
						con = "false"
						
					out += "\t\t\"con\": \"" + con + "\",\n";
					
				2:#Act
					tabNum = 3;
					
					index += 1;
					act = "";
					act += data.substr(index , data.find("\t", index) - index);
					index = data.find("\t",index);
					
					act = act.substr(0, act.rfind(";") + 1);
					act = act.replace("\"", "");
					
					var entry = "";

					for i in act.length():
						var add = "";
						
						if act[i] == ';':
							if i < act.length()-1:#If not the last char
								if act[max(0,i-1)] == '\"':  add += ",";
								else: add += "\",";
									
								if act[i+1] != '\"': add += "\"";
							else:
								if act[max(0,i-1)] != '\"': add += "\"";
								
							entry += add;
							
						else:
							entry += act[i]
					
					
					if entry.length() >= 1:
						if act[0] != '\"':
							entry = "\"" + entry;
						
					act = entry;

					out += "\t\t\"act\": [" + act + "],\n";
					
				3:#Def
					tabNum = 4;
					
					index += 1;
					
					def = "";
					def += data.substr(index , data.find("\n", index) - index -1);
					
					def = def.substr(0, def.rfind(";") + 1);
					
					def = def.replace("\"", "");
					
					var entry = "";
					
					for i in def.length():
						var add = "";
						
						if def[i] == ';':
							
							if i < def.length()-1:#If not the last char
								if def[max(0,i-1)] == '\"':  add += ",";
								else: add += "\",";
									
								if def[i+1] != '\"': add += "\"";
							else:
								if def[max(0,i-1)] != '\"': add += "\"";
								
							entry += add;
						
							
						else:
							entry += def[i]
					
					
					if entry.length() >= 1:
						if def[0] != '\"':
							entry = "\"" + entry;
						
						
					def = entry;
					
					out += "\t\t\"def\": [" + def + "]\n";
					
					index = data.find("\n",index);
					index = data.length() if index == -1 else index;
					
					
				_:
					err = 1;
					label.text += "\n[color=red]FormatingError Converting Strange Tabing, On/before/affter Line: " + str(tag) + "[/color]"
					return "";
		
		elif data[index] == '\n':#End of line
			tabNum = 0;
			out += "\t},\n"
			index += 1;
		else:
			out += data[index];
			index += 1;
			
	out += "\t},\n";
	
	if order.size() > 0:
		out += "\t\"order\":[" ;
		for i in order.size()-1:
			out += "\"" + str(order[i]) + "\",";
		out += "\"" + str(order[order.size() -1]) + "\"";
		out += "]\n";
	else:
		err = 2;
		label.text += "\n[color=red]Could Not determine order[/color=red]"
		return "";
	
	out += "\n}"

	return out;
	
	
	


