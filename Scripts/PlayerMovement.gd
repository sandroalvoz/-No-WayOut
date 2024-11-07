extends CharacterBody3D

var tension :float = 0
var target_velocity = Vector3.ZERO
@export var baseSpeed: float
@onready var soundPlayer = $AudioStreamPlayer3D
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed ("Attack"):
		#perform attack
		print("jaj estoy atacando")
	pass
	
func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		var pointer = event.position
		#cabeza.basis = Basis.lookingat(pointer)

func _physics_process(delta):
	var direction = Vector3.ZERO
	#direction = Input.get_vector("MoveLeft","MoveRight","MoveUp","MoveDown")
	if Input.is_action_pressed("MoveUp"): 
		direction.x +=1
	if Input.is_action_pressed("MoveDown"): 
		direction.x -=1
	if Input.is_action_pressed("MoveLeft"): 
		direction.z +=1
	if Input.is_action_pressed("MoveRight"): 
		direction.z -=1
	if(direction!= Vector3.ZERO):
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)
	target_velocity.x = direction.x * baseSpeed *GetTension()
	target_velocity.z = direction.z * baseSpeed *GetTension()
	#Vertical velocity
	#if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		#target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	velocity = target_velocity
	move_and_slide()
	pass

func PerformAttack():
	#soundPlayer.stream = load()
	soundPlayer.play()
	#demas cosas de ataque
	
	pass
	
func GetTension():
	return 1.0+tension*0.2
