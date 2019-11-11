#Programs will be supplied to your language method via a string passed in as an argument. 

# Your program should produce an error if an unexpected item is present in the string, 
# or if a required stack value is not on the stack when it should be (the stack is empty). 

# In all error cases, no further processing should be performed on the program.

#You should initialize the register to 0.

# n Place a value n in the "register". Do not modify the stack.
# PUSH Push the register value on to the stack. Leave the value in the register.
# ADD Pops a value from the stack and adds it to the register value, storing the result in the register.
# SUB Pops a value from the stack and subtracts it from the register value, storing the result in the register.
# MULT Pops a value from the stack and multiplies it by the register value, storing the result in the register.
# DIV Pops a value from the stack and divides it into the register value, storing the integer result in the register.
# MOD Pops a value from the stack and divides it into the register value, storing the integer remainder of the division in the register.
# POP Remove the topmost item from the stack and place in register
# PRINT Print the register value

class Minilang
  attr_accessor :register, :stack, :commands

  def initialize(commands)
    @commands = commands.split
  end

  def eval
    @register = 0
    @stack = []
    convert_command_to_i
    commands.each do |command|
      if command.class == Integer
        self.register = command
      else
        case command 
        when "PRINT" then print
        when "PUSH" then push
        when "POP" then pop
        when "MULT" then mult
        when "ADD" then add
        when "DIV" then div
        when "MOD" then mod
        when "SUB" then sub
        else
          raise StandardError, "Invalid Token: #{command}"
        end
      end
    end
  end

  private 
  def push
    stack.push(register)
  end

  def add
    self.register += stack.pop

  end

  def sub
    self.register -= stack.pop
  end

  def mult
    self.register *= stack.pop
  end

  def div
    self.register /= stack.pop
  end

  def mod
    self.register %= stack.pop
  end

  def pop
    
    raise StandardError, "Empty Stack!" if stack.empty?
    self.register = stack.pop
  end

  def print
  
      puts register

  end

  def can_be_integer?(str)
   str.to_i.to_s == str
  end

  def convert_command_to_i
    commands.map! do |command| 
      if can_be_integer?(command)
        command.to_i 
      else
        command
      end
    end
  end

  def eval
    commands.each do |command|
      if command.class == Integer
        self.register = command
      else
        case command 
        when "PRINT" then print
        when "PUSH" then push
        when "POP" then pop
        when "MULT" then mult
        when "ADD" then add
        when "DIV" then div
        when "MOD" then mod
        when "SUB" then sub
        else
          raise StandardError, "Invalid Token: #{command}"
        end
      end
    end
  end
end


# Examples:

# Minilang.new('PRINT').eval
# # 0

# Minilang.new('5 PUSH 3 MULT PRINT').eval
# # 15

# Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# # 5
# # 3
# # 8

# Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# # 10
# # 5

# Minilang.new('5 PUSH POP POP PRINT').eval
# # Empty stack!

# Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# # 6

# Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# # 12

# Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# # Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)