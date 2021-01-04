#include "rwmake.ch"
#include "protheus.ch"
#include "totvs.ch"

/*/   {Protheus.doc} MGFFINBI

Descrição : Função para tratar para gerar registro de Movimentação de Reposição de Caixinha, 
            para baixa de títulos, a  partir da baixa de Cnab.
    		Rotinas pertencentes: Cnab , F430bxa.prw
@author Henrique Vidal
@since 05/03/2020
@return Null
/*/

User Function MGFFINBI()
	Local _aArea	:= GetArea()    
	Local _aAreaSE2 := SE2->(GetArea())

	aMvPar := {}

	For nX := 1 To 40
	aAdd( aMvPar, &( "MV_PAR" + StrZero( nX, 2, 0 ) ) )
	Next nX

	If !Empty(cNumTit)
	
	   //Busca por IdCnab (sem filial)
	   SE2->(dbSetOrder(13)) 
	   SE2->(dbgotop())
	   If SE2->(MsSeek(Substr(cNumTit,1,10)))
			
			If AllTrim(SE2->E2_PREFIXO) == "CXA"
	  	  		U_MGFFINB6()
			EndIf
	   
	   Endif
	
	EndIf
			
	RestArea(_aAreaSE2)
	RestArea(_aArea)

	For nX := 1 To Len( aMvPar )
 		&( "MV_PAR" + StrZero( nX, 2, 0 ) ) := aMvPar[ nX ]
	Next nX

Return