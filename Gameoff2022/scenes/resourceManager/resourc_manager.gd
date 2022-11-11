extends Node

var tactics_data = {
	#"RefID" : preload(res:path),
	"test" : preload("res://scenes/resources/actions/tactics/test_tactic.tres")
}
	
	
func get_tactic(id : String) -> TacticsData:
	return tactics_data.get(id,null);
	
	
