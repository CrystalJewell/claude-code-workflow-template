(.[0] // error("credo produced no JSON")) | .issues | group_by(.filename) | .[] | "\(.[0].filename)	\(length)"
