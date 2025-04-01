extends Control



func _on_host_button_pressed():
	Network.player_info["Name"] = $NameLine.get_text()
	Network.player_info["Class"] = $OptionButton.get_text()
	Network.host_game($AddressLine.get_text())
	get_tree().change_scene_to_file("res://lobby.tscn")

func _on_join_button_pressed():
	Network.player_info["Name"] = $NameLine.get_text()
	Network.player_info["Class"] = $OptionButton.get_text()
	Network.join_game($AddressLine.get_text())
	get_tree().change_scene_to_file("res://lobby.tscn")
