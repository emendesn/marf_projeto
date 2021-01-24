#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
 
/*/
==============================================================================================================================================================================
{Protheus.doc} MGFEEC74 
Inclusão na tabela SX5 Z1

@description
Tabela Z1 da SX5 que será utilizada na funcionalidade de despesas de despachante EEC


@author Marcelo de Almeida Carneiro
@since 08/11/2019
@type Function 

@table 
    SX5 - Z1 - Fornecedor da Despesa

@param
    
@return
    
@menu
    EEC - Atualizações - Especificos Marfrig - Fornecedor Despesa

@history

/*/   
 
User Function MGFEEC74()

Local oBrowse

Private cTitulo  := "Inclusão de Fornecedores da Despesa"
Private cTab     := 'Z1'

DbSelectArea('SX5')
SX5->(DbSetOrder(1)) // X5_FILIAL+X5_TABELA+X5_CHAVE
SX5->(DbGoTop())
     
        
oBrowse := FWMBrowse():New()
oBrowse:SetAlias("SX5")
oBrowse:SetDescription(cTitulo)
oBrowse:SetOnlyFields( { 'X5_CHAVE','X5_DESCRI' } ) 
oBrowse:SetFilterDefault("SX5->X5_TABELA = '"+cTab+"' ")
oBrowse:Activate()
    
Return
************************************************************************************************************************
Static Function MenuDef()

Local aRot := {}
    
ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.MGFEEC74' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.MGFEEC74' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.MGFEEC74' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.MGFEEC74' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return aRot
************************************************************************************************************************
Static Function ModelDef()

Local oModel := Nil
Local oStSX5 := FWFormStruct(1, "SX5")
    
//Editando características do dicionário
oStSX5:SetProperty('X5_TABELA',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                       //Modo de Edição
oStSX5:SetProperty('X5_TABELA',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'cTab'))                     //Ini Padrão
oStSX5:SetProperty('X5_CHAVE',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    'Iif(INCLUI, .T., .F.)'))     //Modo de Edição
oStSX5:SetProperty('X5_CHAVE',    MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'u_zSX5Chv()'))               //Validação de Campo
oStSX5:SetProperty('X5_CHAVE',    MODEL_FIELD_OBRIGAT, .T. )                                                                //Campo Obrigatório
oStSX5:SetProperty('X5_DESCRI',   MODEL_FIELD_OBRIGAT, .T. )                                                                //Campo Obrigatório
        
oModel := MPFormModel():New("zCadSX5M",/*bPre*/,/*bPos*/,/*bCommit*/,/*bCancel*/) 
oModel:AddFields("FORMSX5",/*cOwner*/,oStSX5)
oModel:SetPrimaryKey({'X5_FILIAL', 'X5_TABELA', 'X5_CHAVE'})
oModel:SetDescription(cTitulo)
oModel:GetModel("FORMSX5"):SetDescription(cTitulo)
Return oModel
************************************************************************************************************************ 
Static Function ViewDef()

Local oModel := FWLoadModel("MGFEEC74")
Local oStSX5 := FWFormStruct(2, "SX5")  
Local oView := Nil

oView := FWFormView():New()
oView:SetModel(oModel)
oView:AddField("VIEW_SX5", oStSX5, "FORMSX5")
oView:CreateHorizontalBox("TELA",100)
oView:EnableTitleView('VIEW_SX5', 'Dados - '+cTitulo )  
oView:SetCloseOnOk({||.T.})
oView:SetOwnerView("VIEW_SX5","TELA")
oStSX5:RemoveField("X5_TABELA")
oStSX5:RemoveField("X5_DESCSPA")	
oStSX5:RemoveField("X5_DESCENG")
Return oView

************************************************************************************************************************ 
User Function zSX5Chv()

Local aArea    := GetArea()
Local lRet     := .T.
Local cX5Chave := M->X5_CHAVE
    
If SX5->(DbSeek(FWxFilial('SX5') +  cTab + cX5Chave))
    Help('',1, 'Chave duplicada' ,, 'Já existe chave para o codigo !',1,0)  
    lRet := .F.
EndIf
    
RestArea(aArea)
Return lRet