#Using the following code, create a class named Person with an instance variable named @secret. 
# Use a setter method to add a value to @secret, then use a getter method to print @secret.



class Person

  attr_accessor :secret

end
person1 = Person.new
p person1.secret
person1.secret = 'Shh.. this is a secret!'
puts person1.secret
#Expected output:

#Shh.. this is a secret!
