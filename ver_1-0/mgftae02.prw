#include "totvs.ch"                                   
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "apwebsrv.ch"
#include "apwebex.ch"
#define CRLF chr(13) + chr(10)             
/*
=====================================================================================
Programa.:              MGFTAE02
Autor....:              Marcelo Carneiro         
Data.....:              20/10/2016 
Descricao / Objetivo:   Integração TAURA - ENTRADAS
Doc. Origem:            Contrato GAPS - MIT044- TAURA PROCESSO DE ENTRADA
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Envio Pedido de Compra de Gado - Parte ExecAuto
=====================================================================================
*/
                                               
User Function TTAE02

Local aItens := {{'0001','000050',35,1000,STOD('20171115')},; 
				 {'0002','000051',20,1200,STOD('20171115')}}


U_MGFTAE02('1','71222',STOD('20171117'),'037503238000001','02','010','010003',aItens,'03750323801','', '')

Return
*****************************************************************************************************************************
User Function MGFTAE02(cACAO,cNUM,dEMISSAO,cFORNECE,cLOJA,cCOND,cC7FILIAL,aItens,cC7_CNPJ ,cC7_CODEXP, cIDFazenda)

Local nI		:= 0
Local aErro	    := {}
Local cErro	    := ""
Local aLine	    := {}
Local aCAB		:= {}
Local aITEM	    := {}
Local bContinua := .T.
Local cC7Num	:= ""
Local aTables	:= { "SB1" , "SC7" , "SM0" , "SA2" , "SE4" }
Local aRetorno  := {}
Local nValPar   := 0        
Local cCodAgr   := ''
Local nPos      := 0
Local cItem     := ''

Private lMsHelpAuto     := .T.
Private lMsErroAuto     := .F.
Private lAutoErrNoFile  := .T.  
Private cCodProd        := ''


RPCSetType( 3 )
RpcSetEnv( '01',cC7FILIAL , '', '', "COM",'RPC', aTables )
//RpcSetEnv( SubStr(cC7FILIAL,1,2) , '01' , Nil, Nil, "COM", Nil, aTables )

SetFunName("MGFTAE02")
__cUserId	:= Alltrim(GetMv("MGF_USRAUT"))

//Fazer a Validação dos Campos 

IF !(cACAO $ '123')
	AAdd(aRetorno ,"2")
	AAdd(aRetorno,'C7_ACAO:Ação deverá ser : 1=Inclusão 2=Alteração3=Exclusão')
	bContinua := .F.
Else
	IF Empty(cLOJA) .AND. Empty(cIDFazenda)
			AAdd(aRetorno ,"2")
			AAdd(aRetorno,'C7_LOJA:Loja e ID da Fazenda em Brancoem Branco')
			bContinua := .F.
	Else
		IF  !FWFilExist(cEmpAnt,cC7FILIAL)
			AAdd(aRetorno ,"2")
			AAdd(aRetorno,'C7_FILIAL:Filial não cadastrada')
			bContinua := .F.
		Else
			cFilAnt := cC7FILIAL
			//Fornecedor
			dbSelectArea('SA2')
			SA2->(dbSetOrder(1))
			IF !U_TAE02_VALFOR(cFORNECE,cLOJA,cC7_CNPJ ,cC7_CODEXP,cIDFazenda)//SA2->(!dbSeek(xFilial('SA2')+ALLTRIM(cFORNECE)+ALLTRIM(cLOJA)))
				AAdd(aRetorno ,"2")
				AAdd(aRetorno,'C7_FORNECE:Fornecedor não cadastrado')
				bContinua := .F.
			Else
				cFORNECE  := SA2->A2_COD
				cLOJA     := SA2->A2_LOJA
				//Condição de Pagamento
				dbSelectArea('SE4')
				SE4->(dbSetOrder(1))
				IF SE4->(!dbSeek(xFilial('SE4')+ALLTRIM(cCOND)))
					AAdd(aRetorno ,"2")
					AAdd(aRetorno,'C7_COND:Condição de Pagamento não Cadastrada')
					bContinua := .F.
				Else
					For nI := 1 To Len( aItens )                   
						IF bContinua
							dbSelectArea('SB1')
							SB1->(dbSetOrder(1))
							IF SB1->(!dbSeek(xFilial('SB1')+ALLTRIM(aItens[nI][2])))
								AAdd(aRetorno ,"2")
								AAdd(aRetorno,'C7_PRODUTO:Produto não Cadastrado')
								bContinua := .F.
							Else
								/*IF Empty(SB1->B1_ZCODAGR)
									AAdd(aRetorno ,"2")
									AAdd(aRetorno,'C7_PRODUTO:Produto Agrupador não Cadastrado')
									bContinua := .F.
								EndIF */
							EndIF
							nValPar   += (aItens[nI][3] * aItens[nI][4])
						EndIF
					Next NI
					IF bContinua
						IF  !U_AE02_TOTALPED('1',cC7FILIAL,cNUM, nValPar) //cACAO == '2' .AND.
							AAdd(aRetorno ,"2")
							AAdd(aRetorno,'C7_VALOR:Valor do Pedido alterado é menor que os adiantamentos !!')
							bContinua := .F.
						EndIF
					EndIF
				EndIF
			EndIF
		EndIF
	EndIF
