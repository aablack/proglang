# University of Washington, Programming Languages, Homework 7, 
# hw7testsprovided.rb

require "./hw7.rb"

#  Will not work completely until you implement all the classes and their methods

# Will print only if code has errors; prints nothing if all tests pass

# These tests do NOT cover all the various cases, especially for intersection

#Constants for testing
ZERO = 0.0
ONE = 1.0
TWO = 2.0
THREE = 3.0
FOUR = 4.0
FIVE = 5.0
SIX = 6.0
SEVEN = 7.0
TEN = 10.0

#Point Tests
a = Point.new(THREE,FIVE)
if not (a.x == THREE and a.y == FIVE)
	raise "Point is not initialized properly"
end
if not (a.eval_prog([]) == a)
	raise "Point eval_prog should return self"
end
if not (a.preprocess_prog == a)
	raise "Point preprocess_prog should return self"
end
a1 = a.shift(THREE,FIVE)
if not (a1.x == SIX and a1.y == TEN)
	raise "Point shift not working properly"
end
a2 = a.intersect(Point.new(THREE,FIVE))
if not (a2.x == THREE and a2.y == FIVE)
	raise "Point intersect not working properly"
end 
a3 = a.intersect(Point.new(FOUR,FIVE))
if not (a3.is_a? NoPoints)
	raise "Point intersect not working properly"
end

#Line Tests
b = Line.new(THREE,FIVE)
if not (b.m == THREE and b.b == FIVE)
	raise "Line not initialized properly"
end
if not (b.eval_prog([]) == b)
	raise "Line eval_prog should return self"
end
if not (b.preprocess_prog == b)
	raise "Line preprocess_prog should return self"
end

b1 = b.shift(THREE,FIVE) 
if not (b1.m == THREE and b1.b == ONE)
	raise "Line shift not working properly"
end

b2 = b.intersect(Line.new(THREE,FIVE))
if not (((b2.is_a? Line)) and b2.m == THREE and b2.b == FIVE)
	raise "Line intersect not working properly"
end
b3 = b.intersect(Line.new(THREE,FOUR))
if not ((b3.is_a? NoPoints))
	raise "Line intersect not working properly"
end

#VerticalLine Tests
c = VerticalLine.new(THREE)
if not (c.x == THREE)
	raise "VerticalLine not initialized properly"
end

if not (c.eval_prog([]) == c)
	raise "VerticalLine eval_prog should return self"
end
if not (c.preprocess_prog == c)
	raise "VerticalLine preprocess_prog should return self"
end
c1 = c.shift(THREE,FIVE)
if not (c1.x == SIX)
	raise "VerticalLine shift not working properly"
end
c2 = c.intersect(VerticalLine.new(THREE))
if not ((c2.is_a? VerticalLine) and c2.x == THREE )
	raise "VerticalLine intersect not working properly"
end
c3 = c.intersect(VerticalLine.new(FOUR))
if not ((c3.is_a? NoPoints))
	raise "VerticalLine intersect not working properly"
end

#LineSegment Tests
d = LineSegment.new(ONE,TWO,-THREE,-FOUR)
if not (d.eval_prog([]) == d)
	raise "LineSegement eval_prog should return self"
end
d1 = LineSegment.new(ONE,TWO,ONE,TWO)
d2 = d1.preprocess_prog
if not ((d2.is_a? Point)and d2.x == ONE and d2.y == TWO) 
	raise "LineSegment preprocess_prog should convert to a Point if ends of segment are real_close"
end

d = d.preprocess_prog
if not (d.x1 == -THREE and d.y1 == -FOUR and d.x2 == ONE and d.y2 == TWO)
	raise "LineSegment preprocess_prog should make x1 and y1 on the left of x2 and y2"
end

d3 = d.shift(THREE,FIVE)
if not (d3.x1 == ZERO and d3.y1 == ONE and d3.x2 == FOUR and d3.y2 == SEVEN)
	raise "LineSegment shift not working properly"
end

d4 = d.intersect(LineSegment.new(-THREE,-FOUR,ONE,TWO))
if not (((d4.is_a? LineSegment)) and d4.x1 == -THREE and d4.y1 == -FOUR and d4.x2 == ONE and d4.y2 == TWO)	
	raise "LineSegment intersect not working properly"
