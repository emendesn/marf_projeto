#include "rwmake.ch"
#include "protheus.ch"
#include "totvs.ch"

user function MGFFIN90()
	Local _aArea	:= GetArea()    
	Local _aAreaSE2 := SE2->(GetArea())
	Local _nDescon  := 0
	Local _nAcresc  := 0
	
	If !Empty(cNumTit)
	
	   //Busca por IdCnab (sem filial)
	   SE2->(dbSetOrder(13)) // IdCnab
	   SE2->(dbgotop())
	   If SE2->(MsSeek(Substr(cNumTit,1,10)))
	      
	      _nAcresc  := Round(NoRound(xMoeda(SE2->E2_SDACRES,SE2->E2_MOEDA,1,dBaixa,3),3),2)
		  _nDecres  := Round(NoRound(xMoeda(SE2->E2_SDDECRE,SE2->E2_MOEDA,1,dBaixa,3),3),2)
	
	      If (nMulta+nJuros) = 0 .and. _nAcresc > 0
	        
	          //nMulta := _nAcresc
	          nJuros := _nAcresc
	      
	      EndIf
	
	      If (nDescont) = 0 .and. _nDecres > 0
	        
	          nDescont := _nDecres
	      
	      EndIf
	
	   Endif
	
	EndIf
	
	RestArea(_aAreaSE2)
	RestArea(_aArea)
return