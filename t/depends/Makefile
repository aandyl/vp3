default: all

# Test whether we still output dependencies when we fail at each of the
# following failure points:
#  dep1: error during preprocessing (must report earlier deps)
#  dep2: error during verilog parse (must report preproc deps)
#  dep3: during instance expansion (must report a missing module)

# What to build

FILES := \
dep1.v \
dep2.v \
dep3.v \

# Build options

VP3_OPTS := -y .

VP3_SHOULD_FAIL := 1
VP3_DIFF_OUTPUT :=

# What to compile

TOP :=

# Build exceptions

# Dependencies

# Rules

include ../rules.make
