default: all

# What to build

FILES := \
error1.v \
sub.v \
werror.v \

# Build options

VP3_OPTS := -y .

# these tests don't produce proper output
TOP :=

# Build exceptions

werror.v: VP3_OPTS += -w

sub.v: VP3_SHOULD_FAIL :=

# Dependencies

error1.v: sub.v

VP3_SHOULD_FAIL := 1
VP3_DIFF_OUTPUT :=

include ../rules.make
