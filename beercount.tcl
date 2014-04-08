# Beer Counter
#
# Eggdrop script to count consumed beer and shows stats
#
# Triggers:
#   *tsst*, *tsih*, *kork*, *glug*
#
# Author: Timo Sandberg <warren@iki.fi>
# 
# Version 0.0.1


# variables
set statfile "beerstats.txt"
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
bind pub - !savetest beercounter:save
bind pub - !reset beercounter:reset

#procedures
proc beercounter:counter {nick uhost hand chan rest} {
	global cheers users

	if {![info exists users($nick)]} {
		set users($nick) 1
	} else {
		set users($nick) [expr $users($nick) + 1]
	}
	puthelp "PRIVMSG $chan :[lindex $cheers [rand [llength $cheers]]] ($users($nick))"
}

proc beercounter:stats {nick uhost hand chan rest} {
	global users

	set x [list]
	foreach {k v} [array get users] {
	    lappend x [list $k $v]
	}
	set result [lsort -integer -index 1 $x]

	puthelp "PRIVMSG $chan :TOP 10: $result"
}

proc beercounter:load {} {
	global statfile
}

proc beercounter:save {nick uhost hand chan rest} {
	global statfile users

	set fd [open $statfile "w"]

	foreach key [array names users] {
		puts $fd "$key;$users($key)"
	}
	close $fd
}

proc beercounter:reset {nick uhost hand chan rest} {
	global users
	array unset users 
}

puts "Beer Counter"