end
d5 = d.intersect(LineSegment.new(TWO,THREE,FOUR,FIVE))
if not ((d5.is_a? NoPoints))
	raise "LineSegment intersect not working properly"
end

#Intersect Tests
i = Intersect.new(LineSegment.new(-ONE,-TWO,THREE,FOUR), LineSegment.new(THREE,FOUR,-ONE,-TWO))
i1 = i.preprocess_prog.eval_prog([])
if not (i1.x1 == -ONE and i1.y1 == -TWO and i1.x2 == THREE and i1.y2 == FOUR)
	raise "Intersect eval_prog should return the intersect between e1 and e2"
end

#Var Tests
v = Var.new("a")
v1 = v.eval_prog([["a", Point.new(THREE,FIVE)]])
if not ((v1.is_a? Point) and v1.x == THREE and v1.y == FIVE)
	raise "Var eval_prog is not working properly"
end 
if not (v1.preprocess_prog == v1)
	raise "Var preprocess_prog should return self"
end

#Let Tests
l = Let.new("a", LineSegment.new(-ONE,-TWO,THREE,FOUR),
             Intersect.new(Var.new("a"),LineSegment.new(THREE,FOUR,-ONE,-TWO)))
l1 = l.preprocess_prog.eval_prog([])
if not (l1.x1 == -ONE and l1.y1 == -TWO and l1.x2 == THREE and l1.y2 == FOUR)
	raise "Let eval_prog should evaluate e2 after adding [s, e1] to the environment"
end

#Let Variable Shadowing Test
l2 = Let.new("a", LineSegment.new(-ONE, -TWO, THREE, FOUR),
              Let.new("b", LineSegment.new(THREE,FOUR,-ONE,-TWO), Intersect.new(Var.new("a"),Var.new("b"))))
l2 = l2.preprocess_prog.eval_prog([["a",Point.new(0,0)]])
if not (l2.x1 == -ONE and l2.y1 == -TWO and l2.x2 == THREE and l2.y2 == FOUR)
	raise "Let eval_prog should evaluate e2 after adding [s, e1] to the environment"
end

l3 = Let.new("a", Line.new(1,2), Let.new("a", Line.new(3,4), Var.new("a"))).eval_prog([])
if not (l3.m == 3 and l3.b == 4)
    raise "environment variable was not overwritten"
end

#Shift Tests
s = Shift.new(THREE,FIVE,LineSegment.new(-ONE,-TWO,THREE,FOUR))
s1 = s.preprocess_prog.eval_prog([])
if not (s1.x1 == TWO and s1.y1 == THREE and s1.x2 == SIX and s1.y2 == 9)
	raise "Shift should shift e by dx and dy"
end

s = VerticalLine.new(1).shift(1,0).eval_prog([])
if s.x != 2
    raise "Shift answer is incorrect"
end

s = Line.new(1,1).shift(0,1).eval_prog([])
if not (s.m == 1 and s.b == 2)
    raise "Shift answer is incorrect"
end

s = Line.new(1,1).shift(1,0).eval_prog([])
if not (s.m == 1 and s.b == 0)
    raise "Shift answer is incorrect"
end

s = Line.new(1,0).shift(1,1).eval_prog([])
if not (s.m == 1 and s.b == 0)
    raise "Shift answer is incorrect, m: #{s.m}, b: #{s.b}"
end

s = Point.new(0,0).shift(-1,-1).eval_prog([])
if not (s.x == -1 and s.y == -1)
    raise "Shift answer is incorrect, x: #{s.x}, y: #{s.y}"
end

s = LineSegment.new(0,0,1,1).shift(1,1).eval_prog([])
if not (s.x1 == 1 and s.y1 == 1 and s.x2 == 2 and s.y2 == 2)
    raise "Shift answer is incorrect for line segment"
end

s = NoPoints.new.shift(1,1).eval_prog([])
if not s.is_a?(NoPoints)
    raise "Shift answer is incorrect or NoPoints"
end

i = NoPoints.new.intersect(NoPoints.new).eval_prog([])
if not i.is_a?(NoPoints)
    raise "Intersection is incorrect"
end

i = Line.new(1,1).intersect(NoPoints.new).eval_prog([])
if not i.is_a?(NoPoints)
    raise "Intersection is incorrect"
end

