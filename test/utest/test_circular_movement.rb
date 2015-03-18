
#CRotateAroudPoint  
mv = NPLAB::Motion::CRotateAroudPoint.new


mv.set([0, 1, 0], [0, 0, 1], [0, 0, 0])
puts mv.position(0).origin
puts mv.position(1).origin

mv.set([0, 1, 0], [0, 0, -1], [0, 0, 0])
puts mv.position(0).origin
puts mv.position(1).origin

#CRotateAroundAxis
mv = NPLAB::Motion::CRotateAroundAxis.new
mv.set([0, 1, 0], [0, 0, 1], [0, 0, 0], [1, 0, 0])
puts mv.position(0).origin
puts mv.position(1).origin

mv.set([0, 1, 0], [0, 0, -1], [0, 0, 0], [1, 0, 0])
puts mv.position(0).origin
puts mv.position(1).origin

mv.set([0, 1, 0], [1, 0, 0], [0, 0, 0], [0, 0, 1])
puts mv.position(0).origin
puts mv.position(1).origin
