extends Node3D

signal player_connected()
# Called when the node enters the scene tree for the first time.
func _ready():
	 # Conectar la señal `player_connected` al método `sync_params_to_new_player`
	get_node("..").connect("player_connected", signalRelay)

func signalRelay():
	emit_signal("player_connected")
