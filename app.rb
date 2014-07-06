# @author ComradCat
require 'gosu'
require './game'
#global variables
$width = 480
$height = 640

class GameWindow < Gosu::Window
def initialize
  super($width, $height, false)
  self.caption = "Ruby Pong"
  @tiles = *Gosu::Image.load_tiles(self, "terminal.png", 8, 8, false)
  @manager = Game::Manager.new($width, $height, self, *@tiles)
  @command = :none
end
def draw
  @manager.draw
end
def button_down(id)
  case id
  when Gosu::KbLeft then
    @command = :move_left
  when Gosu::KbRight then
    @command = :move_right
  end
end
def button_up(id)
  @command = :none
end
def update
  @manager.do(@command)
  @manager.next_step!
end
end

window = GameWindow.new
window.show
