#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"  
#INCLUDE 'TOTVS.CH' 
/*
============================================================================================================================
Programa.:              MGFCOM48 
Autor....:              Antonio Carlos        
Data.....:              16/10/2017                                                                                                            
Descricao / Objetivo:   Implementação do Ponto de Entrada MT120FIM que srá utilizado para salvar Obs no PC
Doc. Origem:            Compras - GAP ID068
Solicitante:            Cliente 
Uso......:              Marfrig
Obs......:              Ponto de Entrada para salvar a xObs no PC.
============================================================================================================================
*/  
User Function MGFCOM48()
   
   Local aArea		:= 	GetArea ()
   
   If isInCallStack("U_TAE02_ALT")
   		Return 
   Endif

   If !IsBlind() .and. Type("_cNumPC") <> "U"
	   SC7->(DBGOTOP())
	   SC7->(DBSETORDER(1))
	   SC7->(DBSEEK(xFilial("SC7")+_cNumPC))
	   While !SC7->( Eof() ) .AND. _cNumPC = SC7->C7_NUM
	      RecLock("SC7", .F.)
	      SC7->C7_ZCODOBS := cXObsAux
	      SC7->(MsUnlock()) 
	      SC7->(DBSKIP())
	   EndDo
   EndIf
   
   RestArea( aArea )
   
Return()