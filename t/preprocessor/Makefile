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

preprocessor_ep3.vp : VP3_OPTS += -p ep3

preprocessor_ep3.vp : preprocessor.vp
	@cp $< $@

# Dependencies

preprocessor.v : common.vh

preprocessor_ep3.v : common.vh

# Rules

include ../rules.make
