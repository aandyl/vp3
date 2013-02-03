default: all

# Test whether we still output dependencies when we fail at each of the
# following failure points:
#  dep1: error during preprocessing (must report earlier deps)
#  dep2: error during verilog parse (must report preproc deps)
#  dep3: during instance expansion (must report a missing module)

# What to build

FILES := \
dep1.v \
dep1_ep3.v \
dep2.v \
dep3.v \
chameleon.v \
chameleon2.v \
chameleon_mods.v \

# Build options

VP3_OPTS := -y .

VP3_SHOULD_FAIL.dep1 := 1
VP3_SHOULD_FAIL.dep2 := 1
VP3_SHOULD_FAIL.dep3 := 1

VP3_SHOULD_FAIL.dep1_ep3 := 1

VP3_SHOULD_FAIL.chameleon := 1

VP3_OPTS.chameleon2 := -v chameleon_mods.v

dep1_ep3.run_vp3 : VP3_OPTS += -p ep3

# What to compile

TOP :=

# Build exceptions

chameleon2.vp : chameleon.vp
	cp $< $@

dep1_ep3.vp: dep1.vp
	cp $< $@

# Dependencies

chameleon.run_vp3 : chameleon_mods.run_vp3

chameleon2.run_vp3 : chameleon_mods.run_vp3

# Rules

include ../rules.make
