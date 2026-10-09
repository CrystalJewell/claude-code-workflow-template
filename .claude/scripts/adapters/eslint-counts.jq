(.[0] // error("eslint produced no JSON")) | .[] | select((.messages | length) > 0) | "\(.filePath | ltrimstr($root))	\(.messages | length)"
