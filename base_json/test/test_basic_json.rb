require "../src/basic_json.rb"
require "test/unit"

module NPLAB
  class CTestBaseJson < Test::Unit::TestCase
    def test_parse_array()
      expect_array=[ 
             {  "description"   => "maximum validation",
                "schema"        =>  {"maximum"=> 3.0},
                "tests"         =>  [ { "description" => "below the maximum is valid",
                                        "data"        =>  2.6,
                                        "valid"       =>  true },
                                      { "description" =>  "above the maximum is invalid",
                                        "data"        =>  3.5,
                                        "valid"       =>  false },
                                      { "description" =>  "ignores non-numbers",
                                        "data"        =>  "x",
                                        "valid"       =>  true}
                                    ] },
            { "description"     => "exclusiveMaximum validation",
              "schema"          =>  { "maximum"       =>  3.0, "exclusiveMaximum"=>  true},
              "tests"           => [ {  "description" =>  "below the maximum is still valid",
                                        "data"        =>  2.2,
                                        "valid"       =>  true},
                                     {  "description" =>  "boundary point is invalid",
                                        "data"        =>  3.0,
                                        "valid"       =>  false} ]}]
      input = "../cases/utest_json_array_1.json"
      content = File.exist?(input) ? IO.readlines(input).join() : input
   
      array, content = BasicJson.parse_array(content)
      assert_equal(array, expect_array)
      assert_equal(content.strip, "")
      
      # puts BasicJson.array_to_json(expect_array)
      input = "../cases/utest_json_2.json"
      content = File.exist?(input) ? IO.readlines(input).join() : input
   
      array, content = BasicJson.parse_array(content)
      assert_equal(array, expect_array)
      assert_equal(content.strip, "")
      
    end

    def test_parse_object_1()
      content = '{"attr1": 1, "attr2":true, "attr3": "string"}'
      expect_obj = {"attr1" => 1, "attr2"=>true, "attr3"=>"string"}
      obj, content = BasicJson.parse_object(content)
      assert_equal(obj, expect_obj)
      assert_equal(content.strip, "")
    end
    
    
    def test_parse_object_2()
      input = "../cases/utest_json_object_1.json"
      expect_obj = {  "description"   => "Example Address JSON Schema",
                      "type"          => "object",
                      "properties"    => {  "address"     => {  "title"   => "Street name and number",
                                                                "type"    => "string"},
                                            "city"        => {  "title"   => "City name",
                                                                "type"    => "string"},
                                            "postalCode"  => {  "title"   => "Zip Code: 2 letters dash five digits",
                                                                "type"    => "string",
                                                                "pattern" => "^[A-Z]{2}-[0-9]{5}$"},
                                            "region"      => {  "title"   => "Optional Region name",
                                                                "type"    => "string",
                                                                "optional"=> true},
                                            "country"     => {  "title"   => "Country name",  
                                                                "type"    => "string" }  },
                    "additionalProperties" => false}
      # content = File.exist?(input) ? IO.readlines(input).join() : input             
      obj = BasicJson.parse(input)
      assert_equal(obj, expect_obj)

      
      #puts BasicJson.hash_to_json(expect_obj)
      input = "../cases/utest_json_1.json"
      content = File.exist?(input) ? IO.readlines(input).join() : input
      obj, content = BasicJson.parse_object(content)
      assert_equal(obj, expect_obj)
      assert_equal(content.strip, "")
    end
    
  end
end
