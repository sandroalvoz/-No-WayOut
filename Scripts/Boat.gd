extends CharacterBody3D
@onready var island= $"../Terrain"
var distance = 45
var islandMesh
var speed = 8
var health = 4
var boatState = boatStates.arriving
enum boatStates{arriving, onLand, leaving}
var center
var playersOnArea = 0
@onready var interactableArea = $InteractableArea
@onready var player = $Player


#referencia al jugador
# Called when the node enters the scene tree for the first time.
func _ready():
	islandMesh = island.mesh
	center = Vector3(island.position.x, position.y, island.position.z)+ Vector3(island.xSize / 2, 0,  island.zSize / 2)
	self.position = getSpawnPosition(center)
	var direction_to_center = (center - position).normalized()
	self.global_transform.basis = Basis.looking_at(Vector3(direction_to_center.x, position.y, direction_to_center.z))
	interactableArea.set_process(false)
	pass # Replace with function body.

func getSpawnPosition(center):
	var angle_radians = deg_to_rad(randf() * 360)
	return Vector3(center.x + cos(angle_radians) * distance, self.position.y, center.z + sin(angle_radians) * distance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if boatState!= boatStates.onLand:
		move(delta)
	pass

func move(delta):
	var direction_to_center = (center - position).normalized()
	var move_vector = direction_to_center * speed * delta
	if boatState==boatStates.arriving:
		var collision = move_and_collide(move_vector)
		if collision:
			if collision.get_collider()!=player:
				boatState = boatStates.onLand
				on_arrival()
	if boatState==boatStates.leaving:
		move_and_collide(-move_vector)
		if position.distance_to(center)>30:
			print("ha huido")
			#mandar señal para abandonar la partida
	pass
func on_arrival():
	player.reparent(self.get_parent())
	interactableArea.set_process(true)
	pass
	
func on_hit():
	health-=1
	if health<=0:
		self.queue_free()


func _on_area_3d_body_entered(body):
	body.inExitRange = true
	body.exitBoat = self 

func _on_area_3d_body_exited(body):
	body.inExitRange = false

func exit(player):
	if boatState ==boatStates.onLand:
		player.reparent(self)
		boatState=boatStates.leaving
