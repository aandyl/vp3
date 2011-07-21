default: all

# What to build

FILES := \
empty.v \
newline.v \
subA.v \
subB.v \
test.v \

# Build options

VP3_OPTS := -y .

# icarus can't parse v2k attributes, and compiling isn't that important for
# these simple tests.
TOP :=

# Build exceptions

# Dependencies

test.v : subA.v subB.v

# Rules

#.PRECIOUS: %.v
#
#VP3 := ../../blib/script/vp3
#VP3_DEPS := ../../pm_to_blib
#
#%.v: %.vp $(VP3) $(VP3_DEPS)
#	perl -Mblib $(VP3) $(VP3_OPTS) $(VP3_OPTS.$*) -o $@ $< >$*.out 2>$*.err
#	@cat $*.err
#
#diff_%.v: %.v
#	@if [ -f gold/$*.v ]; then echo diff gold/$*.v $*.v; diff gold/$*.v $*.v; else echo "gold/$*.v not found"; false; fi
#	@if [ -f gold/$*.out ]; then echo diff gold/$*.out $*.out; diff gold/$*.out $*.out; else echo "gold/$*.out not found"; false; fi
#	@if [ -f gold/$*.err ]; then echo diff gold/$*.err $*.err; diff gold/$*.err $*.err; else echo "gold/$*.err not found"; false; fi
#
#build_%.v: %.v
#	iverilog -o /dev/null -y . $<
#
#all: $(foreach top, $(TOP), build_$(top)) $(foreach file, $(FILES), diff_$(file))
#	@echo All passed
#
#.PHONY: ../../pm_to_blib
#
## Only do the automatic rebuild if we're not already running under the perl
## test infrastructure, to avoid weirdness
#ifeq ($(HARNESS_ACTIVE),)
#../../pm_to_blib:
#	$(MAKE) -C ../..
#else
#../../pm_to_blib:
#	@true
#endif

include ../rules.make
