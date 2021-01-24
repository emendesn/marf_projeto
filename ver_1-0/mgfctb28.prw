#Include 'Protheus.ch'

#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: MGFCTB28
Autor...............: Renato V.B.Jr
Data................: 15/05/2020
Descrição / Objetivo: Reprocessar Periodos contabeis Bloqueados. 
Doc. Origem.........: RTASK0011088
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Utilizado no ponto de entrada CT010TOK
=====================================================================================
*/
User Function MGFCTB28()
Local	_nI         :=  0
Local	cAreaCTG    := CTG->(GetArea())
Local	_cCalend    := CTG->CTG_CALEND
Local	_cExerci    := CTG->CTG_EXERC 
Local	_lPerBlq    :=  .F.

dbSelectArea("CTG")
dbSetOrder(1)
For _nI := 1 To Len(aCols)
    // Não estar deletado e igual a 4 - Bloqueio
	If !aCols[_nI][nUsado+1]  .AND.   aCols[_nI][nPosStatus] == "4"
		If dbSeek(xFilial() + _cCalend + _cExerci + aCols[_nI][1], .F.)
            If CTG->CTG_STATUS  <> aCols[_nI][nPosStatus]     // Bloqueado
				_lPerBlq    :=  .T.
				Exit
            Endif
        Endif
    Endif
Next

If (_lPerBlq)
    CTBA190(.F.,dDatabase,dDatabase,cFilAnt,cFilAnt,"1",.F.,"")
Endif
RestArea(cAreaCTG)
Return .T.
