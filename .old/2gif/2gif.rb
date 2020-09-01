#!/usr/bin/ruby
require 'ostruct'

def display_help()
	print "
[34m🎞 2gif[0m - [1mv0.0.1[0m

[1mUsage:[0m

2gif [options] ./input-file.* ./output-file.gif

[1mOptions:[0m

--help, -h\r[25C: Display this help text and exit.
--width, -w ...\r[25C: Specify the width of the output gif.
--height, -H ...\r[25C: Specify the height of the output gif.
--fps, -f ...\r[25C: Specify the fps of the output gif.
--start, -s ...\r[25C: Specify the timestamp to start converting from. Accepts HH:MM:SS format.
--stop, -S ...\r[25C: Specify the timestamp to stop converting at. Accepts HH:MM:SS format.
--no-pal\r[25C: Disable palette optimization. Smaller file size, but lower quality output.

"
	exit
end

# An OpenStruct object containing the arguments once they've been parsed.
$arguments = OpenStruct.new(
	width: :not_set,
	height: :not_set,
	fps: :not_set,
	start: :not_set,
	stop: :not_set,
	help: :not_set,
	"no-pal": :not_set,
)

# An OpenStruct object containing type annotations for the various arguments.
$argument_types = OpenStruct.new(
	width: "number",
	height: "number",
	fps: "number",
	start: "timestamp",
	stop: "timestamp",
	help: "default",
	"no-pal": "default",
)

# An OpenStruct object containing the aliases/shorthands for arguments.
$aliases = OpenStruct.new(
	w: "width",
	H: "height",
	f: "fps",
	s: "start",
	S: "stop",
	h: "help",
)

$arg_mode = "default"
$arg_target = nil
$unnamed_arg_count = 0
$input_file = ""
$output_file = ""

ARGV.each do |arg|
	def parse_argument(arg)
		if $arg_mode == "number" then
			if arg.index(/[^0-9]/) == nil then
				$arguments[""<<$arg_target] = arg.to_i()
			else
				print "Error: Argument \""<<$arg_target<<"\" expects a number parameter, got \""<<arg<<"\".\n"
				display_help
			end
		elsif $arg_mode == "timestamp" then
			if arg.index(/\d+:\d\d:\d\d/) != nil then
				$arguments[""<<$arg_target] = arg
			else
				print "Error: Argument \""<<$arg_target<<"\" expects a timestamp parameter, got \""<<arg<<"\".\n"
				display_help
			end
		elsif $arg_mode == "default" then
			print "Error: Argument \""<<$arg_target<<"\" does not accept a parameter.\n"
			display_help
		end
		$arg_mode = "default"
		$arg_target = nil
	end
	if $arg_mode == "default" then
		if arg.start_with?("-") then
			# =================================================================
			# Handle arguments.
			# =================================================================
			if arg.start_with?("--") then
				if !arg.include?("=") then
					# =========================================================
					# Handle longhand arguments.
					# =========================================================

					no_prefix = arg[2..-1]
					
					# Ensure that the argument is valid.
					if $arguments[""<<no_prefix] != nil then
						# Set the argument to be parsed on the next pass.
						$arg_mode = $argument_types[""<<no_prefix]
						$arg_target = no_prefix
						if $arg_mode == "default" then $arguments[""<<no_prefix] = true end
					else
						# Error b/c of an unexpected argument and display help.
						print "Error: Unexpected argument \""<<no_prefix<<"\".\n"
						display_help
					end
				else
					# =========================================================
					# Handle longhand arguments with an =.
					# =========================================================
					no_prefix = arg[2..-1]

					split = no_prefix.split("=")
					left_side = split[0]
					right_side = split[1]
					
					# Ensure that the left hand side of the = is a valid argument.
					if $arguments[""<<left_side] != nil then
						# Parse the argument.
						$arg_mode = $argument_types[""<<left_side]
						$arg_target = left_side
						parse_argument(right_side)
					else
						# Error b/c of an unexpected argument and display help.
						print "Error: Unexpected argument \""<<left_side<<"\".\n"
						display_help
					end
				end
			else
				if !arg.include?("=") then
					# =========================================================
					# Handle shorthand arguments.
					# =========================================================
					
					no_prefix = arg[1..-1]

					# Ensure that the argument is a valid alias.
					if $aliases[""<<no_prefix] then
						no_prefix = $aliases[""<<no_prefix]

						# Ensure that the alias is a valid argument.
						if $arguments[""<<no_prefix] != nil then
							# Set the argument to be parsed on the next pass.
							$arg_mode = $argument_types[""<<no_prefix]
							$arg_target = no_prefix
							if $arg_mode == "default" then $arguments[""<<no_prefix] = true end
						else
							# Error and exit. (Should not occur.)
							print "Error: Internal error 002. Please report this issue.\n"
							exit
						end
					else
						# Error b/c of an unexpected argument and display help.
						print "Error: Unexpected argument \""<<no_prefix<<"\".\n"
						display_help
					end
				else
					# =========================================================
					# Handle shorthand arguments with an =.
					# =========================================================
					
					no_prefix = arg[1..-1]
					
					split = no_prefix.split("=")
					left_side = split[0]
					right_side = split[1]

					# Ensure that the left hand side of the = is a valid alias.
					if $aliases[""<<left_side] != nil then
						left_side = $aliases[""<<left_side]

						# Ensure that the alias is a valid argument.
						if $arguments[""<<left_side] != nil then
							# Parse the argument.
							$arg_mode = $argument_types[""<<left_side]
							$arg_target = left_side
							parse_argument(right_side)
						else
							# Error and exit. (Should not occur.)
							print "Error: Internal error 001. Please report this issue.\n"
							exit
						end
					else
						print "Error: Unexpected argument \""<<left_side<<"\".\n"
						display_help
					end
				end
			end
		else
			# =================================================================
			# Handle input and output file.
			# =================================================================
			if $unnamed_arg_count == 0 then
				$input_file = arg
			elsif $unnamed_arg_count == 1 then
				$output_file = arg
			else
				print "Error: Too many arguments.\n"
				display_help
			end
			$unnamed_arg_count += 1
		end
	elsif $arg_mode == "number" || $arg_mode == "string" then
		parse_argument(arg, $arg_mode)
	end
end

if $input_file != "" && $output_file != "" then
	print "Working...\n"
	
	width = ""
	if $arguments["width"] != :not_set then width = $arguments["width"]
	else width = `mediainfo --fullscan #{$input_file} | jsgrep --color=none -m=1 -o "(?<=Width                                    : )\\d+"` end
	height = ""
	if $arguments["height"] != :not_set then height = $arguments["height"]
	else height = `mediainfo --fullscan #{$input_file} | jsgrep --color=none -m=1 -o "(?<=Height                                   : )\\d+"` end
		
	vf = ""
	if $arguments["no-pal"] == :not_set then vf = "scale=#{width}:#{height},split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse"
	else vf = "scale=#{width}:#{height}" end

	framerate = ""
	if $arguments["fps"] != :not_set then framerate = $arguments["framerate"]
	else framerate = `mediainfo --fullscan #{$input_file} | jsgrep --color=none -m=1 -o "(?<=Frame rate                               : )\\d+.\\d+(?= FPS)"` end
	
	start = ""
	if $arguments["start"] != :not_set then start = $arguments["start"]
	else start = "00:00:00" end
	stop = ""
	if $arguments["stop"] != :not_set then stop = $arguments["stop"]
	else stop = `mediainfo --fullscan #{$input_file} | jsgrep --color=none -m=1 -o "(?<=Duration                                 : )\\d\\d:\\d\\d:\\d\\d.\\d+" | round-time-up` end

	command = "ffmpeg \\
		-i #{$input_file} \\
		-r #{framerate.gsub("\n", "")} \\
		-vf \"#{vf.gsub("\n", "")}\" \\
		-ss #{start.gsub("\n", "")} -to #{stop.gsub("\n", "")} \\
		#{$output_file}"
	
	print ""<<command<<"\n"

	`#{command}`
else
	if $arguments["help"] != :not_set then display_help
	else print "Error: Too few arguments.\n"; display_help end
end
