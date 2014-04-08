# Beer Counter
#
# Counts consumed beer and shows stats
#
# Triggers:
#   *tsst*, *tsih*, *kork*, *glug*
#
# Author: Timo Sandberg <warren@iki.fi>
# 
# Version 002 

# variables
array set users {}

set cheers {
	"Kippis!"
	"Sláinte!"
	"Salud!"
	"Cheers!"
	"Skål!"
	"Cin cin!"
	"Prost!"
}

# bindings
bind pub - "*tsst*" beercounter:counter
bind pub - "*tsih*" beercounter:counter
bind pub - "*kork*" beercounter:counter
bind pub - "*glug*" beercounter:counter
bind pub - !beerstats beercounter:stats

#procedures
proc beercounter:counter {nick uhost hand chan rest} {
	global users cheers

	if {![info exists users($nick)]} {
		set users($nick) 1
	} else {
		set users($nick) [expr $users($nick) + 1]
	}
	puthelp "PRIVMSG $chan :[lindex $cheers [rand [llength $cheers]]] ($users($nick))"
}

proc beercounter:stats {nick uhost hand chan rest} {
	puthelp "PRIVMSG $chan :Coming soon!"
}

puts "Beer Counter"
