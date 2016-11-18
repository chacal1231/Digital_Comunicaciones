: delay_1ms
d# 4167 begin d# 1 - dup d# 0 = until drop
;

: delay_ms
d# 0 do delay_1ms loop
;

: main
begin
d# 1 led !
d# 250 delay_ms
d# 0 led !
d# 250 delay_ms
again
;