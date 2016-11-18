: delay_1ms
d# 4167 begin d# 1 - dup d# 0 = until
;

: delay_ms
d# 0 do delay_1ms loop
;

variable data

: main 

d# 48 data c!

begin

d# 1 led !
[char] H emit-uart
data c@
dup emit-uart
d# 1 + data c!

data c@ d# 58 =
if
d# 48 data c!
then

d# 100 delay_ms
d# 0 led !
d# 200 delay_ms

again

;
