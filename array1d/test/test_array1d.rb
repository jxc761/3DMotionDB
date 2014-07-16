require "../src/array1d.rb"
require "test/unit"

module NPLAB
  
  class CTestArray1d < Test::Unit::TestCase
    
    def test_length_1
      v = [3, 4, 0]
      assert_equal(Array1D.length(v), 5.0)
    end
    
    def test_normalize
      v = [2.0, 0.0, 0.0]
      assert_equal(Array1D.normalize(v), [1.0, 0.0, 0.0])
      assert(v==Array1D.normalize!(v))
      assert_equal(v, [1.0, 0.0, 0.0])
      
      v=[3, 4, 0]
      assert_equal(Array1D.normalize(v), [0.6, 0.8, 0.0])
      assert(v==Array1D.normalize!(v))
      assert_equal(v, [0.6, 0.8, 0.0])
    end
    
    def test_norm2
      v = [1, 2, 3]
      assert_equal(Array1D.norm2(v), 14.0)
    end
    
    def test_linear_combination
      result =  [215, 104, 224]
      ws  = [ 2, 5, 10, 8]
      pts = [[10, 7, 1], [3, 6, 10], [10, 2, 10], [10, 5, 9]]
      r   = Array1D.linear_combination(ws, pts)
      assert_equal(r, result)
    end
    
    
    def test_add
      v1 =[-3, 2, 1]
      v2 =[3, -2, -1]
      assert_equal(Array1D.add(v1, v2), [0.0, 0.0, 0.0])
    end
    
    def test_scale
      v1 = [9, 10, 2]
      v2 = Array1D.scale(0.1, v1)
      assert_equal(v2, [0.9, 1.0, 0.2])
      
      assert(v1==Array1D.scale!(0.1, v1))
      assert_equal(v1, [0.9, 1.0, 0.2])
    end
    
    def test_dot
      v1 = [1, 2, 3]
      v2 = [3, 2, 1]
      assert_equal(Array1D.dot(v1, v2), 10.0)
    end
    
  end
 
end