EndIF

// Se ação igual a 2-alteração ou 3-exclusão faz a exclusão primeiro                                                                     
DbSelectArea('SC7')                             
SC7->(DbOrderNickName('IDZPTAURA'))
IF bContinua 
	IF SC7->(DbSeek(cC7FILIAL+cNUM))
		cC7Num := SC7->C7_NUM
		aCAB := {}
		AAdd(aCAB,{"C7_FILIAL"   ,cC7FILIAL})
		AAdd(aCAB,{"C7_NUM"      ,SC7->C7_NUM})
		AAdd(aCAB,{"C7_EMISSAO"  ,SC7->C7_EMISSAO})
		AAdd(aCAB,{"C7_FORNECE"  ,SC7->C7_FORNECE})
		AAdd(aCAB,{"C7_LOJA"     ,SC7->C7_LOJA})
		AAdd(aCAB,{"C7_COND"     ,SC7->C7_COND})
		AAdd(aCAB,{"C7_CONTATO"  ,SC7->C7_CONTATO})
		AAdd(aCAB,{"C7_FILENT"   ,SC7->C7_FILENT})
		aITEM := {}
		While SC7->(!EOF()) .And. SC7->C7_ZPTAURA == cNUM .AND. cC7Num == SC7->C7_NUM .And. cC7FILIAL == SC7->C7_FILIAL
			aLine := {}
			AAdd(aLine, {'C7_ITEM'		, SC7->C7_ITEM	  , NIL})
			AAdd(aLine, {'C7_PRODUTO'	, SC7->C7_PRODUTO , NIL})
			AAdd(aLine, {'C7_QUANT'	    , SC7->C7_QUANT	  , NIL})
			AAdd(aLine, {'C7_PRECO'	    , SC7->C7_PRECO	  , NIL})
			AAdd(aLine, {"C7_TOTAL"     , SC7->C7_TOTAL   , Nil})
			AAdd(aLine, {"C7_REC_WT"    , SC7->(RECNO())  , Nil})
			AAdd(aITEM, aLine)
			SC7->(dbSkip())
		EndDo
		MATA120(1,aCAB,aITEM,5)
		//SetFunName("MATA121")
		//MSExecAuto({|x,y,z| MATA121(x,y,z)},aCAB,aITEM,5) // SC7 Pedido de Compra
		IF lMsErroAuto
			aErro := GetAutoGRLog()
			cErro := ""
			For nI := 1 to Len(aErro)
				cErro += aErro[nI] + CRLF
			Next nI
			
			//cNameLog := funName() + dToS(dDataBase) + strTran(time(),":")+'.LOG'
			
			//memoWrite("\" + cNameLog , cErro)
			
			AAdd(aRetorno ,"2")
			AAdd(aRetorno ,'Erro na Exclusão:'+cErro)
			bContinua   := .F.
		Else
			bContinua   := .T.
			IF cACAO == '3'
				bContinua   := .F.
				AAdd(aRetorno ,"1")
				AAdd(aRetorno ,'Pedido Excluído')
				U_AE02_VINCULA_AD('2',cC7FILIAL,cC7Num)
			EndIF
		Endif
	Else
	  IF cACAO == '3'
	      AAdd(aRetorno ,"2")
		  AAdd(aRetorno ,'Pedido Não Encontrado !!!')
	  EndIF
	EndIF
EndIF

