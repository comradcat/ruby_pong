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
			@speed = 0;
		end
		#move platform to the left side
		def to_left
			@x = @x - @step
			@speed = -@step
		end
		#move platform to the right side
		def to_right
			@x = @x + @step
			@speed = @step
		end

		def do_nothing
			@speed = 0
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
			@player = Player.new(0, @height-8, 8, 1, @tiles[25])
			@ball = Ball.new(@player.x+@player.width/2-8,
											 @player.y - @player.height, 1, 1, @tiles[14], *[0, 0]);
		end
		def draw
			@player.draw
			@ball.draw
		end
		#Next iteration in game
		def next_step!
			if @player.collides(@ball) then
				# @TODO Think about architecture.
				# add speed of ball and platform?
				#
			end
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
			else
				@player.do_nothing
			end
		end
	end
end
