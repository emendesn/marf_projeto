#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"  
#INCLUDE 'TOTVS.CH' 
/*
=================================================================================================================================================
Programa.:              MGFCOM44 
Autor....:              Antonio Carlos        
Data.....:              16/10/2017                                                                                                            
Descricao / Objetivo:   Implementação que srá utilizado para verificar se o pedido possui item incluído por Solicitação de Compras
                        não permite incluir novo produto nem linha                       
Doc. Origem:            Compras - GAP ID080
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
================================================================================================================================================
*/ 
User Function MGFCOM44() 
	Local aArea		:= 	GetArea ()
	Local _lAltera	:= .T.
	Local _cNumSC	:= Space(06)
	                                       
	If isInCallStack("U_TAE02_ALT")
   		Return _lAltera
   Endif

	
    _nPosxSC  := ASCAN(aHeader,{|X|Trim(X[2])=="C7_NUMSC"}) 
    _nNumSC   := aCols[n][_nPosxSC] 

    IF INCLUI  .AND.  _nNumSC = Space(06)
       _lAltera	:= .T.
    ELSEIF ALTERA
       SC7->( DBGOTOP() )
       SC7->( DBSETORDER(1) )
       SC7->( DBSEEK(xFilial("SC7") + CA120NUM ))
       While !SC7->( Eof() ) .AND. CA120NUM = SC7->C7_NUM
          IF !EMPTY(SC7->C7_NUMSC)
             _cNumSC := SC7->C7_NUMSC
             EXIT
          ENDIF
    	  SC7->(dbSkip())
       End
       IF _cNumSC <> Space(06)
          _lAltera	:= .F.        
          Aviso( "Pedido de Compras","Pedido com Solicitação de Compras não pode sofrer alteração de código.", {" Ok "})   
       ENDIF
    ENDIF

    RestArea (aArea)
Return(_lAltera)