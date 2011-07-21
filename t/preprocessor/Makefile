default: all

#VP3 := ../../vp3
#VP3_DEPS := ../../Parser.pm

# What to build

FILES := \
preprocessor.v \

VP3_OPTS := -y .

TOP := \
preprocessor.v \

# Rules

#.PRECIOUS: %.v
#
#default: all
#
#%.v: %.vp $(VP3) $(VP3_DEPS)
#	$(VP3) $(VP3_OPTS) $(VP3_OPTS.$*) -o $@ $< >$*.out 2>$*.err
#
#diff_%.v: %.v gold/%.v gold/%.err gold/%.out
#	diff gold/$*.v $*.v
#	diff gold/$*.out $*.out
#	diff gold/$*.err $*.err
#
#build_%.v: %.v
#	iverilog -o /dev/null -y . $<
#
#all: $(foreach top, $(TOP), build_$(top)) $(foreach file, $(FILES), diff_$(file))
#	@echo All passed

# Build exceptions

# Dependencies

preprocessor.v : common.vh

include ../rules.make
