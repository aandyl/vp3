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

basic.v : submod.v

connect.v : submod.v

# Rules

include ../rules.make
