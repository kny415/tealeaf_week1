# calculator.rb

require 'pry'

def calc_me(a, b, c)
  result = yield(a, b)
  puts "#{c} = #{result}"
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
    calc_me(nums[1], nums[3], calc_str) { |a, b| a.to_i + b.to_i }
  when '-'
    calc_me(nums[1], nums[3], calc_str) { |a, b| a.to_i - b.to_i }
  when '*'
    calc_me(nums[1], nums[3], calc_str) { |a, b| puts a.to_i * b.to_i }
  when '/'
    calc_me(nums[1], nums[3], calc_str) { |a, b| puts a.to_f / b.to_i }
  end
end
# binding.pry