#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#define CRLF chr(13) + chr(10)             
/*
==========================================================================================================
Programa.:              MA330TRB
Autor....:              Marcelo Carneiro         
Data.....:              07/07/2017 
Descricao / Objetivo:   Altera as movimentacoes na rotina do calculo do custo medio                         
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
==========================================================================================================
*/
User Function MA330TRB()
/*
Local aArea     := GetArea()
Local aAreaSd3  := SD3->(GetArea('SD3'))
Local aAreaSc2  := SD3->(GetArea('SC2'))
Local nL        := 0 
    

SC2->(dbSetOrder(1))

TRB->(dbSetOrder(4))
TRB->(dbSeek(xFilial("SD3")+"SD3"))

While !TRB->(EOF()) .And. TRB->TRB_ALIAS == "SD3"
	If !Empty(TRB->TRB_OP) .And. SC2->(DbSeek(TRB->TRB_FILIAL+TRB->TRB_OP)) 
	    IF !Empty(SC2->C2_ZOPTAUR)
			Reclock("TRB",.F.)
			TRB->(dbDelete())
			TRB->(MsUnlock())
			nL++
		EndIF
	EndIF
	TRB->(dbSkip())
End
*/
/*
dbSelectArea('SC2')
SC2->(DbSetOrder(1))

DbSelectArea("TRB")
TRB->(DbGoTop())

While !TRB->( Eof())
	IF Alltrim(TRB->TRB_ALIAS)=="SD3" .And. !Empty(TRB->TRB_COD) .And. !Empty(TRB->TRB_OP) 
		IF SC2->(DbSeek(TRB->TRB_FILIAL+TRB->TRB_OP))
			IF !Empty(SC2->C2_ZOPTAUR)
				AAdd(aRecSC2, TRB->(Recno()))
			EndIF
		EndIF
	EndIF
	TRB->( dbSkip() )
EndDo

For nL := 1 To Len(aRecSC2)
	TRB->( DbGoto(aRecSC2[nL]))
	Reclock("TRB",.F.)
	TRB->(dbDelete())
	TRB->(MsUnlock())
Next nL
  */

//RestArea(aArea)
//RestArea(aAreaSd3)
//RestArea(aAreaSc2)

Return


