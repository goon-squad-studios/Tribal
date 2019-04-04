extends Node

var DEFAULT_PORT = 42069 #nice
var MAX_PEERS = 4 #3 users and 1 reserved for the server itself

var players = {}
var player_name

signal player_list_changed()
signal connection_failed()
signal connection_succeeded()
signal game_ended()
signal game_error(what)

func start_server():
	player_name = "Server"
	var host = NetworkedMultiplayerENet.new()
	
	host.create_server(DEFAULT_PORT, MAX_PEERS)
	get_tree().set_network_peer(host)
	
func join_server(ip, new_player_name):
	player_name = new_player_name
	var host = NetworkedMultiplayerENet.new()
	
	host.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(host)

#ignore
func _player_connected():
	pass
	
func _player_disconnected(id):
	emit_signal("player_list_changed")
	emit_signal("game_ended")
	unregister_player(id)
	rpc("unregister_player", id)


func _connected_ok():
	rpc("register_player", get_tree().get_network_unique_id(), player_name)
	emit_signal("connection_succeeded")
	
remote func unregister_player(id):
	emit_signal("player_list_changed")
	players.erase(id)
	
remote func register_player(id, new_player_name):
	if get_tree().is_network_server():
		rpc_id(id, "register_player", 1, player_name)
		for pid in players:
			rpc_id(id, "register_player", pid, players[pid])
			rpc_id(pid, "register_player", id, new_player_name)
			
	players[id] = new_player_name
	emit_signal("player_list_changed")
	
	
func _connected_fail():
	get_tree().set_network_peer(null)
	emit_signal("connection_failed")
	
func _server_disconnected():
	emit_signal("game_error", "Server has been disconnected")
	get_tree().set_network_peer(null)
	players.clear()
	
func spawn_player():
	var player_scene = load("res://player/player.tscn")
	var player = player_scene.instance()
	get_parent().add_child(player)
	var spawn_pos = get_node("spawn_points/0").position
	player.position = spawn_pos
	
	
func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
