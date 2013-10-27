.PRECIOUS: %.v %.deps

VP3 := ../../blib/script/vp3
VP3_DEPS := $(VP3) Makefile ../rules.make ../../blib/lib/VP3.pm ../../blib/lib/VP3/*.pm ../../blib/lib/VP3/RTLTool/*.pm

.PRECIOUS: %.run_vp3
%.run_vp3: %.vp $(VP3_DEPS)
	$(if $(VP3_SHOULD_FAIL.$*),! ,)perl -Mblib $(VP3) $(VP3_OPTS) $(VP3_OPTS.$*) -o $*.v $< >$*.out 2>$*.err
	$(if $(VP3_SHOULD_FAIL.$*),! ,)perl -Mblib $(VP3) --depends $(VP3_OPTS) $(VP3_OPTS.$*) -o $*.deps $< >$*.deps.out 2>$*.deps.err
	@cat $*.err
	@touch $@

define _DIFF_OUTPUT
@if [ -f gold/$*.v ]; then \
	echo diff gold/$*.v $*.v ;\
	diff gold/$*.v $*.v ;\
else \
	echo "gold/$*.v not found" ;\
	false ;\
fi
endef

# Suppress diffs that look like error messages from EP3 and that contain a line
# number reference, so we're not overly sensitive to changes in EP3.
DIFF_ARGS := -I 'EP3 error: .*line [0-9]\+'

# By default deps.out and deps.err are diff'ed against the same golden output
# as non-depends-mode. However, if a .deps.err file exists in the golden
# directory, that is used instead. Several of the depends-mode tests use this,
# since messages about generation of debug files aren't printed in depends
# mode.

.PRECIOUS: %.diff
%.diff: %.run_vp3
	$(if $(VP3_SHOULD_FAIL.$*),,$(_DIFF_OUTPUT))
	@if [ -f gold/$*.deps ]; then \
		echo diff gold/$*.deps $*.deps ;\
		diff $(DIFF_ARGS) gold/$*.deps $*.deps ;\
	else \
		echo "gold/$*.deps not found" ;\
		false ;\
	fi
	@if [ -f gold/$*.out ]; then \
		echo diff gold/$*.out $*.out ;\
		diff $(DIFF_ARGS) gold/$*.out $*.out ;\
		echo diff gold/$*.out $*.deps.out ;\
		diff $(DIFF_ARGS) gold/$*.out $*.deps.out ;\
	else \
		echo "gold/$*.out not found" ;\
		false ;\
	fi
	@if [ -f gold/$*.err ]; then \
		echo diff gold/$*.err $*.err ;\
		diff $(DIFF_ARGS) gold/$*.err $*.err ;\
		echo diff $(firstword $(wildcard gold/$*.deps.err gold/$*.err)) $*.deps.err ;\
		diff $(DIFF_ARGS) $(firstword $(wildcard gold/$*.deps.err gold/$*.err)) $*.deps.err ;\
	else \
		echo "gold/$*.err not found" ;\
		false ;\
	fi
	@touch $@

.PRECIOUS: %.build
%.build: %.run_vp3
	iverilog -o /dev/null -y . $(BUILD_OPTS.$*) $*.v 2>/dev/null
	@touch $@

all: $(TOP:%.v=%.build) $(FILES:%.v=%.diff)
	@echo All passed

# If we're not running under the perl test infrastructure, automatically
# rebuild vp3 before running tests.

ifeq ($(HARNESS_ACTIVE),)
$(VP3): module_build
	@true

.PHONY: module_build
module_build:
	$(MAKE) -C ../..
endif
