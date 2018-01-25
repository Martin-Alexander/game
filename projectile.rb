class Projectile
	attr_accessor :x, :y, :player, :width, :height

	def initialize(player, init_pos_x, init_pos_y, size, direction, window)
		# Speed of projectile
		@speed = 8

		# Width and height of projectile
		@width = size
		@height = size

		# Stores the game and player in instance variables
		@window = window
		@player = player

		# Direction of projectile
		@direction =  direction

		# Sets the inital position
		set_initial_position(init_pos_x, init_pos_y)

		# Sets the color based on the number of the player
		if @player.number == 1
			@color = YELLOW 
		elsif @player.number == 2
			@color = WHITE
		end
	end
	
	# Sets the intial startin position of the projectile based on the x and y
	# postition of the player, the size of the projetile, and the direction of
	# the player
	def set_initial_position(init_pos_x, init_pos_y)
		@x = init_pos_x + (@player.width - @width) / 2 
		@y = init_pos_y + (@player.height - @height) / 2
	
		case @direction
		when :up then @y -= @height / 2
		when :down then @y += @height / 2
		when :left then @x -= @width / 2
		when :right then @x += @width / 2
		end
	end

	# Draws the projectile on the canvas
	def draw
		@window.draw_rect(@x, @y, @width, @height, @color)
	end

	# Moves the projectile given it's direction
	def move
		case @direction
		when :up then @y -= @speed
		when :down then @y += @speed
		when :left then @x -= @speed
		when :right then @x += @speed
		end
	end
	
	# Returns whether or not the projectile is out of bound
	def out_of_bounds
		@x + @width < 0 || @x > @window.width || @y + @height < 0 || @y > @window.height 
	end
end