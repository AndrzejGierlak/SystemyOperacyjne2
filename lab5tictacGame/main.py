# pylint: disable=missing-module-docstring
# pylint: disable=missing-class-docstring
# pylint: disable=missing-function-docstring
BOT = 'O'
HUMAN = 'X'
BLANK = ' '


def d2_to_number(num_a, num_b):
    result = 999
    if num_a == 0 and num_b == 0:
        result = 1
    elif num_a == 0 and num_b == 1:
        result = 2
    elif num_a == 0 and num_b == 2:
        result = 3
    elif num_a == 1 and num_b == 0:
        result = 4
    elif num_a == 1 and num_b == 1:
        result = 5
    elif num_a == 1 and num_b == 2:
        result = 6
    elif num_a == 2 and num_b == 0:
        result = 7
    elif num_a == 2 and num_b == 1:
        result = 8
    elif num_a == 2 and num_b == 2:
        result = 9

    return result


def display_board(d2_board):
    blank_board = """
___________________
|  1  |  2  |  3  |
|-----------------|
|  4  |  5  |  6  |
|-----------------|
|  7  |  8  |  9  |
|-----------------|
"""
    for pos_x in range(0, 3):
        for pos_y in range(0, 3):
            pos_number = d2_to_number(pos_x, pos_y)
            if d2_board[pos_x][pos_y] == 'O' or d2_board[pos_x][pos_y] == 'X':
                blank_board = blank_board.replace(str(pos_number), d2_board[pos_x][pos_y])
            else:
                blank_board = blank_board.replace(str(pos_number), ' ')
    print(blank_board)


def number_y(num_c):
    result = 99
    if num_c % 3 == 1:
        result = 0
    if num_c % 3 == 2:
        result = 1
    if num_c % 3 == 0:
        result = 2
    return result


def number_x(num_c):
    if num_c <= 3:
        return 0
    if num_c >= 7:
        return 2
    return 1


def player_input(correct_fields):
    while True:
        print("dostepne pola: ")
        print(correct_fields)
        try:
            console_input = input("Wprowadź numer pola: ")
            console_input = int(console_input)
            if console_input not in correct_fields:
                print(correct_fields)
                print("Błędny numer pola, ponów próbę")
            else:
                break
        except ValueError:
            print(correct_fields)
            print("Podaj pole jako numer pola, ponów próbę")
    return console_input


def computer_turn():
    best_score = -1000
    for pos_x in range(0, 3):
        for pos_y in range(0, 3):
            if d2Board[pos_x][pos_y] == BLANK:
                # u can move here
                d2Board[pos_x][pos_y] = BOT
                score = min_max_algorithm(d2Board, False)
                d2Board[pos_x][pos_y] = BLANK
                if score > best_score:
                    best_score = score
                    best_move_x = pos_x
                    best_move_y = pos_y
    d2Board[best_move_x][best_move_y] = BOT


def trying_max():
    best_score = -1000
    for pos_x in range(0, 3):
        for pos_y in range(0, 3):
            if d2Board[pos_x][pos_y] == BLANK:
                d2Board[pos_x][pos_y] = BOT
                score = min_max_algorithm(d2Board, False)
                d2Board[pos_x][pos_y] = BLANK
                if score > best_score:
                    best_score = score
    return best_score


def trying_min():
    best_score = 1000
    for pos_x in range(0, 3):
        for pos_y in range(0, 3):
            if d2Board[pos_x][pos_y] == BLANK:
                d2Board[pos_x][pos_y] = HUMAN
                score = min_max_algorithm(d2Board, True)
                d2Board[pos_x][pos_y] = BLANK
                if score < best_score:
                    best_score = score
    return best_score


def min_max_algorithm(board, is_maximazing):
    result = 999
    if if_mark_won(BOT):
        result = 100
    elif if_mark_won(HUMAN):
        result = -100
    elif check_draw(board):
        result = 0
    elif is_maximazing:
        result = trying_max()
        # best_score = -1000
        # for pos_x in range(0, 3):
        #     for pos_y in range(0, 3):
        #         if d2Board[pos_x][pos_y] == BLANK:
        #             d2Board[pos_x][pos_y] = BOT
        #             score = min_max_algorithm(board, False)
        #             d2Board[pos_x][pos_y] = BLANK
        #             if score > best_score:
        #                 best_score = score
        # result = best_score
    # minimizing
    elif not is_maximazing:
        result = trying_min()
        # best_score = 1000
        # for pos_x in range(0, 3):
        #     for pos_y in range(0, 3):
        #         if d2Board[pos_x][pos_y] == BLANK:
        #             d2Board[pos_x][pos_y] = HUMAN
        #             score = min_max_algorithm(board, True)
        #             d2Board[pos_x][pos_y] = BLANK
        #             if score < best_score:
        #                 best_score = score
        #result = best_score
    return result


