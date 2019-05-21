;Ausgabe über Port 2 (Spalte) und Port 3 (Zeile)
CSEG AT 0H
LJMP Init
ORG 100H

Init:
MOV P2,#0f8h
MOV P3,#0fdh
JMP Start

Start:
MOV R7,#00h
CALL IterZellen
JMP Start

IterZellen:
CALL LebendeNachbarn
INC R7 ; zeilenweiser Zähler
CJNE R7,#040h, IterZellen
ret

WirSindLebendig:
ret

LebendeNachbarn:
MOV a,R7
MOV b,#08h
DIV ab
MOV R6,a ; Ergebnis der Division in R6 (y koord)
MOV R5,b ; Rest der Division in R5 (x koord)
DEC R6
DEC R5
CALL LebtNoch
INC R5
CALL LebtNoch
INC R5
CALL LebtNoch
INC R6
CALL LebtNoch
INC R6
CALL LebtNoch
DEC R5
CALL LebtNoch
DEC R5
CALL LebtNoch
DEC R6
CALL LebtNoch
CALL RegelnBehandeln
ret

RegelnBehandeln:
MOV a,R2
MOV R1,a ; R1 == Anzahl lebender Nachbarn
MOV R2,#00h
INC R5
CALL LebtNoch ; wenn R2 == 1 dann lebt aktuelle Zelle, sonst tot
CJNE R2,#00h, WirSindLebendig
MOV a,R1 ; wenn wir hier ankommen ist die aktuelle Zelle tot
MOV b,#03h
DIV ab
CJNE a,#01h,keine7WiederBeleben ; macht das gleiche wie Abbruch
MOV a,b
CJNE a,#00h,keine7WiederBeleben ; wenn wir hier springen hat die Zelle mehr oder weniger 				als drei lebende Nachbarn
CJNE R6,#00h,keine0Wiederbeleben
CPL P3.0
CJNE R5,#00h,keine0WiederbelebenX
CPL P2.0

keine0Wiederbeleben:
CJNE R6,#01h, keine1Wiederbeleben
CPL P3.1
CJNE R5,#00h,keine0WiederbelebenX
CPL P2.0
keine1Wiederbeleben:
CJNE R6,#02h, keine2Wiederbeleben
CPL P3.2
CJNE R5,#00h,keine0WiederbelebenX
CPL P2.0
keine2Wiederbeleben:
CJNE R6,#03h, keine3Wiederbeleben
CPL P3.3
CJNE R5,#00h,keine0WiederbelebenX
CPL P2.0
keine3Wiederbeleben:
CJNE R6,#04h, keine4Wiederbeleben
CPL P3.4
CJNE R5,#00h,keine0WiederbelebenX
CPL P2.0
keine4Wiederbeleben:
CJNE R6,#05h, keine5Wiederbeleben
CPL P3.5
CJNE R5,#00h,keine0WiederbelebenX
CPL P2.0
keine5Wiederbeleben:
CJNE R6,#06h, keine6Wiederbeleben
CPL P3.6
CJNE R5,#00h,keine0WiederbelebenX
CPL P2.0
keine6Wiederbeleben:
CJNE R6,#02h, keine7Wiederbeleben
CPL P3.7
CJNE R5,#00h,keine0WiederbelebenX
CPL P2.0
keine7Wiederbeleben:
ret

keine0WiederbelebenX:
CJNE R5,#01h,keine1WiederbelebenX
CPL P2.1
ret
keine1WiederbelebenX:
CJNE R5,#02h,keine2WiederbelebenX
CPL P2.2
ret
keine2WiederbelebenX:
CJNE R5,#03h,keine3WiederbelebenX
CPL P2.3
ret
keine3WiederbelebenX:
CJNE R5,#04h,keine4WiederbelebenX
CPL P2.4
ret
keine4WiederbelebenX:
CJNE R5,#05h,keine5WiederbelebenX
CPL P2.5
ret
keine5WiederbelebenX:
CJNE R5,#06h,keine6WiederbelebenX
CPL P2.6
ret
keine6WiederbelebenX:
CJNE R5,#07h,keine7WiederbelebenX
CPL P2.7
ret
keine7WiederbelebenX:
ret

LebtNoch:
MOV a,R6
MOV b,#0ffh ; durch ff teilen weil R6=FF wenn negativ
DIV ab
CJNE a, #00h, Abbruch
MOV a,R5
MOV b,#0ffh ; durch ff teilen weil R5=FF wenn negativ
DIV ab
CJNE a, #00h , Abbruch

CJNE R6,#00h, Keine0
MOV c, P3.0
CPL c
JNC Abbruch
JMP BerechneX

Keine0:
CJNE R6,#01h, Keine1
MOV c, P3.1
CPL c
JNC Abbruch
JMP BerechneX
Keine1:
CJNE R6,#02h, Keine2
MOV c,P3.2
CPL c
JNC Abbruch
JMP BerechneX
Keine2:
CJNE R6,#03h, Keine3
MOV c,P3.3
CPL c
JNC Abbruch
JMP BerechneX
Keine3:
CJNE R6,#04h, Keine4
MOV c,P3.4
CPL c
JNC Abbruch
JMP BerechneX
Keine4:
CJNE R6,#05h, Keine5
MOV c,P3.5
CPL c
JNC Abbruch
JMP BerechneX
Keine5:
CJNE R6,#06h, Keine6
MOV c,P3.6
CPL c
JNC Abbruch
JMP BerechneX
Keine6:
CJNE R6,#07h, Keine7
MOV c,P3.7
CPL c
JNC Abbruch
JMP BerechneX
Keine7:
JMP Abbruch

Abbruch:
ret

BerechneX:
CJNE R5,#00h, Keine0X
MOV c,P2.0
CPL c
JNC Abbruch  
INC R2 ; wenn carry 1, dann Zelle lebend
ret

Keine0X:
CJNE R5,#01h, Keine1X
MOV c,P2.1
CPL c
JNC Abbruch
INC R2
ret
Keine1X:
CJNE R5,#02h, Keine2X
MOV c,P2.2
CPL c
JNC Abbruch
INC R2
ret
Keine2X:
CJNE R5,#03h, Keine3X
MOV c,P2.3
CPL c
JNC Abbruch
INC R2
ret
Keine3X:
CJNE R5,#04h, Keine4X
MOV c,P2.4
CPL c
JNC Abbruch
INC R2
ret
Keine4X:
CJNE R5,#05h, Keine5X
MOV c,P2.5
CPL c
JNC Abbruch
INC R2
ret
Keine5X:
CJNE R5,#06h, Keine6X
MOV c,P2.6
CPL c
JNC Abbruch
INC R2
ret
Keine6X:
CJNE R5,#07h, Keine7X
MOV c,P2.7
CPL c
JNC Abbruch
INC R2
ret
Keine7X:
JMP Abbruch

Vergleich:
CJNE R4,#00h, Abbruch
CJNE R3,#00h, Abbruch
INC R2
ret
