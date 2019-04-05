extends Control

func ready():
	playerntwrk.connect("connection_failed", self, "_on_connection_failed")
	playerntwrk.connect("connection_succeeded", self, "_on_connection_success")
	playerntwrk.connect("player_list_changed", self, "refresh_lobby")
	playerntwrk.connect("game_ended", self, "_on_game_ended")
	playerntwrk.connect("game_error", self, "_on_game_error")

func _on_connect_server_pressed():
	#make sure the info is good
	var username = get_node("connect/name_tag/username").text
	var ip = get_node("connect/ip_tag/ip").text
	var err = get_node("connect/err").text
	if username == "":
		err = "Please enter a valid username"
		return
	elif not ip.is_valid_ip_address():
		err = "Please enter a valid IP adress"
		return
	#if the user and ip are good, continue
	get_node("connect/host_server").disabled = true
	get_node("connect/connect_server").disabled = true
	playerntwrk.join_game(ip, username)
	
func _on_host_server_pressed():
	var username = get_node("connect/name_tag/username").text
	var err = get_node("connect/err").text
	if username == "":
		err = "Please enter a valid username"
		return
	#if the user is good, continue
	playerntwrk.host_game(username)
	
	get_node("connect").hide()
	get_node("players").show()
	get_node("players/player_list").add_item(username)
	
func _on_connection_failed():
	get_node("connect/host_server").disabled = true
	get_node("connect/connect_server").disabled = true
	get_node("connect/err").text = "Couldn't connect to host"
	pass

func _on_connection_success():
	pass

func refresh_lobby():
	pass

func _on_game_ended():
	pass

func _on_game_error():
	pass


func _on_start_pressed():
	playerntwrk.begin_game()
