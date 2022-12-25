# frozen_string_literal: true

require_relative 'modules/fixtures'
require_relative 'ui/console_loop'

Fixtures.prepare
ConsoleLoop.run