// se for inclusão  ou Alteração
IF bContinua .AND. ( cACAO == '1' .OR.  cACAO == '2' )
	cC7Num := GETSX8NUM("SC7","C7_NUM")
	aCAB := {}
	AAdd(aCAB,{"C7_FILIAL"   ,cC7FILIAL})
	AAdd(aCAB,{"C7_NUM"      ,cC7Num})
	AAdd(aCAB,{"C7_EMISSAO"  ,dEmissao})
	AAdd(aCAB,{"C7_FORNECE"  ,cFORNECE})
	AAdd(aCAB,{"C7_LOJA"     ,cLOJA})
	AAdd(aCAB,{"C7_COND"     ,cCOND})          '
	AAdd(aCAB,{"C7_CONTATO"  ,"AUTO"})
	AAdd(aCAB,{"C7_FILENT"   ,cC7FILIAL})
	
	cItem     := '0000'
	aITEM := {}      
	For nI := 1 To Len(aItens)
	    SB1->(dbSeek(xFilial('SB1')+ALLTRIM(aItens[nI][2])))
	    IF Empty(SB1->B1_ZCODAGR)
	        cCodProd := ALLTRIM(aItens[nI][2])
	    Else 
	        cCodProd := ALLTRIM(SB1->B1_ZCODAGR)
	    EndIF
		nPos := AScan(aITEM,{|x|  x[2] == cCodProd })
		IF nPos == 0 
			aLine := {}
			cItem     := SOMA1(cItem)
			AAdd(aLine, cItem)
			AAdd(aLine, cCodProd)
			AAdd(aLine, aItens[nI][03])
			AAdd(aLine, aItens[nI][04])
			AAdd(aLine, aItens[nI][05])
			AAdd(aITEM, aLine)
		Else                                                       
		    aItem[nPos,03] += aItens[nI][3]
		    aItem[nPos,04] += aItens[nI][4]
		EndIF
	Next NI
	aItens := ACLONE(aITEM)
	aItem  := {}
	For nI := 1 To Len( aItens )
			aLine := {}
			AAdd(aLine, {'C7_ITEM'		, aItens[nI][1]     , NIL})
			AAdd(aLine, {'C7_PRODUTO'	, aItens[nI][2]     , NIL})
			AAdd(aLine, {'C7_QUANT'	    , aItens[nI][3]	    , NIL})
			AAdd(aLine, {'C7_PRECO'	    , aItens[nI][4]	    , NIL})
			AAdd(aLine, {'C7_DATPRF'	, aItens[nI][5]  	, NIL})
			AAdd(aLine, {"C7_ZTIPO"     , '2'               , NIL})
			AAdd(aLine, {"C7_ZPTAURA"   , cNUM              , NIL})
			AAdd(aITEM, aLine)
	Next NI
	PutMv('MV_RESTINC','N')
	MATA120(1,aCAB,aITEM,3)                              
	//SetFunName("MATA121")
	//MSExecAuto({|x,y,z| MATA121(x,y,z)},aCAB,aITEM,3)
	IF lMsErroAuto
		//PutMv('MV_RESTINC','S')
		ROLLBACKSX8()
		aErro := GetAutoGRLog() // Retorna erro em array
		cErro := ""
		For nI := 1 to Len(aErro)
			cErro += aErro[nI] + CRLF
		Next nI
		
		//			cNameLog := funName() + dToS(dDataBase) + strTran(time(),":")+'.LOG'
		//			memoWrite("\" + cNameLog , cErro)
		
		AAdd(aRetorno ,"2")
		AAdd(aRetorno,cErro)
	Else
		CONFIRMSX8()
		AAdd(aRetorno ,"1")
		AAdd(aRetorno,Alltrim(cC7Num) )
		cQuery := " Update "+RetSqlName("SC7")
		cQuery += " Set C7_CONAPRO = 'L'"
		cQuery += " Where C7_FILIAL  = '"+cC7FILIAL+"'"
		cQuery += "   AND C7_NUM     = '"+cC7Num+"'"
		cQuery += "   AND D_E_L_E_T_ = ' ' "
		IF (TcSQLExec(cQuery) < 0)        
			conOut(TcSQLError())
		EndIF                             
		U_AE02_VINCULA_AD('1',cC7FILIAL,cC7Num)
	Endif
EndIF

//RpcClearEnv()


Return aRetorno

********************************************************************************************************************************
User Function AE02_VINCULA_AD(cAcao,cFilPed,cPedido)

Local aAreaSE2 := SE2->(GetArea()) 

DbSelectArea("FIE")
FIE->(dbSetOrder(1))
//Exclusão
IF cAcao == '2'
	If FIE->(dbSeek(cFilPed+"P"+cPedido))
		While !FIE->(Eof()) .And. FIE->FIE_FILIAL == cFilPed .And. FIE->FIE_PEDIDO == cPedido
			Reclock("FIE",.F.)
			FIE->(dbDelete())
			FIE->(MsUnlock())
			FIE->(dbSeek(cFilPed+"P"+cPedido))
		EndDo
	EndIF
