default: all

# What to build

FILES := \
syntax.v \
syntax_sub.v \
defines.v \
v2kmod.v \
wrongname.v \
search.v \
unparsed.v \
multimod.v \
noports.v \
strengths.v \

# Build options

VP3_OPTS := -d SYNTHESIS=YES -d BUGABOO -y .

TOP := \
syntax.v \
defines.v \
v2kmod.v \
search.v \
unparsed.v \
multimod.v \
noports.v \
strengths.v \

# Build exceptions

# Need to specify wrongname.v manually since the module name differs
build_search.v: search.v
	iverilog -o /dev/null -y . wrongname.v $<

# Contains syntax errors in unparsed sections
build_unparsed.v: unparsed.v
	@true

# iverilog doesn't support triregs
build_strengths.v: strengths.v
	@true

# Dependencies

syntax.v : syntax_sub.v

search.v : wrongname.v

# Rules

#.PRECIOUS: %.v
#
#VP3 := ../../blib/script/vp3
#VP3_DEPS := ../../pm_to_blib
#
#%.v: %.vp $(VP3_DEPS)
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
