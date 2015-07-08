# blackjack.rb
require 'pry'

# 1.  create deck(s)
# 2.  shuffle decks
# 3.  deal player, then dealer, then player, then dealer
# 4.  show 1 dealer card (first?)
# 5.  total and check blackjack
# 6.  ask hit stay until stay or 21 or bust
# 7.  when stay, dealer hits until >= 17 or bust
# 8.  check winner
$count = 0

PLAYER = 1
DEALER = 2

DECK = [
              '2h', '3h', '4h', '5h', '6h', '7h', '8h', '9h', '10h', 'Jh', 'Qh', 'Kh', 'Ah', 
              '2s', '3s', '4s', '5s', '6s', '7s', '8s', '9s', '10s', 'Js', 'Qs', 'Ks', 'As', 
              '2c', '3c', '4c', '5c', '6c', '7c', '8c', '9c', '10c', 'Jc', 'Qc', 'Kc', 'Ac', 
              '2d', '3d', '4d', '5d', '6d', '7d', '8d', '9d', '10d', 'Jd', 'Qd', 'Kd', 'Ad'
            ]

def init_shoe(num_decks = 1)
  shoe = []
  $count = 0
  (1..num_decks).each { shoe += DECK }
  shoe.shuffle!
end

def deal_card(shoe)
  card = shoe.shift
  total_count(card)
  card
end

def total_count(card)
  if value_and_suit = /([2-6])([hscd])/.match(card)
    card_value = +1
  elsif value_and_suit = /([10JQKA])([hscd])/.match(card)
    card_value = -1
  else
    card_value = 0
  end

  # binding.pry

  $count += card_value
end

def total_cards(cards)
  hand_total = 0
  cards.each do |card| 
    if value_and_suit = /(\d+)([hscd])/.match(card)
      card_value = value_and_suit[0].to_i
      # binding.pry
    elsif value_and_suit = /([JQK])([hscd])/.match(card)
      card_value = 10
    elsif value_and_suit = /(A)([hscd])/.match(card)
      card_value = 11
    end

    hand_total += card_value

  end
  hand_total
end

def no_aces?(hand)
  hand.select { |v| /A/.match(v) }.empty?
end

def aces?(hand)
  hand.select { |v| /A/.match(v) }.size
end

def reduce_aces(hand)
  hand.each do |card| 
    card.gsub!(/A/, "1")
    # binding.pry
    break if total_cards(hand) <= 21
  end 
end

def bust?(hand)
  temp_hand = Array.new(hand)
  if aces?(temp_hand) > 0 && total_cards(temp_hand)  > 21
    reduce_aces(temp_hand)
  end
  # total_cards(hand) > 21
  total_cards(temp_hand) > 21
end

def show_help (msg)
  puts "Insurance: Insure at +3 or higher."
  puts "16vT: Stand at 0 or higher, hit otherwise."
  puts "15vT: Stand at +4 or higher, hit otherwise."
  puts "TTv5: Split at +5 or higher, stand otherwise."
  puts "TTv6: Split at +4 or higher, stand otherwise."
  puts "10vT: Double at +4 or higher, hit otherwise."
  puts "12v3: Stand at +2 or higher, hit otherwise."
  puts "12v2: Stand at +3 or higher, hit otherwise."
  puts "11vA: Double at +1 or higher, hit otherwise."
  puts "9v2: Double at +1 or higher, hit otherwise."
  puts "10vA: Double at +4 or higher, hit otherwise."
  puts "9v7: Double at +3 or higher, hit otherwise."
  puts "16v9: Stand at +5 or higher, hit otherwise."
  puts "13v2: Stand at -1 or higher, hit otherwise."
  puts "12v4: Stand at 0 or higher, hit otherwise."
  puts "12v5: Stand at -2 or higher, hit otherwise."
  puts "12v6: Stand at -1 or higher, hit otherwise."
  puts "13v3: Stand at -2 or higher, hit otherwise.\n\n"

  puts "2-6 = +1"
  puts "T-A = -1"

  puts "#{msg}"
  puts "enter to continue"
  gets.chomp
end

def show_hands(player_name, player_hand, dealer_hand, turn = PLAYER)
  system 'clear'

  puts "#{player_name}: #{player_hand.inspect}"
  # puts "no aces" if aces?(player_hand) == 0
  if (turn == DEALER)
    puts "Dealer: #{dealer_hand.inspect}, #{total_cards(dealer_hand)}"
  else
    puts "Dealer: #{dealer_hand[0]}, Xx"
  end
  # puts "no aces" if aces?(dealer_hand) == 0
  
end

puts "Welcome to blackjack!  Please enter your name: "
player_name = gets.chomp
player_name = "Player 1" if player_name.size == 0
puts "How many decks?"
num_decks = gets.chomp.to_i

shoe = init_shoe(num_decks)
show_help "new deck..."

puts "Ready #{player_name}..."
sleep 1

begin
  player_hand = []
  dealer_hand = []

  # binding.pry
  if shoe.size < 52 * 0.3
    shoe =  init_shoe(num_decks)
    show_help "new deck..."
  end
  #deal_cards
  (1..2).each do 
    player_hand << deal_card(shoe)
    dealer_hand << deal_card(shoe)
  end

  # binding.pry
  
  #  change this to just check for aces
  bust?(player_hand)
  bust?(dealer_hand)
  show_hands(player_name, player_hand, dealer_hand)

  # binding.pry

  if total_cards(dealer_hand) == 21
    show_hands(player_name, player_hand, dealer_hand, DEALER)
    puts "Dealer has Blajack!"
    # binding.pry
  elsif total_cards(player_hand) == 21
    show_hands(player_name, player_hand, dealer_hand, DEALER)
    puts "#{player_name} has Blajack!"
  else
    begin
      puts "\n(h)it or (s)tand or help"
      user_choice = gets.chomp.downcase
      player_hand << deal_card(shoe) if user_choice == 'h'
      show_help 'Count = #{$count}'  if user_choice == 'help'
      break if bust?(player_hand) || total_cards(player_hand) == 21
      show_hands(player_name, player_hand, dealer_hand)
      
    end until user_choice == 's'

    # binding.pry
    while  !bust?(dealer_hand) && total_cards(dealer_hand) < 17
      # binding.pry
      dealer_hand << deal_card(shoe)
      show_hands(player_name, player_hand, dealer_hand, DEALER)
      sleep 1
    end

    show_hands(player_name, player_hand, dealer_hand, DEALER)

    if total_cards(player_hand) == total_cards(dealer_hand) 
      puts "\nits a push"
    elsif bust?(player_hand) || (total_cards(player_hand) < total_cards(dealer_hand) && !bust?(dealer_hand))
      puts "\nHouse wins"
      # binding.pry
    elsif bust?(dealer_hand) && !bust?(player_hand) || (total_cards(player_hand) > total_cards(dealer_hand) && !bust?(player_hand)) || total_cards(player_hand) == 21
      puts "\n#{player_name} wins"
    end
  end

  # binding.pry
  puts "whats the count?"
  count_answer = gets.chomp.to_i
  if count_answer == $count 
    puts "Correct!  The current count is #{$count}.  Decks remaining = #{shoe.size / 52.0}"
  else
    puts "Incorrect.  The current count is #{$count}.  Decks remaining = #{shoe.size / 52.0}"
  end
  # puts "count = #{$count}"

  puts "play again? y/n"
  play_again = gets.chomp.downcase
end until play_again == 'n'