i = NoPoints.new.intersect(Line.new(1,1)).eval_prog([])
if not i.is_a?(NoPoints)
    raise "Intersection is incorrect"
end

i = Line.new(2,1).intersect(Line.new(1,0)).eval_prog([])
if not (i.x == -1 and i.y == -1)
    raise "Intersection is not correct"
end

i = Line.new(1,0).intersect(Line.new(2,1)).eval_prog([])
if not (i.x == -1 and i.y == -1)
    raise "Intersection is not correct"
end

i = Line.new(10,10).intersect(Line.new(10,10)).eval_prog([])
if not (i.m == 10 and i.b == 10)
    raise "intersection is not correct"
end

i = Line.new(1,-10).intersect(VerticalLine.new(10)).eval_prog([])
if not (i.x == 10 and i.y == 0)
    raise "intersection is incorrect"
end

i = VerticalLine.new(10).intersect(Line.new(1,-10)).eval_prog([])
if not (i.x == 10 and i.y == 0)
    raise "intersection is incorrect"
end

i = VerticalLine.new(1).intersect(VerticalLine.new(1)).eval_prog([])
if not i.x == 1
    raise "Intersection is incorrect"
end

i = Line.new(2,10).intersect(Point.new(10,30)).eval_prog([])
if not (i.x == 10 and i.y == 30)
    raise "Intersection is incorrect"
end

i = Point.new(10,30).intersect(Line.new(2,10)).eval_prog([])
if not (i.x == 10 and i.y == 30)
    raise "Intersection is incorrect"
end

i = Line.new(2,10).intersect(Point.new(11,30)).eval_prog([])
if not (i.is_a?(NoPoints))
    raise "Intersection is incorrect"
end

i = Point.new(11,30).intersect(Line.new(2,10)).eval_prog([])
if not (i.is_a?(NoPoints))
    raise "Intersection is incorrect"
end

i = Intersect.new(VerticalLine.new(5), Point.new(5,10)).eval_prog([])
if not (i.x == 5 and i.y == 10)
    raise "Intersection is incorrect"
end
 
i = Intersect.new(Point.new(5,10), VerticalLine.new(5)).eval_prog([])
if not (i.x == 5 and i.y == 10)
    raise "Intersection is incorrect"
end
 
i = Intersect.new(Point.new(5,5), Point.new(5,5)).eval_prog([])
if not (i.x == 5 and i.y == 5)
    raise "Intersection is incorrect"
end

i = Intersect.new(NoPoints.new, LineSegment.new(1,1,2,2)).eval_prog([])
if not i.is_a?(NoPoints)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(1,1,2,2), NoPoints.new).eval_prog([])
if not i.is_a?(NoPoints)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(1,1,1,1), Point.new(1,1)).eval_prog([])
if not (i.x == 1 and i.y == 1)
    raise "Intersection is not correct"
end

i = Intersect.new(Point.new(1,1), LineSegment.new(1,1,1,1)).eval_prog([])
if not (i.x == 1 and i.y == 1)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(0,0,10,10), Point.new(0,0)).eval_prog([])
if not (i.x == 0 and i.y == 0)
    raise "Intersection is not correct"
end

i = Intersect.new(Point.new(0,0), LineSegment.new(0,0,10,10)).eval_prog([])
if not (i.x == 0 and i.y == 0)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(0,0,10,10), Point.new(10.5,10.5)).eval_prog([])
if not i.is_a?(NoPoints)
    raise "Intersection is not correct"
end

i = Intersect.new(Point.new(10.5,10.5), LineSegment.new(0,0,10,10)).eval_prog([])
if not i.is_a?(NoPoints)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(0,0,10,10), Line.new(-1,-1)).eval_prog([])
if not i.is_a?(NoPoints)
    raise "Intersection is not correct"
end

i = Intersect.new(Line.new(-1,-1),LineSegment.new(0,0,10,10)).eval_prog([])
if not i.is_a?(NoPoints)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(0,0,10,10), VerticalLine.new(-1)).eval_prog([])
if not i.is_a?(NoPoints)
    raise "Intersection is not correct"
end

i = Intersect.new(VerticalLine.new(-1), LineSegment.new(0,0,10,10)).eval_prog([])
if not i.is_a?(NoPoints)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(0,0,10,10), VerticalLine.new(5)).eval_prog([])
if not (i.x == 5 and i.y == 5)
    raise "Intersection is not correct"
