JQ ?= jq-jit

22: src/22.jq assets/names.txt
	@cd src && $(JQ) -crf $(shell basename $<) -R <../assets/names.txt

%: src/%.jq
	@cd src && $(JQ) -ncrf $(shell basename $<)

assets/names.txt:
	@curl 'https://projecteuler.net/project/resources/p022_names.txt' -o assets/names.txt --create-dirs
