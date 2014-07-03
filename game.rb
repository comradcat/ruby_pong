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

	#Player(platform) class
	class Player < Object
		def initialize(*parent_args, speed) 
			super(*parent_args)
			raise ArgumentError, 'Argument is not array!' unless speed.is_a?(Array);
			raise ArgumentError, 'Array have not numeric or float elements!' unless speed.all?(|x| x.is_a(Float) || x.is_a(Fixnum)); 
		end
		#move platform to the left side
		def to_left
		end
		#move platform to the right side
		def to_right
		end
		#Check bonus collision with platform
		#Check brick, wall collision with ball
		def collides(obj)
		end
		#Move platform and ball
		def move
			#move ball
			#move platform, check collision with ball
		end
		#Ball is object
		attr_accessor :ball
		private
		attr_accessor :speed
	end

	class Manager
		def initialize(width, height)
			@width, @height = width, height
			@player = Player.new()
		end
		#Next iteration in game
		def next_step!
			self.stack.each do |obj|
				if(@player.collides(obj)) then
					
				end
			end
		end
		private
		attr_accessor :stack
	end
end
