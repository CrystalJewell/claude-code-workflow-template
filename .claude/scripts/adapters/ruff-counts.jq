(.[0] // error("ruff produced no JSON")) | group_by(.filename) | .[] | "\(.[0].filename | ltrimstr($root))	\(length)"
