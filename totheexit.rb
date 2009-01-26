#!/usr/bin/env ruby

require 'rubygems'
require 'gosu'

class GameWindow < Gosu::Window
	def initialize
		super 640, 480, false
		self.caption = "To the Exit!"
		@level = 1
		@exit_image = Gosu::Image.new self, "media/exit.png", true
		@cursor = Gosu::Image.new self, "media/Cursor.png", false
	end
	
	def update
		self.caption = "x: #{self.mouse_x}, y: #{self.mouse_y}"
	end
	
	def draw
		@cursor.draw mouse_x, mouse_y, ZOrder::Mouse
	end
	
	def button_down id
		if id == Gosu::Button::KbEscape
			close
		end
	end
end

module ZOrder
	Background, Objects, Mouse = *0..2
end

window = GameWindow.new
window.show
