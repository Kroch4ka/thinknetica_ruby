# frozen_string_literal: true
require_relative '../modules/state'
class BaseUI
  extend State
  def self.draw_numbered_list(iterable, &block)
    iterable.each_with_index do |elem, index|
      puts "#{index + 1}) #{block_given? ? block.call(elem) : elem}"
    end
  end

  def self.choose_variant(variants, &block)
    loop do
      draw_numbered_list(variants, &block)
      print 'Вариант: '
      chosen_number = gets.chomp.to_i
      if chosen_number.zero? || variants[chosen_number - 1].nil?
        puts 'Некорректный вариант'
        redo
      end

      return variants[chosen_number - 1]
    end
  end

  def self.clear_console
    puts `clear`
  end

  def self.exit
    Kernel.exit(0)
  end
end
