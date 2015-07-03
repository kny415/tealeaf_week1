# rps.rb
# get player input
# get comp input
# compare
# repeat

require 'pry'

CHOICES = { 'r' => 'Rock', 'p' => 'Paper', 's' => 'Scissors'}

puts "Welcome to Rock Paper Scissors!"

loop do
  puts "Please choose r/p/s or q to quit"
  user_choice = gets.chomp
  break if user_choice == 'q'

  puts "user_choice = #{CHOICES[user_choice]}"

  computer_choice = CHOICES.keys.sample
  puts "computer_choice = #{CHOICES[computer_choice]}"

  # r > s
  # p > r
  # s > p

  if (user_choice == computer_choice ) 
    puts "Its a Tie!"
  elsif (user_choice == 'r' && computer_choice == 's') ||
        (user_choice == 'p' && computer_choice == 'r') ||
        (user_choice == 's' && computer_choice == 'p') 
        puts "You Win!"
  else
    puts "You Lose!"
  end

end