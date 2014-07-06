# @author ComradCat
module Game
	#Basic game class
	class Object
		#Physical parameters of object
		attr_accessor :x, :y, :width, :height
		#Image
		attr_accessor :tile
		attr_reader :center
		#constructor
		def initialize(x, y, width, height, tile)
			@x, @y = x, y
			@width, @height = width, height
			@tile = tile
		end
		#Return center of object box
		def center
			{:x => @x + @width/2, :y => @y + @height/2}
		end
		#draw image in current coordinates
		def draw
			@tile.draw(@x, @y, 0, 1, 1)
		end
		#Collision check
		def collides(object)
			#rewrite
			center = self.center
			collision_x = (object.x <= center[:x]) && (center[:x] <= (object.x + object.width));
			collision_y = ((object.y - object.height) <= center[:y]) && (center[:y] <= object.y);
			if(collision_x && collision_y)
				true
			else
				false
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
			#self.stack.each do |obj|
			#	if(@player.collides(obj)) then
			#	end
			#end
			if @player.collides(@ball) then
				puts 'collides!'
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
			end
		end
		#private
		#attr_accessor :stack
	end
end
