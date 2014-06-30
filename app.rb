# @author ComradCat
require 'gosu'
#global variables
$width = 480
$height = 640
$step = 10
#Базовый класс
class GameObject
  attr_accessor :x, :y, :width, :height
  def initialize (x, y, width, height, tile)
    @x, @y = x, y
    @width, @height = width, height
    @tile = tile
  end
  def x=(x)
    @x=x;
  end
  def y=(y)
    @y=y;
  end
  def width=(width)
    @width=width;
  end
  def height=(height)
    @height=height;
  end
  def draw
    @tile.draw(@x, @y, 0, 1, 1)
  end
end
#Класс шара
class Ball < GameObject
  attr_accessor :speed_x, :speed_y
  def initialize (x, y, width, height, tile)
    super(x, y, width, height, tile)
    #Скорость по осям x, y
    @speed_x, @speed_y = 0, 0
  end
  #Проверка на столкновение с другим объектом
  #Столкновение, если (x_p <= x_b <= x_p + w_p) && (y_p - w_p <= y_b <= y_p)
  def collide_with(object)
    collision_x = (object.x <= @x) && (@x <= (object.x + object.width));
    collision_y = ((object.y - object.height) <= @y) && (@y <= object.y);
    if(collision_x && collision_y)
      true
    else
      false
    end
  end
  def speed(x, y)
    @speed_x, @speed_y = x, y;
  end
  def move
    if(@x >= $width || @x <= 0)
      @speed_x = -@speed_x;
    end
    if(@y >= $height || @y <= 0)
      @speed_y = -@speed_y;
    end
    @x = @x+@speed_x
    @y = @y+@speed_y
  end
end
#Класс платформы
class Platform < GameObject
  # width - ширина платформы в клетках.
  # tile - изображение которым будет отрисована платформа
  def initialize (x = 0, y = $height, width = 8, tile)
    super(x, y, width, tile.height, tile)
    @have_ball = false
  end
  #Помещает мячик на платформу
  def put_ball(ball)
    @have_ball = true
    @ball = ball
    @ball.x = @x + (@width/2)*@tile.width;
    @ball.y = @y-@tile.height;
  end
  #Запускает мяч с указанной скоростью
  def run_ball(speed_x = 0, speed_y = -1)
    if(@have_ball)
      @ball.y = @y-2*@tile.height;
      @ball.speed(speed_x, speed_y);
      @have_ball = false;
    end
  end
  #Влево
  def to_left
    if (@x <= 0) then
      @x = 0;
    else
      @x = @x - $step;
    end
    if(@have_ball)
      @ball.x = @x + (@width/2)*@tile.width;
    end
  end
  #В право
  def to_right
    if ( (@x + @width*@tile.width) >= $width)
      @x = $width - @width*@tile.width
    else
      @x = @x + $step;
    end
    if(@have_ball)
      @ball.x = @x + (@width/2)*@tile.width;
    end
  end
  #Отрисовка платформы
  def draw
    for i in 0..@width
      @tile.draw(@x+i*@tile.width, @y, 0, 1, 1)
    end
  end
end

class GameWindow < Gosu::Window
  def tiles=(path)
    @tiles = *Gosu::Image.load_tiles(self, path, 8, 8, false)
    @player = Platform.new(0, $height-8, 8, @tiles[25])
    @ball = Ball.new(20, $height-16, 1, 1, @tiles[14])
  end

  def initialize
    super($width, $height, false)
    self.caption = "Ruby Pong"
    #Направление в котором движется платформа
    @direction = :none
  end

  def button_down(id)
    case id
    when Gosu::KbLeft then
      @direction = :left
    when Gosu::KbRight then
      @direction = :right
    when Gosu::KbUp then
      @player.run_ball(0, -2);
    else
      @direction = :none
    end
  end

  def button_up(id)
    @direction = :none
  end

  def update
    case @direction
    when :left then
      @player.to_left
    when :right then
      @player.to_right
    end
    if(@ball.collide_with(@player))
      @player.put_ball(@ball);
    else
      @ball.move
    end
  end

  def draw
    @player.draw
    @ball.draw
  end
end

window = GameWindow.new
window.tiles="terminal.png"
window.show
