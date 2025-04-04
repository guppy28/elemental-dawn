extends Control



func _on_button_pressed() -> void:
	Network.load_game("res://arena.tscn")


func _on_red_team_join_button_pressed() -> void:
	$RedTeamList.add_item(Network.player_info["Name"])



func _on_blue_team_join_button_pressed() -> void:
	$BlueTeamList.add_item(Network.player_info["Name"])
