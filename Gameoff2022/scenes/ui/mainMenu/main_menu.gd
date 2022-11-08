extends Control



func _on_play_button_pressed() -> void:
	$Label.set_text("Play_Pressed")


func _on_options_button_pressed() -> void:
	$Label.set_text("Options_Pressed")


func _on_credits_button_pressed() -> void:
	$Label.set_text("Credits_Pressed")


func _on_exit_button_pressed() -> void:
	$Label.set_text("Exit_Pressed")
