extends Resource

class_name NPCTactics

const HEAL = 0;
const GUARD = 1;
const ATTACK = 3;

func get_action(_pers : float, _annoy : float, _guard_turns : int) -> int:
	var tof = randi()%100 > 20 && SystemGlobals.persuasion > 30
	prints("BEEEp",tof )
	return ATTACK if tof else HEAL;
