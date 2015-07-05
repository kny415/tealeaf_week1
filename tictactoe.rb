# tictactoe.rb

# init board
# draw board
# player input square index
# comp square index
# check for all squares taken or 3 in a row

require 'pry'

# BOARD_SIZE = 3
# $player_score = []

# def init_board
#   board = {}
#   (1..9).each { |k| board[k] = ' '}
#   board
# end

def init_board(size)
  board = {}
  (1..(size*size)).each { |k| board[k] = ' '}
  board
  # binding.pry
end

def init_scores(size)
  player_score = []
  (0..(size*size-1)).each { |i| player_score[i] = 0 }
  # binding.pry
  player_score
end

# def draw_board(b)
#   system 'clear'
#   puts " #{b[1]} | #{b[2]} | #{b[3]} "
#   puts "------------"
#   puts " #{b[4]} | #{b[5]} | #{b[6]} "
#   puts "------------"
#   puts " #{b[7]} | #{b[8]} | #{b[9]} "
# end

def draw_board(b)
  system 'clear'
  size = Math.sqrt(b.size)
  (1..b.size).each do |count|
    print " " + b[count].to_s
    if (count % size != 0)
      print " |" 
    elsif (count != b.size)
      print "\n"
      size.to_i.times { print "----" } 
      print "\n"
    end
  end
  print "\n\n"
end

# mod 3 gives column,  0, 1, 2, 0, 1, 2, 0, 1, 2
# /3 gives row,               0, 0, 0, 1, 1, 1, 2, 2, 2
# 012
# 345
# 678
# row1 = index/3  = 0, score[index/3] += 1
# row2 = index/3 = 1
# row3 = index/3 = 2
# col1 = index%3 = 0, score[BOARD_SIZE+index/3] += 1
# col2 = index%3 = 1
# col3 = index%3 = 2
# diag1 = 0, 4, 8: 0..(n-1)*(n+1)
# diag1 = index%4 = 0, if index%4 == 0, score[n*2] += 1
# diag2 = 2, 4, 6: 1..(n)*(n-1)
# diag2 = index/2 = 0, if (index < n*n-1) and (index/2 == 0), score[n*2+1] += 1

# 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3
# 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2

# diag1 = 0, 5, 10, 15:  0..(n-1)*(n+1)
# diag2 = 3, 6, 9, 12:  1..n*(n-1)
# 0123
# 4567
# 891011
# 12131415 
# diag1 = index%5 = 0
# diag2 = index%3 = 0, if index < n*n-1

def update_score(player_score, index, board_size)
  # binding.pry
  player_score[index/board_size] += 1
  player_score[board_size + index % board_size] += 1
  if ( index % (board_size + 1) == 0 )
    player_score[board_size * 2] += 1
  end
  if ((index < board_size * board_size - 1) and (index % (board_size - 1) == 0) and (index > 0))
    player_score[board_size * 2 + 1] += 1
  end
  # binding.pry
  
end

def board_full?(b)
  b.select { |k, v| b[k] == ' ' }.empty?
end 

def get_empty_squares(b)
  b.select { |k, v| b[k] == ' ' }.keys
end

def square_not_taken?(b, index)
  get_empty_squares(b).include?(index)
end

def computers_turn(b)
  get_empty_squares(b).sample
end

def winner?(score, board_size)
  score.select { |s| s >= board_size }.size > 0
end

puts "enter size: (3 for 3x3)"
board_size = gets.chomp.to_i

board = init_board(board_size)
player_score = init_scores(board_size)
computer_score = init_scores(board_size)

puts "Ready Player 1..."
sleep 1

until board_full?(board)
  draw_board(board)
  puts "enter square index (1 - #{ board_size**2 }):  q to quit"
  players_pick = gets.chomp
  if ( /[1-9]/.match(players_pick) && square_not_taken?(board, players_pick.to_i))
    board[players_pick.to_i] = 'X'
    update_score(player_score, (players_pick.to_i - 1), board_size) 
    
    if (winner?(player_score, board_size))
      draw_board(board)
      puts "Player 1 Wins!"
      break
    end

    computers_pick = computers_turn(board)
    board[computers_pick.to_i] = 'O'
    update_score(computer_score, (computers_pick.to_i - 1), board_size) 

    if winner?(computer_score, board_size)
      draw_board(board)
      puts "Computer Wins!"
      break
    end

    # binding.pry
  elsif players_pick == 'q'
    break
  end
  # binding.pry
end 
