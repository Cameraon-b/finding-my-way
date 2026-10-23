# Central lookup tables for all game content. Content files register
# themselves here; nothing else needs to know where they live.
module Registry
  @areas = {}
  @regions = {}
  @items = {}
  @enemies = {}

  class << self
    attr_reader :areas, :regions, :items, :enemies

    def area(id)    = @areas.fetch(id) { raise KeyError, "Unknown area: #{id.inspect}" }
    def item(id)    = @items.fetch(id) { raise KeyError, "Unknown item: #{id.inspect}" }
    def enemy(id)   = @enemies.fetch(id) { raise KeyError, "Unknown enemy: #{id.inspect}" }

    def start_area
      region = @regions.values.first or raise "No regions defined"
      region.start
    end

    # Returns a list of problems (broken exits, unknown items...). Empty = healthy.
    def validate
      problems = []
      @areas.each_value do |a|
        problems << "#{a.id}: unknown region #{a.region.inspect}" unless a.region.nil? || @regions.key?(a.region)
        a.exits.each do |dir, dest|
          problems << "#{a.id}: exit '#{dir}' -> missing area #{dest.inspect}" unless @areas.key?(dest)
        end
        a.items.each { |i| problems << "#{a.id}: unknown item #{i.inspect}" unless @items.key?(i) }
        problems << "#{a.id}: unknown enemy #{a.encounter.inspect}" if a.encounter && !@enemies.key?(a.encounter)
      end
      @regions.each_value do |r|
        problems << "region #{r.id}: start area #{r.start.inspect} missing" unless @areas.key?(r.start)
      end
      problems
    end
  end
end
