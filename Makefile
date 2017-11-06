REBAR ?= rebar3

all: compile

compile:
	@$(REBAR) compile

clean:
	@$(REBAR) clean
