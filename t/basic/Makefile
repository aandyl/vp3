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

test.run_vp3: subA.run_vp3 subB.run_vp3

# Rules

include ../rules.make
