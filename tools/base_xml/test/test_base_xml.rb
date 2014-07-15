require "../src/base_xml.rb"
require "test/unit"
module NPLAB
 
    class CTestBaseXML < Test::Unit::TestCase
      
      
        def test_xml_element_1()
          node = XML::CBaseElement.new
          node.name = "test_node"
          node.text = "&lt;&gt;&amp;&apos;&quot;"
          assert_equal(node.org_str, "<>&'\"")
          node.org_str= "<>&'\"<>&'\""
          assert_equal(node.text, "&lt;&gt;&amp;&apos;&quot;&lt;&gt;&amp;&apos;&quot;")
        end
        
        def test_xml_element_to_hash()
          test_file = "../cases/test_simple_xml_3.xml"
          doc = XML::CBaseXML.parse(test_file)
          
          h = doc.root.to_hash()
          
          expect_h = {"bookstore_text"=>"cooking\r\nchildren\r\n", 
            "book"=>[{"book_text"=>nil, "title"=>"Everyday Italian", "author"=>"Giada De Laurentiis", "year"=>2005, "price"=>30.0}, 
              {"book_text"=>nil, "title"=>"Harry Potter", "author"=>"J K. Rowling", "year"=>2005, "price"=>29.99}, 
              {"book_text"=>nil, "title"=>"Learning XML", "author"=>"Erik T. Ray", "year"=>2003, "price"=>39.95}]}
              
         assert_equal(h, expect_h)
        end
          
         
        def test_to_s()
            test_file = "../cases/test_simple_xml_4.xml"
            doc = XML::CBaseXML.parse(test_file)
      
            s = doc.root.to_s()
            assert_equal(s, "<contact-info>\r\n  <name>Jane Smith</name>\r\n  <company>AT&T</company>\r\n  <phone>(212) 555-4567</phone>\r\n</contact-info>\r\n")
    
            root = doc.root
            assert_equal(root.get_leafs().size, 3)
            assert_equal(root.get_elements("price").size, 0)
            assert_equal(root.get_elements("phone").size, 1)
            assert_equal(root.get_elements("name").size, 1)
            assert_equal(root.get_elements("company").size, 1)
            assert_equal(root.get_elements("company")[0].name, "company")
            assert_equal(root.get_elements("company")[0].text, "AT&amp;T")
            assert_equal(root.get_elements("company")[0].org_str, "AT&T")   
        end

        #test_prase("../cases/test_simple_xml_1.xml")
        #test_prase("../cases/test_simple_xml_2.xml")
        #test_prase("../cases/test_simple_xml_3.xml")
        
        
    end
    
     #CTestBaseXML.test_xml_node
end