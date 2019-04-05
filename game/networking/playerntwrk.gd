extends Node

var DEFAULT_PORT = 42069 #nice
var MAX_PEERS = 5 #4 users and 1 reserved for the server itself

signal connection_failed()
signal connecteion_succeeded()
signal player_list_changed()
signal game_ended()
signal game_error(what)

var player_name
var players = {}

	
func _ready():
#warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_player_connected")
#warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
#warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "_connected_ok")
#warning-ignore:return_value_discarded
	get_tree().connect("connection_failed", self, "_connected_fail")
#warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func _player_connected(id):
	pass
	
func _player_disconnected(id):
	pass

func _connected_ok():
	rpc("register_player", get_tree().get_network_unique_id(), player_name)
	emit_signal("connecteion_succeeded")
	
	pass
	
remote func register_player(id, name):
	if get_tree().is_network_server():
		 #If we are the server, let everyone know about the new player
		rpc_id(id, "register_player", 1, player_name) # Send myself to new dude
		for p_id in players: # Then, for each remote player
#			print(players.size())
			rpc_id(id, "register_player", p_id, players[p_id]) # Send player to new dude
			rpc_id(p_id, "register_player", id, name) # Send new dude to player

	players[id] = name
	emit_signal("player_list_changed")
	
func remove_player(id):
	players.erase(id)

func host_game(username):
	player_name = username
	var host = NetworkedMultiplayerENet.new()
	host.create_server(DEFAULT_PORT, MAX_PEERS)
	get_tree().set_network_peer(host)
	
func join_game(ip, username):
	player_name = username
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(host)

func _connected_fail():
	emit_signal("connection_failed")
	pass
	
func _server_disconnected():
	emit_signal("game_ended")
	pass
	
func begin_game():
	
	assert(get_tree().is_network_server())
	
	var world = load("res://field.tscn").instance()
	var player = load("res://player/player.tscn").instance()

	get_tree().get_root().add_child(world)
	get_tree().get_root().get_node("lobby").hide()

	var pos = world.get_node("spawn_points/0").position

	player.position = pos
	player.set_network_master(1) 

	world.get_node("players").add_child(player)
	
func get_playername():
	return player_name