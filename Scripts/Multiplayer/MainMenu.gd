extends Node

const defaultAddress = "localhost"
@onready var serverIp = $UI/MarginContainer/VBoxContainer/HBoxContainer2/ServerIp
@onready var serverScene = "res://Scenes/Server.tscn"
var spectatorMode: bool = false
const port = 3789


func _on_join_server_pressed():
	var serverAddress = serverIp.text
	if serverAddress =="":
		serverAddress = defaultAddress
	GlobalData.serverAddress = serverAddress
	#var peer =  ENetMultiplayerPeer.new()
	#var client = peer.create_client(GlobalData.serverAddress, port)
	#multiplayer.multiplayer_peer = peer
	GlobalData.multiplayerMode = GlobalData.multiplayerModes.CLIENT
	get_tree().change_scene_to_file("res://Scenes/MultiplayerGame.tscn")
	#get_tree().change_scene_to_file("res://Scenes/EscenarioPrueba.tscn")
	pass


func _on_host_server_pressed():
	GlobalData.spectatorMode = spectatorMode
	GlobalData.multiplayerMode = GlobalData.multiplayerModes.SERVER
	get_tree().change_scene_to_file("res://Scenes/MultiplayerGame.tscn")
	pass

func _on_spectator_toggle_toggled(toggled_on):
	spectatorMode = toggled_on
	print(spectatorMode)
	pass
