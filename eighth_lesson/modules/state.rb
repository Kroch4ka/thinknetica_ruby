# frozen_string_literal: true

module State
  def trains
    @@trains ||= []
  end

  def stations
    @@stations ||= []
  end

  def routes
    @@routes ||= []
  end
end