#INCLUDE 'PROTHEUS.CH'
#include "TOPCONN.CH"
/*
=====================================================================================
Programa.:              MGFEST18
Autor....:              Atilio Amarilla
Data.....:              09/09/2016
Descricao / Objetivo:   Bloqueio automatico de itens sem movimentacao
Doc. Origem:            Contrato - GAP MGEST13
Solicitante:            Cliente
Uso......:              
Obs......:              Usa campos de bloqueio de inventario (B2_DTINV, B2_DINVFIM).
Desbloqueio pela rotina padrao (MATA217)
=====================================================================================
*/
User Function CallES18()

U_MGFEST18( { "01" , "010001" } )

Return

User Function MGFEST18( _aParam )

Local aCampos	:= {}
Local aRetDados	:= {}
Local aTables	:= { "SA1" , "SA2" , "SM0" , "SB1" , "SB2" , "SD1" , "SD2" , "SD3" }
Local dDatMov, dDatBlq
Local cQuery	:= ""
Local cAlias, aAreaSB2

If ValType(_aParam) == "A"
	RPCSetType(3)

//	RpcSetEnv(_aParam[1],_aParam[2],nil,nil,"EST",nil,aTables )
	RpcSetEnv( _aParam[1],_aParam[2], , ,"EST", , aTables, , , ,  ) 
EndIf

//ConOut("#################### MGFEST18 Iniciado. "+DTOC(Date())+"-"+Time())

dDatMov	:= dDataBase - GetNewPar("MGF_EST18A",90)  // Considera numero de dias sem movimentacao. Padr�o 90
dDatBlq	:= dDataBase + GetNewPar("MGF_EST18B",900) // Considera numero de dias de bloqueio. Padr�o 900 (Limite 998)
cAlias	:= GetNextAlias()
aAreaSB2:= SB2->(GetArea())

SB2->( DBOrderNickName("B2_EST1801") ) // B2_COD+B2_FILIAL+B2_LOCAL

BeginSQL Alias cAlias

	SELECT B2_COD, MAX(ULTMOV) ULTMOV
	FROM 
	(
	SELECT B2_COD, MAX(D1_DTDIGIT) ULTMOV
	FROM %table:SB2% SB2
	INNER JOIN 	%table:SD1% SD1 ON SD1.%notDel%
		AND D1_COD = B2_COD
	WHERE SB2.%notDel%
		AND B2_QATU > 0
		AND B2_DTINV = ''
		AND B2_DINVFIM = ''
	GROUP BY B2_COD

	UNION
	
	SELECT B2_COD, MAX(D2_EMISSAO) ULTMOV
	FROM %table:SB2% SB2
	INNER JOIN 	%table:SD2% SD2 ON SD2.%notDel%
		AND D2_COD = B2_COD
	WHERE SB2.%notDel%
		AND B2_QATU > 0
		AND B2_DTINV = ''
		AND B2_DINVFIM = ''
	GROUP BY B2_COD

	UNION

	SELECT B2_COD, MAX(D3_EMISSAO) ULTMOV
	FROM %table:SB2% SB2
	INNER JOIN 	%table:SD3% SD3 ON SD3.%notDel%
		AND D3_COD = B2_COD
		AND D3_ESTORNO = ''
	WHERE SB2.%notDel%
		AND B2_QATU > 0
		AND B2_DTINV = ''
		AND B2_DINVFIM = ''
	GROUP BY B2_COD
    ) AAA
    GROUP BY B2_COD
	ORDER BY 1
	
EndSQL

aQuery := GetLastQuery()
	
MemoWrit( "MGFEST18.SQL" , aQuery[2] )
//[1] Tabela temp
//[2] Query
//..[5]

(cAlias)->(dbGoTop())
While !(cAlias)->(eof())
	If (cAlias)->ULTMOV < DTOS(dDatMov)
		//ConOut("#################### MGFEST18. "+AllTrim((cAlias)->B2_COD)+ " - " +DTOC(STOD( (cAlias)->ULTMOV ))+"-BLOQUEIO")
		SB2->( dbSeek( (cAlias)->B2_COD ) )
		While !SB2->( eof() ) .And. SB2->B2_COD == (cAlias)->B2_COD
			RecLock("SB2",.F.)
			SB2->B2_DTINV	:=	dDataBase
			SB2->B2_DINVFIM	:=	dDatBlq
			SB2->( msUnlock() )		
			SB2->( dbSkip() )		
		EndDo
	Else
		//ConOut("#################### MGFEST18. "+AllTrim((cAlias)->B2_COD)+ " - " +DTOC(STOD((cAlias)->ULTMOV)))	
	EndIf
	(cAlias)->( dbSkip() )
EndDo

dbSelectArea(cAlias)
dbCloseArea()

SB2->( RestArea(aAreaSB2) )

//ConOut("#################### MGFEST18 Finalizado. "+DTOC(Date())+"-"+Time())

If ValType(_aParam) == "A"
	RpcClearEnv()
EndIf

Return .T.