EndIF
//Inclusão
IF cAcao == '1'
	DbSelectArea('SE2')
	SE2->(DbOrderNickName('IDZPTAURA'))
	IF SE2->(DbSeek(cFilPed+cPedido))
		While !SE2->(Eof()) .And. SE2->E2_FILIAL == cFilPed .And. SE2->E2_ZPTAURA == cPedido
			Reclock("FIE",.T.)
			FIE->FIE_FILIAL    := cFilPed
			FIE->FIE_CART      := 'P'
			FIE->FIE_PEDIDO    := cPedido
			FIE->FIE_PREFIX    := SE2->E2_PREFIXO
			FIE->FIE_NUM       := SE2->E2_NUM
			FIE->FIE_PARCEL    := SE2->E2_PARCELA
			FIE->FIE_TIPO      := SE2->E2_TIPO
			FIE->FIE_FORNEC    := SE2->E2_FORNECE
			FIE->FIE_LOJA      := SE2->E2_LOJA
			FIE->FIE_VALOR     := SE2->E2_VALOR
			FIE->FIE_SALDO     := SE2->E2_VALOR
			FIE->(MsUnlock())
			SE2->(dbSkip())
		EndDo
	EndIF
EndIF

SE2->(RestArea(aAreaSE2))             

Return 
********************************************************************************************************************************
User Function AE02_TOTALPED(cTipo,cFilPed,cNum, nValPar)
Local nValSE2  := 0 
Local nValSC7  := 0 

Local bRet    := .T.   
Local cPedido := ''


DbSelectArea('SC7')
SC7->(DbOrderNickName('IDZPTAURA'))
IF SC7->(DbSeek(cFilPed+cNUM))
	cPedido := SC7->C7_NUM
	While SC7->(!EOF()) .And. Alltrim(SC7->C7_ZPTAURA) == cNUM
		nValSC7 += SC7->C7_TOTAL
		SC7->(dbSkip())
	EndDo
	DbSelectArea('SE2')
	SE2->(DbOrderNickName('IDZPTAURA'))
	IF SE2->(DbSeek(cFilPed+cPedido))
		While !SE2->(Eof()) .And. SE2->E2_FILIAL == cFilPed .And. Alltrim(SE2->E2_ZPTAURA) == cPedido
			nValSE2 += SE2->E2_VALOR
			SE2->(dbSkip())
		EndDo
	EndIF
	IF cTipo == '1' .And. nValPar < nValSE2
		bRet   := .F.
	EndIF
	IF cTipo == '2' .And. nValSC7 < (nValSE2+nValPar)
		bRet   := .F.
	EndIF
EndIF


Return bRet
**********************************************************************************************************************************************
User Function TAE02_VALFOR(cFORNECE,cLOJA,cC7_CNPJ ,cC7_CODEXP, cIDFazenda)
Local bRet   := .F.
Local cQuery := ''
                                                         
 
cQuery := " SELECT R_E_C_N_O_  RECFOR "
cQuery += " FROM "+RetSQLName("SA2")
cQuery += " WHERE D_E_L_E_T_ = ' ' "
IF !Empty(cC7_CODEXP)
   cQuery += " AND A2_ZCODMGF = '"+Alltrim(cC7_CODEXP)+"' "
Else
   cQuery += " AND A2_CGC = '"+Alltrim(cC7_CNPJ)+"' "
EndIF
IF !Empty(cLOJA)
    cQuery += " AND A2_LOJA = '"+Alltrim(cLOJA)+"' "
Else
   IF SA2->(FieldPos("A2_ZIDFAZ"))>0
	   IF !Empty(cIDFazenda)
	        cQuery += " AND A2_ZIDFAZ = '"+Alltrim(cIDFazenda)+"' "
	   EndIF
   EndIF
EndIF

If Select("QRY_FOR") > 0
	QRY_FOR->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_FOR",.T.,.F.)
dbSelectArea("QRY_FOR")
QRY_FOR->(dbGoTop())
IF QRY_FOR->(!EOF())
      dbSelectArea('SA2')
      SA2->(dbGoTo(QRY_FOR->RECFOR))
      bRet   := .T.
EndIF
QRY_FOR->(dbCloseArea())                                  

Return bRet
**********************************************************************************************************************************************
User Function TAE02_ALT
Local oBtn

