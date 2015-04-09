module Resque
  module Plugins
    module Director
      class Config
        attr_accessor :queue

        DEFAULT_OPTIONS = {
          :min_workers        => 1,
          :max_workers        => 0,
          :max_time           => 0,
          :max_queue          => 0,
          :wait_time          => 60,
          :start_override     => nil,
          :stop_override      => nil,
          :logger             => nil,
          :log_level          => :debug,
          :no_enqueue_scale   => false
        }
        DEFAULT_OPTIONS.each do |key, _|
          attr_reader key
        end

        def initialize(options={})
          DEFAULT_OPTIONS.each do |key, value|
            self.instance_variable_set("@#{key.to_s}", options[key] || value)
          end

          @min_workers = 0 if @min_workers < 0
          @max_workers = DEFAULT_OPTIONS[:max_workers] if @max_workers < @min_workers
        end

        def log(message)
          @logger.send(@log_level, "DIRECTORS LOG: #{message}") if @logger
        end
      end
    end
  end
end
