# ================================
# Create Simulator
# ================================
set ns [new Simulator]
# Define different colors
# for data flows (for NAM)
$ns color 1 Blue
$ns color 2 Red
# Trace files
set tracefile [open out.tr w]
$ns trace-all $tracefile
set namfile [open out.nam w]
$ns namtrace-all $namfile
# Finish Procedure
proc finish {} {
global ns tracefile namfile
$ns flush-trace
close $tracefile
close $namfile
exec nam out.nam &
exit 0
}
# ================================
# Create 6 Nodes
# ================================
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

set n4 [$ns node]
set n5 [$ns node]
# ================================
# Define Links (DVR)
# ================================
$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms DropTail
$ns duplex-link $n3 $n4 1Mb 10ms DropTail
$ns duplex-link $n4 $n5 1Mb 10ms DropTail
$ns duplex-link $n0 $n5 1Mb 10ms DropTail
# Set queue size
$ns queue-limit $n0 $n1 50
$ns queue-limit $n1 $n2 50
$ns queue-limit $n2 $n3 50
$ns queue-limit $n3 $n4 50
$ns queue-limit $n4 $n5 50
$ns queue-limit $n0 $n5 50
# ================================
# Enable Distance Vector Routing
# ================================
$ns rtproto DV
# ================================
# UDP + CBR Traffic (n0 → n4)
# ================================
set udp1 [new Agent/UDP]
$ns attach-agent $n0 $udp1
set null1 [new Agent/Null]
$ns attach-agent $n4 $null1
$ns connect $udp1 $null1

set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.005
$cbr1 attach-agent $udp1
# ================================
# Second Flow (n1 → n5)
# ================================
set udp2 [new Agent/UDP]
$ns attach-agent $n1 $udp2
set null2 [new Agent/Null]
$ns attach-agent $n5 $null2
$ns connect $udp2 $null2
set cbr2 [new Application/Traffic/CBR]
$cbr2 set packetSize_ 500
$cbr2 set interval_ 0.005
$cbr2 attach-agent $udp2
# ================================
# Link Failure Simulation
# ================================
$ns rtmodel-at 5.0 down $n2 $n3
$ns rtmodel-at 8.0 up $n2 $n3
# ================================
# Schedule Events
# ================================
$ns at 1.0 "$cbr1 start"
$ns at 2.0 "$cbr2 start"
$ns at 10.0 "$cbr1 stop"
$ns at 10.0 "$cbr2 stop"
$ns at 11.0 "finish"

# ================================
# Run Simulation
# ================================
$ns run