VLOG = ncverilog
WAV = +access+r
Test = Test_Bench.v
Test0 = Test_Bench_0.v
Test1 = Test_Bench_1.v
Test2 = Test_Bench_2.v
CPU = Simple_Single_CPU.v
Mem = Data_Memory.v Reg_File.v Instr_Memory.v
ALU = Adder.v ALU.v ALU_Ctrl.v Decoder.v MUX_2to1.v ProgramCounter.v Shift_Left_Two_32.v Sign_Extend.v
all:
	$(VLOG) $(CPU) $(Mem) $(ALU) $(Test)

t0:
	$(VLOG) $(CPU) $(Mem) $(ALU) $(Test0)

t1:
	$(VLOG) $(CPU) $(Mem) $(ALU) $(Test1)

t2:
	$(VLOG) $(CPU) $(Mem) $(ALU) $(Test2)
