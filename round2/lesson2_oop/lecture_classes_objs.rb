# Given the below usage of the Person class, code the class definition.

class Person

  attr_accessor :first_name, :last_name

  def initialize(n)
    parse_full_name(n)
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def name=(n)
    parse_full_name(n)
  end

  private

  def parse_full_name(n)
    parts = n.split
    self.first_name = parts.first
    self.last_name = parts.size > 1 ? parts.last : ""
  end

end

bob = Person.new('Robert')
bob.name                  # => 'Robert'
bob.first_name            # => 'Robert'
bob.last_name             # => ''
bob.last_name = 'Smith'
bob.name                  # => 'Robert Smith'

p bob.name = "John Adams"
p bob.first_name            # => 'John'
p bob.last_name             # => 'Adams'