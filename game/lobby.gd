extends Control


func ready():
	playerntwrk.connect("connection_failed", self, "_on_connection_failed")
	playerntwrk.connect("connection_succeeded", self, "_on_connection_success")
	playerntwrk.connect("player_list_changed", self, "refresh_lobby")
	playerntwrk.connect("game_ended", self, "_on_game_ended")
	playerntwrk.connect("game_error", self, "_on_game_error")

func _on_connect_server_pressed():
	var username = get_node("Panel/name_tag/username").text
	#eventually implement a "is_valid_username" function
	if username == "":
		get_node("Panel/err").text = "Please enter a valid username"
		return
	#check to make sure the ip's good before connecting
	var ip = get_node("Panel/ip_tag/ip").text
	if not ip.is_valid_ip_address():
		get_node("Panel/err").text = "IPv4 not valid"
		return
	
	#attempt to connect
	var host = NetworkedMultiplayerENet.new()
	print("connecting...")
	host.create_client(ip, 42069)
	get_tree().set_network_peer(host)

func _on_host_server_pressed():
	#eventually implement a "is_valid_username" function
	if get_node("Panel/ip_tag/ip").text == "":
		get_node("Panel/err").text = "Please enter a valid username"
		return
#bring them to a lobby table if it's a good username
	print("hello")
	
func _on_connection_failed():
	pass
	
func _on_connection_success():
	pass

func refresh_lobby():
	pass

func _on_game_ended():
	pass

func _on_game_error():
	pass