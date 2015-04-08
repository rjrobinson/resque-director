class TestJob
  extend Resque::Plugins::Director
  @queue = :test

  def self.perform
  end
end

class AnotherTestJob
  extend Resque::Plugins::Director
  @queue = :another

  def self.perform
  end
end

class NonDirectedTestJob
  @queue = :non_directed

  def self.perform
  end
end