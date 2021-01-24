#include 'Protheus.ch'

User Function FA070POS


Local aArray := {}
Local cOldbc := cBanco
Local cOldag := cAgencia
Local cOldcc := cConta

cBanco := SPACE(3)
cAgencia := SPACE(5)
cConta := SPACE(10)






aadd(aArray,cBanco)
aadd(aArray,cAgencia)
aadd(aArray,cConta)

SA6->( dbSeek(xFilial() + cOldbc + cOldag + cOldcc, .T. ) )



Return (aArray)