end

i = Intersect.new(VerticalLine.new(5), LineSegment.new(0,0,10,10)).eval_prog([])
if not (i.x == 5 and i.y == 5)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(0,0,10,10), Line.new(1,1)).eval_prog([])
if not i.is_a?(NoPoints)
    raise "Intersection is not correct"
end

i = Intersect.new(Line.new(1,1), LineSegment.new(0,0,10,10)).eval_prog([])
if not i.is_a?(NoPoints)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(0,0,10,10), Line.new(1,0)).eval_prog([])
if not (i.x1 == 0 and i.y1 == 0 and i.x2 == 10 and i.y2 == 10)
    raise "Intersection is not correct"
end

i = Intersect.new(Line.new(1,0), LineSegment.new(0,0,10,10)).eval_prog([])
if not (i.x1 == 0 and i.y1 == 0 and i.x2 == 10 and i.y2 == 10)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(0,0,10,10), Line.new(2,-1)).eval_prog([])
if not (i.x == 1 and i.y == 1)
    raise "Intersection is not correct"
end

i = Intersect.new(Line.new(2,-1), LineSegment.new(0,0,10,10)).eval_prog([])
if not (i.x == 1 and i.y == 1)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(0,0,10,10), LineSegment.new(-5,-5,-1,-1)).eval_prog([])
if not i.is_a?(NoPoints)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(-5,-5,-1,-1), LineSegment.new(0,0,10,10)).eval_prog([])
if not i.is_a?(NoPoints)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(0,0,10,10), LineSegment.new(-5,-5,0,0)).eval_prog([])
if not (i.x == 0 and i.y == 0)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(-5,-5,0,0), LineSegment.new(0,0,10,10)).eval_prog([])
if not (i.x == 0 and i.y == 0)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(0,0,10,10), LineSegment.new(-5,-5,1,1)).eval_prog([])
if not (i.x1 == 0 and i.y1 == 0 and i.x2 == 1 and i.y2 == 1)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(-5,-5,1,1), LineSegment.new(0,0,10,10)).eval_prog([])
if not (i.x1 == 0 and i.y1 == 0 and i.x2 == 1 and i.y2 == 1)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(0,0,10,10), LineSegment.new(1,1,5,5)).eval_prog([])
if not (i.x1 == 1 and i.y1 == 1 and i.x2 == 5 and i.y2 == 5)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(0,0,10,10), LineSegment.new(-1,-1,11,11)).eval_prog([])
if not (i.x1 == 0 and i.y1 == 0 and i.x2 == 10 and i.y2 == 10)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(0,0,10,10), LineSegment.new(10,10,20,20)).eval_prog([])
if not (i.x == 10 and i.y == 10)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(0,0,10,10), LineSegment.new(11,11,20,20)).eval_prog([])
if not i.is_a?(NoPoints)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(0,0,0,2), LineSegment.new(0,0,0,-1)).eval_prog([])
if not i.is_a?(NoPoints)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(0,0,0,2), LineSegment.new(0,-2,0,0)).eval_prog([])
if not (i.x == 0 and i.y == 0)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(0,0,0,2), LineSegment.new(0,0,0,1)).eval_prog([])
if not (i.x1 == 0 and i.y1 == 0 and i.x2 == 0 and i.y2 == 1)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(0,0,0,2), LineSegment.new(0,-1,0,5)).eval_prog([])
if not (i.x1 == 0 and i.y1 == 0 and i.x2 == 0 and i.y2 == 2)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(0,0,0,2), LineSegment.new(0,2,0,10)).eval_prog([])
if not (i.x == 0 and i.y == 2)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(0,0,0,2), LineSegment.new(0,1,0,10)).eval_prog([])
if not (i.x1 == 0 and i.y1 == 1 and i.x2 == 0 and i.y2 == 2)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(0,1,0,10), LineSegment.new(0,0,0,2)).eval_prog([])
if not (i.x1 == 0 and i.y1 == 1 and i.x2 == 0 and i.y2 == 2)
    raise "Intersection is not correct"
end

i = Intersect.new(LineSegment.new(0,0,0,2), LineSegment.new(0,3,0,10)).eval_prog([])
if not i.is_a?(NoPoints)
    raise "Intersection is not correct"
end

