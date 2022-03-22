# print "\033[43;37m #{a} \033[0m"    # ORANGE
# print "\033[46;37m #{a} \033[0m"    # BLUE

# ==================================================
require "pry-byebug"

class King
    attr_reader :color
    attr_accessor :symbol

    def initialize(color)        
        @color = color
        if(@color == "black")
            @symbol = "30m #{9818.chr(Encoding::UTF_8)} "
        elsif(@color == "white")
            @symbol = "37m #{9818.chr(Encoding::UTF_8)} "
        end
    end    

    def avl_moves(board, piece_coord)
        
        moves_dirs = [  [-1,0],
                        [1,0],
                        [0,-1],
                        [0,1],
                        [-1,-1],
                        [-1,1],
                        [1,-1],
                        [1,1]
                     ]
        avl_moves_dirs = []
        moves_dirs.each do |x|
            new_move = [x[0] + piece_coord[0],x[1] + piece_coord[1]]
                
            if (new_move[0].between?(0,7) && new_move[1].between?(0,7) && (board[new_move[0]][new_move[1]] == nil || board[new_move[0]][new_move[1]].color == "black"))
                avl_moves_dirs.push(new_move)              
            end                       
        end    
        avl_moves_dirs    
    end


end

class Chess    
    attr_accessor :board
    def initialize
        @white_play = true
        @game_end = false
        @board = [  [nil,nil,nil,nil,nil,nil,nil,nil],
                    [nil,nil,nil,nil,nil,nil,nil,nil],
                    [nil,nil,nil,nil,nil,nil,nil,nil],
                    [nil,nil,nil,King.new("black"),nil,nil,nil,nil],
                    [nil,nil,nil,nil,nil,nil,nil,nil],
                    [nil,nil,nil,nil,nil,nil,nil,nil],
                    [nil,nil,nil,nil,nil,nil,nil,nil],
                    [King.new("white"),nil,nil,nil,nil,nil,nil,nil]
                ]
    end
    

    def render
        num = 8
        print " a  b  c  d  e  f  g  h "
        for i in (0...8) do
            puts
            
            for j in (0...8) do
                if(i.even? && j.even?)
                    # print orange field
                    if(@board[i][j] == nil) 
                        print "\033[43;30m   \033[0m"
                    else
                        print "\033[43;#{@board[i][j].symbol}\033[0m"
                    end                    
                elsif(i.even? && j.odd?)
                    # print blue field
                    if(@board[i][j] == nil) 
                        print "\033[46;30m   \033[0m"
                    else
                        print "\033[46;#{@board[i][j].symbol}\033[0m"
                    end
                elsif(i.odd? && j.even?)
                    # print blue field
                    if(@board[i][j] == nil) 
                        print "\033[46;30m   \033[0m"
                    else
                        print "\033[46;#{@board[i][j].symbol}\033[0m"
                    end
                else
                    # print orange field
                    if(@board[i][j] == nil) 
                        print "\033[43;30m   \033[0m"
                    else
                        print "\033[43;#{@board[i][j].symbol}\033[0m"
                    end  
                end
            end
            print " #{num}"
            num -= 1
        end
        puts "\n\n"
    end


    def move(piece_coord, select_field)
        @board[select_field[0]][select_field[1]] = @board[piece_coord[0]][piece_coord[1]]
        @board[piece_coord[0]][piece_coord[1]] = nil
    end

    # transforming input from string to coordinates (e.g. "b3" --> [5,1])
    def transform_input(input)
        arr = [[],[],[],[],[],[],[],[]]
        x = 0
        for i in (8..1).step(-1)       
            for j in ("a".."h")
                arr[x].push("#{j}#{i}")
            end
            x += 1
        end
    
        arr.each_with_index do |x,y| 
            x.each_with_index do |value,index|
                if(value == input)                
                    return [y, index]
                end
            end
        end
        
    end

    def is_valid_move?(input)
        if(@board[input[0]][input[1]] != nil && @white_play == true && @board[input[0]][input[1]].color == "white")
            return true
        elsif(@board[input[0]][input[1]] != nil && @white_play == false && @board[input[0]][input[1]].color == "black")
            return true
        else
            return false
        end
    end

    def select_field
        puts "Choose your field: "
        field = gets.chomp
        valid_field(field)
    end

    # checking for existing field on chess board
    def valid_field(input)        
        until(input.size == 2 && input[0].between?("a","h") && input[1].between?("1","8"))             
            puts "Wrong input! Try again..."
            input = gets.chomp  
        end
        input
        transform_input(input)
    end

    def round
        loop do 
            if(@white_play == true)
                puts "Select white piece: "
            else
                puts "Select black piece: "
            end  

            input = gets.chomp
            white_piece_coord = valid_field(input)
    
            until(is_valid_move?(white_piece_coord))
                puts "Wrong input! Try again..."
                input = gets.chomp
                white_piece_coord = valid_field(input)            
            end 

            white_piece = @board[white_piece_coord[0]][white_piece_coord[1]]     
            available_moves = white_piece.avl_moves(@board,white_piece_coord)
            selection = select_field
            if(available_moves.include?(selection))
                p "YES!!"  
                move(white_piece_coord,selection) 
                break
            else
                puts "Wrong input!"
            end            
            
        end
        render
        @white_play = !@white_play
    end

    def play_game        
        until(@game_end)
            round
        end
    end
end

puts "Welcome!\n\n"

new_game = Chess.new
new_game.render
new_game.play_game