# debug_logger.gd
extends Node

var DEBUG: bool = true

const COLORS = {
	"info": "white",
	"warn": "yellow",
	"error": "red",
}

func log_message(message: String, level: String = "info"):
	if not DEBUG:
		return

	var stack = get_stack()
	var origin = ""
	if stack.size() > 1:
		var caller = stack[2]
		origin = "%s:%s" % [caller.source.get_file(), caller.line]

	var color: String = COLORS.get(level)
	var level_text: String = "[color=%s][b]%s[/b][/color]" % [color, level.to_upper()]
	var msg_text: String = "%s %s (at %s)" % [level_text, message, origin]

	print_rich(msg_text)

func info(msg): log_message(msg, "info")
func warn(msg): log_message(msg, "warn")
func error(msg): log_message(msg, "error")
