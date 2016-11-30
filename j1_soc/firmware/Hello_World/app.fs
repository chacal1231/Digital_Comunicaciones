: delay_1ms
d# 4167 begin d# 1 - dup d# 0 = until
;

: delay_ms
d# 0 do delay_1ms loop
;

: EnviarTemp
Temp @ com_datos !
d# 0 com_comando !
d# 1 com_start !
d# 0 com_start !
;

: EnviarPeso
Peso @ com_datos !
d# 1 com_comando !
d# 1 com_start !
d# 0 com_start !
;

: EnviarNluz
Nluz @ com_datos !
d# 2 com_comando !
d# 1 com_start !
d# 0 com_start !
;

: EnviarEtapa
EtapaCre @ com_datos !
d# 3 com_comando !
d# 1 com_start !
d# 0 com_start !
;

: EnviarDagua
Dagua @ com_datos !
d# 4 com_comando !
d# 1 com_start !
d# 0 com_start !
;

: EnviarNagua
Nagua @ com_datos !
d# 5 com_comando !
d# 1 com_start !
d# 0 com_start !
;

: EnviarPconsumida
Pconsu @ com_datos !
d# 6 com_comando !
d# 1 com_start !
d# 0 com_start !
;
: EnviarCpotencia
CPoten @ com_datos !
d# 7 com_comando !
d# 1 com_start !
d# 0 com_start !
;

: EnviarTetha
Tetha @ com_datos !
d# 8 com_comando !
d# 1 com_start !
d# 0 com_start !
;

: EnviarFhi
Fhi @ com_datos !
d# 9 com_comando !
d# 1 com_start !
d# 0 com_start !
;

: Delay5Min
d# 300000 delay_ms !
;
: main
begin
EnviarTemp
d# 15000 delay_ms !
EnviarPeso
d# 15000 delay_ms !
EnviarNluz
d# 15000 delay_ms !
EnviarEtapa
d# 15000 delay_ms !
EnviarDagua
d# 15000 delay_ms !
EnviarNagua
d# 15000 delay_ms !
EnviarPconsumida
d# 15000 delay_ms !
EnviarCpotencia
d# 15000 delay_ms !
EnviarTetha
d# 15000 delay_ms !
EnviarFhi
d# 60000 delay_ms !
Delay5Min
again
;