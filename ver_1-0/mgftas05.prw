#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
//definicao para browser

#define PESQUISAR    1
#define VISUALIZAR   2
#define INCLUIR      3
#define ALTERAR      4
#define EXCLUIR      5

#define CRLF chr(13) + chr(10)

Static lRetStatPV := .T. // usado em user functions neste .prw

/*
=====================================================================================
Programa............: MGFTAS05
Autor...............: Marcelo Carneiro
Data................: 06/05/2017 
Descricao / Objetivo: Integração Protheus-Taura, PE na liberação do PV
Doc. Origem.........: Protheus-Taura Saida
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Ponto de Entrada bloquear Liberação de Pedidos oriundos do Taura
                      nTipo == 1 no PE Ma440VLD e M410PVNF
                      nTipo == 2 no PE OMSA200P
=====================================================================================
*/

User Function MGFTAS05(xTipo)
Local bRet := .T.
Local cQuery := ''
Local cParam := If(Type("ParamIxb") = "A",ParamIxb[1],If(Type("ParamIxb") = "C",ParamIxb,""))
Local bTemReg
Local aBitMap := {}
Local nCnt := ""
Local nPos := ""
	
Private lIsBlind   :=  IsBlind() .OR. Type("__LocalDriver") == "U"

IF lIsBlind .Or. FunName() == "EECFATCP" // cModulo == "EEC"
	Return  bRet
EndIF
IF xTipo == 1
	DbSelectArea('SZJ')
	SZJ->(dbSetOrder(1))
	IF SZJ->(dbSeek(xFilial('SZJ')+SC5->C5_ZTIPPED))
		IF SZJ->ZJ_TAURA == 'S'
			bRet := .F.
			MsgAlert('Tipo de Pedido Integra com o Taura, Não é possivel Liberar no Protheus!!')
		EndIF
	EndIF
ElseIF xTipo == 2
	cQuery  := "Select Count(*)  TOTAL"
	cQuery  += "FROM "+RetSqlName("DAK")+" DAK, "+RetSqlName("DAI")+" DAI, "+RetSqlName("SC5")+" SC5, "+RetSqlName("SZJ")+" SZJ "
	cQuery  += "Where DAK.D_E_L_E_T_ =	' '"
	cQuery  += "  AND DAI.D_E_L_E_T_ =	' ' "
	cQuery  += "  AND SC5.D_E_L_E_T_ =	' ' "
	cQuery  += "  AND SZJ.D_E_L_E_T_ =	' ' "
	cQuery  += "  AND DAK_FILIAL     = DAI_FILIAL "
	cQuery  += "  AND DAK_COD        = DAI_COD    "
	cQuery  += "  AND DAI_FILIAL     = C5_FILIAL  "
	cQuery  += "  AND DAI_PEDIDO     = C5_NUM     "
	cQuery  += "  AND C5_ZTIPPED     = ZJ_COD     "
	cQuery  += "  AND ZJ_TAURA       = 'S'        "
	cQuery  += "  AND DAK_COD        = '"+DAK->DAK_COD+"'"
	If Select("QRY_OMS") > 0
		QRY_OMS->(dbCloseArea())
	EndIf
	cQuery  := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_OMS",.T.,.F.)
	dbSelectArea("QRY_OMS")
	QRY_OMS->(dbGoTop())
	IF !QRY_OMS->(EOF())
		IF QRY_OMS->TOTAL > 0
			MsgAlert('A Carga possui Pedido que Integra com o Taura, Não é possivel excluir!!')
			bRet := .F.
		EndIF
	EndIF
