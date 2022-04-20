def char_to_int(char):
    return ord(char.lower()) - 97

def chars_to_int(chars):
    char_as_ints = []
    for char in chars:
        char_as_ints.append(char_to_int(char))

    return char_as_ints
