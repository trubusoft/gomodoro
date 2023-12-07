extends Node

func decorate_zero_padding(number: float, n_padding: int = 2) -> String:
	var final_string = str(number)
	if number < 10 * (n_padding - 1):
		var zero_padding: String
		for i in range(n_padding - 1):
			zero_padding = zero_padding + '0'
		final_string = zero_padding + final_string
	return final_string
