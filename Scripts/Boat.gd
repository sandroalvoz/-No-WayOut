extends CharacterBody3D
@onready var island= $"../Terrain"
var distance = 70
var islandMesh
var speed = 4
var health = 4
var boatState = boatStates.arriving
enum boatStates{arriving, onLand, leaving}
var center
@onready var player = $Player
#referencia al jugador
# Called when the node enters the scene tree for the first time.
func _ready():
	islandMesh = island.mesh
	center = Vector3(island.position.x, position.y, island.position.z)+ Vector3(island.xSize / 2, 0,  island.zSize / 2)
	self.position = getSpawnPosition(center)
	var direction_to_center = (center - position).normalized()
	self.global_transform.basis = Basis.looking_at(Vector3(direction_to_center.x, position.y, direction_to_center.z))
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
	if boatState==boatStates.arriving:
		var direction_to_center = (center - position).normalized()
		var move_vector = direction_to_center * speed * delta
		var collision = move_and_collide(move_vector)
		if collision:
			if collision.get_collider()!=player:
				boatState = boatStates.onLand
				on_arrival()
	if boatState==boatStates.leaving:
		#alejarse de la isla
		#mandar señal para abandonar la partida
		print("jeje")
	pass
func on_arrival():
	player.reparent(self.get_parent())
	pass
	
func on_hit():
	health-=1
	if health<=0:
		self.queue_free()
