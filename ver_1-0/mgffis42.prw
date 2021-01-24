#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH' 
#include "totvs.ch"
#include "topconn.ch"
#include "tbiconn.ch"                            
#include "parmtype.ch"
#include "rwmake.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} MGFFIS42
GAP 366 - Bloqueio para apuração de ICMS

Rotina para cadastro de bloqueio de períodos.
Desenvolver uma rotina em MVC dentro do arquivo MGFFIS42.PRW para manutenção
 do cadastro de bloqueio de períodos utilizando a estrutura da tabela ZCG.

@author Natanael Simões
@since 22/01/2019
@version P12.1.17
/*/
//-------------------------------------------------------------------
User Function MGFFIS42()
Local oBrowse

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('ZCG')
oBrowse:SetDescription('Bloqueio de apuração de ICMS')
oBrowse:Activate()

Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE '&Visualizar' ACTION 'VIEWDEF.MGFFIS42' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE '&Incluir'    ACTION 'VIEWDEF.MGFFIS42' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE '&Alterar'    ACTION 'VIEWDEF.MGFFIS42' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE '&Excluir'    ACTION 'VIEWDEF.MGFFIS42' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE '&Fechto Geral'  ACTION 'u_MANPAR53'       OPERATION 6 ACCESS 0
ADD OPTION aRotina TITLE 'Im&primir'   ACTION 'VIEWDEF.MGFFIS42' OPERATION 8 ACCESS 0

//ADD OPTION aRotina TITLE '&Copiar'     ACTION 'VIEWDEF.MGFFIS42' OPERATION 9 ACCESS 0 //Se habilitar a cópia, deve ser tratado o auto-incremental do ZCG_SEQ 
Return aRotina


//-------------------------------------------------------------------
Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados
Local oStruZCG := FWFormStruct( 1, 'ZCG', /*bAvalCampo*/,/*lViewUsado*/ )
Local oModel
 

// Cria o objeto do Modelo de Dados
oModel := FWModelActive()
oModel := MPFormModel():New('XMGFFIS42', /*bPreValidacao*/, { |oModel| FIS42POS( oModel )}, /*bCommit*/, /*bCancel*/ )

