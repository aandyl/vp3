.PRECIOUS: %.v %.deps

VP3 := ../../blib/script/vp3
VP3_DEPS := $(VP3) Makefile ../rules.make

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

.PRECIOUS: %.diff
%.diff: %.run_vp3
	$(if $(VP3_SHOULD_FAIL.$*),,$(_DIFF_OUTPUT))
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
	@touch $@

.PRECIOUS: %.build
%.build: %.run_vp3
	iverilog -o /dev/null -y . $*.v 2>/dev/null
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
