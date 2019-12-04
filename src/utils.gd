extends Node
class_name Utils
export var nn: Script = preload("res://src/NeuralNetwork.gd")
func _ready():
	pass
static func map(value: float , start1: float , stop1: float , start2: float , stop2: float):
	return start2 + (stop2 - start2) * ((value - start1) / (stop1  - start1))
