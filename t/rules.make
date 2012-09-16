.PRECIOUS: %.v %.deps

VP3 := ../../blib/script/vp3
VP3_DEPS := $(VP3) Makefile ../rules.make

# %.deps is included as a dependency here so that target-specific assignment of
# VP3_SHOULD_FAIL on %.v will apply to %.deps as well.

%.v: %.vp %.deps $(VP3_DEPS)
	$(if $(VP3_SHOULD_FAIL),! ,)perl -Mblib $(VP3) $(VP3_OPTS) $(VP3_OPTS.$*) -o $@ $< >$*.out 2>$*.err
	@cat $*.err

%.deps: %.vp $(VP3_DEPS)
	$(if $(VP3_SHOULD_FAIL),! ,)perl -Mblib $(VP3) --depends $(VP3_OPTS) $(VP3_OPTS.$*) -o $@ $< >$*.deps.out 2>$*.deps.err

VP3_DIFF_OUTPUT ?= 1

ifdef VP3_DIFF_OUTPUT
_DIFF_OUTPUT = @if [ -f gold/$*.v ]; then echo diff gold/$*.v $*.v; diff gold/$*.v $*.v; else echo "gold/$*.v not found"; false; fi
else
_DIFF_OUTPUT =
endif

diff_%.v: %.v %.deps
	$(_DIFF_OUTPUT)
	@if [ -f gold/$*.deps ]; then \
		echo diff gold/$*.deps $*.deps ;\
		diff gold/$*.deps $*.deps ;\
	else \
		echo "gold/$*.deps not found" ;\
		false ;\
	fi
	@if [ -f gold/$*.out ]; then \
		echo diff gold/$*.out $*.out ;\
		diff gold/$*.out $*.out ;\
		echo diff gold/$*.out $*.deps.out ;\
		diff gold/$*.out $*.deps.out ;\
	else \
		echo "gold/$*.out not found" ;\
		false ;\
	fi
	@if [ -f gold/$*.err ]; then \
		echo diff gold/$*.err $*.err ;\
		diff gold/$*.err $*.err ;\
		echo diff gold/$*.err $*.deps.err ;\
		diff gold/$*.err $*.deps.err ;\
	else \
		echo "gold/$*.err not found" ;\
		false ;\
	fi

build_%.v: %.v
	iverilog -o /dev/null -y . $< 2>/dev/null

all: $(foreach top, $(TOP), build_$(top)) $(foreach file, $(FILES), diff_$(file))
	@echo All passed

# This logic, combined with listing module_build in VP3_DEPS, was previously
# used to rebuild vp3 on demand. However, it didn't actually serve to trigger a
# rebuild when the installed vp3 changed.

# Only do the automatic rebuild if we're not already running under the perl
# test infrastructure, to avoid weirdness
#ifeq ($(HARNESS_ACTIVE),)
#$(VP3): module_build
#.PHONY: module_build
#module_build:
#	$(MAKE) -C ../..
#else
#.PHONY: module_build
#module_build:
#	@true
#endif

ifeq ($(HARNESS_ACTIVE),)
$(VP3):
	$(MAKE) -C ../..
endif
