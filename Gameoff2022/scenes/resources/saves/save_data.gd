extends Resource
class_name SaveData

const PREFIX : String = "Save"
@export var user_message : String = "This is a normal file";
@export var version : String = "00001";
@export var data : Dictionary = {};
@export var data_hash : int = 0;

func save_data(file_name : String = PREFIX + "1") -> void:
	var path = OS.get_executable_path();
	path = path.substr(0,path.rfind("/")+1) + file_name + ".tres"
	_gather_data();
	data_hash = str(data).hash();
	print(data)
	ResourceSaver.save(self,path);
	
	
func _gather_data() -> void:
	data["SystemGlobals"] = SystemGlobals.data_dump();

func laod_data() -> void:
	prints("LAoding data",data)
#	if str(data).hash() == data_hash:
	user_message = "This is a normal file";
	EventManager.load_data.emit(data);
	print("LAoding data")
	return;
	
#	if user_message == "This is a normal file": user_message = "Warning if you do mess with this file you may cause strange behavior";
#	else: hiden();
		
func hiden():
	var new_hash = 1800;
	match data_hash-new_hash:
		0:
			user_message = "Are you sure? replace me with Y for yes or N for no"
			new_hash += 1;
		1:
			if user_message == "Y":
				user_message = "Neat, I can only wonder why you would want to do this";
				new_hash += 2;
			elif user_message == "N":
				user_message = "Well then put me back to normal";
				new_hash += 0;
			else:
				user_message = "Well that is not an Y or N";
				new_hash += 1;
			
		2:
			user_message = "So how is your day? Y = GOOD, N = BAD, M = Meh";
			new_hash += 3;
		3:
			if user_message == "M" || user_message == "N" :
				user_message = "Yea, I know m'bud but you things can always get better."
				new_hash += 4;
			elif user_message == "Y":
				user_message = "Well that is good to hear, keep up the good attitude";
				new_hash += 4;
		4:
			user_message = "You know what it says here in you file data that you have a high chance of having fun with this game";
			new_hash += 5;
		5:
			user_message = "Well I could sugest another that I am apart of, its called Punchcard https://devratgames.itch.io/punchcard"
			new_hash += 6;
		6:
			user_message = "Hey lets play guess the number. Replace me with your guess its from 0-10btw";
			new_hash += 7;
		7:
			if user_message.is_valid_int():
				var num = randi_range(0,10);
				var n = user_message.to_int();
				if n == num:
					user_message = "Good guess m'bud you got it";
					new_hash += 8;
				else :
					new_hash += 7;
					user_message = "Darn, the nuber was : " + num + "Try again";
		8:
			user_message = "Well its been nice talking to you m'bud but I got to sleep."
			new_hash += 9;
		9:
			user_message = "ZZZZZZZ";
			new_hash += 9;
		_: 
			user_message = "How strange that you are messing with the hash";
			
			
	if user_message != "This is a normal file":
		data_hash = new_hash;
		save_data("strange");








