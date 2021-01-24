//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Vari�veis Est�ticas
Static cTitulo := "Log de Par�metros de Fechamento"

/*/{Protheus.doc} MGFCTB33
Browse e fun��o para visualizar o Log dos parametros de fechamento
@author Renato Junior
@since 25/03/2020
@version 1.0
	@return Nil, Fun��o n�o tem retorno
/*/
User Function MGFCTB33()
	Local aArea   := GetArea()
	Local oBrowse
	Local cFunBkp := FunName()
	
	SetFunName("MGFCTB33")
	
	//Inst�nciando FWMBrowse - Somente com dicion�rio de dados
	oBrowse := FWMBrowse():New()
	
	//Setando a tabela
	oBrowse:SetAlias("ZG3")
	//Setando a descri��o da rotina
	oBrowse:SetDescription(cTitulo)
	
	//Ativa a Browse
	oBrowse:Activate()
	
	SetFunName(cFunBkp)
	RestArea(aArea)
Return Nil
/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Renato Junior                                                |
 | Data:  25/03/2020                                                   |
 | Desc:  Cria��o do menu MVC                                          |
 *---------------------------------------------------------------------*/
Static Function MenuDef()
	Local aRot := {}
	
	//Adicionando op��es
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.MGFCTB33' OPERATION 2 ACCESS 0 //OPERATION 1    // MODEL_OPERATION_VIEW

Return aRot
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Renato Junior                                                |
 | Data:  25/03/2020                                                   |
 | Desc:  Cria��o do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
Static Function ModelDef()
	//Cria��o do objeto do modelo de dados
	Local oModel := Nil
	
	//Cria��o da estrutura de dados utilizada na interface
	Local oStZG3 := FWFormStruct(1, "ZG3")
	
	//Instanciando o modelo, n�o � recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
	oModel := MPFormModel():New("CTB33Model",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
	
	//Atribuindo formul�rios para o modelo
	oModel:AddFields("FORMZG3",/*cOwner*/,oStZG3)
	
	//Setando a chave prim�ria da rotina
	oModel:SetPrimaryKey({'ZG3_FILIAL','ZG3_DATA','ZG3_HORA'})
	
	//Adicionando descri��o ao modelo
	oModel:SetDescription("Dados do Cadastro "+cTitulo)
	
	//Setando a descri��o do formul�rio
	oModel:GetModel("FORMZG3"):SetDescription("Formul�rio do Cadastro "+cTitulo)
Return oModel
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Renato Junior                                                |
 | Data:  25/03/2020                                                   |
 | Desc:  Cria��o da vis�o MVC                                         |
 *---------------------------------------------------------------------*/
Static Function ViewDef()
	Local aStruZG3	:= ZG3->(DbStruct())
	
	//Cria��o do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
	Local oModel := FWLoadModel("MGFCTB33")
	
	//Cria��o da estrutura de dados utilizada na interface do cadastro de Autor
	Local oStZG3 := FWFormStruct(2, "ZG3")  //pode se usar um terceiro par�metro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZZ1_NOME|SZZ1_DTAFAL|'}
	
	//Criando oView como nulo
	Local oView := Nil
	//Criando a view que ser� o retorno da fun��o e setando o modelo da rotina
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//Atribuindo formul�rios para interface
	oView:AddField("VIEW_ZG3", oStZG3, "FORMZG3")
	
	//Criando um container com nome tela com 100%
	oView:CreateHorizontalBox("TELA",100)
	
	//Colocando t�tulo do formul�rio
	oView:EnableTitleView('VIEW_ZG3', 'Dados - '+cTitulo )  
	
	//For�a o fechamento da janela na confirma��o
	oView:SetCloseOnOk({||.T.})
	
	//O formul�rio da interface ser� colocado dentro do container
	oView:SetOwnerView("VIEW_ZG3","TELA")
	
Return oView
