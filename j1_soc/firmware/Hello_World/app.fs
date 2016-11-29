: delay_1ms
d# 4167 begin d# 1 - dup d# 0 = until
;

: delay_ms
d# 0 do delay_1ms loop
;

: EnviarTemp
d# 1 com_led !
h# 41 com_datos !
d# 0 com_comando !
d# 1 com_start !
d# 0 com_start !
begin com_bussy @ d# 0 = until
d# 0 com_led !
d# 1000 delay_ms !
begin again
;