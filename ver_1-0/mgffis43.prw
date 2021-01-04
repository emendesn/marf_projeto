#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#DEFINE CRLF chr(13) + chr(10)

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFFIS43
GAP 366 - Bloqueio para apura��o de ICMS

Descri��o da rotina:

	Rotina valida��o da exclus�o, conforme tabela ZCG (Bloqueio de apura��o de ICMS.)

	Desenvolver uma fun��o dentro do arquivo MGFFIS43.PRW que verificar� se a exclus�o ser�
	realizada ou n�o, conforme registros da tabela ZCG. 
	
	A Fun��o deve ser chamada atrav�s do ponto de entrada PROCAPUR.
	http://tdn.totvs.com/pages/releaseview.action?pageId=407113308
	

@author Natanael Sim�es
@since 22/01/2019
@version P12.1.17
/*/
//-------------------------------------------------------------------
User Function MGFFIS43(nAno,nMes)
Local lRet := .F. //L�gico indicando .T. para bloquear o reprocessamento ou .F. permitir o reprocessamento.
Local aArea := GetArea()
Local cAliasZCG := GetNextAlias()

If !ExisteSx6("MGF_FIS43A")
	CriarSX6("MGF_FIS43A", "D", "Ultima data de encerramento apura��o do ICMS", '')
Endif 

// Periodo que foi fechado no parametro
cPerBloq := GetMV("MGF_FIS43A")

// Periodo da apura��o
cPerApur := LASTDAY(STOD(StrZero(nAno,4) + StrZero(nMes,2) + "01"))

If cPerApur <= cPerBloq //.Or. cPeriodo > cPerApur
	lRet := .T. //Bloqueia a exclus�o nem refazer a apura��o
	MsgAlert("Periodo Bloqueado em todas as filiais para excluir ou refazer a apura��o","MGFFIS43 - Bloqueio") 
	RestArea(aArea)
	Return lRet
EndIf
If Select(cAliasZCG) > 0
	(cAliasZCG)->(DbClosearea())
Endif
//Query na ZCG - Bloqueio de apura��o de ICMS
BeginSql Alias cAliasZCG

	SELECT
		ZCG_FILIAL,
		ZCG_ANO,
		ZCG_MES,
		ZCG_STAT
	FROM
		%Table:ZCG% ZCG
	WHERE
		//ZCG_FILIAL 		= ' ' //22/01/2019: Removi a Filial devido � limita��o do PE PROCAPUR que n�o recebe a filial correta.
		ZCG_FILIAL 			= %Exp:cFilAnt%
		AND ZCG.ZCG_ANO		= %Exp:nAno%
		AND ZCG.ZCG_MES		= %Exp:nMes%
		AND ZCG.%notDel%
EndSQL

(cAliasZCG)->(DBGoTop())
If (cAliasZCG)->(!EOF())
	If (cAliasZCG)->ZCG_STAT == '1' //Per�odo bloqueado
		lRet := .T. //Bloqueia a exclus�o nem refazer a apura��o
		MsgAlert("Periodo Bloqueado para excluir ou refazer a apura��o","MGFFIS42 GAP366 - Bloqueio") 
	EndIf
EndIf
(cAliasZCG)->(DbCloseArea())
RestArea(aArea)
Return lRet