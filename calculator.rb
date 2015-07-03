# calculator.rb

require 'pry'

def calc_me(num1, num2, input_str)
  result = yield(num1, num2)
  puts "#{input_str} = #{result}"
end

puts "enter calculation (ex: 1 + 2)"
calc_str = gets.chomp
# puts calc

nums = /(\d+)\s*([\+\-\*\/])\s*(\d+)/.match(calc_str)
puts nums.inspect

# binding.pry
if nums
  case nums[2]
  when '+'
    calc_me(nums[1], nums[3], calc_str) { |num1, num2| num1.to_i + num2.to_i }
  when '-'
    calc_me(nums[1], nums[3], calc_str) { |num1, num2| num1.to_i - num2.to_i }
  when '*'
    calc_me(nums[1], nums[3], calc_str) { |num1, num2|  num1.to_i * num2.to_i }
  when '/'
    calc_me(nums[1], nums[3], calc_str) { |num1, num2|  num1.to_f / num2.to_i }
  end
end
# binding.pry
