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
#bind pub - "*tsst*" beercounter:count
#bind pub - "*tsih*" beercounter:count
#bind pub - "*kork*" beercounter:count
#bind pub - "*glug*" beercounter:count

bind pubm - * beercounter:count
bind pub - !beerstats beercounter:stats

# procedures
proc beercounter:count {nick uhost hand chan rest} {
	global cheers users

	set pattern "^\\*(beer|tsih|olut|tsst|kork|sihh|sihahti)\\*$"

	if {[regexp $pattern $rest match]} {

		if {![info exists users($nick)]} {
			set users($nick) 1
		} else {
			set users($nick) [expr $users($nick) + 1]
		}
		puthelp "PRIVMSG $chan :[lindex $cheers [rand [llength $cheers]]] ($users($nick))"

		beercounter:save
	}
}

proc beercounter:stats {nick uhost hand chan rest} {
	global users

	set x [list]
	foreach { k v } [array get users] {
		if {$v > 0} {
		    lappend x [list $k $v]
		}
	}
	set result [lsort -integer -decreasing -index 1 $x]

	set stat_text "Top Drunks: "
	set position 1

	foreach { k } $result {
		append stat_text $position ". " [lindex $k 0] " (" [lindex $k 1] "), "
		set position [expr $position + 1]
	}
	puthelp "PRIVMSG $chan :$stat_text"
}

proc beercounter:load {} {
	global statfile users

	set fd [open $statfile "r"]
		set file_data [read $fd]
    close $fd

	set data [split $file_data "\n"]
	foreach line $data {
		if { [string length $data] > 3 } {
			set temp [split $line ";"]
			set users([lindex $temp 0]) [lindex $temp 1]
		}
	}
}

proc beercounter:save {} {
	global statfile users

	set fd [open $statfile "w"]

	foreach key [array names users] {
		if { [string length $key] > 2 } {
			puts $fd "$key;$users($key)"
		}
	}
	close $fd
}

proc beercounter:reset {} {
	global users
	array unset users
}

puts "Initialising Beer Counter..."
beercounter:load
