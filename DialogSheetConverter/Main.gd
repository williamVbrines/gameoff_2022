###############################################################################
#William Brines , Fairy Bound LLC
#Last updated 12-1-2020
#Date creatated 12-1-2020
#This class parses dialog from a json file and manages what each command tang
# and other dialog comming in from that json file.
###############################################################################
extends Node2D
##############################################################

export var _file_path : String = "null";#The path of the dialog file

var _raw_file_content : String = "null";

var d = {"a" : "a", "b" : "b"}
################################################################################
#This function when called saves a dictionary to a file.
################################################################################
func save_json_file(path : String, content : Dictionary) -> void:
	var file = File.new()
	if (file.open(path, File.WRITE)) != 0:
		print("!!Error : could not open file " + path );
		file.close();
		breakpoint;
	else:
		file.store_line(to_json(content));
		file.close();
	
	
################################################################################
#This loads a file into a string
#	The return value is strinng the contains what is transfered from the file as 
#text. If the file cannot be loaded the file will be closed and a breackpoint 
#will be set.
################################################################################
func load_file(path : String) -> String:
	var file = File.new();
	var data = "";
	
	if (file.open(path, File.READ)) != 0:
		$Label.text = "!!Error : could not open file " + path ;
		file.close();
	else:
		data = file.get_as_text();
		file.close();
		
	return data;
	
	
func _on_Button_pressed():
	$Label.text = "Processing" + $LineEdit.text;
	
	var new_content = _convert_to_json(load_file($LineEdit.text));

	
#	print(new_content);
#	var _file_content = parse_json(new_content);
#	print(_file_content);
#	if _file_content is Dictionary:
#
##C:\Users\William\Downloads\leek.trs
#		var maxIndex = $LineEdit.text.length() -1;
#		var path = $LineEdit.text;
#
#		print(_file_content);
#		print(path)
#
#		for i in maxIndex:
#			if path[maxIndex-i] == '.':
#				path.erase(maxIndex-i,maxIndex);
#				path += ".json";
#				break
#
#		print(path)
#
#		save_json_file(path, _file_content);
#
#		$Label.text = "Processing of " + $LineEdit.text + " complete";
#
#		$LineEdit.text = "";
#
#
#
func _convert_to_json(data : String) -> String:
	var out = "{\n";

	var tabNum : int = 0; 
	var index = 0;
	
	var lineNum = 0;
	var tag;
	var acc;
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
				1:#Acc
					tabNum = 2;
					acc = "";
					index += 1;
					
					acc = data.substr(index , data.find("\t", index) - index);
					index = data.find("\t",index);
					
					out += "\t\t\"acc\": \"" + acc + "\",\n";
					
				2:#Con
					tabNum = 3;
					con = "";
					index += 1;
					
					con = data.substr(index , data.find("\t", index) - index);
					index = data.find("\t",index);
					if con == "T":
						con = "true";
					if con == "F":
						con = "false"
						
					out += "\t\t\"con\": \"" + con + "\",\n";
					
				3:#Act
					tabNum = 4;
					
					index += 1;
					act = "";
					act += data.substr(index , data.find("\t", index) - index);
					index = data.find("\t",index);
					
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
					
				4:#Def
					tabNum = 4;
					
					index += 1;
					def = "[";
					def += data.substr(index , data.find("\n", index) - index);
					def += "]";
					
					index = data.find("\n",index);
					index = data.length() if index == -1 else index;
					
					out += "\t\t\"def\": " + def + "\n";
					
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
	out += "\t\"order\":[" ;
	for i in order.size()-1:
		out += "\"" + str(order[i]) + "\",";
	out += "\"" + str(order[order.size()-1]) + "\"";
	out += "]\n";
	out += "\n}"
	
	print(out)
	return out;
	
func _on_PopUP_pressed():
	if $FileDialog.visible == true:
		$FileDialog.hide();
	else: 
		$FileDialog.popup(Rect2(0,0,0,0))
	
	
func _on_FileDialog_file_selected(path):
	$LineEdit.text = path;
	
	
