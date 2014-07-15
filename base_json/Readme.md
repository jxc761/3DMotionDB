##Requirement

+ Ruby Vesion 1.8.6

##Usage

###Parse a JSON string

The basic method to parse a json string is as follows.

 	obj = BasicJson.parse(input)
 	
If the input is has the structure "{ }", this function will return a hash. If the input is has the structure " [ ] ", this  function will return an array. If the input is a path of a file, it will return the parsed result.

Two other ways to parse a string.

	<pre>
	content='{"attr1": 1, "attr2":true, "attr3": "string"}'
	hash, remain = BasicJson.parse_object(content)
	</pre>

This code will parse the <code>content</code> to a <code>hash</code> as follows.

	{"attr1" => 1, "attr2"=>true, "attr3"=>"string"}

The <code>remain</code> will be <code>""</code>, since after parse the hash from the string,
there will no content left. 
	
	content = '[1, true, "string"}'
	array, remain = BasicJson.parse_array(content)

This code will parse the <code>content</code> to a <code>array</code> as follows.

	[1, true, "string"]
	
The <code>remain</code> will be <code>""</code>, since after parse the array from the string,
there will no content left.

### From an array or a hash to JSON

The basic ways to convert an array or a hash to JSON are as follows.

	json_str = BasicJson.to_json(obj)
	BasicJson.write_to_json(filename, obj)

The <code>obj</code> must be an array or a hash. The method <code>to_json</code> will get the corresponding its JSON string. The method <code>write_to_json</code> will write the JSON string to the file.