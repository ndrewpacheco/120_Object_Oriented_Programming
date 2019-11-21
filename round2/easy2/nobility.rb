# Now that we have a Walkable module, we are given a new challenge. \
#Apparently some of our users are nobility, and the regular way of walking simply isn't good enough.
# Nobility need to strut.

# We need a new class Noble that shows the title and name when walk is called:
module Walkable

  def walk
    puts "#{self} #{gait} forwad"
  end  

end

class Noble
  include Walkable

  attr_reader :title
  def initialize(title, name)
    @title = title
    @name = name
  end

  def walk

  end

end


byron = Noble.new("Byron", "Lord")
p byron.walk
# => "Lord Byron struts forward"
#We must have access to both name and title because they are needed
# for other purposes that we aren't showing here.

byron.name
#=> "Byron"
byron.title
#=> "Lord"
