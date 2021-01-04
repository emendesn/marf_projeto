#INCLUDE "rwmake.ch"

/*
=====================================================================================
Programa.:              MGFFIN38
Autor....:              Flavio Dentello
Data.....:              21/10/2016
Descricao / Objetivo:   Cadastro de tipos de desconto
Doc. Origem:            GAP FINCRE029_V2
Solicitante:            Cliente
Uso......:              
Obs......:              Chamado pelo PE SF1100I
=====================================================================================
*/

User Function MGFFIN38()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "ZZ4"

dbSelectArea("ZZ4")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Tipo de Desconto",cVldExc,cVldAlt)

Return

///Ponto de entrada
//�������������������������������������������������������������������������������������������Ŀ
//� Funcao que grava o tipo de desconto no contas a receber a partir da emissao da nota fiscal
//���������������������������������������������������������������������������������������������
User Function CRE2901()

Local aArea	:=	GetArea()
Local aAreaSE1 := SE1->(GetArea())
Local nVlrIcms := SF2->F2_VALICM
Local nSobra := SF2->F2_VALICM
Local nParc := 0
Local nCount := 0
Local cTpDesc  := ""

If (!Empty(SF2->F2_PREFIXO) .or. !Empty(SF2->F2_DUPL))
	
	dbSelectArea("SE1")
	dbSetOrder(1)
	If SE1->(dbSeek(xFilial("SE1")+SF2->(F2_PREFIXO+F2_DUPL)))
		While SE1->(!Eof()) .and. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM) == (xFilial("SE1")+SF2->(F2_PREFIXO+F2_DUPL))
			If AllTrim(SE1->E1_TIPO) == "NF"
				nParc++
			Endif
			
			SE1->(dbSkip())
		Enddo
		
		If !Empty(nParc)
			SE1->(dbSeek(xFilial("SE1")+SF2->(F2_PREFIXO+F2_DUPL)))
			While SE1->(!Eof()) .and. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM) == (xFilial("SE1")+SF2->(F2_PREFIXO+F2_DUPL))
				If AllTrim(SE1->E1_TIPO) == "NF"
					
					dBselectArea('SE4')
					SE4->(dbSetOrder(1))//E4_FILIAL+E4_CODIGO
					If SE4->(dbSeek(xFilial("SE4")+SF2->F2_COND))
						
						nCount++
						
						
						//Tratamento para gravar o numero da ordem de embarque do OMS no titulo gerado.
						//GAP CRE24
						
						dBselectArea('DAI')
						DAI->(dbSetOrder(3))//DAI_FILIAL+DAI_NFISCA+DAI_SERIE+DAI_CLIENT+DAI_LOJA
						If DAI->(dbSeek(xFilial("DAI")+SE1->E1_NUM+SE1->E1_PREFIXO+SE1->E1_CLIENTE+SE1->E1_LOJA))
							
						EndIf
						SE1->(RecLock("SE1",.F.))
						cTpDesc := SE4->E4_ZTPDESC
						//SE1->E1_ZTPDESC := cTpDesc // analista Claudio Torres pediu para retirar essa gravacao em 28/03/17, pois a gravacao deste campo deve ser feita somente
						// pela customizacao do modulo GCT
						SE1->E1_ZORDENT := DAI->DAI_COD /// CRE24   
						SE1->E1_ZSINIST := "N" /// CRE24
						SE1->E1_ZCODSEG := SA1->A1_CODSEG
						If SE1->(FieldPos("E1_ZCNPJ")) > 0
							SE1->E1_ZCNPJ := SA1->A1_CGC
						Endif	
						SE1->(MsUnlock())
					EndIf
				Endif
				
				SE1->(dbSkip())
			Enddo
		Endif
	Endif
Endif

SE1->(RestArea(aAreaSE1))
RestArea(aArea)

Return()

//// PONTO DE ENTRADA PARA ADIONAR O BOT�O DE ALTERACAO DE TIPO DE DESCONTO.

#Include 'Protheus.ch'

User Function CRE2902()
Loca aButtons := PARAMIXB[1]

AADD(aButtons, {"Alter. Tp. Desconto", {|| U_ALTTPDES()}, "Alter. Tp. Desconto" })

Return aButtons



///Apresenta a tela de alteracao do tipo de desconto

User Function ALTTPDES()

Local 	cTpdes  := Space(TamSX3("E1_ZTPDESC")[1])
Local	Odlg
Local 	lOk
Local 	lCancel
Local	aArea := {SE1->(GetArea()),GetArea()} 

