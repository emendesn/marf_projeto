#include "protheus.ch"
#include "rwmake.ch"

/*
=====================================================================================
Programa............: MGFFIS41
Autor...............: Totvs
Data................: Nov/2018
Descricao / Objetivo: Fiscal
Doc. Origem.........: Fiscal
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Tela para permitir alteração do parametro MV_SPEDEXC
=====================================================================================
*/
User Function MGFFIS41()

Local nHoras := 0
Local nHorasSav := 0
Local lOk := .F.
Local nOpcA := 0
Local cDet := ""
Local cIdCV8 := ""

nHoras := GetMv("MV_SPEDEXC")
nHorasSav := nHoras
cDet := "Conteudo anterior parametro 'MV_SPEDEXC': "+Alltrim(Str(nHoras))+CRLF

@ 000, 000 TO 160,400 DIALOG oDlg TITLE "Parâmetro 'MV_SPEDEXC'"
@ 010, 020 SAY "Informar a quantidade de horas, conforme SEFAZ de cada estado" 
@ 020, 020 SAY "determina, para possibilitar o cancelamento da NFe." 
@ 030, 020 SAY "Empresa: "+cEmpAnt+" - Filial: "+cFilAnt+" / "+FWFilialName() 
@ 040, 020 SAY "Conteúdo: " 
@ 040, 050 GET nHoras Picture "999" VALID (!Empty(nHoras) .and. Positivo(nHoras)) SIZE 15,10
@ 060, 070 BMPBUTTON TYPE 01 ACTION ( nOpcA := 1, lOk := .T. , Close( oDlg ) )
@ 060, 130 BMPBUTTON TYPE 02 ACTION ( nOpcA := 0, lOk := .F. , Close( oDlg ) )

ACTIVATE DIALOG oDlg CENTERED

If nOpcA == 1 .and. nHoras != nHorasSav
	If lOk .and. MsgYesNo("Deseja realmente atualizar o parâmetro ?") 
		cDet += "Conteudo atual parametro 'MV_SPEDEXC': "+Alltrim(Str(nHoras))+CRLF
		
		Begin Transaction
		
		PutMv("MV_SPEDEXC",nHoras)
		
		// grava tabela de log cv8
		ProcLogIni( {},ProcName(),,@cIdCV8)
		ProcLogAtu("FIM","Processamento de alteração do parâmetro 'MV_SPEDEXEC' pela rotina 'MGFFIS41'",cDet,,.T.)
		
		End Transaction
	Endif 
Endif	
  
Return()