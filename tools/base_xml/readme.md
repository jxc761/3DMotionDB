## Why I write this script
For some reasons, I should work with ruby 1.8.5 with just core library. So the standard xml library and most open source library cannot be used in my project. But fortunately, what I really need is not a general xml parser but the one which can parse the baisc xml format.


## Features

- Good feature: Work with Ruby 1.8.5 core library.
- Bad feature: Limited functions

## The target XML file

What I am trying to parse looks like:

	<?xml version="1.0" encoding="UTF-8"?>
	<!-- This is a comment -->
	<notes>
		<note>
			<to>Tove</to>
			<from>Jani</from>
			<heading>Reminder</heading>
			<body>Don't forget me this weekend!</body>
		</note>
		<author>J K. Rowling</author>
    	<year>2005</year>
	</notes>
  
Any tag are allowed to have attributes, but it will be discarded. That means it can parse a xml file as follows. But it will just ignore the attributes like 	<code>category="COOKING"</code>

	
		<bookstore>
  			<book category="COOKING">
    		<title lang="en">Everyday Italian</title>
    		<author>Giada De Laurentiis</author>
    		<year>2005</year>
    		<price>30.00</price>
  			</book>
  		
  			<book category="CHILDREN">
    		<title lang="en">Harry Potter</title>
    		<author>J K. Rowling</author>
    		<year>2005</year>
    		<price>29.99</price>
  			</book>
  		
  			<book category="WEB">
    		<title lang="en">Learning XML</title>
    		<author>Erik T. Ray</author>
    		<year>2003</year>
    		<price>39.95</price>
  			</book>
		</bookstore>


 
