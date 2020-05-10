22: src/22.jq assets/names.txt
	@cd src && jq -crf $(shell basename $<) -R <../assets/names.txt

%: src/%.jq
	@cd src && jq -ncrf $(shell basename $<)

assets/names.txt:
	@curl 'http://odz.sakura.ne.jp/projecteuler/index.php?plugin=attach&refer=Problem%2022&openfile=names.txt' -o assets/names.txt --create-dirs
