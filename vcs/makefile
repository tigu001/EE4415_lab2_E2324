make compile:
	vcs -full64 +lint=all -debug_all -timescale=1ns/10ps -l run.log ../src/bf_radix2_noW.v ../src/signed_mult.v ../tb/try_tb.v
plot:
	dve -vpd waveform.vpd &	
clean:
	@echo "Cleaning up files"
	rm -r csrc simv simv.daidir DVEfiles ucli.key waveform.vpd
