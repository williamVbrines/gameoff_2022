extends Node2D

@export var _file_path : String = "null";#The path of the dialog file

var _raw_file_content : String = "null";

func _ready() -> void:
	var res = load("res://out.tres") as DialogData;
	if res != null:
		print(res.data)
	
################################################################################
#This function when called saves a dictionary to a file.
################################################################################
func save_json_file(path : String, content : Dictionary) -> void:
	var file = FileAccess.open(path , FileAccess.WRITE)

	if file != null:
		print("!!Error : could not open file " + path );
		breakpoint;
	else:
		file.store_line(JSON.new().stringify(content));
	
	
################################################################################
#This loads a file into a string
#	The return value is strinng the contains what is transfered from the file as 
#text. If the file cannot be loaded the file will be closed and a breackpoint 
#will be set.
################################################################################
func load_file(path : String) -> String:
	
	var file = FileAccess.open(path, FileAccess.READ)
	var data = "";
	
	if file == null:
		$Label.text = "!!Error : could not open file " + path ;
	else:
		data = file.get_as_text();
		
	return data;
	
	
func _on_Button_pressed():
	$Label.text = "Processing" + $LineEdit.text;
	
	var new_content = _convert_to_json(load_file($LineEdit.text));
	print(new_content);
	print(JSON.parse_string(new_content));
	save_data(new_content)
	
	
func save_data(data : String) -> void:
	var dialog_data = DialogData.new();
	dialog_data.data = JSON.parse_string(data);
	ResourceSaver.save(dialog_data,"res://out.tres")
	
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
	#Constrution = "tag" : { "Access" : "acc", "Condition" : "con"}
	
	while index < data.length():
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
			order.append(tag);
			
		elif data[index] == '\t': #IF tab
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
					var i = 0;
					while i < act.length():
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
							
						i += 1;
					
					if entry.length() >= 1:
						if act[0] != '\"':
							entry = "\"" + entry;
						
					act = entry;

					out += "\t\t\"act\": [" + act + "],\n";
					
				3:#Def
					tabNum = 3;
					
					index += 1;
					def = "";
					def += data.substr(index , data.find("\n", index) - index -1);
					
					def = def.substr(0, def.rfind(";") + 1);
					
					def = def.replace("\"", "");
					
					var entry = "";
					var i = 0;
					
					while i < def.length():
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
							
						i += 1;
					
					
					if entry.length() >= 1:
						if def[0] != '\"':
							entry = "\"" + entry;
						
						
					def = entry;
					
					out += "\t\t\"def\": [" + def + "]\n";
					
					index = data.find("\n",index);
					index = data.length() if index == -1 else index;
					
					
				_:
					index += 1;
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

	out += "\n}"

	return out;
	
	
func _on_PopUP_pressed():
	if $FileDialog.visible == true:
		$FileDialog.hide();
	else: 
		$FileDialog.popup(Rect2(0,0,0,0))
	
	
func _on_FileDialog_file_selected(path):
	$LineEdit.text = path;
	
	
