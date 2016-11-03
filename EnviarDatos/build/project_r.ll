Revision 3
; Created by bitgen P.20131013 at Wed Nov  2 23:07:15 2016
; Bit lines have the following form:
; <offset> <frame address> <frame offset> <information>
; <information> may be zero or more <kw>=<value> pairs
; Block=<blockname     specifies the block associated with this
;                      memory cell.
;
; Latch=<name>         specifies the latch associated with this memory cell.
;
; Net=<netname>        specifies the user net associated with this
;                      memory cell.
;
; COMPARE=[YES | NO]   specifies whether or not it is appropriate
;                      to compare this bit position between a
;                      "program" and a "readback" bitstream.
;                      If not present the default is NO.
;
; Ram=<ram id>:<bit>   This is used in cases where a CLB function
; Rom=<ram id>:<bit>   generator is used as RAM (or ROM).  <Ram id>
;                      will be either 'F', 'G', or 'M', indicating
;                      that it is part of a single F or G function
;                      generator used as RAM, or as a single RAM
;                      (or ROM) built from both F and G.  <Bit> is
;                      a decimal number.
;
; Info lines have the following form:
; Info <name>=<value>  specifies a bit associated with the LCA
;                      configuration options, and the value of
;                      that bit.  The names of these bits may have
;                      special meaning to software reading the .ll file.
;
Info STARTSEL0=1
Bit   491920 0x0010001c      0 Block=OLOGIC_X11Y1 Type=DRP
Bit   491921 0x0010001c      1 Block=OLOGIC_X11Y1 Type=DRP
Bit   491922 0x0010001c      2 Block=OLOGIC_X11Y1 Type=DRP
Bit   491923 0x0010001c      3 Block=OLOGIC_X11Y1 Type=DRP
Bit   491924 0x0010001c      4 Block=OLOGIC_X11Y1 Type=DRP
Bit   491925 0x0010001c      5 Block=OLOGIC_X11Y1 Type=DRP
Bit   491926 0x0010001c      6 Block=OLOGIC_X11Y1 Type=DRP
Bit   491927 0x0010001c      7 Block=OLOGIC_X11Y1 Type=DRP
Bit   491928 0x0010001c      8 Block=OLOGIC_X11Y1 Type=DRP
Bit   491929 0x0010001c      9 Block=OLOGIC_X11Y1 Type=DRP
Bit   491930 0x0010001c     10 Block=OLOGIC_X11Y1 Type=DRP
Bit   491931 0x0010001c     11 Block=OLOGIC_X11Y1 Type=DRP
Bit   491932 0x0010001c     12 Block=OLOGIC_X11Y1 Type=DRP
Bit   491933 0x0010001c     13 Block=OLOGIC_X11Y1 Type=DRP
Bit   491934 0x0010001c     14 Block=OLOGIC_X11Y1 Type=DRP
Bit   491935 0x0010001c     15 Block=OLOGIC_X11Y1 Type=DRP
Bit   491936 0x0010001c     16 Block=OLOGIC_X11Y1 Type=DRP
Bit   491937 0x0010001c     17 Block=OLOGIC_X11Y1 Type=DRP
Bit   491938 0x0010001c     18 Block=OLOGIC_X11Y1 Type=DRP
Bit   491939 0x0010001c     19 Block=OLOGIC_X11Y1 Type=DRP
Bit   491940 0x0010001c     20 Block=OLOGIC_X11Y1 Type=DRP
Bit   491941 0x0010001c     21 Block=OLOGIC_X11Y1 Type=DRP
Bit   491942 0x0010001c     22 Block=OLOGIC_X11Y1 Type=DRP
Bit   491943 0x0010001c     23 Block=OLOGIC_X11Y1 Type=DRP
Bit   491944 0x0010001c     24 Block=OLOGIC_X11Y1 Type=DRP
Bit   491945 0x0010001c     25 Block=OLOGIC_X11Y1 Type=DRP
Bit   491946 0x0010001c     26 Block=OLOGIC_X11Y1 Type=DRP
Bit   491947 0x0010001c     27 Block=OLOGIC_X11Y1 Type=DRP
Bit   491951 0x0010001c     31 Block=OLOGIC_X11Y1 Type=DRP
Bit   491952 0x0010001c     32 Block=OLOGIC_X11Y1 Type=DRP
Bit   491956 0x0010001c     36 Block=OLOGIC_X11Y1 Type=DRP
Bit   491957 0x0010001c     37 Block=OLOGIC_X11Y1 Type=DRP
Bit   491958 0x0010001c     38 Block=OLOGIC_X11Y1 Type=DRP
Bit   491959 0x0010001c     39 Block=OLOGIC_X11Y1 Type=DRP
Bit   491960 0x0010001c     40 Block=OLOGIC_X11Y1 Type=DRP
Bit   491961 0x0010001c     41 Block=OLOGIC_X11Y1 Type=DRP
Bit   491962 0x0010001c     42 Block=OLOGIC_X11Y1 Type=DRP
Bit   491963 0x0010001c     43 Block=OLOGIC_X11Y1 Type=DRP
Bit   491964 0x0010001c     44 Block=OLOGIC_X11Y1 Type=DRP
Bit   491965 0x0010001c     45 Block=OLOGIC_X11Y1 Type=DRP
Bit   491966 0x0010001c     46 Block=OLOGIC_X11Y1 Type=DRP
Bit   491967 0x0010001c     47 Block=OLOGIC_X11Y1 Type=DRP
Bit   491968 0x0010001c     48 Block=OLOGIC_X11Y1 Type=DRP
Bit   491969 0x0010001c     49 Block=OLOGIC_X11Y1 Type=DRP
Bit   491970 0x0010001c     50 Block=OLOGIC_X11Y1 Type=DRP
Bit   491971 0x0010001c     51 Block=OLOGIC_X11Y1 Type=DRP
Bit   491972 0x0010001c     52 Block=OLOGIC_X11Y1 Type=DRP
Bit   491973 0x0010001c     53 Block=OLOGIC_X11Y1 Type=DRP
Bit   491974 0x0010001c     54 Block=OLOGIC_X11Y1 Type=DRP
Bit   491975 0x0010001c     55 Block=OLOGIC_X11Y1 Type=DRP
Bit   491976 0x0010001c     56 Block=OLOGIC_X11Y1 Type=DRP
Bit   491977 0x0010001c     57 Block=OLOGIC_X11Y1 Type=DRP
Bit   491978 0x0010001c     58 Block=OLOGIC_X11Y1 Type=DRP
Bit   491979 0x0010001c     59 Block=OLOGIC_X11Y1 Type=DRP
Bit   491980 0x0010001c     60 Block=OLOGIC_X11Y1 Type=DRP
Bit   491981 0x0010001c     61 Block=OLOGIC_X11Y1 Type=DRP
Bit   491982 0x0010001c     62 Block=OLOGIC_X11Y1 Type=DRP
Bit   491983 0x0010001c     63 Block=OLOGIC_X11Y1 Type=DRP
