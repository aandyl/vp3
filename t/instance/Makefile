default: all

# What to build

FILES := \
basic.v \
submod.v \
ranges.v \

# Build options

VP3_OPTS := -y .

TOP := \
basic.v \
ranges.v \

# Build exceptions

# Dependencies

basic.v : submod.v

ranges.v : submod.v

# Rules

include ../rules.make
