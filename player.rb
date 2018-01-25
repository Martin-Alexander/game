class Player
	attr_accessor :x, :y, :number, :width, :height

	def initialize(init_pos_x, init_pos_y, window, player_number)
		# Speed of player
		@speed = 4
				
		# Starting position
		@x = init_pos_x
		@y = init_pos_y
		
		# Width and height of player
		@width = 10
		@height = 10

		# Intial facing direction & player number
		@direction = :left
		@number = player_number

		# Sets the color based on the player number
		if @number == 1
			@color = BLUE
		elsif @number == 2
			@color = RED
		end

		# Stores the game in an instance variable
		@window = window
	end
		
	# Draws the player on the canvas base on direction
	def draw
		case @direction
		when :right
			@window.draw_triangle(@x, @y, @color, @x, @y + @width, @color, @x + @width, @y + @width / 2, @color)
		when :left
			@window.draw_triangle(@x + @width, @y, @color, @x + @width, @y + @width, @color, @x, @y + @width / 2, @color)
		when :down
			@window.draw_triangle(@x, @y, @color, @x + @width, @y, @color, @x + @width / 2, @y + @width, @color)
		when :up
			@window.draw_triangle(@x, @y + @width, @color, @x + @width, @y + @width, @color, @x + @width / 2, @y, @color)
		end
	end

	# Move controller
	def move(direction)
		case direction
		when :up
			if move_is_in_bounds?(0, -@speed)
				execute_move(0, -@speed) 
				@direction = direction
			end
		when :down
			if move_is_in_bounds?(0, @speed)
				execute_move(0, @speed) 
				@direction = direction
			end
		when :left
			if move_is_in_bounds?(-@speed, 0)
				execute_move(-@speed, 0)
				@direction = direction
			end
		when :right
			if move_is_in_bounds?(@speed, 0)
				execute_move(@speed, 0) 
				@direction = direction
			end
		end
	end

	# Returns whether or not a given move would put the player out of bounds
	def move_is_in_bounds?(change_in_x, change_in_y)
		new_x = @x + change_in_x
		new_y = @y + change_in_y

		new_x >= 0 && new_x + 10 <= @window.width && new_y >= 0 && new_y + 10 <= @window.height
	end

	# Updates x and y position
	def execute_move(change_in_x, change_in_y)
		@x += change_in_x
		@y += change_in_y
	end

	# Calls the Game object to create a new projectile
	def fire
		@window.add_projectile(self, @x, @y, @direction)
	end
end