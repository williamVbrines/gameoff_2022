###############################################################################
#William Brines , Fairy Bound LLC
#Last updated 9-29-2020
#Date creatated 9-26-2020
#This class parses dialog from a json file and manages what each command tang
# and other dialog comming in from that json file.
###############################################################################
extends Node2D
##############################################################

export var _file_path : String = "null";#The path of the dialog file

var _raw_file_content : String = "null";
	
	

	
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
	
	_raw_file_content = load_file($LineEdit.text);
	
	for index in _raw_file_content.length():
		if _raw_file_content[index] == '\n':
			_raw_file_content.erase(0,index+1);
			break
			
	_raw_file_content = "{\"" + _raw_file_content;
	
	var hold = "";
	
	for index in _raw_file_content.length():
		if _raw_file_content[index] == '\t':
			hold += "\": ";
		elif _raw_file_content[index] == '\n':
			hold += ",\"";
		else:
			hold += _raw_file_content[index];
			
	_raw_file_content = hold + "}\n\n"
	
	var _file_content = parse_json(_raw_file_content);
	
	if _file_content is Dictionary:

#C:\Users\William\Downloads\leek.trs
		var maxIndex = $LineEdit.text.length() -1;
		var path = $LineEdit.text;
		
		print(path)
		
		for index in maxIndex:
			if path[maxIndex-index] == '.':
				path.erase(maxIndex-index,maxIndex);
				path += ".json";
				break
				
		print(path)
		
		save_json_file(path, _file_content);
	
		$Label.text = "Processing of " + $LineEdit.text + " complete";
		
		$LineEdit.text = "";
	
		


func _on_PopUP_pressed():
	if $FileDialog.visible == true:
		$FileDialog.hide();
	else: 
		$FileDialog.popup(Rect2(0,0,0,0))

func _on_FileDialog_file_selected(path):
	$LineEdit.text = path;

