class Cat
  @@total_num_of_cats = 0
  def initialize

    @@total_num_of_cats += 1
  end
  def self.total
    p @@total_num_of_cats
  end

end



kitty1 = Cat.new
kitty2 = Cat.new

Cat.total