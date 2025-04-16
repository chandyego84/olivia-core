import sys

# Instruction mapping
instruction_map = {
    "GETHIMBACK": "LDUR",
    "STRANGER": "STUR",
    "SOAMERICAN": "ADD",
    "VAMPIRE": "SUB",
    "TEENAGEDREAM": "B",
    "LOGICAL": "CBZ",
    "REDLIGHT": "NOP",
    "B": "B"
}

def encode_instruction(mnemonic, args, label_positions=None, current_line=None):
    # opcodes
    opcode = {
        "LDUR":  "11111000010",
        "STUR":  "11111000000",
        "ADD":   "10001011000",
        "SUB":   "11001011000",
        "B":     "000101",
        "CBZ":   "10110100",
        "NOP":   "00000000000000000000000000000000"
    }

    if mnemonic == "NOP":
        return opcode["NOP"]

    if mnemonic in ["ADD", "SUB"]:
        rd, rn, rm = [int(r[1:]) for r in args]  # remove 'X'
        return f"{opcode[mnemonic]:<11}{rm:05b}{0:06b}{rn:05b}{rd:05b}".ljust(32, '0')

    if mnemonic in ["LDUR", "STUR"]:
        rd = int(args[0][1:])
        rn = int(args[1][1:])
        addr = int(args[2].replace("#", ""))
        return f"{opcode[mnemonic]:<11}{addr:09b}{rn:05b}{rd:05b}".ljust(32, '0')

    if mnemonic == "B":
        # BRANCH - calculate offset
        label = args[0]
        if label in label_positions:
            label_addr = label_positions[label]
            offset = label_addr - current_line  # offset in terms of instructions
            print(f"Branching to label '{label}' at line {label_addr}, offset: {offset}")
            return f"{opcode[mnemonic]:<6}{(offset & 0x3FFFFFF):026b}"
        else:
            raise ValueError(f"Label '{label}' not found during branch resolution.")

    if mnemonic == "CBZ":
        rt = int(args[0][1:])
        imm = int(args[1]) & 0x7FFFF
        return f"{opcode[mnemonic]:<8}{imm:019b}{rt:05b}"

    return "0" * 32

def translate_assembly(input_file, output_file):
    # first pass: gather label positions
    label_positions = {}
    instructions = []
    current_line = 0

    with open(input_file, "r") as infile:
        for line in infile:
            line = line.strip()
            if not line or line.startswith("#"):
                continue

            # Check if the line is a label (labels are just a word followed by ":")
            if line.endswith(":"):
                label = line[:-1]
                label_positions[label] = current_line
                continue

            parts = line.replace(",", "").split()
            olivia_inst = parts[0].upper()  # ensure it's in uppercase
            args = parts[1:]

            if olivia_inst not in instruction_map:
                print(f"Unknown instruction: {olivia_inst}")
                continue

            instructions.append((olivia_inst, args))
            current_line += 1

    # second pass: encode instructions and resolve branches
    with open(output_file, "w") as outfile:
        current_line = 0
        for olivia_inst, args in instructions:
            print(f"Encoding: {olivia_inst} {args}")
            mnemonic = instruction_map[olivia_inst]
            try:
                binary = encode_instruction(mnemonic, args, label_positions, current_line)
                # Convert binary to big-endian bytes and write each byte on a separate line
                hex_str = f"{int(binary, 2):08X}"
                # Split into bytes (big-endian order)
                bytes_list = [hex_str[i:i+2] for i in range(0, len(hex_str), 2)]
                # Write bytes in big-endian order (MSB first)
                for byte in bytes_list:
                    outfile.write(byte + "\n")
            except ValueError as e:
                print(f"Error at line {current_line}: {e}")
            current_line += 1

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python assembler.py <input.asm> <output.mem>")
    else:
        translate_assembly(sys.argv[1], sys.argv[2])