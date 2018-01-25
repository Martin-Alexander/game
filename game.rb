class Game < Gosu::Window
	# Class method to determine if two entities are touching
	def self.colision?(a, b)
		a.x + a.width >= b.x && 
		a.x < b.x + b.width &&
		a.y + a.height >= b.y &&
		a.y < b.y + b.height
	end

	attr_reader :width, :height

	def initialize
		# Width and height of window
		@width = 800
		@height = 600
		super(@width, @height)

		# Caption
		self.caption = "My Game"

		# Create player one, player two and stores them in an instance variable 
		@player_one = Player.new(@width - 20, @height - 20, self, 1)
		@player_two = Player.new(10, 10, self, 2)
		@players = [@player_one, @player_two]

		# Initialized an array to store all projectiles
		@projectiles = []

		# Winner of the game
		@winner = false
	end

	# Main draw method (called 60 times a second)
	def draw
		# Loop through and draw each player
		@players.each do |player|
			player.draw
		end

		# Loop through and draw each projectile
		@projectiles.each do |projectile|
			projectile.draw
		end
	end
	
	# Main update method (called 60 times a second)
	def update
		if !@winner
			handle_inputs
			update_projectiles	
			handle_projectile_player_colision	
		else
			# Wait 2.5 seconds and the re-initialize the game
			sleep(2.5)
			initialize
		end
	end
	
	def handle_inputs
		# Player one controls
		@player_one.move(:left) if Gosu.button_down? Gosu::KB_L
		@player_one.move(:right) if Gosu.button_down? Gosu::KB_APOSTROPHE
		@player_one.move(:up) if Gosu.button_down? Gosu::KB_P
		@player_one.move(:down) if Gosu.button_down? Gosu::KB_SEMICOLON
		
		# Player two controls
		@player_two.move(:left) if Gosu.button_down? Gosu::KB_A
		@player_two.move(:right) if Gosu.button_down? Gosu::KB_D
		@player_two.move(:up) if Gosu.button_down? Gosu::KB_W
		@player_two.move(:down) if Gosu.button_down? Gosu::KB_S
	end
	
	# Iterate through each projectile, move it, and delete it if it's out of bounds
	def update_projectiles
		@projectiles.delete_if do |projectile|
			projectile.move
			projectile.out_of_bounds
		end
	end

	# Method is called when a button is released
	def button_up(id)
		case id
		when 44 then @player_one.fire
		when 225 then @player_two.fire
		when 41 then exit
		end
	end

	# Create a projectile and set its size based on the number of projectiles
	# the player already has on the screen
	def add_projectile(player, x, y, direction)
		if player_projectiles(player).count > 10
			projectile_size = 2
		else
			projectile_size = 100 / (player_projectiles(player).count + 1)
		end 
			
		@projectiles << Projectile.new(player, x, y, projectile_size, direction, self)
	end

	# Returns an array of all projectiles belonging to a given player
	def player_projectiles(player)
		@projectiles.select { |projectile| projectile.player == player }
	end

	# Iterates through each player and each projectile to see if anyone has
	# been hit. If so, the winner is declared
	def handle_projectile_player_colision
		winner = false

		@players.each do |player|
			break if winner
			@projectiles.each do |projectile|
				break if winner
				if Game.colision?(player, projectile) && player != projectile.player
					winner = projectile.player
				end
			end
		end

		@winner = winner
	end
end