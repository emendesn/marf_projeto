#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "VKEY.CH"
#INCLUDE "FONT.CH"


User Function MT110ROT()

If findfunction("U_MGFCOM29")
	AADD(aRotina,{	OemtoAnsi("Descrição do Produto") ,'U_MGFCOM29', 0 ,4 })  
Endif

Return aRotina