ELSEIF xTipo == 3
	// rotina de importacao de ordem de embarque
	If !(IsInCallStack("GravarCarga") .or. IsInCallStack("U_GravarCarga") .or. IsInCallStack("INCPEDEXP") .or. IsInCallStack("U_INCPEDEXP"))
		// rotina de exclusao de nota de saida, desfaz fis45
		If !(IsInCallStack("MATA521") .or. IsInCallStack("MATA521A") .or. IsInCallStack("MATA521B"))
			IF IsInCallStack("EECAP100") .And. cParam ==  "AP100MAN_INICIO"
				// zera variaveis de controle do taura 
				lRetStatPV := .T. 
				If Type("__lRetStatPV") != "U"
					__lRetStatPV := lRetStatPV
				Endif	
				
				IF nOpcAux == ALTERAR
					dbSelectArea('SC5')
					SC5->(dbSetOrder(1))
					If SC5->(dbSeek(xFilial("EE7")+ALLTRIM(EE7->EE7_PEDFAT)))
						lRetStatPV := U_TAS01StatPV({SC5->C5_NUM,2})
					EndIf
				
					If bRet
						bRet := EE8Fis45(SC5->C5_FILIAL,SC5->C5_PEDEXP)
					Endif
				Endif	
			EndIF

			IF IsInCallStack("EECAP100") .And. cParam == "ANTES_TELA_PRINCIPAL"
				IF nOpcAux == ALTERAR
					SC5->(dbSetOrder(1))
					If SC5->(dbSeek(xFilial("EE7")+ALLTRIM(EE7->EE7_PEDFAT)))
						// taura retornou que nao pode alterar o pedido ou pedido jah foi integrado com o taura
						If !lRetStatPV .and. SC5->C5_ZTAUINT == "S"
							aBitMap := {"BMPINCLUIR","EDIT","EXCLUIR"}
							// exclui botoes de incluir/alterar/excluir itens
							For nCnt:=1 To Len(aBitMap)
								If (nPos := aScan(aButtons,{|x| Alltrim(x[1])==aBitMap[nCnt]})) > 0 
									aDel(aButtons,nPos)
									aButtons := aSize(aButtons,Len(aButtons)-1)
								Endif	
							Next	
							// inclui botao de visualizar item
							bTemReg := {|| IF(IsVazio("WorkIt"),(HELP(" ",1,"AVG0000632"),.F.),.T.) }
					      	aAdd(aButtons,{"BMPVISUAL" /*"ANALITICO"*/,{|| IF(Empty(M->EE7_PEDIDO),Help(" ",1,"AVG0000020"),IF(Eval(bTemReg),AP100DETMAN(/*VIS_DET*/3),))},/*STR0002*/"Visualizar"}) //"Visualizar"
						Endif
					Endif
				Endif	
			Endif	
		Endif	
	EndIF
Endif	
	
Return bRet                    

****************************************************************************************************************************
User Function xMGFTAS05()        //IIF(Findfunction("U_MGFTAS05"),xMGFTAS05(),.T.)
Local bRet := .T.
                 
IF MV_PAR01 == 1
    MsgAlert('Liberação automatica não disponivel !!')
    bRet := .F.
EndIF
Return bRet


// verifica se algum item do pedido teve alteracao em funcao do gap fis45, que inclui/altera itens no pedido
Static Function EE8Fis45(cFil,cPed)

Local aArea := {SZJ->(GetArea()),GetArea()}
Local cQ := ""
Local lRet := .T.
Local cAliasTrb := GetNextAlias()

SZJ->(dbSetOrder(1))
If SZJ->(dbSeek(xFilial("SZJ")+SC5->C5_ZTIPPED))
	If SZJ->ZJ_TAURA == "S"
		cQ := "SELECT R_E_C_N_O_ EE8_RECNO "
		cQ += "FROM "+RetSqlName("EE8")+" EE8 "
		cQ += "WHERE "
		cQ += "EE8_FILIAL = '"+cFil+"' "
		cQ += "AND EE8_PEDIDO = '"+cPed+"' "
		cQ += "AND EE8_ZGERSI = 'S' "
		cQ += "AND EE8.D_E_L_E_T_ = ' ' "
		cQ += "UNION "
		cQ += "SELECT R_E_C_N_O_ EE8_RECNO "
		cQ += "FROM "+RetSqlName("EE8")+" EE8 "
		cQ += "WHERE "
		cQ += "EE8_FILIAL = '"+cFil+"' "
		cQ += "AND EE8_PEDIDO = '"+cPed+"' "
		cQ += "AND EE8_ZTESSI <> ' ' "
		cQ += "AND EE8.D_E_L_E_T_ = ' ' "
		
		cQ := ChangeQuery(cQ)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)
		
		While (cAliasTrb)->(!Eof())
			lRet := .F.
			ApMsgStop("Pedido de exportação já tem itens gerados por Sif´s diferentes."+CRLF+;
			"É necessário excluir esta Ordem de Embarque, para que as alterações anteriores sejam desfeitas e em seguida incluir novamente a Ordem de Embarque."+CRLF+;
			"Solicite a exclusão da Ordem de Embarque pelo sistema Taura.")
			Exit
		Enddo
		
		(cAliasTrb)->(dbCloseArea()) 
	Endif
