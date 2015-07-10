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

PLAYER = 1
DEALER = 2

# DECK = [
#               '2h', '3h', '4h', '5h', '6h', '7h', '8h', '9h', '10h', 'Jh', 'Qh', 'Kh', 'Ah', 
#               '2s', '3s', '4s', '5s', '6s', '7s', '8s', '9s', '10s', 'Js', 'Qs', 'Ks', 'As', 
#               '2c', '3c', '4c', '5c', '6c', '7c', '8c', '9c', '10c', 'Jc', 'Qc', 'Kc', 'Ac', 
#               '2d', '3d', '4d', '5d', '6d', '7d', '8d', '9d', '10d', 'Jd', 'Qd', 'Kd', 'Ad'
#               ]

RANKS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
SUITS = ['h', 's', 'c', 'd']

# DECK = SUITS.product(RANKS)

# DECK = RANKS.map { |rank| rank + SUITS[0]}
DECK = []

# SUITS.each do |suit|
#   RANKS.each do |rank|
#     DECK << rank + suit 
#   end
# end

SUITS.each do |suit|
  DECK << RANKS.map { |rank| rank + suit }
end

DECK.flatten!
# binding.pry

def init_shoe(num_decks = 1)
  shoe = []
  (1..num_decks).each { shoe += DECK }
  shoe.shuffle!
end

def deal_card(shoe)
  shoe.shift
end

def count_value(card)
  if value_and_suit = /([2-6])([hscd])/.match(card)
    card_value = 1
  elsif value_and_suit = /([10JQKA])([hscd])/.match(card)
    card_value = -1
  else
    card_value = 0
  end
  card_value
end

def get_value(card)
  if value_and_suit = /(\d+)([hscd])/.match(card)
    card_value = value_and_suit[0].to_i
  elsif value_and_suit = /([JQK])([hscd])/.match(card)
    card_value = 10
  elsif value_and_suit = /(A)([hscd])/.match(card)
    card_value = 11
  end
  card_value
end

def total_cards(cards)
  hand_total = 0
  num_aces = 0
  cards.each do |card| 
    num_aces += 1 if /(A)([hscd])/.match(card)
    card_value = get_value(card)
    hand_total += card_value
  end

  while hand_total > 21 && num_aces > 0
    hand_total -= 10
    num_aces -= 1
  end 

  hand_total
end

def bust?(hand)
 total_cards(hand) > 21
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

  puts msg
  puts "\n\nenter to continue"
  gets.chomp
end

def print_cards(hand)
  hand.each do |card|
    print card + "  "
  end
  puts
end

def show_hands(player_name, player_hand, dealer_hand, turn = PLAYER)
  system 'clear'

  puts player_name + ": (#{ total_cards(player_hand) })"
  print_cards(player_hand)

  print "\n\n"

  if (turn == DEALER)
    puts "Dealer: (#{ total_cards(dealer_hand) })"
    print_cards(dealer_hand)
  else
    puts "Dealer:"
    print dealer_hand[0]
    puts ", Xx"
  end
end

puts "Welcome to blackjack!  Please enter your name: "
player_name = gets.chomp
player_name = "Player 1" if player_name.size == 0
puts "How many decks?"
num_decks = gets.chomp.to_i
num_decks = 1 if num_decks < 1

shoe = init_shoe(num_decks)
running_count = 0

puts "Ready #{player_name}..."
sleep 1

begin
  player_hand = []
  dealer_hand = []

  if shoe.size < 52 * 0.3
    shoe =  init_shoe(num_decks)
    running_count = 0
    show_help "new deck..."
  end

  2.times do 
    card = deal_card(shoe)
    running_count += count_value(card)
    player_hand << card

    card = deal_card(shoe)
    running_count += count_value(card)
    dealer_hand << card
  end

  # binding.pry

  show_hands(player_name, player_hand, dealer_hand)

  if total_cards(dealer_hand) == 21
    show_hands(player_name, player_hand, dealer_hand, DEALER)
    puts "\nDealer has Blajack!"
  elsif total_cards(player_hand) == 21
    show_hands(player_name, player_hand, dealer_hand, DEALER)
    puts "\n#{player_name} has Blajack!"
  else
    begin
      puts "\n(h)it or (s)tand or help"
      user_choice = gets.chomp.downcase
      if user_choice == 'h'
        card = deal_card(shoe)
        player_hand << card
        running_count += count_value(card)
      end

      show_help ("Count = #{ running_count }")  if user_choice == 'help'
      show_hands(player_name, player_hand, dealer_hand)
      
    end until user_choice == 's' || bust?(player_hand) || total_cards(player_hand) == 21

    until bust?(dealer_hand) || total_cards(dealer_hand) >= 17 do
      card = deal_card(shoe)
      dealer_hand << card
      running_count += count_value(card)
      show_hands(player_name, player_hand, dealer_hand, DEALER)
      sleep 1
    end 

    show_hands(player_name, player_hand, dealer_hand, DEALER)

    if total_cards(player_hand) == total_cards(dealer_hand) && !bust?(player_hand)
      puts "\nits a push"
    elsif bust?(player_hand) || (total_cards(player_hand) < total_cards(dealer_hand) && !bust?(dealer_hand))
      puts "\nHouse wins"
    elsif bust?(dealer_hand) && !bust?(player_hand) || 
            (total_cards(player_hand) > total_cards(dealer_hand) && !bust?(player_hand)) || 
            total_cards(player_hand) == 21
      puts "\n#{player_name} wins"
    end
  end

  puts "whats the count?"
  count_answer = gets.chomp.to_i
  if count_answer == running_count 
    puts "Correct!  The current count is #{ running_count }.  Decks remaining = #{ (shoe.size / 52.0).round(2) }"
  else
    puts "Incorrect.  The current count is #{ running_count }.  Decks remaining = #{ (shoe.size / 52.0).round (2)} "
  end

  puts "play again? y/n"
  play_again = gets.chomp.downcase
end until play_again == 'n'
