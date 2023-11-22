require "yaml"

module IceCube
  class YamlParser < HashParser
    SERIALIZED_START = /start_(?:time|date): .+(?<tz>(?:-|\+)\d{2}:\d{2})$/
    SAFE_LOAD_CLASSES = [
      Date,
      Symbol,
      Time,
      IceCube::YearlyRule,
      IceCube::Validations::YearlyInterval::Validation,
    ].freeze

    attr_reader :hash

    def initialize(yaml)
      @hash = YAML.safe_load(yaml, permitted_classes: SAFE_LOAD_CLASSES, aliases: true)
      yaml.match SERIALIZED_START do |match|
        start_time = hash[:start_time] || hash[:start_date]
        TimeUtil.restore_deserialized_offset start_time, match[:tz]
      end
    end
  end
end
