# reads input from file and separates it into lines
def file_input
	
	line_num = 1
	file_name = "file1.while"
	file = IO.readlines(file_name)
	tokens_hash = Hash.new
	
	file.each do |line|

		if (line != file.last)
			get_tokens(file_name, line, line_num, tokens_hash)
			line_num += 1
		elsif (file.last.include? "EOF")
			puts "SUCCESSFUL!"
		elsif (!file.last.include? "EOF")
			get_tokens(file_name,line, line_num, tokens_hash)
			line_num += 1
			puts "#{file_name}> syntax error: no EOF symbol found"
		end
	end
end

# separates tokens into left-hand and right-hand
# values delimited by :=
def get_tokens(file_name, line, line_num, tokens_hash)
	
	# checks if there is a point from identifier to the values
	if (line.include? ":=")
		tokens = line.split(":=")
		identifier = tokens[0]

		# checks if the identifier follows the correct rules
		if ((identifier =~ /^[0-9a-zA-Z_]/ && identifier[0] =~ /^[a-zA-Z]/))

			rh_tokens = tokens[1].split(" ")
			
			# checks if there is an end of line symbol
			if (rh_tokens[rh_tokens.length-1].include? ";")
				#lexer(identifier, rh_tokens, tokens_hash)
			else
				puts "#{file_name}: #{line_num}> syntax error: no semicolon at end of line"
				abort
			end

		else
			puts "#{file_name}: #{line_num}> syntax error: incorrect identifier"
			abort
		end

	# checks if the comment follows the correct rules
	elsif (line.include? "//")
		if (line[line.length-2] != ";")
			puts "#{file_name}: #{line_num}> syntax error: no end of line symbol"
			abort
		end
	else
		puts "#{file_name}: #{line_num}> syntax error: no pointer, ':=', was found"
		abort
	end 
end


# to start my program
def start
	file_input
end

start
