extends Resource

class_name NPCTactics

const HEAL = 0;
const GUARD = 1;
const ATTACK = 3;

func get_action(_pers : float, _annoy : float, _guard_turns : int) -> int:
	seed(int(_pers + _annoy))
	var tof = randi()%100 > 30 && SystemGlobals.persuasion <= 60
	return ATTACK if tof else HEAL;
