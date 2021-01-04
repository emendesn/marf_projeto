#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWBROWSE.CH"

/*/{Protheus.doc} MGFGFE01
Cadastro de Aprovadores

@description
Este cadastro tem como funcao fazer a manutencao do cadastro de Aprovadores.
 
@author Marcos Cesar Donizeti Vieira
@since 22/01/2020

@version P12.1.017
@country Brasil
@language Portugues

@type Function 
@table 
	SZO - Cadastro de Aprovaddores
@param
@return

@menu
@history 
/*/
User Function MGFGFE01()
	Local oMBrowse := nil	

	oMBrowse:=FWMBrowse():New()
	oMBrowse:SetCanSaveArea(.t.)
	oMBrowse:SetAlias("SZO")
	oMBrowse:SetDescription("Cadastro de Alcada de Aprovacao")
	oMBrowse:Activate()

return nil



/*/
{Protheus.doc} MenuDef

@author Marcos Cesar Donizeti Vieira
@since 22/01/2020

@type Function
@param	
@return
/*/
Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar' 	  	ACTION 'PesqBrw'          	OPERATION 1     ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' 	  	ACTION 'VIEWDEF.MGFGFE01' 	OPERATION 2  	ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    	  	ACTION 'VIEWDEF.MGFGFE01' 	OPERATION 3 	ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    	  	ACTION 'VIEWDEF.MGFGFE01' 	OPERATION 4 	ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    		ACTION 'VIEWDEF.MGFGFE01' 	OPERATION 5 	ACCESS 0
	ADD OPTION aRotina TITLE 'Substituir'		ACTION 'U_GFE01SUB'			OPERATION 6		ACCESS 0

Return aRotina



