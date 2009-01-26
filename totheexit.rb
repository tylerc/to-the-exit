#!/usr/bin/env ruby

require 'rubygems'
require 'gosu'

class GameWindow < Gosu::Window
	def initialize
		super 640, 480, false
		self.caption = "To the Exit!"
		@exit_image = Gosu::Image.new self, "media/exit.png", true
		@cursor = Gosu::Image.new self, "media/Cursor.png", false
		@exit_size = @exit_image.width
		@level = 1
		move_exit
	end
	
	def update
		self.caption = "x: #{self.mouse_x}, y: #{self.mouse_y}, level: #{@level}"
		
		if mouse_x > @exit_x and mouse_x < @exit_x + @exit_size and mouse_y > @exit_y and mouse_y < @exit_y + @exit_size
			@level += 1
			move_exit
		end
	end
	
	def draw
		@cursor.draw mouse_x, mouse_y, ZOrder::Mouse
		@exit_image.draw @exit_x, @exit_y, ZOrder::Objects
	end
	
	def button_down id
		if id == Gosu::Button::KbEscape
			close
		end
	end
	
	def move_exit
		@exit_x = rand(self.width)
		@exit_y = rand(self.height)
	end
end

module ZOrder
	Background, Objects, Mouse = *0..2
end

window = GameWindow.new
window.show
