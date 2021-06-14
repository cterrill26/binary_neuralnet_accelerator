create_clock -period 2.000 -name clk -waveform {0.000 1.000} [get_ports -filter { NAME =~  "*clk*" && DIRECTION == "IN" }]
