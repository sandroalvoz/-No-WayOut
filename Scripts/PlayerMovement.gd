extends CharacterBody3D

var username:String
var tension :float = 0
var target_velocity = Vector3.ZERO
var baseSpeed: float = 10
var inExitRange : bool = false
var exitBoat
var period = 30
var timeSince = 0
var motionActivated:bool = false
var canMove:bool = true
#var multiplayerMode:bool = true
var fall_acceleration = 0.5
var health = 5
@onready var swordHitbox = $Node3D/JugadorModelo/Armature_001/Skeleton3D/BoneAttachment3D/Sword/SwordHitbox
@onready var animationPlayer = $Node3D/JugadorModelo/AnimationPlayer
@onready var soundPlayer =$AudioStreamPlayer3D

func _enter_tree():
	set_multiplayer_authority(name.to_int())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed ("Attack"):
		PerformAttack()
	if Input.is_action_pressed("Use"):
		if exitBoat != null:
			exitBoat.exit(self)
	if Input.is_action_pressed("Dodge"):
		canMove= false
		setStateDodge()
	pass
	
func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		var pointer = event.position
		#cabeza.basis = Basis.lookingat(pointer)

func _physics_process(delta):
	if !motionActivated: return
	var direction = Vector3.ZERO
	if canMove:
		if Input.is_action_pressed("MoveUp"):
			direction.z -=1
		if Input.is_action_pressed("MoveDown"): 
			direction.z +=1
		if Input.is_action_pressed("MoveLeft"): 
			direction.x -=1
		if Input.is_action_pressed("MoveRight"): 
			direction.x+=1
		if(direction!= Vector3.ZERO):
			setStateWalk()
			direction = direction.normalized()
			self.basis = Basis.looking_at(direction)
		else: setStateIdle()
		#$Pivot.basis = Basis.looking_at(direction)
		target_velocity.x = direction.x * baseSpeed *GetTension()
		target_velocity.z = direction.z * baseSpeed *GetTension()
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = -(fall_acceleration * delta)
	#if multiplayerMode:
		#print(is_multiplayer_authority())
		#if is_multiplayer_authority():
			#velocity = target_velocity
	#if multiplayerMode and is_multiplayer_authority():
		#print("Tengo control del jugador")
		#velocity = target_velocity
	velocity = target_velocity
	#print(velocity)
	move_and_slide()
	pass

func PerformAttack():
	#soundPlayer.stream = load()
	canMove = false
	var enemies = swordHitbox.get_overlapping_bodies()
	for enemy in enemies:
		print(enemy)
		if enemy.has_method("on_hit"): enemy.on_hit()
	setStateAttack()
	#soundPlayer.play()
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
	
func setStateIdle():
	canMove = true
	animationPlayer.play("Idle",0.05)

func setStateAttack():
	animationPlayer.play("Attack",0.05)

func setStateDodge():
	animationPlayer.play("Dodge",0.05)

func setStateWalk():
	animationPlayer.play("Walk",0.05)
	
func setStateDeath():
	animationPlayer.play("Death",0.05)

func on_hit():
	health-=1
	if health <=0:
		setStateDeath()

func destroy():
	self.queue_free()
