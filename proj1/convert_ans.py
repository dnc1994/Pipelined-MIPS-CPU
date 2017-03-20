import os
import sys
import shutil
import fileinput


if __name__ == '__main__':

    for file in sys.argv[1:]:
        shutil.copyfile(file, file+'.bak')
    for line in fileinput.input(inplace=True, backup='.tmp'):
        reg, num = line.strip().split('=')
        num = int(num.strip(), 16)
        if num > 0x80000000:
            num -= 2 * 0x80000000
        print reg + ' = ' + str(num) + '\n',
    print
    for file in sys.argv[1:]:
        os.remove(file+'.tmp')