/*/
{Protheus.doc} ModelDef

@author Marcos Cesar Donizeti Vieira
@since 22/01/2020

@type Function
@param	
@return
/*/
Static Function ModelDef()
	Local oStruSZO := FWFormStruct( 1, 'SZO', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel

	oModel:= MPFormModel():New('XMGFGFE01', /*bPreValidacao*/,  , /*bCommit*/, /*bCancel*/ )
	oModel:AddFields('SZOMASTER', /*cOwner*/, oStruSZO, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	oModel:SetDescription("Cadastro de Alcada de Aprovacao")
	oModel:SetPrimaryKey({"ZO_FILIAL","ZO_USUARIO"})
	oModel:GetModel('SZOMASTER'):SetDescription("Cadastro de Alcada de Aprovacao")
Return oModel



/*/
{Protheus.doc} ViewDef

@author Marcos Cesar Donizeti Vieira
@since 22/01/2020

@type Function
@param	
@return
/*/
Static Function ViewDef()

Local oModel   := FWLoadModel( 'MGFGFE01' )
Local oStruSZO := FWFormStruct( 2, 'SZO' )
Local oView

oView:= FWFormView():New()
oView:SetModel( oModel )
oView:AddField( 'VIEW_SZO', oStruSZO, 'SZOMASTER' )
oView:CreateHorizontalBox( 'TELA' , 100 )
oView:SetOwnerView( 'VIEW_SZO', 'TELA' )

Return oView



/*{Protheus.doc} GFE01SUB
Funcao que efetua a montagem da tela da Substituicao do Aprovador.

@author Marcos Cesar Donizeti Vieira
@since 23/01/2020

@type Function
@param	
@return
/*/
User Function GFE01SUB()
	Local oDlg
	Local _cTPAprov
	Local _aArea    	:= GetArea()
	Local _lOk			:= .F.
	Local _lgrv			:= .F.
	Local _aItensAprv	:= {}
	Local _aItensSubs	:= {}
	Local _cUsuario		:= SZO->ZO_USUARIO
	Local oSize			:= FWDefSize():New(.T.)
	Local _cAliasSZO	:= GetNextAlias()

	Private cCadastro := "Substituir Aprovador"

	Private _cCodUsuar	:= SZO->ZO_USUARIO
	Private _cNomUsuar	:= SZO->ZO_NMUSUA                      
	Private _cTPAprov	:= SZO->ZO_TPAPROV
	Private _nVlMin		:= SZO->ZO_VLMIN
	Private _nVlAte		:= SZO->ZO_VLATE

	Private _cCodUsSb	:= SPACE(06)
	Private _cNomUsSb	:= SPACE(40)               
	Private _cMotivo	:= SPACE(60)
	Private _nVlMinSb	:= SZO->ZO_VLMIN
	Private _nVlAteSb	:= SZO->ZO_VLATE
	Private _dVigIni	:= CTOD("//") 
	Private _dVigFin	:= CTOD("//") 

	If SZO->ZO_SUBSTIT = "S"
		Help(NIL, NIL,"SUBSTITUIR APROVADOR", NIL, "Nao � possivel substituir um substituto!", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Escolha um Aprovador Oficial."})
		Return Nil
	EndIf

	BeginSql Alias _cAliasSZO

		SELECT 
			ZO_FILIAL, ZO_TPAPROV
		FROM 
			%Table:SZO% SZO
		WHERE 
			SZO.%notdel% 					AND
			SZO.ZO_USUARIO	=  %Exp:_cUsuario%	
		ORDER BY SZO.ZO_FILIAL, SZO.ZO_USUARIO

	EndSql

	While (_cAliasSZO)->(!Eof())
		If (_cAliasSZO)->ZO_TPAPROV = "1"
			_cTPAprov := "1 - Documento de Frete"
		ElseIf (_cAliasSZO)->ZO_TPAPROV = "2"
			_cTPAprov := "2 - Fatura de Frete"
		ElseIf (_cAliasSZO)->ZO_TPAPROV = "3"
			_cTPAprov := "3 - Aprovacao Ocorrencias"
		ElseIf (_cAliasSZO)->ZO_TPAPROV = "4"
			_cTPAprov := "4 - AJuste de Frete"
		ElseIf (_cAliasSZO)->ZO_TPAPROV = "5"
			_cTPAprov := "5 - Frete Combinado"
		Else
			_cTPAprov := "6 - Todos"
		EndIf
		AAdd(_aItensAprv, {(_cAliasSZO)->ZO_FILIAL,_cUsuario,_cTPAprov})
		(_cAliasSZO)->(dbSkip())
	EndDo
	
	SZO->(DbSetOrder(1))
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM oSize:aWindSize[1],oSize:aWindSize[2] TO oSize:aWindSize[3],oSize:aWindSize[4] PIXEL
	
	ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,	{||_lOk := .T. ,_aItensAprv:=aClone(_aItensAprv),_aItensSubs:=aClone(_aItensSubs), oDlg:End()},;
														{||_lOk := .F., oDlg:End()}),GFE01LAYER(oDlg, @_aItensAprv, @_aItensSubs))
	
	If _lOk
		If Len(_aItensSubs) > 0
			_lgrv := .T.

			dbSelectArea("SZO")
			SZO->(dbSetOrder(2))	//ZO_USUARIO
			If SZO->(dbSeek(_cCodUsSb))
				If dDatabase <= SZO->ZO_VIGFIN 
					Help(NIL, NIL,"SUBSTITUIR APROVADOR", NIL, "H� uma susbstituicao vigente para este usuario!", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Escolha outro usuario ou altere a vig�ncia deste substituto."})
					_lgrv := .F.
				Else
					While !SZO->( EOF() ) .AND. SZO->ZO_USUARIO = _cCodUsSb
						If SZO->ZO_SUBSTIT = "S" 
							RecLock('SZO', .F.)
							SZO->(dbDelete())
							SZO->(MsUnLock())
						EndIf

						SZO->(DBSKIP())	
					EndDo
				EndIf
			EndIf

			If _lgrv
				For i := 1 To Len(_aItensSubs)		
					RecLock("SZO",.T.)
						SZO->ZO_FILIAL		:= _aItensSubs[i][1]
						SZO->ZO_USUARIO		:= _cCodUsSb 
						SZO->ZO_NMUSUA 		:= _cNomUsSb
						SZO->ZO_TPAPROV		:= SUBSTR(_aItensSubs[i][3],1,1)
						SZO->ZO_VLMIN		:= _nVlMinSb 
						SZO->ZO_VLATE  		:= _nVlAteSb                    
						SZO->ZO_VIGINI 		:= _dVigIni  	            
						SZO->ZO_VIGFIN 		:= _dVigFin                  
						SZO->ZO_MOTSUBS		:= _cMotivo
						SZO->ZO_SUBSTIT		:= "S"                     
					MsUnLock()
				Next
				MsgInfo("Cadastro do Substituto criado com sucesso.")
			EndIf
		Else
			Help(NIL, NIL,"SUBSTITUIR APROVADOR", NIL, "Nao foi atribuida nenhuma alcada para o Substituto!", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Refa�a o processo de substitui��o."})
		EndIf
	EndIf
	
	SetKey( VK_F5,{||NIL} )
	RestArea(_aArea)
Return Nil



Static Function GFE01LAYER(oDlg, _aItensAprv,_aItensSubs)
	
	Local _nPercent1
	Local _nPercent2
	Local _nAltura

	Local oFWLayer
	Local oPanel0
	Local oPanel1
	Local oPanel2
	Local oPanel3
	Local oPanel4
	Local oBrowse1
	Local oBrowse2
	Local oNomSubs

	Setkey(VK_F5,{||U_GFE01ALSUB(_aItensSubs, _aItensAprv, @oPanel4, @oBrowse2)})
	
	oPanel0:= tPanel():New(0,0,,oDlg,,,,,,0,0)
	oPanel0:Align := CONTROL_ALIGN_ALLCLIENT
	
	// Cria instancia do fwlayer
	oFWLayer := FWLayer():New()
	
	// Inicializa componente passa a Dialog criada,o segundo parametro � para
	// criacao de um botao de fechar utilizado para Dlg sem cabecalho
	oFWLayer:Init(oPanel0,.F./*,.T.*/)
	
	oPanel0:ReadClientCoors(.T.,.T.)
	_nAltura := oPanel0:nHeight
	
	_nPercent1 := (210 * 100) / _nAltura
	_nPercent2 := 100 - _nPercent1
	
	// Efetua a montagem das linhas das telas
	oFWLayer:addLine("LINHA1",_nPercent1,.T.)
	oFWLayer:addLine("LINHA2",_nPercent2,.F.)
	
	// Efetua a montagem das colunas das telas
	oFWLayer:AddCollumn("BOX1",50,.T.,"LINHA1")
	oFWLayer:AddCollumn("BOX2",50,.T.,"LINHA1")
	
	oFWLayer:AddCollumn("BOX3",50,.T.,"LINHA2")
	oFWLayer:AddCollumn("BOX4",50,.T.,"LINHA2")
	
	// Cria a window passando, nome da coluna onde sera criada, nome da window
	// titulo da window, a porcentagem da altura da janela, se esta habilitada para click,
	// se � redimensionada em caso de minimizar outras janelas e a acao no click do split
	oFWLayer:AddWindow("BOX1","oPanel1","Dados do Aprovador"	,100,.F.,.T.,,"LINHA1",{ || })
	oFWLayer:AddWindow("BOX2","oPanel2","Dados do Substituto"	,100,.F.,.T.,,"LINHA1",{ || })
	
	oFWLayer:AddWindow("BOX3","oPanel3","Alcadas Aprovador"		,100,.F.,.T.,,"LINHA2",{ || })
	oFWLayer:AddWindow("BOX4","oPanel4","Alcadas Substituto"	,100,.F.,.T.,,"LINHA2",{ || })
	
	// Retorna o objeto do painel da Janela
	oPanel1 := oFWLayer:GetWinPanel("BOX1","oPanel1","LINHA1")
	oPanel2 := oFWLayer:GetWinPanel("BOX2","oPanel2","LINHA1")
	
	oPanel3 := oFWLayer:GetWinPanel("BOX3","oPanel3","LINHA2")
	oPanel4 := oFWLayer:GetWinPanel("BOX4","oPanel4","LINHA2")

	// Dados do Aprovador
	@ 07,002 SAY RetTitle("ZO_USUARIO")					OF oPanel1 														PIXEL
	@ 05,037 MSGET _cCodUsuar				SIZE 50,10	OF oPanel1	WHEN .F.											PIXEL 	 
	
	@ 07,120 SAY RetTitle("ZO_NMUSUA ") 				OF oPanel1 														PIXEL
	@ 05,160 MSGET _cNomUsuar				SIZE 150,10	OF oPanel1	WHEN .F.											PIXEL	  

	@ 27,002 SAY RetTitle("ZO_VLMIN") 					OF oPanel1														PIXEL
	@ 25,037 MSGET _nVlMin					SIZE 65,10	OF oPanel1	WHEN .F. 	PICTURE PesqPict("SZO","ZO_VLMIN")		PIXEL
	
	@ 27,120 SAY RetTitle("ZO_VLATE") 					OF oPanel1 														PIXEL
	@ 25,160 MSGET _nVlAte					SIZE 65,10	OF oPanel1	WHEN .F. 	PICTURE PesqPict("SZO","ZO_VLATE")	 	PIXEL

	// Dados do Aprovador substituto
	@ 07,002 SAY "Usuario Subs"							OF oPanel2														PIXEL
	@ 05,037 MSGET _cCodUsSb				SIZE 50,10	OF oPanel2	F3 "USGFE1"	 										PIXEL
	
	@ 07,120 SAY RetTitle("ZO_NMUSUA ") 				OF oPanel2 														PIXEL
	@ 05,160 MSGET oNomSubs VAR _cNomUsSb	SIZE 150,10	OF oPanel2	WHEN .F. 	 										PIXEL

	@ 27,002 SAY RetTitle("ZO_VLMIN") 					OF oPanel2														PIXEL
	@ 25,037 MSGET _nVlMinSb				SIZE 65,10	OF oPanel2	WHEN .F.	PICTURE PesqPict("SZO","ZO_VLMIN")	 	PIXEL
	
	@ 27,120 SAY RetTitle("ZO_VLATE") 					OF oPanel2														PIXEL
	@ 25,160 MSGET _nVlAteSb				SIZE 65,10	OF oPanel2	WHEN .F. 	PICTURE PesqPict("SZO","ZO_VLATE")	 	PIXEL

	@ 47,002 SAY RetTitle("ZO_VIGINI") 					OF oPanel2														PIXEL
	@ 45,037 MSGET _dVigIni					SIZE 65,10	OF oPanel2	VALID _dVigIni >= Date()							PIXEL
	
	@ 47,120 SAY RetTitle("ZO_VIGFIN") 					OF oPanel2 	 													PIXEL
	@ 45,160 MSGET _dVigFin					SIZE 65,10	OF oPanel2	VALID _dVigFin >= _dVigIni							PIXEL

	@ 67,2 SAY "Motivo"									OF oPanel2 														PIXEL
	@ 65,35 MSGET _cMotivo 					SIZE 200,10	OF oPanel2	PICTURE PesqPict("SZO","ZO_MOTSUBS")				PIXEL	

	TButton():Create(oPanel2,37,240,"Copiar Alcadas (F5)",{||U_GFE01ALSUB(_aItensSubs, _aItensAprv, @oPanel4, @oBrowse2)},70,13,,,,.T.,,"Copiar Alcadas (F5)",,,,)
	
	// Carga de dados das alcadas do Aprovador
	DEFINE FWBROWSE oBrowse1 DATA ARRAY ARRAY _aItensAprv NO CONFIG  NO REPORT NO LOCATE OF oPanel3
	
		ADD COLUMN oColumn DATA { || _aItensAprv[oBrowse1:At(),1] } TITLE "Filial" 			HEADERCLICK�{�||�.T.�} 	OF oBrowse1
		ADD COLUMN oColumn DATA { || _aItensAprv[oBrowse1:At(),2] } TITLE "Cod.Usuario" 	HEADERCLICK�{�||�.T.�}	OF oBrowse1
		ADD COLUMN oColumn DATA { || _aItensAprv[oBrowse1:At(),3] } TITLE "Tipo Aprov." 	HEADERCLICK�{�||�.T.�} 	OF oBrowse1

		oBrowse1:bOnMove := {|oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow| U_GFE01MOVE(oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow,oBrowse1,oBrowse2)}
		oBrowse1:SetLineHeight(25)
	
	ACTIVATE FWBROWSE oBrowse1

	// Carga de dados das alcadas do Substituto
	DEFINE FWBROWSE oBrowse2 DATA ARRAY ARRAY _aItensSubs NO CONFIG  NO REPORT NO LOCATE OF oPanel4

		ADD COLUMN oColumn DATA { || _aItensSubs[oBrowse2:At(),1] } TITLE "Filial" 			HEADERCLICK�{�||�.T.�} 	OF oBrowse2
		ADD COLUMN oColumn DATA { || _aItensSubs[oBrowse2:At(),2] } TITLE "Cod.Usuario" 	HEADERCLICK�{�||�.T.�}	OF oBrowse2
		ADD COLUMN oColumn DATA { || _aItensSubs[oBrowse2:At(),3] } TITLE "Tipo Aprov." 	HEADERCLICK�{�||�.T.�} 	OF oBrowse2
	
		oBrowse2:bOnMove := {|oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow| U_GFE01MOVE(oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow,oBrowse1,oBrowse2)}
		oBrowse2:SetLineHeight(25)
	
	ACTIVATE FWBROWSE oBrowse2
	
Return



/*/{Protheus.doc} GFE01MOVE
Funcao responsavel por atualizar cursor nas linhas do Browser.

@author Marcos Cesar Donizeti Vieira
@since 24/01/2020

@type Function
@param	
@return
/*/
User Function GFE01MOVE(oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow,oBrowse1,oBrowse2)
	
	oBrowse1:OnMove(oBrowse1:oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow)
	oBrowse2:OnMove(oBrowse2:oBrowse,nMoveType,nCursorPos,nQtdLinha,nVisbleRow)
	
Return Nil



/*/{Protheus.doc} GFE01ALSUB
Funcao responsavel por atualizar cursor nas linhas do Browser.

@author Marcos Cesar Donizeti Vieira
@since 24/01/2020

@type Function
@param	
@return
/*/
User Function GFE01ALSUB(_aItensSubs, _aItensAprv, oPanel4, oBrowse2 )

	Local _lRet := .T.

	If EMPTY(_cCodUsSb)
		Help(NIL, NIL,"SUBSTITUTO", NIL, "Codigo do Usuario Subs nao preenchido!", 1, 0, NIL, NIL, NIL, NIL, NIL, {'Selecione um usuario valido.'})
    	_lRet := .F.
	ElseIf EMPTY(_dVigIni)
		Help(NIL, NIL,"SUBSTITUTO", NIL, "Vigencia Ini nao preenchido!", 1, 0, NIL, NIL, NIL, NIL, NIL, {'Preencha com uma data valida.'})
    	_lRet := .F.
	ElseIf EMPTY(_dVigFin)
		Help(NIL, NIL,"SUBSTITUTO", NIL, "Vigencia Fin nao preenchido!", 1, 0, NIL, NIL, NIL, NIL, NIL, {'Preencha com uma data valida.'})
    	_lRet := .F.
	ElseIf EMPTY(_cMotivo)
		Help(NIL, NIL,"SUBSTITUTO", NIL, "Motivo nao preenchido!", 1, 0, NIL, NIL, NIL, NIL, NIL, {'Preencha com um Motivo valido.'})
    	_lRet := .F.
	EndIf
	
	If _lRet
		_aItensSubs := aClone(_aItensAprv)
		
		oBrowse2:Show()
		oPanel4:lVisible := .T.
		oBrowse2:SetArray(_aItensAprv)
		oBrowse2:Refresh(.T.)
		Setkey(VK_F5,{||U_GFE01ALSUB(_aItensSubs, _aItensAprv, @oPanel4, @oBrowse2)})
	EndIf
				
Return _lRet



/*/{Protheus.doc} GFE01VLDSUB
Funcao responsavel por validar substutos quanto a vig�ncia.

@author Marcos Cesar Donizeti Vieira
@since 2/01/2020

@type Function
@param	
@return
/*/
User Function GFE01VLDSUB()
	Local _lRet := .T.

	//--------------| Verifica existencia de parametros e caso nao exista cria. |-------------------------
	If !ExisteSx6("MGF_GFE01A")
		CriarSX6("MGF_GFE01A", "L", "Flag para habilitar ou nao a funcao" , ".T." )	
	EndIf

	If SUPERGETMV("MGF_GFE01A",.F., '.T.' )
		If SZO->ZO_SUBSTIT	= "S"  
			If dDatabase < SZO->ZO_VIGINI .OR. dDatabase > SZO->ZO_VIGFIN 
				Help(NIL, NIL,"SUBSTITUTO", NIL, "Substituto Aprovador fora do per�odo de Vigencia!", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Altere o per�odo de vig�ncia."}) 
				_lRet := .F.
			EndIf             
		EndIf
	EndIF
	 	
Return _lRet



/*
=========================================================================================================
Programa.................: GFEA0851
Autor:...................: Flavio Dentello
Data.....................: 05/12/2016
Descricao / Objetivo.....: Controle de aprovacoes de ajustes baseado no cadastro de aprovadores
Doc. Origem..............: GAP - GFE02
Solicitante..............: 
Uso......................: 
Obs......................: Criado ponto de entrada para o controle de aprovacoes de ajustes conforme tabela de aprovadores
=========================================================================================================
*/
User Function GFE0202()

	Local cCodUser	:= RetCodUsr() //Retorna o Codigo do Usuario
	Local lRet 		:= .F.  
	Local lMsg 		:= .F.
	Local xRet 		:= .F.
							
	dBselectArea("SZO")
	SZO->(dbSetOrder(1))//ZO_FILIAL+ZO_USUARIO
	If SZO->(dbSeek(xFilial("SZO")+cCodUser))
		While !SZO->(eof()) .AND. (SZO->ZO_USUARIO = cCodUser ) .AND. !lRet .AND. U_GFE01VLDSUB()
				If SZO->ZO_TPAPROV $ '46'
					If GWO->GWO_VLAJUS >= SZO->ZO_VLMIN .AND. GWO->GWO_VLAJUS <= SZO->ZO_VLATE		
						lRet := .T.
						lMsg := .T.
					Else		
						lMsg := .F.
					EndIf		
				Else		
					lMsg := .F.
				EndIf	
			SZO->(DBSKIP())	 
		Enddo
		
	Else                
		If lMsg = .F.
			Alert("usuario sem permissao para aprovacao!")           
			xRet := .T.
		EndIf
	EndIf            
	If xRet <> .T.
		If lMsg = .F.
			Alert("usuario sem permissao para aprovacao!")
		EndIf
	EndIf

Return lRet

                           


/*
=========================================================================================================
Programa.................: GFEA032E
Autor:...................: Flavio Dentello
Data.....................: 06/09/2016
Descricao / Objetivo.....: Controle de aprovacoes de ocorrencias baseado no cadastro de alcada de aprovacao
Doc. Origem..............: GAP - GFE02
Solicitante..............: 
Uso......................: 
Obs......................: Criado ponto de entrada para o controle de aprovacoes de ocorrencias conforme tabela de aprovadores
=========================================================================================================
*/                                                                                                                                                             
User Function GFE0203()                  
	Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
	Local lRet := .F.
	Local lMsg := .F.

	dBselectArea("SZO")
	SZO->(dbSetOrder(1))//ZO_FILIAL+ZO_USUARIO
	If SZO->(dbSeek(xFilial("SZO")+cCodUser))                  
		While !SZO->(eof()) .AND. (SZO->ZO_USUARIO = cCodUser )	 .AND. !lRet .AND. U_GFE01VLDSUB()	
				If SZO->ZO_TPAPROV $ '36'           
					lRet := .T.	 
					lMsg := .F.
				Else                                                                            
					lMsg := .T.
				EndIf	
			SZO->(DBSKIP())	 
		Enddo
	Else
		lMsg := .T.	 
	EndIf	

	If lMsg = .T.
		Alert("usuario sem permissao para aprovacao da ocorrencia!")        	
	EndIf
Return lRet                                                            



/*
=========================================================================================================
Programa.................: GFEA0662
Autor:...................: Flavio Dentello
Data.....................: 06/09/2016
Descricao / Objetivo.....: Criado ponto de entrada para o controle de aprovacoes de Documentos de Frete
Doc. Origem..............: GAP - GFE02
Solicitante..............: 
Uso......................: 
Obs......................: Criado ponto de entrada para o controle de aprovacoes de Documentos de Frete
=========================================================================================================
*/                                                                                  
User Function GFE0204()
    Local cfilter           := ""
    Local cFiltroPadrao     := ParamIxb[1]
	Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
	Local cTipAprov := ""
	Local nValmin := 0
	Local nValate := 0                  
	Local lMsg1 := .T.                
	Local lMsg2 := .F.
	
	dBselectArea("SZO")
	SZO->(dbSetOrder(1))//ZO_FILIAL+ZO_USUARIO
	If SZO->(dbSeek(xFilial("SZO")+cCodUser))  
		If U_GFE01VLDSUB() 
			While !SZO->(eof()) .AND. (SZO->ZO_USUARIO = cCodUser )	.AND. lMsg1
				cTipAprov := SZO->ZO_TPAPROV
				nValmin := SZO->ZO_VLMIN
				nValate := SZO->ZO_VLATE	
				If cTipAprov $ '16'
					cfilter :=  cFiltroPadrao  + " .and. GW3_SIT == '2' "	             
					cfilter +=  " .and. GW3_VLDF >= " + Alltrim(Str(nValmin)) 	    	    
					cfilter +=  " .and. GW3_VLDF <= " + Alltrim(Str(nValate)) 	    	    	    
					lMsg1 := .F.
				Else  
					lMsg1 := .T.
					cfilter :=  cFiltroPadrao  + " .AND. GW3_VLDF = '0' "			    
				EndIf    
				SZO->(dBskip())
			Enddo
		Else
			cfilter :=  cFiltroPadrao  + " .AND. GW3_VLDF = '0' "
			lMsg2 := .F.
		EndIf
	Else
		lMsg2 := .T.
		cfilter :=  cFiltroPadrao  + " .AND. GW3_VLDF = '0' "	
	EndIf
	If lMsg1 = .T.
		MsgAlert ("Usuario aprovador nao tem permissao para realizar aprovacoes de Documentos de Frete! Os registros bloqueados nao serao apresentados ao usuario!")         			    
	EndIf   
	      
	If lMsg2 = .T.                                                       
		MsgAlert ("Usuario sem permissao para realizar aprovacoes! Os registros bloqueados nao serao apresentados ao usuario!")          		    
	EndIf
Return cfilter         


/*
=========================================================================================================
Programa.................: GFEA0714
Autor:...................: Flavio Dentello
Data.....................: 06/09/2016
Descricao / Objetivo.....: Cadastro de alcada de aprovacao
Doc. Origem..............: GAP - GFE02
Solicitante..............: 
Uso......................: 
Obs......................: Criado ponto de entrada para o controle de aprovacoes de Faturas de Frete conforme tabela de aprovadores
=========================================================================================================
*/                                                                                  
User Function GFE0205()
    Local cfilter       := ""
    Local cFiltroPadrao  := ParamIxb[1]
	Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
	Local cTipAprov := ""
	Local nValmin := 0
	Local nValate := 0
	Local lMsg1 := .F.
	Local lMsg2 := .F.
	
	dBselectArea("SZO")
	SZO->(dbSetOrder(1))//ZO_FILIAL+ZO_USUARIO
	If SZO->(dbSeek(xFilial("SZO")+cCodUser))	
		If U_GFE01VLDSUB()                                               
			While !SZO->(eof()) .AND. SZO->ZO_USUARIO = cCodUser
				cTipAprov := SZO->ZO_TPAPROV
				nValmin := SZO->ZO_VLMIN
				nValate := SZO->ZO_VLATE
								
				If cTipAprov $ '26'
					cfilter :=  cFiltroPadrao  +  " .and. GW6_SITAPR== '2'"                     
					cfilter +=  " .and. GW6_VLFATU >= " + Alltrim(Str(nValmin)) 	    	    
					cfilter +=  " .and. GW6_VLFATU <= " + Alltrim(Str(nValate)) 	    	        
					lMsg1 := .F.
				Else              
					lMsg1 := .T.
					cfilter :=  cFiltroPadrao  + " .and. GW6_VLFATU = '0' "
				EndIf
				SZO->(dbSkip())
			Enddo	
		Else
			cfilter :=  cFiltroPadrao  + " .and. GW6_VLFATU = '0' "
			lMsg2 := .F.
		EndIf                                               
	Else
		lMsg2 := .T.
		cfilter :=  cFiltroPadrao  + " .AND. GW6_VLFATU = '0' "	
	EndIf
If lMsg1 = .T.
	MsgAlert ("Usuario sem permissao para realizar aprovacoes!" + "Portanto os registros bloqueados nao serao apresentados ao usuario")         		
EndIf	 

If lMsg2 = .T.
	MsgAlert ("Usuario sem permissao para realizar aprovacoes!" + "Portanto os registros bloqueados nao serao apresentados ao usuario")         		
EndIf	 

Return cfilter