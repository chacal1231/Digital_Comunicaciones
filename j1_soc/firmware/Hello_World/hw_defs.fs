( Hardware port assignments )

h# FF00 constant mult_a  \ no cambiar estos tres
h# FF02 constant mult_b  \ hacen parte de otras
h# FF04 constant mult_p  \ definiciones

\ memory map multiplier:
h# 6700 constant multi_a	
h# 6702 constant multi_b
h# 6704 constant multi_init
h# 6706 constant multi_done
h# 6708 constant multi_pp_high
h# 670A constant multi_pp_low

\ memory map divider:
h# 6800 constant div_a		
h# 6802 constant div_b
h# 6804 constant div_init
h# 6806 constant div_done
h# 6808 constant div_c

\ memory map uart:
h# 6900 constant uart_busy    	\ para lectura de uart (uart_busy)
h# 6902 constant uart_data    	\ escritura de datos que van a la uart
h# 6904 constant led     	\ led-independiente , se lo deja dentro del mapa de memoria de la uart
h# 6906 constant uart_datarcv
h# 6908 constant uart_flagrcv

\ Comunicaciones memory map
h# 9900 constant com_start
h# 9902 constant com_datos
h# 9904 constant com_comando
h# 9906 constant com_led
h# 9908 constant com_bussy

\ memory map gpout
\ h# 6000 constant gp_out0
\ h# 6001 constant gp_out1

\ memory map gpin
\ h# 6100 constant gp_in0
\ h# 6101 constant gp_in1

\ ram
\ h# 7000 constant ram0

\ everloop
h# 7300 constant ever_start
h# 738C constant ever_end

\ uvSensor
h# 7400 constant uv_start
h# 7402 constant uv_ready
h# 7404 constant uv_data