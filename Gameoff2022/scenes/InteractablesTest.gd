extends InteractableArea3D

@onready var mesh: MeshInstance3D = $MeshInstance3D

func _on_area_hovered() -> void:
	mesh.get_active_material(0).set("albedo_color", Color.GREEN);


func _on_area_pressed() -> void:
	mesh.get_active_material(0).set("albedo_color", Color.DARK_GREEN);


func _on_area_released() -> void:
	if is_hovered:
		mesh.get_active_material(0).set("albedo_color", Color.GREEN);
	else:
		mesh.get_active_material(0).set("albedo_color", Color.WHITE);


func _on_area_unhovered() -> void:
	mesh.get_active_material(0).set("albedo_color", Color.WHITE);
