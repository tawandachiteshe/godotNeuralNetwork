class activationFunction:
	static func sigmoid(x):
		return 1 / (1 + exp(-x))
	static func dsigmoid(y):
		return y * (1 - y)
	static func _tanh(x):
		return tanh(x)
	static func _dtanh(y):
		return 1 - (y * y)
class Matrix:
	var data : = []
	var _rows : int = 0
	var _cols : int = 0
	
	func _init(rows: int=2,cols : int=2):
		self._rows = rows
		self._cols = cols
		for i in range(rows):
			data.append([])
			for j in range(cols):
				data[i].append(0)
		
	func init_randomf():
		for i in range(_rows):
			for j in range(_cols):
				data[i][j] = randf() * 2 - 1
	func init_randomi():
		for i in range(_rows):
			for j in range(_cols):
				data[i][j] = randi() % 4
	
	func _add(matrix : Matrix):
		if _rows != matrix._rows || _cols != matrix._cols:
			printerr("rows must be equal to cols to perform matrix addition")
			return
		for i in range(_rows):
			for j in range(_cols):
				data[i][j] += matrix.data[i][j]	
		
	
	func _subtract(matrix : Matrix):
		if _rows != matrix._rows || _cols != matrix._cols:
			printerr("rows must be equal to cols to perform matrix subtration")
			return
		for i in range(_rows):
			for j in range(_cols):
				data[i][j] -= matrix.data[i][j]	
	
	func scalar(a):
		for i in range(_rows):
			for j in range(_cols):
				data[i][j] *= 2
	
	func copy():
		var a  = Matrix.new(self._rows, self._cols)
		for i in range(self._rows):
			for j in range(self.cols):
				a.data[i][j] = self.data[i][j]
		return a
	
	static func multiply(a: Matrix , b: Matrix):
		var c = Matrix.new(a._rows, b._cols)
		if a._cols != b._rows:
			printerr("rows must be equal to cols inoder for matrix multiplication to complete")
			return
		for i in range(c._rows):
			for j in range(c._cols):
				for k in range(a._cols):
					c.data[i][j] += a.data[i][k] * b.data[k][j]
				
		return c
	func _multiply(a):
		if _rows != a._rows || _cols != a._cols: 
			printerr("rows must be equal to cols inoder for matrix multiplication to complete")
			return
		for i in range(_rows):
			for j in range(_cols):
				data[i][j] = data[i][j] * a.data[i][j]
				
	static func subtract(a : Matrix , b : Matrix):
		if a._rows != b._rows || a._cols != b._cols:
			printerr("rows must be equal to cols to perform matrix subtration")
			return
		var c = Matrix.new(a._rows, a._cols)
		for i in range(c._rows):
			for j in range(c._cols):
				c.data[i][j] = a.data[i][j] - b.data[i][j]
		return c;
	
	static func dot(a : Matrix , b : Matrix):
		if a._rows != b._cols:
			printerr("rows must be equal to cols inoder for matrix multiplication to complete")
			return
		var c = 0
		for i in range(c._rows):
			for j in range(c._cols):
				for k in range(a._cols):
					c += a.data[i][k] * b.data[k][j]
		return c
	func to_array():
		var arr = []
		for i in range(_rows):
			for j in range(_cols):
				arr.append(data[i][j])
		return arr
	
	static func transpose(matrix: Matrix):
		var c = Matrix.new(matrix._cols,matrix._rows)
		for i in range(c._rows):
			for j in range(c._cols):
				c.data[i][j] = matrix.data[j][i]
		return c
	
	static func fromArray(arr: Array):
		var c = Matrix.new(arr.size(), 1)
		for i in range(arr.size()):
			c.data[i][0] = arr[i]
		return c
	
	static func add(a : Matrix , b : Matrix):
		if a._rows != b._rows || a._cols != b._cols:
			printerr("rows must be equal to cols to perform matrix addition")
			return
		var c = Matrix.new(a._rows,b._cols)
		c._rows = a._rows
		c._cols = a._cols
		for i in range(c._rows):
			for j in range(c._cols):
				c.data[i][j] = a.data[i][j] + b.data[i][j]
		return c;
	func _print():
		print(data)
	func map(actFunc : String = "sigmoid"):
		if actFunc == "sigmoid":
			for i in range(_rows):
				for j in range(_cols):
					data[i][j] = activationFunction.sigmoid(data[i][j])
		elif actFunc == "tanh":
			for i in range(_rows):
				for j in range(_cols):
					data[i][j] = activationFunction._tanh(data[i][j])
	
	static func _map(matrix: Matrix, actFunc : String = "sigmoid"):
		var c = Matrix.new(matrix._rows, matrix._cols)
		if actFunc == "sigmoid":
			for i in range(c._rows):
				for j in range(c._cols):
					c.data[i][j] = activationFunction.sigmoid(matrix.data[i][j])
			return c
		elif actFunc == "tanh":
			for i in range(c._rows):
				for j in range(c._cols):
					c.data[i][j] = activationFunction._tanh(matrix.data[i][j])
			return c
		else:
			return null
	
	static func dmap(matrix: Matrix , actFunc = "dsigmoid"):
		var c = Matrix.new(matrix._rows, matrix._cols)
		if actFunc == "dsigmoid":
			for i in range(c._rows):
				for j in range(c._cols):
					c.data[i][j] = activationFunction.dsigmoid(activationFunction.sigmoid(matrix.data[i][j]))
			
			return c
		elif actFunc == "dtanh":
			for i in range(c._rows):
				for j in range(c._cols):
					c.data[i][j] = activationFunction._dtanh(activationFunction._tanh(matrix.data[i][j]))
			return c
