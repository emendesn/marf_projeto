#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'FWMVCDEF.CH' 

#define CRLF chr(13)+chr(10)

//-------------------------------------------------------------------
/*{Protheus.doc} MGFLOJ01 - JOB para forçar a integração do Loja (SL1)
RITM0016587  - MARFRIG

Criar um programa que execute a query abaixo. Criaremos um JOB para executar de tempos em tempos. 
Isso se faz necessário, pois de tempos em tempos temos vendas que não sobem para o financeiro. Esse comando força a integração. 

UPDATE SL1010 SEL L1_SITUA = 'RX' 
WHERE 1=1
AND D_E_L_E_T_ <> '*' 
AND L1_ENTRADA > 0
AND L1_KEYNFCE <> ' '
AND L1_SITUA <> 'OK'

@author Natanael Simões
@since 26/04/2019
@version P12.1.17
*/
//-------------------------------------------------------------------

User Function MGFLOJ01(_aParam)

	Local cQuery	:= ' '
	Local nRet
	Local nQtdForc	:= 3//Default para o limite de tentativas.
	Local bError	:= ErrorBlock( { |oError| MyError( oError ) } )
	
	
	Private cError
	
	RpcSetType(3)
	RpcSetEnv("01","010001")
	

	
	//Mensagem de console
	ConOut(CRLF + Replicate("-",20))
	ConOut(PROCNAME() + ": Inicio - Forçando a integração da SL1 - " + dToc(dDataBase) + ", " + Time())
	
	ConOut(Replicate("-",20))
	VarInfo("Valores passados para a rotina",_aParam)
	
	ConOut(Replicate("-",20))
	ConOut("Filial logada: " + cFilAnt)
	
	DEFAULT _aParam	:= {3}
	
	If ValType(_aParam[1]) == 'N'
		nQtdForc	:= _aParam[1]
	EndIf
	
	//Composição da Query
	cQuery	+= " Update " + RetSQLName("SL1") + " SL1" + CRLF
	cQuery	+= " SET SL1.L1_SITUA = 'RX', " + CRLF
	cQuery	+= " SL1.L1_ZQTFORC = SL1.L1_ZQTFORC + 1 " + CRLF
	cQuery 	+= " WHERE SL1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery	+= " AND L1_ENTRADA > 0 " + CRLF
	cQuery	+= " AND L1_KEYNFCE <> ' ' " + CRLF
	cQuery	+= " AND L1_SITUA NOT IN ('OK','RX') " + CRLF
	cQuery	+= " AND SL1.L1_ZQTFORC < " + Alltrim(Str(nQtdForc)) + CRLF
	
	//cQuery	:= ChangeQuery(cQuery)
	ConOut(Replicate("-",20))
	ConOut("Query: " + CRLF + cQuery)
	ConOut(Replicate("-",20))	


	BEGIN SEQUENCE
		nRet	:= tcSQLExec(cQuery)
		
		If nRet = 0
			ConOut(PROCNAME() + ":Query executada com sucesso!")
		Else
			ConOut(PROCNAME() + ":Problema na execução da Query: " + "TCSQLError() " + TCSQLError())
		EndIf
		
		//cArquivo	:= "\temp\" + "cQuery_" + PROCNAME() + StrTran(Time(),':','') + ".sql"
		//MemoWrite(cArquivo,cQuery)
		
		ConOut(PROCNAME() + ": Fim - " + Time())
	END SEQUENCE

	ErrorBlock(bError)
	
	If ValType(cError) == 'C'
		ConOut("cError: "+cError)
	EndIf

Return

//====================================
//ErrorBlock - Proteção contra erros
//====================================
Static Function MyError(oError)

	cError := oError:ERRORSTACK

Return