// Adiciona ao modelo uma estrutura de formulário de edição por campo
oModel:AddFields( 'ZCGMASTER', /*cOwner*/, oStruZCG,  /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

// Adiciona a descricao do Modelo de Dados
oModel:SetDescription( 'Bloqueio de apuração de ICMS' )
oModel:SetPrimaryKey({"ZCG_FILIAL+ZCG_ANO+ZCG_MES"})

// Adiciona a descricao do Componente do Modelo de Dados
oModel:GetModel( 'ZCGMASTER' ):SetDescription( 'Bloqueio de apuração de ICMS' )

Return oModel


//-------------------------------------------------------------------
Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
Local oModel   := FWLoadModel('MGFFIS42')
// Cria a estrutura a ser usada na View
Local oStruZCG := FWFormStruct( 2, 'ZCG' )
Local oView
Local cCampos := {}

// Crio os Agrupamentos de Campos  
// AddGroup( cID, cTitulo, cIDFolder, nType )   nType => ( 1=Janela; 2=Separador )
oStruZCG:AddGroup( 'GRUPO01', 'Período', '', 2 )

oStruZCG:SetProperty( '*'         , MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )

// Cria o objeto de View
oView := FWFormView():New()

// Define qual o Modelo de dados será utilizado
oView:SetModel( oModel )

//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
oView:AddField('VIEW_ZCG', oStruZCG, 'ZCGMASTER')

// Criar um "box" horizontal para receber algum elemento da view
oView:CreateHorizontalBox( 'TELA' , 100 )

// Relaciona o ID da View com o "box" para exibicao
oView:SetOwnerView( 'VIEW_ZCG', 'TELA' )

Return oView


//-------------------------------------------------------------------
Static Function FIS42POS( oModel )
Local nOperation := oModel:GetOperation()
Local lRet       := .T.

// Inclusão dos registros
If nOperation == 3
	// Valida se o cadastro já existe
	If !Vazio(Posicione("ZCG",1,xFilial("ZCG")+Alltrim(STR(M->ZCG_ANO))+Alltrim(STR(M->ZCG_MES)),"ZCG_STAT"))
		Help( ,, 'MGFFIS42',, 'Registro/Combinação já existente na Base de Dados', 1, 0)
		lRet := .F.
	EndIf
	
EndIf

Return lRet

//-------------------------------------------------------------------
Static Function FIS42ACT( oModel )  // Passa o model sem dados
Local aArea      := GetArea()
Local cQuery     := ''
Local cTmp       := ''
Local lRet       := .T.
Local nOperation := oModel:GetOperation()

RestArea( aArea )

Return lRet


//--------------------------------------------------------------------
/*t1005551
=====================================================================================
Programa............: MANPAR53
Autor...............: Wagner Neves
Data................: 16/03/2020
Descricao / Objetivo: Este programa serve para alterar o parâmetro que controla bloqueio apuração do ICMS
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/

User Function MANPAR53()

Local _cUsuarios := GETMV("MGF_FIS43B")
Local cTitulo := ""
Local _aFields := {}
Local aAlter   := {}
Local aButtons := {}

If !__cUserId $ _cUsuarios
	Alert("Somente o Administrador ou usuários autorizados podem executar esta rotina.")
	Return
EndIf
Private oDlg, oMainWnd
Private _oGroupRod
Private _oFont 
 
Public _aColsEx := {}
Public _aHeader := {}
Private oGetD
cTitulo  := "Fechamento Geral (Todas as Filiais) para Apuração do ICMS"

DEFINE MSDIALOG oDlg TITLE cTitulo From 09,00 to 40,101 of oMainWnd
_oGroupRod := TGroup():New(015,010,220,390,cTitulo,oDlg,,,.T.) 
_aHeader := {"Filial  ","Parametro  ","Descrição do Parametro  ","Data  "}
DbSelectArea("SM0")  
DbSelectArea('SX6')
SX6->(DbSetOrder(1))        
SX6->(Dbseek("      "+"MGF_FIS43A"))
Aadd(_aFields, {SX6->X6_FIL,"MGF_FIS43A",SX6->X6_DESCRIC,STOD(SX6->X6_CONTEUD)})
Aadd(_aColsEx, _aFields)
_oBrw := TWBrowse():New(035,015,370,190,,_aHeader,_aColsEx,oDlg,,,,,,,,,,,,.T.,,.T.,,.F.)
_oBrw:SetArray(_aFields)
_oBrw:bLine      := {|| {_aFields[_oBrw:nAT,1],_aFields[_oBrw:nAT,2],_aFields[_oBrw:nAT,3],_aFields[_oBrw:nAT,4]}}
_oBrw:bLDblClick := {|| Edita(@_aFields)}
oDlg:bInit := {|| EnchoiceBar(oDlg, {|| xaltpar_B(@_aFields)}, {||oDlg:End()},,, )}
oDlg:lCentered := .T.
oDlg:Activate()
Return()
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function Edita(aArr)
LEDITCELL(@aArr,_oBrw,"",4)
Return .T.
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function xaltpar_B(aArr)
Local cret:=.f.
Local cfilorig := cfilant
Local aArea := getArea()
Local culmes	 := ""		
Local cdatafis := ""		
Local cdatafin := ""
iif(msgyesno("Confirma a alteração do parâmetro ?"),cret:=.t.,cret:=.f.)
if cret == .t.
	for nx := 1 to Len(aArr)  	
		cfilant := aArr[nx][1]
		If(ALLTRIM(aArr[nx][2])=="MGF_FIS43A")			
			cdatafis := DTOS(aArr[nx][4])
			putmv("MGF_FIS43A",cdatafis)		
		EndIf
	next nx
	msginfo("O parâmetro foi alterado com sucesso !")
endif
cfilant := cfilorig      
restArea(aArea)
Return(Close(oDlg))