SE1->(DbSetOrder(1))
If SE1->(DbSeek(xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA ) )
	cTpdes := SE1->E1_ZTPDESC
	
	DEFINE DIALOG oDlg TITLE "Alterando Tp de desconto" FROM 180,180 TO 300,450 PIXEL
	@ 15,05 SAY "Tipo de desconto:"       SIZE  50,10 OF oDlg PIXEL
	@ 15,50 MSGET cTpdes                  SIZE  50,10 OF oDlg PIXEL F3 "ZZ4" VALID (Vazio(cTpdes) .or. ExistCpo("ZZ4",cTpdes)) PICTURE '@!'
	
	oTButton := TButton():New( 35, 30, "&OK",oDlg			,{|| lOk:= .T.    , oDlg:End() }	,40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton := TButton():New( 35, 80, "&Cancelar",oDlg	,{|| lCancel:= .T., oDlg:End() }	,40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	
	ACTIVATE DIALOG oDlg CENTERED
	
	If lCancel
	ElseIf lOk
		SE1->(RecLock("SE1",.F.))		
		SE1->E1_ZTPDESC := cTpdes
		SE1->(MsUnLock())
		
		MsgInfo ("Alteracao realizada com sucesso!")
		
	EndIf
	
EndIf

aEval(aArea,{|x| RestArea(x)})

Return

/////////Ponto de Entrada para gravar Tipo de desconto na tabela de Movimentacao Bancaria

User Function xCRE2903()

	SE5->(RecLock('SE5',.F.))
	SE5->E5_ZTPDESC := SE1->E1_ZTPDESC
	SE5->E5_ZDSTPDE := SE1->E1_ZDSTPDE
	SE5->(MsUnlock())

Return


// rotina chamada pelos pontos de entrada FA040INC e FA040ALT
User Function CRE2904()

Local lRet := .T.

If !Empty(M->E1_DESCFIN) .or. !Empty(M->E1_DECRESC) .or. M->E1_TIPO $ MVABATIM
	If Empty(M->E1_ZTPDESC)
		lRet := .F.
//		APMsgAlert("Titulo com valor de desconto informado ou titulo de abatimento financeiro."+CRLF+;
//		"Necessario informar o campo de Tipo de Desconto Marfrig.")
		If IsBlind()
			Help(" ",1,'TPDESCMGF',,'Titulo com valor de desconto informado ou titulo de abatimento financeiro.'+CRLF+;
						    'Necessario informar o campo de Tipo de Desconto Marfrig.',1,0)
		Else
			MsgAlert("Titulo com valor de desconto informado ou titulo de abatimento financeiro."+CRLF+;
			"Necessario informar o campo de Tipo de Desconto Marfrig.")
		EndIf
	Endif
Else
	If !Empty(M->E1_ZTPDESC)
		lRet := .F.
//		APMsgAlert("Titulo nao tem valor de desconto informado ou titulo nao � de abatimento financeiro."+CRLF+;
//		"Nao � necessario informar o campo de Tipo de Desconto Marfrig.")
		If IsBlind()
			Help(" ",1,'TPDESCMGF',,'Titulo nao tem valor de desconto informado ou titulo nao � de abatimento financeiro.'+CRLF+;
						    'Nao � necessario informar o campo de Tipo de Desconto Marfrig.',1,0)
		Else
			MsgAlert("Titulo nao tem valor de desconto informado ou titulo nao � de abatimento financeiro."+CRLF+;
			"Nao � necessario informar o campo de Tipo de Desconto Marfrig.")
		EndIf
	Endif	
Endif		

Return(lRet)


// rotina chamada pelo ponto de entrada FA040GRV e FA040B01
User Function CRE2905(nTipo)

Local aArea := {SE1->(GetArea())}

If M->E1_TIPO $ MVABATIM
	SE1->(dbSetOrder(1))
	If SE1->(dbSeek(xFilial("SE1")+M->E1_PREFIXO+M->E1_NUM+M->E1_PARCELA))
		While SE1->(!Eof()) .and. xFilial("SE1")+M->E1_PREFIXO+M->E1_NUM+M->E1_PARCELA == SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA)
			If SE1->E1_TIPO == MVNOTAFIS .and. M->E1_CLIENTE == SE1->E1_CLIENTE .and. M->E1_LOJA == SE1->E1_LOJA
				If SE1->E1_SALDO > 0
					If nTipo == "1" // inclusao do titulo de abatimento
						If Empty(SE1->E1_ZTPDESC)
							SE1->(RecLock("SE1",.F.))
							SE1->E1_ZTPDESC := M->E1_ZTPDESC
							SE1->(MsUnLock())
							Exit
						Endif	
					Elseif nTipo == "2" // exclusao do titulo de abatimento
						If !Empty(SE1->E1_ZTPDESC) .and. Empty(SE1->E1_DESCFIN) .and. Empty(SE1->E1_DECRESC)
							SE1->(RecLock("SE1",.F.))
							SE1->E1_ZTPDESC := ""
							SE1->(MsUnLock())
							Exit
						Endif	
					Endif	
				Endif	
			Endif
			SE1->(dbSkip())
		Enddo
	Endif
Endif

aEval(aArea,{|x| RestArea(x)})

Return()
				
				
				
					
			