Endif		

aEval(aArea,{|x| RestArea(x)})	
		
Return(lRet)


// valida a confirmacao do pedido de exportacao
// valida quais campos do pedido poderao ser alterados apos integracao com taura
// PE criado neste fonte para usar a variavel static lRetStatPV, que eh alterada no PE EECAP100_PE
User Function MGFEEC52() //EECPEM44()

Local lRet := .T.
Local cCampoAlt := "" // campos que o usuario pode alterar na tela
Local aAreaSX3 := {}
Local cCampoAlt1 := "" // campos que o sistema muda quando se abre a tela de alteracao, mesmo que o usuario nao altere o campo

If Type("__lRetStatPV") == "U"
	Public __lRetStatPV := lRetStatPV // public pois eh usado em outros PE no pedido de venda
Else
	__lRetStatPV := lRetStatPV
Endif		

// rotina de importacao de ordem de embarque
If !(IsInCallStack("GravarCarga") .or. IsInCallStack("U_GravarCarga") .or. IsInCallStack("INCPEDEXP") .or. IsInCallStack("U_INCPEDEXP"))
	// rotina de exclusao de nota de saida, desfaz fis45
	If !(IsInCallStack("MATA521") .or. IsInCallStack("MATA521A") .or. IsInCallStack("MATA521B"))
		IF IsInCallStack("EECAP100")
			IF nOpcAux == ALTERAR			
				SC5->(dbSetOrder(1))
				If SC5->(dbSeek(xFilial("EE7")+ALLTRIM(EE7->EE7_PEDFAT)))
					// taura retornou que nao pode alterar o pedido ou pedido jah foi integrado com o taura
					If !lRetStatPV .and. SC5->C5_ZTAUINT == "S"
						cCampoAlt := GetMv("MGF_EE7TAL",,"EE7_FRPREV/EE7_FRPCOM/EE7_SEGPRE")
						cCampoAlt1 := GetMv("MGF_EE7TA1",,"EE7_FATURA")
						aAreaSX3 := SX3->(GetArea())
								
						SX3->(dbSetOrder(1))
						If SX3->(dbSeek("EE7"))
							While SX3->(!Eof()) .and. SX3->X3_ARQUIVO == "EE7"
								cCampo := "M->"+SX3->X3_CAMPO
								If Type(cCampo) != "U"
									If SX3->X3_CONTEXT != "V" .and. X3USO(SX3->X3_USADO) .and. !Alltrim(SX3->X3_CAMPO) $ cCampoAlt .and. !Alltrim(SX3->X3_CAMPO) $ cCampoAlt1
										If IIf(Type(cCampo) $ "C/M",!Alltrim(&(cCampo)) == Alltrim(&("EE7->"+SX3->X3_CAMPO)),!&(cCampo) == &("EE7->"+SX3->X3_CAMPO))
											lRet := .F.
											ApMsgAlert("Pedido já integrado com Taura, não será permitido alterar."+CRLF+;
											"Campo: "+SX3->X3_CAMPO+CRLF+;
											"Descrição: "+SX3->X3_TITULO+CRLF+;
											"Conteúdo atual ( base de dados - EE7 ): "+cValToChar(&("EE7->"+SX3->X3_CAMPO))+CRLF+;
											"Conteúdo novo ( tela de pedido ): "+cValToChar(&(cCampo)))
											Exit
										Endif
									Endif
								Endif
								
								SX3->(dbSkip())
							Enddo
						Endif					
						
						SX3->(RestArea(aAreaSX3))
					Endif
				Endif
			Endif	
		Endif	
	Endif
Endif		
			
Return(lRet)			