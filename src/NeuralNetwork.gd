
class NeuralNetwork:
	var lr : float = 0.1
	var input_nodes : int = 0
	var hidden_nodes : int = 0
	var bias_hidden = null
	var bias_output = null
	var matrix_class
	var output_nodes : int = 0
	var weights_input_to_hidden = null
	var weights_hidden_to_output = null
	func _init(input : int, hidden: int , output: int, lr = 0.1):
		self.lr = lr
		self.matrix_class = preload("res://src/Matrix.gd")
		self.input_nodes = input
		self.hidden_nodes = hidden
		self.output_nodes = output
		self.weights_input_to_hidden = matrix_class.Matrix.new(self.hidden_nodes,self.input_nodes)
		self.weights_hidden_to_output = matrix_class.Matrix.new(self.output_nodes,self.hidden_nodes)
		self.weights_hidden_to_output.init_randomf()
		self.weights_input_to_hidden.init_randomf()
		
		self.bias_hidden = matrix_class.Matrix.new(self.hidden_nodes,1)
		self.bias_output = matrix_class.Matrix.new(self.output_nodes,1)
		self.bias_hidden.init_randomf()
		self.bias_output.init_randomf()
	
	func predict(input_array):
		var inputs = matrix_class.Matrix.fromArray(input_array)
		var hidden = matrix_class.Matrix.multiply(weights_input_to_hidden, inputs)
		hidden._add(self.bias_hidden)
		hidden.map()
		
		var output = matrix_class.Matrix.multiply(self.weights_hidden_to_output,hidden)
		output._add(self.bias_output)
		output.map()
		return output.to_array()
	
	func train(X , y):
		var inputs = matrix_class.Matrix.fromArray(X)
		var hidden = matrix_class.Matrix.multiply(weights_input_to_hidden, inputs)
		hidden._add(self.bias_hidden)
		hidden.map()
		
		var outputs = matrix_class.Matrix.multiply(self.weights_hidden_to_output,hidden)
		outputs._add(self.bias_output)
		outputs.map()
		
		var ys = matrix_class.Matrix.fromArray(y)
		
		var output_errors = matrix_class.Matrix.subtract(ys, outputs)
		
		var gradients = matrix_class.Matrix.dmap(outputs)
		gradients._multiply(output_errors)
		gradients.scalar(self.lr)
		
		var hidden_transpose = matrix_class.Matrix.transpose(hidden)
		var weight_ho_deltas = matrix_class.Matrix.multiply(gradients,hidden_transpose)
		
		self.weights_hidden_to_output._add(weight_ho_deltas)
		self.bias_output._add(gradients)
		
		
		var weights_ho_transpose = matrix_class.Matrix.transpose(self.weights_hidden_to_output)
		var hidden_errors = matrix_class.Matrix.multiply(weights_ho_transpose,output_errors)
		
		var hidden_gradient = matrix_class.Matrix.dmap(hidden)
		hidden_gradient._multiply(hidden_errors)
		hidden_gradient.scalar(self.lr)
		
		var inputs_transpose = matrix_class.Matrix.transpose(inputs)
		var weights_ih_deltas = matrix_class.Matrix.multiply(hidden_gradient,inputs_transpose)
		self.weights_input_to_hidden._add(weights_ih_deltas)
		self.bias_hidden._add(hidden_gradient)
	func mutate(name):
		weights_input_to_hidden.map(name)
		weights_hidden_to_output.map(name)
		bias_hidden.map(name)
		bias_output.map(name)
