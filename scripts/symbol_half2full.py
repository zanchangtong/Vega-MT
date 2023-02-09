import string
import argparse
import re

def is_punct(char):
    if char in string.punctuation:
        return True
    return False

def symbol_half2full(input_path):
    num=0 
    with open(input_path, 'r', encoding='utf-8') as raw:
        for sent in raw:
            old_str=re.sub(' ', '', sent.strip())
            char_post=[]
            for (i, char) in enumerate(old_str):
                if is_punct(char):
                    try:
                        if str.isdigit(old_str[i-1]) or str.isdigit(old_str[i+1]):
                            char_post.append(char)
                        else:
                            char_post.append(chr(ord(char)+0xfee0))
                    except:
                        char_post.append(chr(ord(char)+0xfee0))
                else:
                    char_post.append(char)
            post_str=''.join(char_post)
            # print(">> vegaMT translation output:")
            print(post_str)



if __name__=='__main__':
    parser = argparse.ArgumentParser(description='open file and do some actions')
    parser.add_argument('--input',  type=str, help='raw file path')
    args = parser.parse_args()

    symbol_half2full(args.input)
