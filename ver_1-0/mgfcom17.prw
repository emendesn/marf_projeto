	#include 'protheus.ch'
#INCLUDE "FWMVCDEF.CH"   
/*    
================================================================================================================
Data da alteração............: 10/12/2018
Autor........................: Caroline Cazela (caroline.cazela@totvspartners.com.br)
Descrição da alteração.......: Inclusão lançamentos contábeis no log. Utiliza o tipo LC e as tabelas SCR e CT2.
================================================================================================================
*/
Static _cTipo

User function MGFCOM17(ctp)

	Local aButtons 	:= {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}

	If !(Empty(cTp))
		_cTipo := cTp
		FWExecView('Log Aprovação','MGFCOM17', MODEL_OPERATION_VIEW, , { || .T. }, ,50,aButtons )
	EndIf

Return


Static function MenuDef()

	Local	aRotina	:= {}

	ADD OPTION aRotina TITLE "Pesquisar"  ACTION "PesqBrw"          OPERATION 1                      ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.MGFCOM17" OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.MGFCOM17" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.MGFCOM17" OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.MGFCOM17" OPERATION MODEL_OPERATION_DELETE ACCESS 0

Return(aRotina)

Static function ModelDef()

	Local oModel := nil

	Local oStrSC1 := FWFormStruct(1,"SC1")
	Local oStrSC7 := FWFormStruct(1,"SC7")
	Local oStrSCP := FWFormStruct(1,"SCP")
	Local oStrSE2 := FWFormStruct(1,"SE2")
	Local oStrSCR := FWFormStruct(1,"SCR")
	Local oStrSC3 := FWFormStruct(1,"SC3")   
	Local oStrCT2 := FWFormStruct(1,"CT2") // Alteração Caroline Cazela 10/12/18

	oStrSCR:AddField(' ','CR_ZLEG' ,'CR_ZLEG','BT',1,0,/*bValid*/, /*bWhen*/,,.F.,{||U_MC17RLeg('SCR')})

	oStrSCR:AddField( 							 	   ; // Ord. Tipo Desc.
						'Resp. Aprv.'	 	 		 , ; // [01] C Titulo do campo
						'Responsavel pela Aprovação' , ; // [02] C ToolTip do campo
						'CR_ZRESAPR' 				 , ; // [03] C identificador (ID) do Field
						'C' 						 , ; // [04] C Tipo do campo
						30 							 , ; // [05] N Tamanho do campo
						0 							 , ; // [06] N Decimal do campo
						{||.T.}						 , ; // [07] B Code-block de validação do campo
						NIL 						 , ; // [08] B Code-block devalidação When do campo
						Nil 			 			 , ; // [09] A Lista de valores permitido do campo
						.F. 						 , ; // [10] L Indica se o campo tem preenchimento obrigatório
						{||xNomApr('01')}			 , ; // [11] B Code-block de inicializacao do campo
						NIL 						 , ; // [12] L Indica se trata de um campo chave
						NIL 						 , ; // [13] L Indica se o campo pode receber valor em uma operação de update.Manual ADvPl utilizando o MVC 60 Versão 4.0 Manual ADvPl utilizando o MVC
						.T. ) 							 // [14] L Indica se o campo é virtual

	oStrSCR:AddField( 							 	   ; // Ord. Tipo Desc.
						'Aprovador'	 	 		 	 , ; // [01] C Titulo do campo
						'Aprovação' 				 , ; // [02] C ToolTip do campo
						'CR_ZNOMAPR' 				 , ; // [03] C identificador (ID) do Field
						'C' 						 , ; // [04] C Tipo do campo
						30 							 , ; // [05] N Tamanho do campo
						0 							 , ; // [06] N Decimal do campo
						{||.T.}			 			 , ; // [07] B Code-block de validação do campo
						NIL 						 , ; // [08] B Code-block devalidação When do campo
						Nil 			 			 , ; // [09] A Lista de valores permitido do campo
						.F. 						 , ; // [10] L Indica se o campo tem preenchimento obrigatório
						{||xNomApr('02')}			 , ; // [11] B Code-block de inicializacao do campo
						NIL 						 , ; // [12] L Indica se trata de um campo chave
						NIL 						 , ; // [13] L Indica se o campo pode receber valor em uma operação de update.Manual ADvPl utilizando o MVC 60 Versão 4.0 Manual ADvPl utilizando o MVC
						.T. ) 							 // [14] L Indica se o campo é virtual

	oModel := MPFormModel():New("XMGFCOM17",/*bPreValidacao*/,/*bPosValid*/,/*bCommit*/,/*bCancel*/ )

	If _cTipo == 'SC'
		oModel:AddFields("CABMASTER",/*cOwner*/,oStrSC1, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )
	ElseIf _cTipo == 'PC'
		oModel:AddFields("CABMASTER",/*cOwner*/,oStrSC7, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )
	ElseIf _cTipo == 'SA'
		oModel:AddFields("CABMASTER",/*cOwner*/,oStrSCP, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )
	ElseIf _cTipo == 'ZC'
		oModel:AddFields("CABMASTER",/*cOwner*/,oStrSE2, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )
	ElseIf _cTipo == 'CP'
		oModel:AddFields("CABMASTER",/*cOwner*/,oStrSC3, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )
	ElseIf _cTipo == 'LC' // Alteração Caroline Cazela 04/12/18
		oModel:AddFields("CABMASTER",/*cOwner*/,oStrCT2, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )
	EndIf

	oModel:AddGrid("SCRDETAIL","CABMASTER",oStrSCR, /*bLinePreValid*/,/*bLinePosValid*/,/*bPreValid*/,/*bPosValid*/, /*bCarga*/ )

	If _cTipo == 'SC'
		oModel:SetRelation("SCRDETAIL",{{"CR_FILIAL","xFilial('SCR')"},{"CR_TIPO", "'SC'"},{"CR_NUM", "C1_NUM"}},SCR->(IndexKey(1)))
		oModel:SetPrimaryKey({"C1_FILIAL","C1_NUM"})
	ElseIf _cTipo == 'PC'
		oModel:SetRelation("SCRDETAIL",{{"CR_FILIAL","xFilial('SCR')"},{"CR_TIPO", "'PC'"},{"CR_NUM", "C7_NUM"}},SCR->(IndexKey(1)))
		oModel:SetPrimaryKey({"C7_FILIAL","C7_NUM"})
	ElseIf _cTipo == 'SA'
		oModel:SetRelation("SCRDETAIL",{{"CR_FILIAL","xFilial('SCR')"},{"CR_TIPO", "'PC'"},{"CR_NUM", "CP_NUM"}},SCR->(IndexKey(1)))
		oModel:SetPrimaryKey({"CP_FILIAL","CP_NUM"})
	ElseIf _cTipo == 'ZC'
		oModel:SetRelation("SCRDETAIL",{{"CR_FILIAL","xFilial('SCR')"},{"CR_TIPO", "'ZC'"},{"CR_NUM", "E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA"}},SCR->(IndexKey(1)))
		oModel:SetPrimaryKey({"E2_FILIAL","E2_PREFIXO","E2_NUM","E2_PARCELA","E2_TIPO","E2_FORNECE","E2_LOJA"})
	ElseIf _cTipo == 'CP'
		oModel:SetRelation("SCRDETAIL",{{"CR_FILIAL","xFilial('SCR')"},{"CR_TIPO", "'CP'"},{"CR_NUM", "C3_NUM"}},SCR->(IndexKey(1)))
		oModel:SetPrimaryKey({"C3_FILIAL","C3_NUM"})  
	ElseIf _cTipo == 'LC' // Alteração Caroline Cazela 10/12/18  
		oModel:SetRelation("SCRDETAIL",{{"CR_FILIAL","xFilial('SCR')"},{"CR_TIPO", "'LC'"},{"CR_NUM", "C1_NUM"}},SCR->(IndexKey(1)))
		oModel:SetPrimaryKey({"CT2_FILIAL","CT2_DOC"})
	EndIf

	oModel:SetDescription("Itens de Aprovação")

