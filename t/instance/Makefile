default: all

# What to build

FILES := \
basic.v \
submod.v \
ranges.v \
connect.v \

# Build options

VP3_OPTS := -y .

TOP := \
basic.v \
ranges.v \
connect.v \

# Build exceptions

# Dependencies

basic.run_vp3 : submod.run_vp3

connect.run_vp3 : submod.run_vp3

# Rules

include ../rules.make
