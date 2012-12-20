default: all

# What to build

FILES := \
preprocessor.v \
preprocessor_ep3.v \

# Build options

VP3_OPTS := -y .

# What to compile

TOP := \
preprocessor.v \
preprocessor_ep3.v \

# Build exceptions

preprocessor.run_vp3 : VP3_OPTS += --define MACRO2=m2val

preprocessor_ep3.run_vp3 : VP3_OPTS += -p ep3 --define MACRO2=m2val

# Dependencies

preprocessor.v : common.vh

# Rules

include ../rules.make