return oModel


Static function ViewDef()

	Local oView
	Local oModel  	:= FWLoadModel('MGFCOM17')

	Local cFldSCR	:= "CR_USER|CR_NIVEL|CR_STATUS|CR_EMISSAO|CR_DATALIB|CR_DATALIB|CR_ZUSELIB|CR_ZHORAPR"

	Local oStrSC1 	:= FWFormStruct(2,"SC1")
	Local oStrSC7 	:= FWFormStruct(2,"SC7")
	Local oStrSCP 	:= FWFormStruct(2,"SCP")
	Local oStrSE2 	:= FWFormStruct(2,"SE2")
	Local oStrSCR 	:= FWFormStruct(2,"SCR",{|cCampo|(AllTrim(cCampo) $ cFldSCR)})
	Local oStrSC3 	:= FWFormStruct(2,"SC3") 
	Local oStrCT2 	:= FWFormStruct(2,"CT2") // Alteração Caroline Cazela 04/12/18

	oStrSCR:AddField( 'CR_ZLEG','01','','',/*aHelp*/,"BT")

	oStrSCR:AddField( ; 					    		     // Ord. Tipo Desc.
						'CR_ZRESAPR' 				 	 , ; // [01] C Nome do Campo
						'06' 						 	 , ; // [02] C Ordem
						'Resp. Aprv.' 				 	 , ; // [03] C Titulo do campo
						'Responsavel pela Aprovação' 	 , ; // [04] C Descrição do campo
						{ 'Responsavel Pela Aprovação' } , ; // [05] A Array com Help
						'C' 							 , ; // [06] C Tipo do campo
						'@!' 							 , ; // [07] C Picture
						NIL 							 , ; // [08] B Bloco de Picture Var
						'' 								 , ; // [09] C Consulta F3
						.T. 							 , ; // [10] L Indica se o campo é evitável
						NIL 							 , ; // [11] C Pasta do campo
						NIL 							 , ; // [12] C Agrupamento do campo
						NIL			  	 				 , ; // [13] A Lista de valores permitido do campo (Combo)
						NIL 							 , ; // [14] N Tamanho Máximo da maior opção do combo
						NIL 							 , ; // [15] C Inicializador de Browse
						.T. 							 , ; // [16] L Indica se o campo é virtual
						NIL ) 								 // [17] C Picture Variável

	oStrSCR:AddField( ; 					    		     // Ord. Tipo Desc.
						'CR_ZNOMAPR' 				 	 , ; // [01] C Nome do Campo
						'99' 						 	 , ; // [02] C Ordem
						'Resp. Aprv.' 				 	 , ; // [03] C Titulo do campo
						'Responsavel pela Aprovação' 	 , ; // [04] C Descrição do campo
						{ 'Responsavel Pela Aprovação' } , ; // [05] A Array com Help
						'C' 							 , ; // [06] C Tipo do campo
						'@!' 							 , ; // [07] C Picture
						NIL 							 , ; // [08] B Bloco de Picture Var
						'' 								 , ; // [09] C Consulta F3
						.T. 							 , ; // [10] L Indica se o campo é evitável
						NIL 							 , ; // [11] C Pasta do campo
						NIL 							 , ; // [12] C Agrupamento do campo
						NIL			  	 				 , ; // [13] A Lista de valores permitido do campo (Combo)
						NIL 							 , ; // [14] N Tamanho Máximo da maior opção do combo
						NIL 							 , ; // [15] C Inicializador de Browse
						.T. 							 , ; // [16] L Indica se o campo é virtual
						NIL ) 								 // [17] C Picture Variável

	oView := FWFormView():New()
	oView:SetModel(oModel)

	If _cTipo == 'SC'
		oView:AddField( 'VIEW_CAB' , oStrSC1, 'CABMASTER' )
	ElseIf _cTipo == 'PC'
		oView:AddField( 'VIEW_CAB' , oStrSC7, 'CABMASTER' )
	ElseIf _cTipo == 'SA'
		oView:AddField( 'VIEW_CAB' , oStrSCP, 'CABMASTER' )
	ElseIf _cTipo == 'ZC'
		oView:AddField( 'VIEW_CAB' , oStrSE2, 'CABMASTER' )
	ElseIf _cTipo == 'CP'
		oView:AddField( 'VIEW_CAB' , oStrSC3, 'CABMASTER' ) 
	ElseIf _cTipo == 'LC' // Alteração Caroline Cazela 04/12/18
		oView:AddField( 'VIEW_CAB' , oStrCT2, 'CABMASTER' )
	EndIf

	oView:AddGrid( 'VIEW_SCR' , oStrSCR, 'SCRDETAIL' )

	oView:CreateHorizontalBox( 'SUPERIOR' , 40 )
	oView:CreateHorizontalBox( 'INFERIOR' , 60 )

	oView:SetOwnerView( 'VIEW_CAB', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_SCR', 'INFERIOR' )

	oView:AddUserButton('Legenda','',{|oView|U_MC17Legend()})

Return oView

Static Function xNomApr(cTp)

	Local cRet := ''
	Local nPos 	  := 0

	/*If Type('__aXAllUser') <> 'A'
		U_xMGC10CRIP()
	EndIf	*/

	If cTp == '01'
		If !(Empty(SCR->CR_USER))
			//nPos := aScan(__aXAllUser,{|x| Alltrim(x[2]) == Alltrim(SCR->CR_USER)})
			//cRet  := Alltrim(__aXAllUser[nPos][4])
			//cRet := xNomSAK(SCR->CR_FILIAL,SCR->CR_USER)
			cRet := xNomUSR(SCR->CR_USER)
		EndIf
	ElseIf cTp == '02'
		If !(Empty(SCR->CR_ZUSELIB))
			//nPos := aScan(__aXAllUser,{|x| Alltrim(x[2]) == Alltrim(SCR->CR_ZUSELIB)})
			//cRet  := Alltrim(__aXAllUser[nPos][4])
			//cRet := xNomSAK(SCR->CR_FILIAL,SCR->CR_ZUSELIB)
			cRet := xNomUSR(SCR->CR_ZUSELIB)
		EndIf
	EndIf

Return cRet

//Função da Legenda
User Function MC17RLeg(cAlias)

	Local cRet:=''

	If (cAlias)->CR_STATUS == '01' //Blqueado (aguardando outros niveis)
		cRet		:= 'BR_AZUL'
	ElseIf (cAlias)->CR_STATUS == '02' //Aguardando Liberacao do usuario
		cRet		:= 'DISABLE'
	ElseIf (cAlias)->CR_STATUS == '03' //Documento Liberado pelo usuario
		cRet		:= 'ENABLE'
	ElseIf (cAlias)->CR_STATUS == '04' //Documento Bloqueado pelo usuario
		cRet		:= 'BR_PRETO'
	ElseIf (cAlias)->CR_STATUS == '05' //Documento Liberado por outro usuario
		cRet		:= 'BR_CINZA'
	ElseIf (cAlias)->CR_STATUS == '06'//Documento Rejeitado pelo usuário
		cRet		:= 'BR_AMARELO'
	EndIf

Return cRet

User Function MC17Legend()

	Local oLegenda := FwLegend():New()

	oLegenda:add( "CR_STATUS=='01'", "BR_AZUL"   , "Bloqueado (aguardando outros niveis)" )
	oLegenda:add( "CR_STATUS=='02'", "DISABLE"   , "Aguardando Liberacao do usuario"     )
	oLegenda:add( "CR_STATUS=='03'", "ENABLE"    , "Documento Liberado pelo usuario"     )
	oLegenda:add( "CR_STATUS=='04'", "BR_PRETO"  , "Documento Bloqueado pelo usuario"    )
	oLegenda:add( "CR_STATUS=='05'", "BR_CINZA"  , "Documento Liberado por outro usuario")
	oLegenda:add( "CR_STATUS=='06'", "BR_AMARELO", "Documento Rejeitado pelo usuário"    )

	oLegenda:View()

	oLegenda := nil

Return .T.

Static Function xNomSAK(cxSCRFil,cUser)

	Local aArea 	:= GetArea()
	Local aAreaSAK	:= SAK->(GetArea())

	Local cRet := ''

	dbSelectArea('SAK')
	SAK->(dbSetOrder(2))//AK_FILIAL + AK_USER

	If SAK->(dbSeek(cxSCRFil + cUser))
		cRet := SAK->AK_NOME
	EndIf

	RestArea(aArea)
	RestArea(aAreaSAK)

return cRet

Static Function xNomUSR(cUser)

	Local aArea 	:= GetArea()
	Local cAlias	:= GetNextAlias()
	Local cRet		:= ''

	BeginSQL Alias cAlias

		SELECT USR_NOME
		FROM SYS_USR
		WHERE D_E_L_E_T_ = ' '
			AND USR_ID = %Exp:cUser%

	EndSQL

	cRet	:= 	( cAlias )->USR_NOME

	dbSelectArea(cAlias)
	dbCloseArea()

	RestArea( aArea )
Return cRet