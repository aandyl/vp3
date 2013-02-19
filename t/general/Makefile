default: all

# What to build

FILES := \
syntax.v \
syntax_sub.v \
defines.v \
v2kmod.v \
wrongname.v \
search.v \
unparsed.v \
multimod.v \
noports.v \
strengths.v \
v2k_params.v \
v2k_ports.v \
ranges.v \

# Build options

VP3_OPTS := -y .

VP3_OPTS.defines := --vdefine SYNTHESIS=YES --vdefine BUGABOO --vinclude ../include -y .

BUILD_OPTS.defines := -I ../include

TOP := \
syntax.v \
defines.v \
v2kmod.v \
search.v \
multimod.v \
noports.v \
v2k_params.v \
v2k_ports.v \
ranges.v \

# Not included in TOP:
# strengths.v: iverilog doesn't support triregs
# unparsed.v: syntax errors in unparsed sections

# Build exceptions

# Need to specify wrongname.v manually since the module name differs
search.build: search.run_vp3
	iverilog -o /dev/null -y . wrongname.v $< 2>/dev/null
	@touch $@

# Dependencies

syntax.run_vp3 : syntax_sub.run_vp3

search.run_vp3 : wrongname.run_vp3

# Rules

include ../rules.make
