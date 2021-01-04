#INCLUDE "Protheus.ch"
#INCLUDE "TOPConn.ch"
#INCLUDE "Rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*/{Protheus.doc} MGFFATB4 (JOB pedido credito)

Criação de rotina em Job, para para reavaliação financeira dos pedidos de venda que entraram no dia anterior.

@description
Nesta reavaliação o pedido de venda deverá passar apenas pela validação do bloqueio financeiro "000002 - Cliente com duplicatas em atraso".

Assim, caso o cliente do pedido esteja com alguma duplicata vencida, terá o pedido de venda bloqueado, 
não sendo possível faturar sem a liberação manual do setor financeiro.

Este JOB deverá gerar um histórico de execução para análise, caso haja necessidade.

@author Henrique Vidal Santos
@since 17/08/2019

@version P12.1.017
@country Brasil
@language Português

@type Function  
@table 
	SA1 - Clientes
	SC5 - Cabeçalho do pedido de vendas
	SZV - Detalhamento do bloqueio por regra

@param
@return

@menu
	SIGACFG->Jobs
@history
	Criação da rotina
	RITM002078 - Descritivo da necessidade
	
/*/

User Function MGFFATB4()

Private lAuto		  := .F.

IF Alltrim(FUNNAME()) == "RPC"  .Or. Empty(FUNNAME())
	Conout('MGFFATB4 - Iniciou Processo: ' + DtoC(Date()) + ' Horas: ' + TIME() + ' - Schedule Job Fat14 ' )
	RpcSetType(3)
	RpcSetEnv("01","010001")
	lAuto := .T.
EndIf

U_MGFREPPED()

IF lAuto
	Conout('MGFFATB4 - Terminou Processo: ' + DtoC(Date()) + ' Horas: ' + TIME())
EndIf

Return()

User Function MGFREPPED()

Local cQry	  	:= ""
Local lRet		:= .F.
Local lContinua	:= .T.  			//Utilizado para garantir que posiconou nas tabelas SA1 e SC5. Devido o fonte MGFFAT16 posicionar diretamente os campos 
Local cDataB		:= DtoS(dDataBase)
Local cCodRga		:= GetNewPar("MGF_FATJOB","000002")
Local cErro		:= ""

cqry += " SELECT C5_FILIAL , C5_NUM, A1_FILIAL, A1_COD , A1_LOJA "				+CRLF
cqry += " 	FROM "  +RetSqlName("SC5")+ " SC5, "  +RetSqlName("SA1")+ " SA1  "	+CRLF  
cqry += " 	WHERE C5_FILIAL >='01' " +CRLF//Tratar todas a filiais, filtrando filial somente para questão de performace da querie.

cqry += "	AND C5_EMISSAO < '" +  cDataB + "' "	+CRLF 
cqry += " 	AND C5_NOTA = '     ' "					+CRLF

cqry += " 	AND A1_FILIAL = '"+xFilial("SA1")+"' "	+CRLF		
cqry += " 	AND A1_COD = C5_CLIENTE		"	+CRLF	
cqry += " 	AND A1_LOJA = C5_LOJACLI	"	+CRLF

cqry += " 	AND SC5.D_E_L_E_T_ <> '*'	"	+CRLF
cqry += " 	AND SA1.D_E_L_E_T_ <> '*'	"	+CRLF

cqry += " 	AND NOT EXISTS ( SELECT * FROM " + RetSqlName("SZV")+ " SZV " + " WHERE ZV_FILIAL = C5_FILIAL AND ZV_PEDIDO = C5_NUM  AND ZV_CODRGA ='000002' AND ZV_DTBLQ >= C5_EMISSAO AND SZV.D_E_L_E_T_ =' ' ) "	+CRLF
cqry += " 	AND NOT EXISTS ( SELECT * FROM " + RetSqlName("SZV")+ " SZV " + " WHERE ZV_FILIAL = C5_FILIAL AND ZV_PEDIDO = C5_NUM  AND ZV_CODRGA ='000002' AND ZV_DTAPR <> '      '   AND SZV.D_E_L_E_T_ =' ' ) "	+CRLF

IF lAuto
	Conout( "MGFFATB4 - " + cqry) 
Else
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",cqry) // Retirado devido função GetTempPath não funcioanr em Schedule
EndIf 

cqry := ChangeQuery(cqry)

TCQUERY cqry NEW ALIAS "TRF"

While TRF->(!EOF())
	
	dbSelectArea('SC5')
	SC5->(dbSetOrder(1))
	If !SC5->(dbSeek(TRF->C5_FILIAL + TRF->C5_NUM))
		lContinua	:= .F.
		Return
	EndIf
	
	If lContinua
		DbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		If !SA1->(dbSeek(TRF->A1_FILIAL + TRF->A1_COD + TRF->A1_LOJA ))
			lContinua	:= .F.
		EndIf	
	EndIf 	
	
	If lContinua		
		lRet	:= U_MGFFAT16("02")	

		If lRet
			
			cFilAnt := TRF->C5_FILIAL
			dbSelectArea('SC5')
			
			lRet	:= U_TAS01VldMnt({TRF->C5_NUM} , .T.)
			
			If lRet[1]
				lRet	:= U_TAS01StatPV({TRF->C5_NUM,2},.F.,.T.)
			EndIf 

			If lRet[1]
				U_TAS06_GRV(TRF->C5_FILIAL,TRF->C5_NUM,'01',cCodRga)
				U_MGFMONITOR(TRF->C5_FILIAL,"1",'007','001',lRet[2], TRF->C5_FILIAL+"-"+TRF->C5_NUM+"-"+TRF->A1_COD+TRF->A1_LOJA ,'0','',0)
				
				dbSelectArea('SC5')
				SC5->(dbSetOrder(1))
				If SC5->(dbSeek(TRF->C5_FILIAL+TRF->C5_NUM))
					RecLock('SC5',.F.)
						SC5->C5_ZBLQRGA := 'B'	
						SC5->C5_ZLIBENV := 'S'
						SC5->C5_ZTAUREE := 'S'
					SC5->(MsUnlock())	
				EndIf 
			Else
				U_MGFMONITOR(TRF->C5_FILIAL,"2",'007','001',lRet[2], TRF->C5_FILIAL+"-"+TRF->C5_NUM+"-"+TRF->A1_COD+TRF->A1_LOJA ,'0','',0)
			EndIf
		EndIf 
	
	EndIf 		
	
	TRF->(dbSkip())
EndDo
TRF->(dbCloseArea())

Return()

