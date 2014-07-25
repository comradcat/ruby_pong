# @author ComradCat
module Game
	#Basic game class
	class Object
		#Physical parameters of object
		attr_accessor :x, :y, :width, :height
		#Image
		attr_accessor :tile
		attr_reader :right, :bottom
		#constructor
		def initialize(x, y, width, height, tile)
			@x, @y = x, y
			@width, @height = width, height
			@tile = tile
		end
		def left
			self.x - @tile.width*0.8
		end
		def right
			self.x + self.width + @tile.width*0.8
		end
		def top
			self.y - @tile.height*0.8
		end
		def bottom
			self.y + self.height + @tile.height*0.8
		end
		#draw image in current coordinates
		def draw
			@tile.draw(@x, @y, 0, 1, 1)
		end
		#Collision check
		def collides(object)
			if(self.bottom < object.top)
				false	
			elsif(self.top > object.bottom)
				false
			elsif(self.right < object.left)
				false
			elsif(self.left > object.right)
				false
			else
				true
			end
		end
		#Call this when object collides with other object
		def thud(other)
			#do some stuff
			other.thud!
		end
		#Will call by another object
		#TODO: It's 
		def thud!
		end
	end
	#wall class
	class Wall < Game::Object
		def draw
			for i in 0..@width
				for j in 0..@height
					@tile.draw(@x+i*@tile.width, @y+j*@tile.height, 0, 1, 1)
				end
			end
		end
	end
	#Ball class
	class Ball < Game::Object
		def initialize(x, y, width, height, tile, *speed)
			super(x, y, width, height, tile)
			@speed = *speed
		end
	end

	#Player(platform) class
	class Player < Game::Object
		attr_reader :speed
		def initialize(x, y, width, height, tile)
			super(x, y, width, height, tile)
			@step = 5
		end
		#move platform to the left side
		def to_left
			@x = @x - @step
		end
		#move platform to the right side
		def to_right
			@x = @x + @step
		end
		def draw
			for i in 0..@width
				@tile.draw(@x+i*@tile.width, @y, 0, 1, 1)
			end
		end
		def width
			(@width+1)*@tile.width
		end
		def height
			@height*@tile.height
		end
	end

	class Manager
		def initialize(width, height, window, *tiles)
			@width, @height = width, height
			@tiles = *tiles
			@player = Player.new(0, @height-16, 8, 1, @tiles[25])
			@lwall = Wall.new(0, 0, 0, @height, @tiles[27]) #left wall
			@rwall = Wall.new(width-@tiles[27].width, 0, 0, height, @tiles[27]) #right wall
			@twall = Wall.new(0, -1, width, 0, @tiles[27]) #top wall
			@bwall = Wall.new(0, height-@tiles[28].width, width, 1, @tiles[28])
			@objects = [@lwall, @rwall, @twall, @bwall]
		end
		def draw
			@player.draw
			#@ball.draw
			@objects.each do |wall|
				wall.draw
			end
		end
		#Next iteration in game
		def next_step!
			if @player.x <= 0
				@player.x = 0
			elsif (@player.x + @player.width) >= @width
				@player.x = @width - @player.width
			end
		end

		def do(command_id)
			case command_id
			when :move_left then
				@player.to_left
			when :move_right then
				@player.to_right
			end
		end
	end
end
