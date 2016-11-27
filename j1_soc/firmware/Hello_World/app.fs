: main
begin
h# 40 com_datos !
d# 0 com_comando !
d# 1 com_start !
d# 0 com_start !
begin com_bussy @ d# 0 = until \ Espera a que se desocupe, y ahí si empieza a enviar el nuevo valor
h# 41 com_datos !
d# 0 com_comando !
d# 1 com_start !
d# 0 com_start !
begin com_bussy @ d# 0 = until \ Espera a que se desocupe, y ahí si empieza a enviar el nuevo valor
again
;