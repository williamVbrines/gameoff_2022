extends Node

var player_stats : Dictionary = {
	"CHARM" : 50,
	"LOGIC" : 50,
	"DECEPTION" : 50,
	"INTIMIDATION" : 50
}
	
	
var player_tactics : Dictionary = {
	"SLOT:1" : "EMPTY",
	"SLOT:2" : "EMPTY",
	"SLOT:3" : "EMPTY",
	"AVAILABLE" : ["test"] #List of all available tatictics to the player.
}
	
	
var player_items : Array[String] = [] #List of refids to all items the player has
var player_clues : Array[String] = [] #List of refids to all clues the player has
