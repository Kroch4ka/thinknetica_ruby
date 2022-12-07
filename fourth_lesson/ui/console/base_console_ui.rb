class BaseConsoleUI
  STOP_WORD = 'stop'
  
  class << self
    def stop_command_request(outer_command = nil, custom_message = nil)
      default_message = "Если Вы хотите выйти - введите, пожалуйста: #{self::STOP_WORD}. В противном случае - нажмите любую кнопку."
      message = default_message || custom_message
      stop_command = 
        if outer_command
          outer_command
        else
          puts message
          gets.chomp
        end
  
      return stop_command == self::STOP_WORD
    end

    def validate_serial_number(collection, serial_number)
      return serial_number <= collection.length && serial_number >= 1
    end

    private
    
    def clear_console!
      puts `clear`
    end
  end
end