extends Node

const defaultAddress = "localhost"
@onready var serverIp = $UI/MarginContainer/VBoxContainer/HBoxContainer2/ServerIp
@onready var serverScene = "res://Scenes/Server.tscn"
var spectatorMode: bool = false

func _ready():
	pass

func _on_join_server_pressed():
	var serverAddress = serverIp.text
	if serverAddress =="":
		serverAddress = defaultAddress
	GlobalData.serverAddress = serverAddress
	#get_tree().change_scene_to_file("res://Scenes/Client.tscn")
	get_tree().change_scene_to_file("res://Scenes/EscenarioPrueba.tscn")
	pass # Replace with function body.


func _on_host_server_pressed():
	GlobalData.spectatorMode = spectatorMode
	get_tree().change_scene_to_file(serverScene)
	pass # Replace with function body.

func _on_spectator_toggle_toggled(toggled_on):
	spectatorMode = toggled_on
	print(spectatorMode)
	pass # Replace with function body.
