
isim condition remove -all
restart

put g '11110000' -radix bin
put r '10101010' -radix bin
put b '11001100' -radix bin
isim force add clk 1 -value 0 -time 10 ns -repeat 20 ns
run 40us
puts joy!
