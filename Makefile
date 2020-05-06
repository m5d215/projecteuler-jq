%: src/%.jq
	@cd src && jq -ncrf $(shell basename $<)
