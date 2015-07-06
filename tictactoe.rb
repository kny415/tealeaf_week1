# tictactoe.rb

# init board
# draw board
# player input square index
# comp square index
# check for all squares taken or 3 in a row

require 'pry'

def init_board(size)
  board = {}
  (1..(size*size)).each { |k| board[k] = ' '}
  board
end

def init_scores(size)
  player_score = []
  (0..(size*size-1)).each { |i| player_score[i] = 0 }
  player_score
end

def draw_board(board)
  system 'clear'
  size = Math.sqrt(board.size)
  (1..board.size).each do |count|
    print " " + board[count].to_s
    if (count % size != 0)
      print " |" 
    elsif (count != board.size)
      print "\n"
      size.to_i.times { print "----" } 
      print "\n"
    end
  end
  print "\n\n"
end

def update_score(player_score, index, board_size)
  player_score[index/board_size] += 1
  player_score[board_size + index % board_size] += 1
  if (index % (board_size + 1) == 0)
    player_score[board_size * 2] += 1
  end
  if ((index < board_size * board_size - 1) && (index % (board_size - 1) == 0) && (index > 0))
    player_score[board_size * 2 + 1] += 1
  end
end

def board_full?(board)
  board.select { |k, v| board[k] == ' ' }.empty?
end 

def get_empty_squares(board)
  board.select { |k, v| board[k] == ' ' }.keys
end

def square_not_taken?(board, index)
  get_empty_squares(board).include?(index)
end

def computers_turn(board)
  get_empty_squares(board).sample
end

def winner?(score, board_size)
  score.select { |s| s >= board_size }.size > 0
end

board_size = 0

until board_size >= 3
  puts "enter size: (3 for 3x3, 4 for 4x4, ...)"
  board_size = gets.chomp.to_i
end

board = init_board(board_size)
player_score = init_scores(board_size)
computer_score = init_scores(board_size)

puts "Ready Player 1..."
sleep 1

until board_full?(board)
  draw_board(board)
  puts "enter square index (1 - #{ board_size**2 }):  q to quit"
  players_pick = gets.chomp

  if ( /[1-9]+/.match(players_pick) && square_not_taken?(board, players_pick.to_i))
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

  elsif players_pick == 'q'
    break
  end
end 