Private oListPed 
Private aListPed  :={}       
Private oDlg     


If SC7->C7_ZTIPO  <>  '2'
	MsgAlert('Só é possivel alterar Pedidos oriundos do Taura !!')
	Return
EndIF
IF !Empty(C7_RESIDUO)
	MsgAlert('Pedido eliminado residuo !!')
	Return
EndIF
//C7_QUJE>=C7_QUANT
cQuery := " SELECT SC7.R_E_C_N_O_ RECNO, SC7.*, SB1.B1_DESC"
cQuery += " FROM "+RetSQLName("SC7")+' SC7, '+RetSQLName("SB1")+' SB1'
cQuery += " Where SC7.D_E_L_E_T_ = ' '"
cQuery += "   AND SB1.D_E_L_E_T_ = ' '"
cQuery += "   AND B1_FILIAL  = '"+xFilial('SB1')+"'"
cQuery += "   AND B1_COD     = C7_PRODUTO"
cQuery += "   AND C7_FILIAL   = '" + SC7->C7_FILIAL + "' "
cQuery += "   AND C7_NUM     = '" + SC7->C7_NUM + "' "
cQuery += " ORDER BY C7_ITEM "

If Select("QRY_PED") > 0
	QRY_PED->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_PED",.T.,.F.)
dbSelectArea("QRY_PED")
QRY_PED->(dbGoTop())
While !QRY_PED->(EOF())
	aRec   := {}
	AAdd(aRec,QRY_PED->C7_PRODUTO)
	AAdd(aRec,Alltrim(QRY_PED->B1_DESC))
	AAdd(aRec,QRY_PED->C7_QUANT)
	AAdd(aRec,QRY_PED->RECNO)
	AADD(aListPed,aRec)
	QRY_PED->(dbSkip())
End
DEFINE MSDIALOG oDlg TITLE "Altera Codigos dos Produtos" FROM 000, 000  TO 300, 580 COLORS 0, 16777215 PIXEL

	@ 010, 005 SAY  "Pedido Protheus"   SIZE 041, 010 OF oDLG                       COLORS 0, 16777215 PIXEL
	@ 008, 049 MSGET  SC7->C7_NUM       SIZE 080, 010 OF oDLG When .F. PICTURE "@!" COLORS 0, 16777215 PIXEL
	
	@ 023, 005 SAY  "Pedido Taura"   SIZE 041, 010 OF oDLG                       COLORS 0, 16777215 PIXEL
	@ 021, 049 MSGET  SC7->C7_ZPTAURA     SIZE 080, 010 OF oDLG When .F. PICTURE "@!" COLORS 0, 16777215 PIXEL
	
	@ 036, 005 LISTBOX oListPed Fields HEADER "Produto","Descrição","Qtde. Total"  SIZE 285,95 OF oDlg COLORS 0, 16777215 PIXEL
	oListPed:SetArray(aListPed)
	oListPed:nAt := 1
	oListPed:bLine := { || {aListPed[oListPed:nAt,1], aListPed[oListPed:nAt,2], aListPed[oListPed:nAt,3]}}
	
	oBtn := TButton():New( 004,240, "Confirmar"   ,oDlg,{|| Conf_Pedido()},050,011,,,,.T.,,"",,,,.F. )
	oBtn := TButton():New( 017,240, "Sair"        ,oDlg,{|| oDlg:End() },050,011,,,,.T.,,"",,,,.F. )
	oBtn := TButton():New( 135,240, "Alterar"     ,oDlg,{|| Alt_Prod() },050,011,,,,.T.,,"",,,,.F. )
	
ACTIVATE MSDIALOG oDlg CENTERED
	
Return
****************************************************************************************************************************************
Static Function Alt_Prod
Local aRec := {}
Private aParamBox := {}                                        
Private aRet      := {}

         

