: delay_1ms
d# 4167 begin d# 1 - dup d# 0 = until
;

: delay_ms
d# 0 do delay_1ms loop
;

: main
begin
d# 1 com_start !
h# 41 com_datos !
d# 1 com_comando !
again
;