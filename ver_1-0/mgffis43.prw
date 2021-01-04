#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#DEFINE CRLF chr(13) + chr(10)

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFFIS43
GAP 366 - Bloqueio para apuração de ICMS

Descrição da rotina:

	Rotina validação da exclusão, conforme tabela ZCG (Bloqueio de apuração de ICMS.)

	Desenvolver uma função dentro do arquivo MGFFIS43.PRW que verificará se a exclusão será
	realizada ou não, conforme registros da tabela ZCG. 
	
	A Função deve ser chamada através do ponto de entrada PROCAPUR.
	http://tdn.totvs.com/pages/releaseview.action?pageId=407113308
	

@author Natanael Simões
@since 22/01/2019
@version P12.1.17
/*/
//-------------------------------------------------------------------
User Function MGFFIS43(nAno,nMes)
Local lRet := .F. //Lógico indicando .T. para bloquear o reprocessamento ou .F. permitir o reprocessamento.
Local aArea := GetArea()
Local cAliasZCG := GetNextAlias()

If !ExisteSx6("MGF_FIS43A")
	CriarSX6("MGF_FIS43A", "D", "Ultima data de encerramento apuração do ICMS", '')
Endif 

// Periodo que foi fechado no parametro
cPerBloq := GetMV("MGF_FIS43A")

// Periodo da apuração
cPerApur := LASTDAY(STOD(StrZero(nAno,4) + StrZero(nMes,2) + "01"))

If cPerApur <= cPerBloq //.Or. cPeriodo > cPerApur
	lRet := .T. //Bloqueia a exclusão nem refazer a apuração
	MsgAlert("Periodo Bloqueado em todas as filiais para excluir ou refazer a apuração","MGFFIS43 - Bloqueio") 
	RestArea(aArea)
	Return lRet
EndIf
If Select(cAliasZCG) > 0
	(cAliasZCG)->(DbClosearea())
Endif
//Query na ZCG - Bloqueio de apuração de ICMS
BeginSql Alias cAliasZCG

	SELECT
		ZCG_FILIAL,
		ZCG_ANO,
		ZCG_MES,
		ZCG_STAT
	FROM
		%Table:ZCG% ZCG
	WHERE
		//ZCG_FILIAL 		= ' ' //22/01/2019: Removi a Filial devido à limitação do PE PROCAPUR que não recebe a filial correta.
		ZCG_FILIAL 			= %Exp:cFilAnt%
		AND ZCG.ZCG_ANO		= %Exp:nAno%
		AND ZCG.ZCG_MES		= %Exp:nMes%
		AND ZCG.%notDel%
EndSQL

(cAliasZCG)->(DBGoTop())
If (cAliasZCG)->(!EOF())
	If (cAliasZCG)->ZCG_STAT == '1' //Período bloqueado
		lRet := .T. //Bloqueia a exclusão nem refazer a apuração
		MsgAlert("Periodo Bloqueado para excluir ou refazer a apuração","MGFFIS42 GAP366 - Bloqueio") 
	EndIf
EndIf
(cAliasZCG)->(DbCloseArea())
RestArea(aArea)
Return lRet