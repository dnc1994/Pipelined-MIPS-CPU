import sys


support_instr = [
    'add',
    'sub',
    'and',
    'or',
    'slt',
    'addi',
    'lw',
    'sw',
    'slti',
    'beq'
]

r_type = {
    'add': 0x20,
    'sub': 0x22,
    'and': 0x24,
    'or': 0x25,
    'slt': 0x2a
}


def to_reg_addr(x):
    x = int(x)
    ret = bin(x)[2:]
    return '0' * (5 - len(ret)) + ret


def to_imm(x):
    x = int(x)
    if x < 0:
        x = x & 0b1111111111111111
    ret = bin(x)[2:]
    return '0' * (16 - len(ret)) + ret


def main():
    # with open(sys.argv[1], 'r') as f:
    with open('asm.txt', 'r') as f:
        lines = f.readlines()

    # Assembly
    outputs = []
    for line in lines:
        tokens = line.strip().split(' ')
        print tokens
        instr = tokens[0]
        assert instr in support_instr
        if instr != 'lw' and instr != 'sw':
            op1, op2, op3 = tokens[1:]
        else:
            op1, op2 = tokens[1:]
        if instr in r_type.keys():
            r3, r1, r2 = map(to_reg_addr, [op1[1:], op2[1:], op3[1:]])
            funct = bin(r_type[instr])[2:]
            asm = '000000{r1}{r2}{r3}00000{funct}'.format(r1=r1, r2=r2, r3=r3, funct=funct)
        elif instr == 'addi':
            r2, r1 = map(to_reg_addr, [op1[1:], op2[1:]])
            imm = to_imm(op3)
            asm = '001000{r1}{r2}{imm}'.format(r1=r1, r2=r2, imm=imm)
        elif instr == 'lw' or instr == 'sw':
            opcode = '100011' if instr == 'lw' else '101011'
            imm, op2 = op2.split('(')
            imm = to_imm(imm)
            op2 = op2[:-1]
            r2, r1 = map(to_reg_addr, [op1[1:], op2[1:]])
            asm = '{opcode}{r1}{r2}{imm}'.format(opcode=opcode, r1=r1, r2=r2, imm=imm)
        elif instr == 'slti':
            r2, r1 = map(to_reg_addr, [op1[1:], op2[1:]])
            imm = to_imm(op3)
            asm = '001010{r1}{r2}{imm}'.format(r1=r1, r2=r2, imm=imm)
        elif instr == 'beq':
            r2, r1 = map(to_reg_addr, [op1[1:], op2[1:]])
            imm = to_imm(op3)
            asm = '000100{r1}{r2}{imm}'.format(r1=r1, r2=r2, imm=imm)

        outputs.append(asm)

    with open('testcase_f.txt', 'w') as f:
        f.writelines([line+'\n' for line in outputs])

    # Simulation
    # pc = 0
    # while True:
    #     line = lines[pc / 4]

if __name__ == '__main__':
    main()
 