#include 'protheus.ch'
#include 'topconn.ch'

Static __OXDIALOG

/*/{Protheus.doc} MGFCOM36
//TODO Utilizado no ponto de entrada MT110TEL Inclusão de campo com nome do comprador e substituir campo Codigo Comprador
@author leonardo.kume
@since 28/09/2017
@version 6

@type function
/*/
user function MGFCOM36()

	Local oNewDialog 	:= PARAMIXB[1]
	Local aPosGet    	:= PARAMIXB[2]
	Local nOpcx      	:= PARAMIXB[3]
	Local nReg       	:= PARAMIXB[4]
	Public cCompr		:= PADR(GetAdvFVal("SY1","Y1_NOME",xFilial("SY1")+cCodCompr,1,""),15)
	
	__OXDIALOG := oNewDialog
	
	@ aPosGet[1,1]+27,aPosGet[1,4]+55	MSGET cCompr 	Picture PesqPict("SC1","C1_NOMCOMP")	When .T. of oNewDialog PIXEL
	@ aPosGet[1,1]+27,aPosGet[2,4] MSGET cCodCompr F3 CpoRetF3("C1_CODCOMP") Picture PesqPict("SC1","C1_CODCOMP");
							When VisualSX3("C1_CODCOMP") Valid ExistCpo("SY1",cCodCompr) .And. CheckSX3("C1_CODCOMP",cCodCompr) 	of oNewDialog PIXEL HASBUTTON

return

/*/{Protheus.doc} COM36TRG
//TODO Gatilho para preecher o Nome do comprador
@author leonardo.kume
@since 28/09/2017
@version 6

@type function
/*/
User Function COM36TRG()	

Local nCodCom := ascan(aHeader,{|x| x[2] == "C1_CODCOMP"})
Local nNomCom := ascan(aHeader,{|x| x[2] == "C1_NOMCOMP"})

Local nI	:= 0

cCompr := ALLTRIM(GetAdvFVal("SY1","Y1_NOME",xFilial("SY1")+cCodCompr,1,""))
cCodCompr := cCodCompr
If nCodCom > 0 
	For nI := 1 To Len(aCols)
		aCols[nI][nCodCom] := cCodCompr
		aCols[nI][nNomCom] := cCompr
	Next nI
EndIf

GETDREFRESH()

//__OXDIALOG:Refresh()
//oNewDialog:Refresh()

Return .T.