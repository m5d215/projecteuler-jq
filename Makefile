JQ ?= jq-jit

22: src/22.jq assets/names.txt
	@cd src && $(JQ) -crf $(shell basename $<) -R <../assets/names.txt

42: src/42.jq assets/words.txt
	@cd src && $(JQ) -crf $(shell basename $<) -R <../assets/words.txt

54: src/54.jq assets/poker.txt
	@cd src && $(JQ) -nrRf $(shell basename $<) <../assets/poker.txt

59: src/59.jq assets/cipher.txt
	@cd src && $(JQ) -crf $(shell basename $<) -R <../assets/cipher.txt

67: src/67.jq assets/triangle.txt
	@cd src && $(JQ) -nrRf $(shell basename $<) <../assets/triangle.txt

%: src/%.jq
	@cd src && $(JQ) -ncrf $(shell basename $<)

assets/names.txt:
	@curl 'https://projecteuler.net/project/resources/p022_names.txt' -o assets/names.txt --create-dirs

assets/words.txt:
	@curl 'https://projecteuler.net/project/resources/p042_words.txt' -o assets/words.txt --create-dirs

assets/poker.txt:
	@curl 'https://projecteuler.net/project/resources/p054_poker.txt' -o assets/poker.txt --create-dirs

assets/cipher.txt:
	@curl 'https://projecteuler.net/project/resources/p059_cipher.txt' -o assets/cipher.txt --create-dirs

assets/triangle.txt:
	@curl 'https://projecteuler.net/project/resources/p067_triangle.txt' -o assets/triangle.txt --create-dirs
