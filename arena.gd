extends Node3D # Or Node2D.

var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene

func _on_host_button_pressed():
	peer.create_server(2828)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	print("testhost")
	add_player()
	$CanvasLayer.hide()

func _on_join_button_pressed():
	peer.create_client("127.0.0.1,",2828)
	multiplayer.multiplayer_peer = peer
	print("testjoin")
	$CanvasLayer.hide()

func add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)

func del_player(id):
	rpc("_del_player",id)

@rpc("any_peer", "call_local")
func _del_player(id):
	rpc("_del_player",id)

func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	
"""
func remove_multiplayer_peer():
	multiplayer.multiplayer_peer = null


# When the server decides to start the game from a UI scene,
# do Lobby.load_game.rpc(filepath)
@rpc("call_local", "reliable")
func load_game(game_scene_path):
	get_tree().change_scene_to_file(game_scene_path)


# Every peer will call this when they have loaded the game scene.
@rpc("any_peer", "call_local", "reliable")
func player_loaded():
	if multiplayer.is_server():
		players_loaded += 1
		if players_loaded == players.size():
			$/root/Game.start_game()
			players_loaded = 0


# When a peer connects, send them my player info.
# This allows transfer of all desired data for each player, not only the unique ID.
func _on_player_connected(id):
	_register_player.rpc_id(id, player_info)


@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)


func _on_player_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)


func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)


func _on_connected_fail():
	multiplayer.multiplayer_peer = null


func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()

# Default game server port. Can be any number between 1024 and 49151.
# Not present on the list of registered or common ports as of December 2022:
# https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
@onready var address = $Address
@onready var host_button = $HostButton
@onready var join_button = $JoinButton
@onready var status_ok = $StatusOk
@onready var status_fail = $StatusFail
@onready var port_forward_label = $PortForward
@onready var find_public_ip_button = $FindPublicIP

var peer = null

func _ready():
	# Connect all the callbacks related to networking.
	multiplayer.peer_connected.connect(_player_connected)
	multiplayer.peer_disconnected.connect(_player_disconnected)
	multiplayer.connected_to_server.connect(_connected_ok)
	multiplayer.connection_failed.connect(_connected_fail)
	multiplayer.server_disconnected.connect(_server_disconnected)

#### Network callbacks from SceneTree ####

# Callback from SceneTree.
func _player_connected(_id):
	# Someone connected, start the game!
	var pong = load("res://pong.tscn").instantiate()
	# Connect deferred so we can safely erase it from the callback.
	pong.game_finished.connect(_end_game, CONNECT_DEFERRED)

	get_tree().get_root().add_child(pong)
	hide()


func _player_disconnected(_id):
	if multiplayer.is_server():
		_end_game("Client disconnected")
	else:
		_end_game("Server disconnected")


# Callback from SceneTree, only for clients (not server).
func _connected_ok():
	pass # This function is not needed for this project.


# Callback from SceneTree, only for clients (not server).
func _connected_fail():
	_set_status("Couldn't connect.", false)

	multiplayer.set_multiplayer_peer(null) # Remove peer.
	host_button.set_disabled(false)
	join_button.set_disabled(false)


func _server_disconnected():
	_end_game("Server disconnected.")

##### Game creation functions ######

func _end_game(with_error = ""):
	if has_node("/root/Pong"):
		# Erase immediately, otherwise network might show
		# errors (this is why we connected deferred above).
		get_node(^"/root/Pong").free()
		show()

	multiplayer.set_multiplayer_peer(null) # Remove peer.
	host_button.set_disabled(false)
	join_button.set_disabled(false)

	_set_status(with_error, false)


func _set_status(text, isok):
	# Simple way to show status.
	if isok:
		status_ok.set_text(text)
		status_fail.set_text("")
	else:
		status_ok.set_text("")
		status_fail.set_text(text)


func _on_host_pressed():
	peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(DEFAULT_PORT, 1) # Maximum of 1 peer, since it's a 2-player game.
	if err != OK:
		# Is another server running?
		_set_status("Can't host, address in use.",false)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)

	multiplayer.set_multiplayer_peer(peer)
	host_button.set_disabled(true)
	join_button.set_disabled(true)
	_set_status("Waiting for player...", true)

	# Only show hosting instructions when relevant.
	port_forward_label.visible = true
	find_public_ip_button.visible = true


func _on_join_pressed():
	var ip = address.get_text()
	if not ip.is_valid_ip_address():
		_set_status("IP address is invalid.", false)
		return

	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, DEFAULT_PORT)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)

	_set_status("Connecting...", true)


func _on_find_public_ip_pressed():
	OS.shell_open("https://icanhazip.com/")
"""

