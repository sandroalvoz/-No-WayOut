@tool
extends MeshInstance3D

@export var xSize = 20
@export var zSize = 20

@export var max_height = 8.0 # Altura máxima de la isla
@export var falloff_strength = 2.0 # Controla la pendiente hacia los bordes
@export var frequency = 0.2 # Frecuencia del ruido

@export var update = false
@export var clear_vert_vis = false

func _ready():
	generate_terrain()

func generate_terrain():
	# Limpia el terreno previo si es necesario
	if clear_vert_vis:
		for child in get_children():
			child.queue_free()
		clear_vert_vis = false

	var a_mesh: ArrayMesh
	var surftool = SurfaceTool.new()
	var n = FastNoiseLite.new()
	
	# Cambia la semilla para generar terreno distinto cada vez
	n.seed = randi()  
	n.noise_type = FastNoiseLite.TYPE_PERLIN
	n.frequency = frequency
	
	surftool.begin(Mesh.PRIMITIVE_TRIANGLES)

	# Centro de la malla, para calcular la distancia a los bordes
	var center = Vector2(xSize / 2, zSize / 2)

	for z in range(zSize + 1):
		for x in range(xSize + 1):
			# Generar altura basada en el ruido
			var y = n.get_noise_2d(x * 0.5, z * 0.5) * max_height
			
			# Calcular distancia del punto al centro, normalizada entre 0 y 1
			var dist_to_center = (Vector2(x, z) - center).length() / (xSize / 2)
			dist_to_center = clamp(dist_to_center, 0, 1) # Limitar a valores entre 0 y 1
			
			# Ajustar la altura aplicando una función de atenuación basada en dist_to_center
			var falloff = pow(1.0 - dist_to_center, falloff_strength)
			y *= falloff

			# Forzar reducción en los bordes
			if dist_to_center > 0.8:
				y -= (dist_to_center - 0.8) * max_height * 2.0 # Reduce en los bordes

			# Coordenadas UV para texturizado
			var uv = Vector2(inverse_lerp(0, xSize, x), inverse_lerp(0, zSize, z))
			surftool.set_uv(uv)

			# Añadir vértice
			surftool.add_vertex(Vector3(x, y, z))
			draw_sphere(Vector3(x, y, z))

	var vert = 0
	for z in range(zSize):
		for x in range(xSize):
			surftool.add_index(vert)
			surftool.add_index(vert + 1)
			surftool.add_index(vert + xSize + 1)
			surftool.add_index(vert + xSize + 1)
			surftool.add_index(vert + 1)
			surftool.add_index(vert + xSize + 2)
			vert += 1
		vert += 1

	surftool.generate_normals()
	a_mesh = surftool.commit()
	mesh = a_mesh

func draw_sphere(pos: Vector3):
	var ins = MeshInstance3D.new()
	add_child(ins)
	ins.position = pos
	var sphere = SphereMesh.new()
	sphere.radius = 0.1
	sphere.height = 0.2
	ins.mesh = sphere

func _process(delta):
	if update:
		generate_terrain()
		update = false
	pass
