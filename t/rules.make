.PRECIOUS: %.v

VP3 := ../../blib/script/vp3
VP3_DEPS := ../../pm_to_blib

%.v: %.vp $(VP3) $(VP3_DEPS)
	$(if $(VP3_SHOULD_FAIL),! ,)perl -Mblib $(VP3) $(VP3_OPTS) $(VP3_OPTS.$*) -o $@ $< >$*.out 2>$*.err
	@cat $*.err

VP3_DIFF_OUTPUT ?= 1

ifdef VP3_DIFF_OUTPUT
_DIFF_OUTPUT = @if [ -f gold/$*.v ]; then echo diff gold/$*.v $*.v; diff gold/$*.v $*.v; else echo "gold/$*.v not found"; false; fi
else
_DIFF_OUTPUT =
endif

diff_%.v: %.v
	$(_DIFF_OUTPUT)
	@if [ -f gold/$*.out ]; then echo diff gold/$*.out $*.out; diff gold/$*.out $*.out; else echo "gold/$*.out not found"; false; fi
	@if [ -f gold/$*.err ]; then echo diff gold/$*.err $*.err; diff gold/$*.err $*.err; else echo "gold/$*.err not found"; false; fi

build_%.v: %.v
	iverilog -o /dev/null -y . $< 2>/dev/null

all: $(foreach top, $(TOP), build_$(top)) $(foreach file, $(FILES), diff_$(file))
	@echo All passed

# Only do the automatic rebuild if we're not already running under the perl
# test infrastructure, to avoid weirdness
ifeq ($(HARNESS_ACTIVE),)
$(VP3): module_build
../../pm_to_blib: module_build
.PHONY: module_build
module_build:
	$(MAKE) -C ../..
else
../../pm_to_blib:
	@true
endif
