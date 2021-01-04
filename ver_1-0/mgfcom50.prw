#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "DIALOG.CH"
#INCLUDE "FONT.CH"
#INCLUDE "FWCOMMAND.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE xMarcado      1 // Marcado/Desmarcado
#DEFINE xCodigo       2 // Codigo do registro
#DEFINE xDescric      3 // Descricao da Obs  
#DEFINE xNumColunas   3

Static MGF_COM45  

User Function MGFCOM50()

Local aArea      := GetArea()

Local cCodigos   := ""

Local nOpca      := 0
Local nLoop      := 0
Local nX

Local oBold
Local oBmp
Local oBut1 
Local oBut2

Local lTodos     := .F.
Local cFilCtr    := cFilAnt
Local _cTexto    := ""
Local _nPos      := 0

Local oSize 	 := FwDefSize():New()

Private oOk        := LoadBitmap( GetResources(), "LBOK" )
Private oNOk       := LoadBitmap( GetResources(), "LBNO" )

Private cQuery     := ""
Private cAliasQry  := ""
Private cXObsAux 
Private  oList, oDlg
Private _aListBox := {}


MGF_COM45 := SC7->C7_ZCODOBS

GeraQuery()  

If len(_aListBox)=0    // Tratamento para caso ja existe o List e ja estao marcados, continuarem marcados
	While !( cAliasQry )->( Eof() )   
		_cTexto := Alltrim(MGF_COM45)
	    _nPos   := AT((cAliasQRY)->ZAO_COD,_cTexto)                                                     
		AAdd( _aListBox, Array(xNumColunas))
		Atail(_aListBox)[xMarcado] := If( _nPos > 0 , .T. , .F. )  //If( Empty((cAliasQRY)->ZAO_COD),.F.,.F.)
		Atail(_aListBox)[xCodigo]  := ( cAliasQRY )->ZAO_COD   
		Atail(_aListBox)[xDescric] := ( cAliasQRY )->ZAO_DESCRIC
		( cAliasQry )->( dbSkip() )
	EndDo
Endif
                 
( cAliasQRY )->( dbCloseArea() )

//+----------------------------------------------------------------------------
//| Definicao da janela e seus conte�dos
//+----------------------------------------------------------------------------
DEFINE MSDIALOG oDlg TITLE "Cadastro de Observa��es" FROM 0,0 TO 282,552 OF oDlg PIXEL
DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

//@ 03, 40 SAY "Observa��es"  FONT oBold PIXEL
@ 03, 30 TO 16 ,250 LABEL ''  OF oDlg PIXEL

oList := TWBrowse():New(20, 10, 255, 108 ,,{ "","Codigo","Observa��es",},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)

oList:SetArray(_aListBox)

oList:bLine := { || { If(  _aListBox[oList:nAT,xMarcado]=.T., oOk, oNOK ),;
                           _aListBox[oList:nAt,xCodigo]  ,;
                           _aListBox[oList:nAt,xDescric] }}                          
oList:bLDblClick := { || OBS001MkCron()}

@ 130,025 CheckBox oTodos Var lTodos Prompt "Marcar Todos" Size 060, 015 PIXEL OF oDlg On Click MarDes( lTodos )
//@ 130,145 BUTTON "Incluir" SIZE 35,11 ACTION {|| IncObs(oList),GeraQuery() } OF oDlg PIXEL  
DEFINE SBUTTON oBut1 FROM 130, 188 TYPE 1 ACTION ( nOpca := 1, oDlg:End() ) ENABLE of oDlg 
DEFINE SBUTTON oBut2 FROM 130, 220 TYPE 2 ACTION ( nOpca := 0, oDlg:End() ) ENABLE of oDlg


ACTIVATE MSDIALOG oDlg CENTERED
 

For nLoop := 1 to Len(_aListBox)
    IF _aListBox[nLoop,1] = .T.
        cCodigos += _aListBox[nLoop,2] + ","
    ENDIF
Next
  
cXObsAux := cCodigos
MGF_COM45:= cCodigos
RestArea( aArea )


Return(.T.)  


//-------------------------------------------------------------------
user function VCOM045()
return(MGF_COM45)
  

//���������������������������������������������Ŀ
//� Incluir Observacao                          �
//�����������������������������������������������
Static Function IncObs(oList)
Local _cFunction  := ""
Local nRowList
Local cPict
Local oDlgGet
Local oDlgBtn
Local aDim := {}
Local oRect:= tRect():New(0,0,0,0) // obt�m as coordenadas da c�lula

_cFunction := FUNNAME()

u_xCadObs()

GeraQuery()

If len(_aListBox)=0    // Tratamento para caso ja existe o List e ja estao marcados, continuarem marcados
	While !( cAliasQry )->( Eof() )                                                        
		AAdd( _aListBox, Array(xNumColunas))
		Atail(_aListBox)[xMarcado] := If( Empty((cAliasQRY)->ZAO_COD),.F.,.F.)
		Atail(_aListBox)[xCodigo]  := ( cAliasQRY )->ZAO_COD   
		Atail(_aListBox)[xDescric] := ( cAliasQRY )->ZAO_DESCRIC
		( cAliasQry )->( dbSkip() )
	EndDo
Endif

oList:SetArray(_aListBox)

oList:bLine := { || { If(  _aListBox[oList:nAT,xMarcado]=.T., oOk, oNOK ),;
                           _aListBox[oList:nAt,xCodigo]  ,;
                           _aListBox[oList:nAt,xDescric] }}                          
oList:bLDblClick := { || OBS001MkCron()}

oList:Refresh()
oDlg:Refresh() 

  
Return()
  
  
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GeraQuery    �Autor  �A.Carlos            � Data �  26/10/17���
�������������������������������������������������������������������������͹��
���Desc.     �GeraQuerya para TwBrowse .                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Cliente                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GeraQuery()  
cAliasQry := GetNextAlias()
cQuery := "SELECT ZAO_FILIAL, ZAO_COD, UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(ZAO_DESCRI)) ZAO_DESCRIC "  +Chr(10)
cQuery += "  FROM "+RetSqlName("ZAO")              +Chr(10)
cQuery += " WHERE "                                +Chr(10)
cQuery += "   D_E_L_E_T_=' ' "                     +Chr(10)
cQuery += "   ORDER BY ZAO_FILIAL, ZAO_COD "       +Chr(10)

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasQry, .F., .T. )

Return()
  
  
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OBS001MkCron �Autor  �A.Carlos            � Data �  30/09/16���
�������������������������������������������������������������������������͹��
���Desc.     �Marca/Desmarca itens na TwBrowse .                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Cliente                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function OBS001MkCron()

Local nX         := 0
Local lRetVCK    := .T.

IF _aListBox[oList:nAT, xMarcado]==.T.
   _aListBox[oList:nAT, xMarcado]:=.F.
Else
   _aListBox[oList:nAT, xMarcado]:=.T.
Endif

Return()


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MarDes       �Autor  �A.Carlos            � Data �  30/09/16���
�������������������������������������������������������������������������͹��
���Desc.     �Marca/Desmarca todos os itens na TwBrowse .                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Cliente                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MarDes( lTodos )

Local nX := 0

For nX := 1 to Len(_aListBox)
	If lTodos
		_aListBox[nX,1] := .T.
	Else
		_aListBox[nX,1] := .F.
	EndIf
Next nX

oList:Refresh()

Return Nil