def check_draw(d2_board):
    for pos_x in range(0, 3):
        for pos_y in range(0, 3):
            if d2_board[pos_x][pos_y] == BLANK:
                return False
    return True


def if_mark_won(mark):
    symbol = 'X'
    for pos_x in range(0, 3):
        # sprwadz piony
        if d2Board[pos_x][0] == d2Board[pos_x][1] and d2Board[pos_x][1] == d2Board[pos_x][2]:
            symbol = d2Board[pos_x][0]
            if symbol == mark:
                return True
        # sprawdz poziomy
        if d2Board[0][pos_x] == d2Board[1][pos_x] and d2Board[1][pos_x] == d2Board[2][pos_x]:
            symbol = d2Board[0][pos_x]
            if symbol == mark:
                return True
    # sprawdz skosy
    if d2Board[0][0] == d2Board[1][1] and d2Board[1][1] == d2Board[2][2]:
        symbol = d2Board[0][0]
        if symbol == mark:
            return True
    if d2Board[2][0] == d2Board[1][1] and d2Board[1][1] == d2Board[0][2]:
        symbol = d2Board[2][0]
        if symbol == mark:
            return True
    return False


def check_end(d2_board):
    # sprwadz
    symbol = 'X'
    for pos_x in range(0, 3):
        # sprwadz piony
        if d2_board[pos_x][0] == d2_board[pos_x][1] and d2_board[pos_x][1] == d2_board[pos_x][2]:
            symbol = d2_board[pos_x][0]
            if symbol in ('O', 'X'):
                print('Wygrał1 ' + str(symbol))
                return True
        # sprawdz poziomy
        if d2_board[0][pos_x] == d2_board[1][pos_x] and d2_board[1][pos_x] == d2_board[2][pos_x]:
            symbol = d2_board[0][pos_x]
            if symbol in ('O', 'X'):
                print('Wygrał2 ' + str(symbol))
                return True
    # sprawdz skosy
    if d2_board[0][0] == d2_board[1][1] and d2_board[1][1] == d2_board[2][2]:
        symbol = d2_board[0][0]
        if symbol in ('O', 'X'):
            print('Wygrał3 ' + str(symbol))
            return True
    if d2_board[2][0] == d2_board[1][1] and d2_board[1][1] == d2_board[0][2]:
        symbol = d2_board[2][0]
        if symbol in ('O', 'X'):
            print('Wygrał4 ' + str(symbol))
            return True
    return False


def basic_game_turn(player_turn, d2_board):
    if player_turn:
        print('Gracz X')
        choice = player_input(able_fields)
        d2_board[number_x(choice)][number_y(choice)] = 'X'
    else:
        print('Komputer O')
        # odkomentuj ponizsze dla 2ch graczy
        # choice = playerInput(avaibleFields)
        # d2Board[numberX(choice)][numberY(choice)] = 'O'
        computer_turn()

    list_of_globals = globals()
    list_of_globals['PLAYER_TURN'] = not list_of_globals['PLAYER_TURN']


if __name__ == '__main__':
    w, h = 3, 3
    d2Board = [[7 for x in range(w)] for y in range(h)]
    for i in range(0, 3):
        for j in range(0, 3):
            d2Board[i][j] = BLANK

    display_board(d2Board)
    PLAYER_TURN = True
    while True:
        able_fields = []
        for i in range(0, 3):
            for j in range(0, 3):
                POS_NUMBER = d2_to_number(i, j)
                if not (d2Board[i][j] == 'O' or d2Board[i][j] == 'X'):
                    # jeśli nie ma zajętego pola, możesz je zająć
                    able_fields.append(POS_NUMBER)
        if if_mark_won(HUMAN):
            print("Wygrał gracz, X")
            break
        if if_mark_won(BOT):
            print("Wygrał komputer, X")
            break
        if len(able_fields) <= 0:
            print("End of the game")
            if if_mark_won(HUMAN):
                print("Wygrał gracz, X")
                break
            if if_mark_won(BOT):
                print("Wygrał komputer, X")
                break
            print("Remis")
            break
        basic_game_turn(PLAYER_TURN, d2Board)
        display_board(d2Board)
        # print(d2Board)
