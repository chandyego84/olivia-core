import sys

instruction_map = {
    "GETHIMBACK" : "LDUR", # getting back from memory == GET HIM BACK! 
    "STRANGER" : "STUR", # they both start with 'ST'
    "SOAMERICAN" : "ADD", # 1 + 1 = 2 ;)
    "VAMPIRE" : "SUB", # like sucking blood
    "TEENAGEDREAM" : "B", # branch: many paths when young
    "LOGICAL" : "CBZ", # branch but with extra logic
    "REDLIGHT" : "NOP" # driver's license reference (RED light, STOP sign == NO OP!!!)
}

def translate_assembly(input_file, output_file): 
    with open(input_file, "r") as infile, open(output_file, "w") as outfile:
        pass

if __name__ == '__main__':
    pass