* Legacy Flipent Program for IBM 1410

* Define constants
MCO63B DC 6,3
MCO75B DC 8,4
MCO182B DC 12,6

* Define storage
GRID DS 72C
PATTERN DS 72C

* Main program
START  BEGIN
       LDX 1,0
       LDX 2,0
       LDX 3,0
       LDX 4,0
       LDX 5,0
       LDX 6,0
       LDX 7,0
       LDX 8,0

* Initialize grid
       LA 1,GRID
       LA 2,72
INIT   STC ' ',0(1)
       A 1,1
       BCT 2,INIT

* Read pattern
       LA 1,PATTERN
       LA 2,72
READ   STC ' ',0(1)
       A 1,1
       BCT 2,READ

* Parse pattern
       LA 1,PATTERN
       LA 2,GRID
PARSE  CLI 0(1),'@'
       BE SETBIT
       CLI 0(1),'#'
       BE HALFBIT
       A 1,1
       B PARSE

* Set full-bit flip
SETBIT CLI 1(1),','
       BE NEXT
       CLI 1(1),' '
       BE NEXT
       STC 'X',0(2)
       A 1,1
       A 2,1
       B SETBIT

* Set half-bit flip
HALFBIT CLI 1(1),','
       BE NEXT
       CLI 1(1),' '
       BE NEXT
       STC '/',0(2)
       A 1,1
       A 2,1
       B HALFBIT

* Move to next entry
NEXT   A 1,1
       B PARSE

* Display grid
       LA 1,GRID
       LA 2,72
DISPLAY STC 0(1),0
       A 1,1
       BCT 2,DISPLAY

* End program
       END
