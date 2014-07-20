require "#{File.dirname(File.dirname(__FILE__))}/movement/movement.rb"

module NPLAB
  module Movement
    
    
    # ---------------------------------------------------
    # Test "GET" methods of CLinearMovement
    # ---------------------------------------------------
    def self.test_linear_movement_1()
      test_name = "test_linear_movement_1"
     
      mv = CLinearMovement.new([0, 0, 0], [0, 0, 2])
      
      gt_d0 = Geom::Vector3d.new([0, 0, 1]) # gt=ground_true
      gt_p0 = Geom::Transformation.new.to_a
      gt_l0 = Geom::Point3d.new([0, 0, 0]).to_a
      gt_v0 = Geom::Vector3d.new([0, 0, 2])
      gt_p2 = Geom::Transformation.new([0, 0, 4]).to_a
      gt_l2 = Geom::Point3d.new([0, 0, 4]).to_a
      gt_xa = Geom::Vector3d.new([1, 0, 0])
      gt_ya = Geom::Vector3d.new([0, 1, 0])
      gt_za = Geom::Vector3d.new([0, 0, 1])
      
      s0    = mv.init_speed
      a     = mv.acceleration
      d0    = mv.init_direction
      p0    = mv.init_position.to_a
      l0    = mv.init_location.to_a
      v0    = mv.init_velocity
      p2    = mv.position(2).to_a
      l2    = mv.location(2).to_a
      xa    = mv.xaxis(2)
      ya    = mv.yaxis(2)
      za    = mv.zaxis(2)
      
      assert(s0 , 2      , "#{test_name}/init_speed") 
      assert(a  , 0      , "#{test_name}/acceleration") 
      assert(d0 , gt_d0  , "#{test_name}/init_direction") 
      assert(p0 , gt_p0  , "#{test_name}/init_position")
      assert(l0 , gt_l0  , "#{test_name}/init_location")
      assert(v0 , gt_v0  , "#{test_name}/init_velocity")
      assert(p2 , gt_p2  , "#{test_name}/position")
      assert(l2 , gt_l2  , "#{test_name}/location")
      assert(xa , gt_xa  , "#{test_name}/xaxis")
      assert(ya , gt_ya  , "#{test_name}/yaxis")
      assert(za , gt_za  , "#{test_name}/zaxis")
      
      
      # test init_speed = 
      mv.init_speed= 4
      s0      = mv.init_speed
      v0      = mv.init_velocity
      gt_v0   = Geom::Vector3d.new([0, 0, 4])
      assert(s0 , 4      , "#{test_name}/init_speed=") 
      assert(v0 , gt_v0  , "#{test_name}/init_speed=")

    end
    
    
    
    # ---------------------------------------------------
    # Test "SET" method of CLinearMovement
    # ---------------------------------------------------
    def self.test_linear_movement_2()
      # test init_velocity= & init_position= & acceleration & acceleration=
      test_name = "test_linear_movement_2"
     
      mv = CLinearMovement.new()
      
      mv.acceleration= 2
      mv.init_velocity= [0, 0, 2]
      mv.init_position= [0, 0, 1]
      
      gt_d0 = Geom::Vector3d.new([0, 0, 1]).to_a               # gt=ground_true
      gt_p0 = Geom::Transformation.new([0, 0, 1]).to_a
      gt_l0 = Geom::Point3d.new([0, 0, 1]).to_a
      gt_v0 = Geom::Vector3d.new([0, 0, 2])
      gt_p2 = Geom::Transformation.new([0, 0, 9]).to_a
      gt_xa = Geom::Vector3d.new([1, 0, 0])
      gt_ya = Geom::Vector3d.new([0, 1, 0])
      gt_za = Geom::Vector3d.new([0, 0, 1])
      
      s0    = mv.init_speed
      a     = mv.acceleration
      d0    = mv.init_direction
      p0    = mv.init_position.to_a
      l0    = mv.init_location
      v0    = mv.init_velocity
      p2    = mv.position(2).to_a
      xa    = mv.xaxis(2)
      ya    = mv.yaxis(2)
      za    = mv.zaxis(2)
      
      assert(s0 , 2      , "#{test_name}/init_speed") 
      assert(a  , 2      , "#{test_name}/acceleration") 
      assert(d0 , gt_d0  , "#{test_name}/init_direction") 
      assert(p0 , gt_p0  , "#{test_name}/init_position")
      assert(l0 , gt_l0  , "#{test_name}/init_location")
      assert(v0 , gt_v0  , "#{test_name}/init_velocity")
      assert(p2 , gt_p2  , "#{test_name}/position")
      assert(xa , gt_xa  , "#{test_name}/xaxis")
      assert(ya , gt_ya  , "#{test_name}/yaxis")
      assert(za , gt_za  , "#{test_name}/zaxis")

    end
    

    
    
    # ---------------------------------------------------
    # Test CCircularMovement
    #
    # This test focus on the behavior of rotation around a point
    # 
    # ---------------------------------------------------
    def self.test_circular_movement_1()
      test_name = "test_circular_movement_1"
     
      mv = CCircularMovement.new([5, 0, 1], [3, 4, 0], [0, 0, 1])
      
      
           
      gt_origin = Geom::Point3d.new([0, 0, 1])
      gt_center = Geom::Point3d.new([0, 0, 1])
      gt_p0     = Geom::Transformation.new([5, 0, 1]).to_a
      gt_l0     = Geom::Point3d.new([5, 0, 1]).to_a
      gt_v0     = Geom::Vector3d.new([0, 4, 0])
      gt_w0     = 20                              #init angular speed(rad/s)
      gt_s0     = 4
      gt_d0     = Geom::Vector3d.new([0, 1, 0])
      
      gt_rr     = 5                               #rotation radius,i.e., the distance to the center 
      gt_r      = 5                               #the distance to the origin
      gt_ra     = Geom::Vector3d.new([ 0, 0, 1])
      
      
      gt_xa     = Geom::Vector3d.new([ 0, 1, 0])
      gt_ya     = Geom::Vector3d.new([-1, 0, 0])
      gt_za     = Geom::Vector3d.new([ 0, 0, 1]) 
      gt_lt     = Geom::Point3d.new([ 0, 5, 1]).to_a
      gt_pt     = Geom::Transformation.new(gt_xa, gt_ya, gt_za, gt_lt).to_a
      
      t       = Math::PI / 40
      origin  = mv.origin
      center  = mv.center
      
      p0      = mv.init_position.to_a
      l0      = mv.init_location.to_a
      v0      = mv.init_velocity
      
      w0      = mv.init_angular_speed
      s0      = mv.init_speed
      d0      = mv.init_direction
      
      rr      = mv.rotation_radius
      r       = mv.radius
      ra      = mv.rotation_axis
      
      pt      = mv.position(t).to_a
      lt      = mv.location(t).to_a
      xa      = mv.xaxis(t)
      ya      = mv.yaxis(t)
      za      = mv.zaxis(t)
      
     
      assert(origin , gt_origin, "#{test_name}/origin", origin.to_a.to_s, gt_origin.to_a.to_s) 
      assert(center , gt_center, "#{test_name}/center")

      assert(p0     , gt_p0  , "#{test_name}/init_position")
      assert(l0     , gt_l0  , "#{test_name}/init_location")
      assert(v0     , gt_v0  , "#{test_name}/init_velocity")
      
      assert(w0     , gt_w0  , "#{test_name}/init_angular_speed") 
      assert(s0     , gt_s0  , "#{test_name}/init_speed") 
      assert(d0     , gt_d0  , "#{test_name}/init_direction") 
      
      assert(rr     , gt_rr  , "#{test_name}/rotation_radius")
      assert(r      , gt_r   , "#{test_name}/radius")
      assert(ra     , gt_ra  , "#{test_name}/rotation_axis")
      
      assert(is_close(lt, gt_lt),  true, "#{test_name}/location(t)")
      assert(is_equal(xa, gt_xa),  true, "#{test_name}/xaxis")
      assert(is_equal(ya, gt_ya),  true, "#{test_name}/yaxis")
      assert(is_equal(za, gt_za),  true, "#{test_name}/zaxis")
      #assert(is_equal(xa, gt_xa),   pt     , gt_pt  , "#{test_name}/position(t)")

    end
    
    
        
    
       
    def self.test_circular_movement_2()
      
      test_name = "test_circular_movement_2"
      
     
     
      mv = CCircularMovement.new([5, 0, 1], [3, 4, 0], [0, 0, 2], [0, 0, 1])
      
      
           
      gt_origin = Geom::Point3d.new([0, 0, 2])
      gt_center = Geom::Point3d.new([0, 0, 1])
      gt_p0     = Geom::Transformation.new([5, 0, 1]).to_a
      gt_l0     = Geom::Point3d.new([5, 0, 1]).to_a
      gt_v0     = Geom::Vector3d.new([0, 4, 0])
      gt_w0     = 20                              #init angular speed(rad/s)
      gt_s0     = 4
      gt_d0     = Geom::Vector3d.new([0, 1, 0])
      
      gt_rr     = 5                               #rotation radius,i.e., the distance to the center 
      gt_r      = Math.sqrt(26)                   #the distance to the origin
      gt_ra     = Geom::Vector3d.new([ 0, 0, 1])
      
      
      gt_xa     = Geom::Vector3d.new([ 0, 1, 0])
      gt_ya     = Geom::Vector3d.new([-1, 0, 0])
      gt_za     = Geom::Vector3d.new([ 0, 0, 1]) 
      gt_lt     = Geom::Point3d.new([ 0, 5, 1]).to_a
      gt_pt     = Geom::Transformation.new(gt_xa, gt_ya, gt_za, gt_lt).to_a
      
      t       = Math::PI / 40
      origin  = mv.origin
      center  = mv.center
      
      p0      = mv.init_position.to_a
      l0      = mv.init_location.to_a
      v0      = mv.init_velocity
      
      w0      = mv.init_angular_speed
      s0      = mv.init_speed
      d0      = mv.init_direction
      
      rr      = mv.rotation_radius
      r       = mv.radius
      ra      = mv.rotation_axis
      
      pt      = mv.position(t).to_a
      lt      = mv.location(t).to_a
      xa      = mv.xaxis(t)
      ya      = mv.yaxis(t)
      za      = mv.zaxis(t)
      
     
      assert(origin , gt_origin, "#{test_name}/origin", origin.to_a.to_s, gt_origin.to_a.to_s) 
      assert(center , gt_center, "#{test_name}/center")

      assert(p0     , gt_p0  , "#{test_name}/init_position")
      assert(l0     , gt_l0  , "#{test_name}/init_location")
      assert(v0     , gt_v0  , "#{test_name}/init_velocity")
      
      assert(w0     , gt_w0  , "#{test_name}/init_angular_speed") 
      assert(s0     , gt_s0  , "#{test_name}/init_speed") 
      assert(d0     , gt_d0  , "#{test_name}/init_direction") 
      
      assert(rr     , gt_rr  , "#{test_name}/rotation_radius")
      assert(r      , gt_r   , "#{test_name}/radius")
      assert(ra     , gt_ra  , "#{test_name}/rotation_axis")
      
      assert(is_close(lt, gt_lt),  true, "#{test_name}/location(t)")
      assert(is_equal(xa, gt_xa),  true, "#{test_name}/xaxis")
      assert(is_equal(ya, gt_ya),  true, "#{test_name}/yaxis")
      assert(is_equal(za, gt_za),  true, "#{test_name}/zaxis")
      #assert(is_equal(xa, gt_xa),   pt     , gt_pt  , "#{test_name}/position(t)")

      
    end
    
    
    
    
    private
    
   
    def self.assert(value, expect_value, test_name, str_value=nil, str_expect_value=nil)
      if value==expect_value
        puts test_name + ": pass"
      else
        if str_value == nil
          str_value = value.to_s
        end
        if str_expect_value == nil
          str_expect_value = expect_value.to_s
        end
        raise test_name + ": fail\r\n value: #{str_value} but expect #{str_expect_value}"
      end 
    end
    
    
    # ---------------------------------------------------
    # Assistance methods for test CCircularMovement
    # ---------------------------------------------------
    def self.is_close(d1, d2)
      return d1.distance(d2) < 1e-3
    end
    
    def self.is_equal(v0, v1)
      bdd = (v0.angle_between(v1) < 1.degrees)
      bdl = (v0-v1).length < 1e-3  
      return bdd && bdl
    end

    
    # NPLAB::Movement.test_linear_movement_1()
    # NPLAB::Movement.test_linear_movement_2()
    # NPLAB::Movement.test_circular_movement_1()
    # NPLAB::Movement.test_circular_movement_2()
  end
end

