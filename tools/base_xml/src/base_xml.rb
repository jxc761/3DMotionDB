
require "#{File.dirname(__FILE__)}/base_xml_element.rb"
require "#{File.dirname(__FILE__)}/base_xml_doc.rb"
module NPLAB
	module XML
	  	
		#################################################
		class CBaseXML
		  
			# input: path or content
			def self.parse(input)
				content = File.exist?(input) ? IO.readlines(input).join() : input
	
				# <	- match the '<'
				# \s*?	- match the blank charactors
				# (\w+?)- match the tag name
				# ((\s*?)|(\s[^>]*?))- match the blank charactors and left attributes
				#	* (\s*?) - no attributes just blank charactors 
				#	* (\s[^>]*?) - match the attributes part
				# >	- match the '>'

				re_open_tag= '<\s*?([\w-]+?)((\s*?)|(\s[^>]*?))>'# opening tags 
				re_close_tag = '<\s*?/([\w-]+?)\s*?>'		# closing tags
				tag_index = 1


				stack = [] 
				cur_content= clean(content)
				cur_root_node = nil
				doc	= CBaseDocument.new()
 
				while !cur_content.empty?
		
					open_tag= cur_content.match(/#{re_open_tag}/m)
					close_tag = cur_content.match(/#{re_close_tag}/m)
	
	
					# cannot find any match
					if open_tag == nil && close_tag == nil
						raise("xml parse error")
					end
	
					# first match is the openning tag
					if open_tag !=nil && (close_tag == nil || open_tag.begin(0) < close_tag.begin(0) ) 
		 
						# create a node
						node = CBaseElement.new
						node.name = open_tag[tag_index]
						node.parent = cur_root_node
		
						# if cur_root_node == nil but the doc.root != nil
						# it means there are something out the root node 
						if cur_root_node == nil && doc.root != nil
							raise("xml parse error")
						end
		
						doc.root = node unless cur_root_node
		 
		
						# link this node to current root node
						if cur_root_node
							cur_root_node.children.push(node) 
							text = open_tag.pre_match.strip
							cur_root_node.text << text << "\r\n" unless text.empty?
						end
		
						# update current root to the new node
						cur_root_node = node
		
						# push the new node to the stack
						stack.push(node)
		
						# strip the matched part
		
						cur_content = open_tag.post_match.lstrip
		
						next
					end 
	
	
					# first match is the closing tag
	
					node= stack.pop()
					if node.name !=close_tag[tag_index]
						puts node.name
						puts close_tag[tag_index]
						raise("xml parse error")
					end
					node.text << close_tag.pre_match.strip
					cur_root_node = node.parent 
					cur_content = close_tag.post_match.lstrip
		
				end # while

				return doc
			end
	
	
			# no trick conent like
			# <root>
			# <trick attr="<!--comment-->"> </trick>
			# <trick attr="<?xml version?>">
			# <root>
			# 
			def self.clean(content)
				comment	= '<\!--(.|\r|\n)*?-->'	# comments
				declaration= '<\?(.|\r|\n)*?\?>'	 # xml declaration
				regexp	= "(#{comment})|(#{declaration})"
	
				clean_content = content.gsub(/#{regexp}/m, "")
	
				return clean_content.strip
			end
			
		end # end class
		
	end
end