SB1->(dbSetOrder(1))
AAdd(aParamBox, {1, "Produto:"   ,Space(tamSx3("B1_COD")[1])   , "@!",  ,"MGFSB1" ,, 060	, .T.	})
AAdd(aParamBox, {1, "Qtd. "	     ,0                            , "@E 99,999,999,999,999.99",                           ,      ,, 050	, .T.	})
IF ParamBox(aParambox, "Informe o Codigo do Produto"	, @aRet, , , .T. /*lCentered*/, 0, 0, , , .T. /*lCanSave*/, .T. /*lUserSave*/)
	IF SB1->(!dbSeek(xFilial('SB1')+MV_PAR01))
		msgAlert('Produto não cadastrado !!')
		Return
	EndIF
	IF MV_PAR02 > aListPed[oListPed:nAt,3]
		msgAlert('Quantidade maior que o item do Pedido !!')
		Return
	EndIF
	nPos := AScan(aListPed,{|x|  Alltrim(x[1]) == Alltrim(MV_PAR01) })
	IF nPos == 0
		AAdd(aRec,MV_PAR01)
		AAdd(aRec,Alltrim(SB1->B1_DESC))
		AAdd(aRec,MV_PAR02)
		AAdd(aRec,aListPed[oListPed:nAt,4])
		AADD(aListPed,aRec)
	Else
	   aListPed[nPos,3] := aListPed[nPos,3] + MV_PAR02
	EndIF
	aListPed[oListPed:nAt,3] := aListPed[oListPed:nAt,3] - MV_PAR02
	IF aListPed[oListPed:nAt,3] <= 0 
	    ADel(aListPed,oListPed:nAt)
	    ASize(aListPed, Len(aListPed) -1 )
	EndIF
	oListPed:SetArray(aListPed)
	oListPed:nAt := 1
	oListPed:bLine := { || {aListPed[oListPed:nAt,1], aListPed[oListPed:nAt,2], aListPed[oListPed:nAt,3]}}
	oListPed:Refresh()
	
EndIF


Return
*****************************************************************************************************************************************************
Static Function Conf_Pedido()
Local aCAB   := {}
Local aITEM  := {}
Local aLine  := {}
Local nI     := 0 

Private lMsHelpAuto     := .T.
Private lMsErroAuto     := .F.
Private lAutoErrNoFile  := .T.  
      

IF MsgYESNO('Deseja alterar o Pedido de Compra ?')
	AAdd(aCAB,{"C7_FILIAL"   ,SC7->C7_FILIAL})
	AAdd(aCAB,{"C7_NUM"      ,SC7->C7_NUM})
	AAdd(aCAB,{"C7_EMISSAO"  ,SC7->C7_EMISSAO})
	AAdd(aCAB,{"C7_FORNECE"  ,SC7->C7_FORNECE})
	AAdd(aCAB,{"C7_LOJA"     ,SC7->C7_LOJA})
	AAdd(aCAB,{"C7_COND"     ,SC7->C7_COND})
	AAdd(aCAB,{"C7_CONTATO"  ,SC7->C7_CONTATO})
	AAdd(aCAB,{"C7_FILENT"   ,SC7->C7_FILENT})
	aITEM := {}
	cItem := '0001'
	For nI := 1 To Len(aListPed)
		SC7->(dbGoTo(aListPed[nI][04]))
		aLine := {}
		AAdd(aLine, {'C7_ITEM'		, cItem	  , NIL})
		AAdd(aLine, {'C7_PRODUTO'	, aListPed[nI][01] , NIL})
		AAdd(aLine, {'C7_QUANT'	    , aListPed[nI][03]  , NIL})
		AAdd(aLine, {'C7_PRECO'	    , SC7->C7_PRECO	  , NIL})
		AAdd(aLine, {"C7_TOTAL"     , aListPed[nI][03] * SC7->C7_PRECO , Nil})
		AAdd(aLine, {"C7_ZTIPO"     , '2'               , NIL})
		AAdd(aLine, {"C7_ZPTAURA"   , SC7->C7_ZPTAURA   , NIL})
		//AAdd(aLine, {"C7_REC_WT"    , aListPed[nI][04]  , Nil})
		AAdd(aITEM, aLine)
		cItem := SOMA1(cItem)
	Next nI
	MATA120(1,aCAB,aITEM,4)
	IF lMsErroAuto
		aErro := GetAutoGRLog()
		cErro := ""
		For nI := 1 to Len(aErro)
			cErro += aErro[nI] + CRLF
		Next nI
		MsgAlert('Erro na Alteração:'+cErro)
	Else
        cQuery := " Update "+RetSqlName("SC7")
		cQuery += " Set C7_CONAPRO = 'L'"
		cQuery += " Where C7_FILIAL  = '"+SC7->C7_FILIAL+"'"
		cQuery += "   AND C7_NUM     = '"+SC7->C7_NUM+"'"
		cQuery += "   AND D_E_L_E_T_ = ' ' "
		IF (TcSQLExec(cQuery) < 0)        
			conOut(TcSQLError())
		EndIF                             
        msgAlert('Pedido Alterado com Sucesso !')
	Endif
	oDlg:End()
EndIF                                            

Return