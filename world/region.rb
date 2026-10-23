#   Region.define :whispering_woods, name: "The Whispering Woods", start: :woods_clearing
# The first region defined is where a new game begins.
class Region
  attr_reader :id, :name, :start

  def self.define(id, name:, start:)
    Registry.regions[id] = new(id, name, start)
  end

  def initialize(id, name, start)
    @id = id
    @name = name
    @start = start
  end
end
