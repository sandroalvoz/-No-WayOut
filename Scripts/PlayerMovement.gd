extends CharacterBody3D

var tension :float = 0
var target_velocity = Vector3.ZERO
var baseSpeed: float = 10
@onready var soundPlayer = $AudioStreamPlayer3D

var inExitRange : bool = false
var exitBoat
var period = 30
var timeSince = 0

func _enter_tree():
	set_multiplayer_authority(name.to_int())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed ("Attack"):
		PerformAttack()
		print("jaj estoy atacando")
	if Input.is_action_pressed("Use"):
		if exitBoat != null:
			exitBoat.exit(self)
	pass
	
func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		var pointer = event.position
		#cabeza.basis = Basis.lookingat(pointer)

func _physics_process(delta):
	var direction = Vector3.ZERO
	#direction = Input.get_vector("MoveLeft","MoveRight","MoveUp","MoveDown")
	if Input.is_action_pressed("MoveUp"): 
		direction.z -=1
	if Input.is_action_pressed("MoveDown"): 
		direction.z +=1
	if Input.is_action_pressed("MoveLeft"): 
		direction.x -=1
	if Input.is_action_pressed("MoveRight"): 
		direction.x+=1
	if(direction!= Vector3.ZERO):
		direction = direction.normalized()
		self.basis = Basis.looking_at(direction)
		#$Pivot.basis = Basis.looking_at(direction)
	target_velocity.x = direction.x * baseSpeed *GetTension()
	target_velocity.z = direction.z * baseSpeed *GetTension()
	
	#Vertical velocity
	#if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		#target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	#if is_multiplayer_authority():
		#velocity = target_velocity
	velocity = target_velocity
	move_and_slide()
	pass

func PerformAttack():
	#soundPlayer.stream = load()
	soundPlayer.play()
	#demas cosas de ataque
	
	pass

func addTension(n):
	tension += n
	timeSince = 0
	
func GetTension():
	return 1.0+(tension*0.2)

func timer(delta):
	timeSince+=delta
	if timeSince>=period:
		timeSince=0
		if tension >0: tension-=1

func _on_area_3d_body_entered(body):
	pass # Replace with function body.
