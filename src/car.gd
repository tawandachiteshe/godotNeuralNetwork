extends KinematicBody2D
var Velocity : Vector2
var speed : float = 100
var rot_speed : = 1.5
var rot_dir = 0
var sensors_pos = []

export var nn: Script 
var brain
var inputs = []
var sens
func _ready():
	sens = $rays.get_children()
	brain = nn.NeuralNetwork.new(2,3,2)

func sensors():
	inputs = brain.predict([1,0])
	brain.train([1,0],[1,0])
	print(brain.weights_input_to_hidden.data)
	
	
func load_model():
	var file:File = File.new()
	file.open("res://model.gtm", File.READ)
	var content = file.get_var(true)
	file.close()
	return content
func save_model(content):
	var file = File.new()
	file.open("res://model.gtm", File.WRITE)
	file.store_var(content,true)
	file.close()
func human_movement():
	Velocity = Vector2.ZERO
	rot_dir = 0
	if inputs[0]:
		rot_dir -= 1
	if inputs[1]:
		rot_dir += 1
	if inputs[0]:
		Velocity = Vector2(speed, 0).rotated(rotation)
	if inputs[1]:
		Velocity = Vector2(-speed, 0).rotated(rotation)

func _physics_process(delta):
	update()
	sensors()
	human_movement()
	rotation += rot_dir * rot_speed * delta
	move_and_slide(Velocity)
func _draw():
	for hit in sensors_pos:
			if hit:
				draw_circle((hit - global_position).rotated(-rotation) * 2,5,Color(1,0,0))
				draw_line(Vector2.ZERO, (hit - global_position).rotated(-rotation) * 2,Color(1,0,0))

