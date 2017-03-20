VLOG = ncverilog
WAV = +access+r
Test = Test_Bench.v
Test0 = Test_Bench_0.v
Test1 = Test_Bench_1.v
Test2 = Test_Bench_2.v
Test3 = Test_Bench_3.v
Test4 = Test_Bench_4.v
Test5 = Test_Bench_5.v
TestF = Test_Bench_f.v
CPU = Pipe_CPU.v
Mem = Data_Memory.v Reg_File.v Instr_Memory.v Pipe_Reg.v
ALU = Adder.v ALU.v ALU_Ctrl.v Decoder.v MUX_2to1.v ProgramCounter.v Shift_Left_Two_32.v Sign_Extend.v MUX_3to1.v ForwardinUnit.v Hazard_Detect.v
all:
	$(VLOG) $(CPU) $(Mem) $(ALU) $(Test)

t0:
	$(VLOG) $(CPU) $(Mem) $(ALU) $(Test0)

t1:
	$(VLOG) $(CPU) $(Mem) $(ALU) $(Test1)

t2:
	$(VLOG) $(CPU) $(Mem) $(ALU) $(Test2)

t3:
	$(VLOG) $(CPU) $(Mem) $(ALU) $(Test3)

t4:
	$(VLOG) $(CPU) $(Mem) $(ALU) $(Test4)

t5:
	$(VLOG) $(CPU) $(Mem) $(ALU) $(Test5)

tf:
	$(VLOG) $(CPU) $(Mem) $(ALU) $(TestF)
