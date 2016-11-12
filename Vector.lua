Vector = {}
Vector.__index = Vector

function Vector.new(x, y, x2, y2)
	if x2 then
		vector = {x = x2 - x, y = y2 - y}
	else
		vector = {x = x, y = y}
	end	
	setmetatable(vector, Vector)
	return vector
end

function Vector.add(vector1, vector2)
  return Vector.new(vector1.x + vector2.x, vector1.y + vector2.y)
end

function Vector:scalar(vector)
	return self.x * vector.x + self.y * vector.y
end

function Vector:length()
	return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector:multiply(s)
	self.x = self.x * s
	self.y = self.y * s
	return self
end

function Vector:projectOn(vector)
	-- projects self on vector (destructive)
	mult = vector:scalar(self) / vector:scalar(vector)
	self.x = vector.x * mult
	self.y = vector.y * mult
	return self
end

function Vector:cropProjectOn(vector, min, max)
	-- projects self on vector but limits multiplier to min/max (destructive)
	mult = math.max(min, math.min(vector:scalar(self) / vector:scalar(vector), max))
	self.x = vector.x * mult
	self.y = vector.y * mult
	return self
end

function Vector:crop(min, max)
	-- crops x and y coordinate seperately
	self.x = math.min(max, math.max(self.x, min))
	self.y = math.min(max, math.max(self.y, min))
end

function Vector:normalize()
	return self:multiply(1/self:length())
end
