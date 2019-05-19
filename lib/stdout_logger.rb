class StdoutLogger
  include Singleton

  attr_reader :logger

  def initialize
    @logger = Logger.new(STDOUT)
  end

  def self.info(message)
    instance.logger.info(message)
  end
end
