extends Node

const defaultAddress = "localhost"
const port = 3789
@onready var username = $UI/MarginContainer/VBoxContainer/HBoxContainer/Username
@onready var serverIp = $UI/MarginContainer/VBoxContainer/HBoxContainer2/ServerIp
var peer = ENetMultiplayerPeer.new()

func _on_button_pressed():
	var serverAddress = serverIp.text
	if serverAddress =="":
		serverAddress = defaultAddress
	peer.create_client("localhost", port)
	multiplayer.multiplayer_peer = peer
