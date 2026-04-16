# Create simulator
set ns [new Simulator]

# Open trace and NAM files
set tf [open out.tr w]
set nf [open out.nam w]

$ns trace-all $tf
$ns namtrace-all $nf

# Finish procedure
proc finish {} {
    global ns tf nf
    $ns flush-trace
    close $tf
    close $nf
    exec nam out.nam &
    exit 0
}

# Create nodes
set n0 [$ns node]
set n1 [$ns node]

# Create link
$ns duplex-link $n0 $n1 1Mb 10ms DropTail

# UDP agent on n0
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

# CBR traffic
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

# Null agent on n1
set null0 [new Agent/Null]
$ns attach-agent $n1 $null0

# Connect agents
$ns connect $udp0 $null0

# Schedule events
$ns at 0.5 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"
$ns at 5.0 "finish"

# Run simulation
$ns run