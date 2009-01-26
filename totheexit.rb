#!/usr/bin/env ruby

require 'rubygems'
require 'gosu'

class GameWindow < Gosu::Window
	attr_accessor :exit_x, :exit_y, :exit_size
	def initialize
		super 640, 480, false
		self.caption = "To the Exit!"
		@exit_image = Gosu::Image.new self, "media/exit.png", true
		@cursor = Gosu::Image.new self, "media/Cursor.png", false
		@exit_size = @exit_image.width
		@level = 0
		@blocks = []
		@started = false
		@font_handle = Gosu::Font.new self, Gosu::default_font_name, 20
		move_exit
	end
	
	def update
		self.caption = "x: #{self.mouse_x}, y: #{self.mouse_y}, level: #{@level}"
		
		@blocks.each {|block| block.update}
		
		@blocks.each do |block|
			if mouse_collision block
				@level = 0
				@started = false
				@blocks = []
				@exit_x = self.width/2
				@exit_y = self.height/2
			end
		end
		
		if mouse_x > @exit_x and mouse_x < @exit_x + @exit_size and mouse_y > @exit_y and mouse_y < @exit_y + @exit_size
			move_exit
			@started = true
			@level += 1
			@blocks = []
			@level.times do
				@blocks += [Block.new self]
			end
		end
	end
	
	def draw
		@blocks.each {|block| block.draw}
		@cursor.draw mouse_x, mouse_y, ZOrder::Mouse
		@exit_image.draw @exit_x, @exit_y, ZOrder::Objects
		if @started == false
			@font_handle.draw("To The Exit!", self.width/2-@font_handle.text_width("To The Exit!", 4)/2, 1, ZOrder::UI, 4, 4)
			@font_handle.draw("Get Your Mouse to the Exit!", self.width/2-@font_handle.text_width("Get Your Mouse to the Exit!", 2)/2, 80, ZOrder::UI, 2, 2)
			@font_handle.draw("Don't Touch the Red Blocks!", self.width/2-@font_handle.text_width("Don't Touch the Red Blocks!", 2)/2, 140, ZOrder::UI, 2, 2)
			@font_handle.draw("Touch the Exit to Begin", self.width/2-@font_handle.text_width("Touch the Exit to Begin")/2, self.height-20, ZOrder::UI)
		end
	end
	
	def button_down id
		if id == Gosu::Button::KbEscape
			close
		end
	end
	
	def move_exit
		@exit_x = rand(self.width)
		@exit_y = rand(self.height)
		if @exit_x < 0 or @exit_y < 0 or @exit_x + @exit_size > self.width or @exit_y + @exit_size > self.height
			move_exit
		end
	end
	
	def mouse_collision obj
		if mouse_x > obj.x and mouse_x < obj.x + obj.width and mouse_y > obj.y and mouse_y < obj.y + obj.height
			return true
		else
			return false
		end
	end
end

class Block
	attr_accessor :x, :y, :width, :height
	def initialize window
		@window = window
		@image = Gosu::Image.new @window, 'media/block.png', true
		@factor = 1
		place_block
	end
	
	def draw
		@image.draw @x, @y, ZOrder::Objects, @factor, @factor
	end
	
	def update
		@factor += 0.01
		@width = @image.width * @factor
		@height = @image.height * @factor
	end
	
	def place_block
		@x = rand(@window.width)
		@y = rand(@window.height)
		# avoid placing the blocks outside the window
		if @x < 0 or @y < 0 or @x + @image.width > @window.width or @y + @image.height > @window.height
			place_block
		# avoid placing the blocks on the mouse
		elsif (@x > @window.mouse_x-48 and @x < @window.mouse_x+48) and (@y > @window.mouse_y-48 and @y < @window.mouse_y+48)
			place_block
		# avoid placing the blocks on the exit
		elsif (@x > @window.exit_x-32 and @x < @window.exit_x+@window.exit_size+32) and (@y > @window.exit_y-32 and @y < @window.exit_y+@window.exit_size+32)
			place_block
		end
	end
end

module ZOrder
	Background, Objects, Mouse, UI = *0..3
end

window = GameWindow.new
window.show
