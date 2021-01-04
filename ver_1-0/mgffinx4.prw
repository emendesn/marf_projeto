#INCLUDE 'PROTHEUS.CH'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"
#Include "TOTVS.CH"
/*/
{Protheus.doc} MGFFINX4 
Atendimento por Lote

@description
Atendimento acompanhamento de cobranca em lote  -  Financeiro

@author Antonio Carlos
@since 29/10/2019 
@type Function MGFFINX4 
*/
User Function MGFFINX4()
	Local nMv         := 0
	Local nSldIni     := 0.001
	Local oOk		  := LoadBitMap(GetResources(),"LBOK")
	Local oNo		  := LoadBitMap(GetResources(),"LBNO")
	Private _VarFilt  := " "
	Private oBrowse
	Private cFieldMark:="E1_ZFLAG" 
	Private lMarcar   := .f.
	Private aMvPar	  := {}
	Private _aRet	  := {}, _aParambox := {}
	Private _cQuery
	Private _nInterval, _aSelFil := {}, _aDefinePl := {}, _aCampoQry := {}

	Private _aSe1rec  := {}
	Private _lMark    := .F.
    Private _olxse1   := nil
	Private _oDlse1   := nil
	Private _oChk     := Nil
	Private _cVARSE1  := nil
	Private _lChk     := .F. 
	
	_nInterval := 7300  //Intervalo de dias para o parametro de datas PAR (10, 11, 12 e 13)

	aAdd(_aParambox,{1,"Empresa"	          ,Space(tamSx3("A2_FILIAL")[1]) ,"@!"	,""													,""		,"",050,.T.})
	aAdd(_aParambox,{1,"Cod Tipo Inicial"	  ,Space(tamSx3("E1_TIPO")[1])	 ,"@!"	,""                                           		,"SE1LOT","",050,.F.})
	aAdd(_aParambox,{1,"Cod Tipo Final"	      ,Space(tamSx3("E1_TIPO")[1])	 ,"@!"	,"U_VLFIMMAI(MV_PAR02,MV_PAR03,'Cod Tipo')"         ,"SE1LOT","",050,.F.})
	aAdd(_aParambox,{1,"Cod Natureza Inicial" ,Space(tamSx3("E1_NATUREZ")[1]),"@!"  ,""                                                 ,"SED"	 ,"",070,.F.})
	aAdd(_aParambox,{1,"Cod Natureza Final"	  ,Space(tamSx3("E1_NATUREZ")[1]),"@!"  ,"U_VLFIMMAI(MV_PAR04, MV_PAR05, 'Cod. Natureza')"  ,"SED"	 ,"",070,.F.})
	aAdd(_aParambox,{1,"Cod Cliente Inicial"  ,Space(tamSx3("A1_COD")[1])	 ,"@!"  ,""		                                            ,"CLI"	 ,"",050,.F.})
	aAdd(_aParambox,{1,"Cod Cliente Final"    ,Space(tamSx3("A1_COD")[1])	 ,"@!"  ,"U_VLFIMMAI(MV_PAR06, MV_PAR07, 'Cod. Cliente')"   ,"CLI"	 ,"",050,.F.})
	aAdd(_aParambox,{1,"Cod Rede Inicial"     ,Space(tamSx3("ZQ_COD")[1])	 ,"@!"  ,""                                               	,"SZQ"   ,"",070,.F.})
	aAdd(_aParambox,{1,"Cod Rede Final"       ,Space(tamSx3("ZQ_COD")[1])	 ,"@!"	,"U_VLFIMMAI(MV_PAR08, MV_PAR09, 'Cod. Rede')"	    ,"SZQ"	 ,"",070,.F.})
	aAdd(_aParambox,{1,"Dt. Emissao Inicial"  ,Ctod("")						 ,""	,                                                   ,""   	 ,"",050,.F.})
	aAdd(_aParambox,{1,"Dt. Emissao Final"    ,Ctod("")                      ,""	,"U_VLDTINIF(MV_PAR10,MV_PAR11,_nInterval)"	        ,""  	 ,"",050,.F.})
	aAdd(_aParambox,{1,"Dt. Venc/to Inicial"  ,Ctod("")						 ,""	,""                                     		    ,""  	 ,"",050,.F.})
	aAdd(_aParambox,{1,"Dt. Venc/to Final"    ,Ctod("")                 	 ,""	,"U_VLDTINIF(MV_PAR12,MV_PAR13,_nInterval)"         ,""	     ,"",050,.F.})
	aAdd(_aParambox,{1,"Saldo Inicial"        ,nSldIni                       ,"@E 999,999,999.999",""                                   ,""	     ,"",050,.F.})
	aAdd(_aParambox,{1,"Saldo Final"          ,0                        	 ,"@E 999,999,999.999","U_VLFIMMAI(MV_PAR14,MV_PAR15,'Saldo')",""    ,"",050,.F.})
	aAdd(_aParambox,{1,"Vendedor Inicial"     ,Space(tamSx3("E1_VEND1")[1])  ,"@!"	,""                                             	,"SA3" 	 ,"",050,.F.})
	aAdd(_aParambox,{1,"Vendedor Final"       ,Space(tamSx3("E1_VEND1")[1])  ,"@!"	,"U_VLFIMMAI(MV_PAR16,MV_PAR17,'Cod Vendedor')"	,"SA3" 	,"",050,.F.})
	aAdd(_aParambox,{1,"Atendente Inicial"    ,Space(tamSx3("ZZ8_USUARI")[1]),"@!"	,                                                   ,"ZZ8B" ,"",050,.F.})
	aAdd(_aParambox,{1,"Atendente Final"      ,Space(tamSx3("ZZ8_USUARI")[1]),"@!"	,"U_VLFIMMAI(MV_PAR18,MV_PAR19,'Cod Atendente')"	,"ZZ8B"	,"",050,.F.})
//                     1                   2   34  5 6789 10  11
	IF !Parambox(_aParambox,"Atendimento em Lote",_aRet,,,.T.,,,,,   ,.T.)
       RETURN()
	ENDIF
	For nMv := 1 To 20
	    aAdd( aMvPar, &( "MV_PAR" + StrZero( nMv, 2, 0 ) ) )
		&( "MV_PAR" + StrZero( nMv, 2, 0 ) ) := aMvPar[ nMv ]
	Next nMv
	if MV_PAR14 == 0 
		MV_PAR14 := 0.001 
	Endif
    
	MSAGUARDE({|LEND|MGFFINCAD(_aSe1rec,_lMark)},"Aguarde...","Selecionando registro",.T.)
	
	IF LEN(_aSe1rec) == 0 
	   Msginfo("Nao existe titulos na base para os parametros","Nao ha Titulos")
	   RETURN
	ENDIF
	DEFINE MSDIALOG _oDlse1 Title "Titulos " FROM 1,1 TO 700,1200 PIXEL
    	
	@ 02,05 TO 345,590 PIXEL OF _oDlse1 	
	@ 20,10 LISTBOX _olxse1 VAR _cVARSE1 FIELDS HEADER ;
			"Sel"         ,;
			"Filial"      ,;
			"Prefixo"     ,;
			"Titulo"      ,;
			"Parcela"     ,;
			"Tipo"        ,;
			"Natureza"    ,;
			"Portador"    ,;
			"AgenciaDp"   ,;
			"Num conta"   ,;
			"Cliente"     ,;
			"Loja"        ,;
			"Nome"        ,;
			"Dt Emisao"   ,;
			"Vencimento"  ,;
			"Vencto Real" ,;
			"Vencto Original",;			
			"Valor Titulo"   ,;
			"Saldo"          ,;
			"Atendente"      ,;
			"Descr.Segm. "   ,;
			"Descr.Rede  "   ,;
			"Recno",;
			SIZE 570,320 OF _oDlse1 PIXEL ON DBLClick( _aSe1rec[_olxse1:nAt,1]  := !_aSe1rec[_olxse1:nAt,1],_olxse1:refresh() )
			_olxse1:setArray( _aSe1rec )
			_olxse1:bLine := {|| {IF(_aSe1rec[_olxse1:nAt,1],oOK,oNo),;
							_aSe1rec[_olxse1:nAt,2],;
							_aSe1rec[_olxse1:nAt,3],;
							_aSe1rec[_olxse1:nAt,4],;
							_aSe1rec[_olxse1:nAt,5],;
							_aSe1rec[_olxse1:nAt,6],;
							_aSe1rec[_olxse1:nAt,7],;
							_aSe1rec[_olxse1:nAt,8],;
							_aSe1rec[_olxse1:nAt,9],;
							_aSe1rec[_olxse1:nAt,10],;
							_aSe1rec[_olxse1:nAt,11],;
							_aSe1rec[_olxse1:nAt,12],;
							_aSe1rec[_olxse1:nAt,13],;
							_aSe1rec[_olxse1:nAt,14],;
							_aSe1rec[_olxse1:nAt,15],;
							_aSe1rec[_olxse1:nAt,16],;
							_aSe1rec[_olxse1:nAt,17],;
							_aSe1rec[_olxse1:nAt,18],;
							_aSe1rec[_olxse1:nAt,19],;
							_aSe1rec[_olxse1:nAt,20],;
							_aSe1rec[_olxse1:nAt,21],;
							_aSe1rec[_olxse1:nAt,22]} }
							
	@   10,10 CHECKBOX _oChk VAR _lChk PROMPT "Marca/Desmarca" SIZE 60,10 PIXEL OF _oDlse1;
		      ON CLICK(aEVAL(_aSe1rec,{|X| X[1]:=_lChk}),_olxse1:REFRESH() ) 

    @   08,070 BUTTON "&Confirma" SIZE 30,10  PIXEL OF _oDlse1 ACTION (_oDlse1:end(),U_MGFINX4A())
	//@   08,110 BUTTON "&Visualizar" SIZE 30,10  PIXEL OF _oDlse1 ACTION (_oDlse1:end(),U_MGFINX4C(_aSe1rec[_olxse1:nAt,2],_aSe1rec[_olxse1:nAt,4],_aSe1rec[_olxse1:nAt,5],_aSe1rec[_olxse1:nAt,6],_aSe1rec[_olxse1:nAt,11],_aSe1rec[_olxse1:nAt,12]) )
	@   08,110 BUTTON "&Visualizar" SIZE 30,10  PIXEL OF _oDlse1 ACTION (U_MGFINX4C(_aSe1rec[_olxse1:nAt,2],_aSe1rec[_olxse1:nAt,4],_aSe1rec[_olxse1:nAt,5],_aSe1rec[_olxse1:nAt,6],_aSe1rec[_olxse1:nAt,11],_aSe1rec[_olxse1:nAt,12]) )
	@   08,150 BUTTON "&Cancela" SIZE 30,10  PIXEL OF _oDlse1 ACTION _oDlse1:end()
	
	ACTIVATE MSDIALOG _oDlse1 

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  MGFFX4IN   �Autor  �Microsiga           � Data �  29/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �  Funcao para marcar ou desmarcar os registros na gride     ���
���          �  Filtra conforme a variavel do ParamBox                    ���
���          �  Set Filter To &_VarFilt.                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MGFFX4IN(cFieldMark)

Local cAlias	:= oBrowse:Alias()
Local aRest		:= GetArea()
local _cCODUSER := RetCodUsr() 

(cAlias)->(DbGoTop())
While (cAlias)->(!Eof())
	If (!oBrowse:IsMark())
		RecLock(cAlias,.F.)
		(cAlias)->&cFieldMark:= oBrowse:Mark()
		(cAlias)->E1_ZUFLAG  :=  _cCODUSER 
		(cAlias)->(MsUnLock())	
		aadd(_aSe1rec,{,}) 		
	Else
		RecLock(cAlias,.F.)
		(cAlias)->&cFieldMark:= "  "
		(cAlias)->E1_ZUFLAG  := " "
		(cAlias)->(MsUnLock())
	EndIf
	(cAlias)->(DbSkip())
EndDo

RestArea(aRest)

oBrowse:refresh(.F.)
Return .T.


/*
=====================================================================================
Programa............: MGFFINX4
Autor...............: Antonio Carlos
Data................: 29/10/2019
Descricao / Objetivo: Acompanhamento de cobranca
Doc. Origem.........: Contrato - GAP CRE025
Solicitante.........: Cliente
Uso.................: 
Obs.................: opcao Confirma Gerar Excel
=====================================================================================
*/
User Function MGFINX4A()
Local aRest		  := GetArea()
Local _aParbox1   := {}
Local _aRt        := {}
Local nMv         := 0
Private cEmpa     := cEmpAnt   

cFieldBrw   := "E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_NATUREZ, E1_CLIENTE, E1_LOJA, E1_VEND1, E1_ZFLAG, "
cFieldBrw   += " E1_NOMCLI, E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_SALDO, E1_ZRESL, E1_FILORIG, E1_ZATEND, E1_ZSEGMEN, E1_ZDESRED, E1_ZUFLAG, E1_ZRESL"

aAdd(_aParbox1,{1,"Filial      " ,cEmpa                        ,"@!","",""   ,".F.",050,.F.})
aAdd(_aParbox1,{1,"Resposta    " ,Space(254)                   ,"@!","",""   ,""   ,100,.F.})
aAdd(_aParbox1,{1,"Cod Posicao " ,Space(tamSx3("ZZ9_CODPOS")[1])  ,"@!",  ,"ZZ9",""   ,050,.F.})

IF !Parambox(_aParbox1,"Dados do Atendimento",_aRt,,,.T.,,,,,   ,.T.)	
	RestArea(aRest)
    RETURN()
ENDIF

For nMv := 1 To 3
    aAdd( aMvPar, &( "MV_PAR" + StrZero( nMv, 2, 0 ) ) )
Next nMv
For nMv := 1 To len( aMvPar)
  	&( "MV_PAR" + StrZero( nMv, 2, 0 ) ) := aMvPar[ nMv ]
Next nMv

msAguarde({||MGFINX4AT()},"Aguarde", "Processando registros")

RestArea(aRest)

return()

static Function MGFINX4AT()
Local _cNome      := UsrFullName(RetCodUsr())
Local  _cResult   := " "
local nY          :=0

ProcRegua( Len(_aSe1rec) ) 

FOR nX:=1 TO LEN(_aSe1rec)
     
	IF _aSe1rec[nX][1]

			nY++
			//MsProcTXT ("Atualizando Registo"+cValtochar(nY)+" de "+cValtochar(LEN(_aSe1rec)))
			_cResult := "Executado c/ Sucesso"
			DbSelectArea('ZZB')
			DbSetorder(1)//ZZB_FILIAL+ZZB_FILORI+ZZB_PREFIX+ZZB_NUM+ZZB_PARCEL+ZZB_TIPO
			If !(ZZB->(dbSeek(xFilial('ZZB')+_aSe1rec[nX][24]+_aSe1rec[nX][3]+_aSe1rec[nX][4]+_aSe1rec[nX][5]+_aSe1rec[nX][6])))
				IncProc('Processando registro' + _aSe1rec[nX][24]+_aSe1rec[nX][3]+_aSe1rec[nX][4]+_aSe1rec[nX][5]+_aSe1rec[nX][6])
				
				RecLock("ZZB",.T.)
					ZZB->ZZB_FILIAL := cEmpa
					ZZB->ZZB_FILORI := _aSe1rec[nX][24] //(_cAlias2)->E1_FILORIG 
					ZZB->ZZB_PREFIX := _aSe1rec[nX][3] //(_cAlias2)->E1_PREFIXO
					ZZB->ZZB_NUM    := _aSe1rec[nX][4] //(_cAlias2)->E1_NUM
					ZZB->ZZB_PARCEL := _aSe1rec[nX][5]//(_cAlias2)->E1_PARCELA
					ZZB->ZZB_TIPO   := _aSe1rec[nX][6]//(_cAlias2)->E1_TIPO
					ZZB->ZZB_USUARI := RetCodUsr()
					ZZB->ZZB_ZATEN  := _aSe1rec[nX][20] //(_cAlias2)->E1_ZATEND
					ZZB->ZZB_ZSEGME := _aSe1rec[nX][21] //(_cAlias2)->E1_ZSEGMEN
					ZZB->ZZB_ZDESRE := _aSe1rec[nX][22] //(_cAlias2)->E1_ZDESRED		
					ZZB->ZZB_DATA   := DATE()
					ZZB->ZZB_HORA   := TIME()
					ZZB->ZZB_CONTAT := _cNome
					ZZB->ZZB_RESPOST:= MV_PAR22
					ZZB->ZZB_CODPOS := MV_PAR23
					ZZB->ZZB_ZRESL  := _cResult				
				ZZB->(MsUnLock())


			EndIf
	ENDIF
  	DbSelectArea('SE1')
	DbGOTO( _aSe1rec[nX][23] )
	RecLock("SE1",.F.)
		E1_ZRESL = _cResult 
	MsUnLock()		
		
NEXT nX

Return()


User Function MGFINX4C(cFil,cNum,cParc,cTip,cCli,cLj)

Local _cArea := getarea()
Local cQuery  := ""
Local cAlias
Local aRet     := {}
Local lMark    := .F.
Local cVar     := Nil
Local oDlg     := Nil
Local cTitulo  := "Consulta acompanhamentos de cobranca"
Local oOk      := LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
Local oNo      := LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
Local oChk     := Nil
Local lMarca   := .T.
Local cNrom	   := ""
Local nLinha	:= 0
Local nTotLinha	:= 0
Local cSveFil	:= cFilAnt
Private cCadastro := "Acompanhamento de cobranca"
Private lChk   := .F.
Private oLbx   := Nil
Private aVetor := {}

cAlias	:= GetNextAlias()

cQuery := "SELECT  SE1.* , ZZB.*, ZZB.R_E_C_N_O_  ZZB_RECNO FROM " + RetSqlName("SE1") + " SE1, "+RetSqlName("ZZB") + " ZZB "

cQuery += " WHERE SE1.E1_FILIAL = '" + cFil + "' "
cQuery += " AND SE1.E1_NUM = ZZB.ZZB_NUM "
cQuery += " AND SE1.E1_PREFIXO = ZZB.ZZB_PREFIX "
cQuery += " AND SE1.E1_PARCELA = ZZB_PARCEL "
cQuery += " AND SE1.E1_TIPO = ZZB.ZZB_TIPO "
cQuery += " AND SE1.E1_FILIAL = ZZB.ZZB_FILORI "
cQuery += " AND SE1.E1_NUM = '" + cNum + "' "
cQuery += " AND SE1.E1_PARCELA = '" + cParc + "' "
cQuery += " AND SE1.E1_TIPO = '" + cTip + "' "
cQuery += " AND SE1.E1_CLIENTE = '" + cCli + "' "
cQuery += " AND SE1.E1_LOJA = '" + cLj + "' "
cQuery += " AND SE1.D_E_L_E_T_='' "
cQuery += " AND ZZB.D_E_L_E_T_='' "

cQuery += " ORDER BY ZZB_DATA "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias, .F., .T.)

While !(cAlias)->(eof())

	AADD (aVetor, {(cAlias)->ZZB_NUM, (cAlias)->ZZB_PARCEL,(cAlias)->ZZB_TIPO, (cAlias)->ZZB_DATA, (cAlias)->ZZB_HORA, (cAlias)->ZZB_RECNO, (cAlias)->ZZB_FILIAL})

	(cAlias)->(DBSKIP())
Enddo

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
If Len( aVetor ) == 0
   Aviso( cTitulo, "Nao h� interacoes", {"Ok"} )
Else

	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL
	dBselectArea('ZZB')
	@ 10,10 LISTBOX oLbx VAR cVar FIELDS HEADER "Titulo", "Parcela", "Tipo", "Data interacao", "Hora interacao", "Recno" SIZE 230,095 OF oDlg PIXEL ;
	ON dblClick(ZZB->(dBgoto(aVetor[oLbx:nAt,6])),cSveFil:=cFilAnt,cFilAnt:=aVetor[oLbx:nAt,7],aXvisual("ZZB",aVetor[oLbx:nAt,6],2),cFilAnt:=cSveFil)

	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {aVetor[oLbx:nAt,1],;
					aVetor[oLbx:nAt,2],;
					aVetor[oLbx:nAt,3],;
					Stod(aVetor[oLbx:nAt,4]),;
					aVetor[oLbx:nAt,5],;
					str(aVetor[oLbx:nAt,6]),;
					aVetor[oLbx:nAt,7]}}
	DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER

Endif
restarea(_cArea)
Return()



/*
=====================================================================================
Programa............: MGFFINX4
Autor...............: Antonio Carlos
Data................: 29/10/2019
Descricao / Objetivo: Consulta Especifica
Doc. Origem.........: Contrato - GAP CRE025
Solicitante.........: Cliente
Uso.................: 
Obs.................: Consulta de Atendente
=====================================================================================
*/
User Function FINX4SM0()
	Local aFilM0
	Local nX
	__cMark := ""

	aFilM0 := ADMGETFIL()

	For nX:= 1 to Len(aFilM0)
		If Empty(__cMark)
			__cMark	:= aFilM0[nX]
		Else
			__cMark	+= "," + aFilM0[nX]
		Endif
	Next

Return(.T.)

Static Function ModelDef()

	Local oModel	:= Nil
	Local oStrSE1 	:= FWFormStruct(1,"SE1")	
	
	oModel := MPFormModel():New("XMGFFINX4",/*bPreValidacao*/,/*bPosValid*/,/*bCommit*/,/*bCancel*/ )
	oModel:AddFields("SE1MASTER",/*cOwner*/,oStrSE1, /*bPreValid*/, /*bPosValid*/, /*bCarga*/ )

	oModel:SetDescription("Atendimento em Lote")
	oModel:SetPrimaryKey({"E1_FILIAL","E1_NUM"})	
	
Return oModel


Static Function ViewDef()

	Local oView
	Local oModel  	:= FWLoadModel('MGFFINX4')
	Local oStrSE1 	:= FWFormStruct( 2, "SE1",nil)

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField( 'VIEW_SE1' , oStrSE1, 'SE1MASTER' )
	
	oView:CreateHorizontalBox( 'TELA' , 100 )
	oView:SetOwnerView( 'VIEW_SE1', 'TELA' )
	
return oView


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa   MGFFX4B   �Autor  �Microsiga           � Data �  29/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �  Funcao para desmarcar os registros na gride               ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MGFFX4B(cFieldMark)
	Local cAlias	:= oBrowse:Alias()
	Local aRest		:= GetArea()
	Local _cQuery4  := " "

	_cQuery4:= "UPDATE " + retSQLName("SE1")  
	_cQuery4+= " SET E1_ZFLAG = ' ' , E1_ZUFLAG = ' ' "
	_cQuery4+= "WHERE D_E_L_E_T_ = ' ' AND E1_ZFLAG<>' ' AND E1_ZUFLAG = '" + RetCodUsr() +"' "  
	tcSQLExec(_cQuery4)
	
	RestArea(aRest)
	
	oBrowse:refresh(.F.)
Return .T.


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa   MGFFINCAD  �Autor  �Roberto R.Mezzalira � Data � 05/12/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �  Funcao para alimentar o array com os tiutulos             ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION MGFFINCAD(_aSe1rec,_lMark)
Local _cQryse1 := " "
Local cRet := ""
Local _cAliase1 := GetNextAlias()	
	
	_cQryse1 := " SELECT *"
	_cQryse1 += " FROM "+retSQLName("SE1")+" SE1"
	_cQryse1 += " WHERE SUBSTRING(SE1.E1_FILIAL,1,2) ='"+ALLTRIM(MV_PAR01)+"' AND "
	_cQryse1 += " SE1.E1_CLIENTE BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"' AND "
	_cQryse1 += " SE1.E1_TIPO    BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' AND "
	_cQryse1 += " SE1.E1_NATUREZ BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' AND "
	IF !Empty(MV_PAR09) .and. MV_PAR09 <> 'ZZZ' 
		_cQryse1 += "  EXISTS ( SELECT * FROM "+retSQLName("SA1")+" XSA1 WHERE E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA AND XSA1.D_E_L_E_T_ =' ' AND A1_ZREDE >= '"+MV_PAR09+"' AND A1_ZREDE <= '"+MV_PAR09+"' )  AND "
	EndIf  
	_cQryse1 += " SE1.E1_VEND1   BETWEEN '"+MV_PAR16+"' AND '"+MV_PAR17+"' AND "
	_cQryse1 += " SE1.E1_SALDO   BETWEEN "+strzero(MV_PAR14,12,3)+" AND "+strzero(MV_PAR15,20,3)+" AND "
	_cQryse1 += " SE1.E1_EMISSAO BETWEEN '"+DTOS(MV_PAR10)+"' AND '"+DTOS(MV_PAR11)+"' AND "
	_cQryse1 += " SE1.E1_VENCTO  BETWEEN '"+DTOS(MV_PAR12)+"' AND '"+DTOS(MV_PAR13)+"' AND "	
	_cQryse1 += " SE1.D_E_L_E_T_ =' '"
	_cQryse1 := ChangeQuery(_cQryse1 )
	MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",_cQryse1)
	IF Select (_cAliase1) > 0 
        DbSelectArea(_cAliase1)
		dbclosearea()
	Endif
	DbUseArea(.T.,'TOPCONN', TCGENQRY(,,_cQryse1),_cAliase1,.F.,.T.)
	DbSelectArea(_cAliase1)
	DBGOTOP()
	
	DO While (_cAliase1)->(!EOF())
		
		aAdd(_aSe1rec,{_lMark ,(_cAliase1)->E1_FILIAL,(_cAliase1)->E1_PREFIXO,(_cAliase1)->E1_NUM,;
				      (_cAliase1)->E1_PARCELA,(_cAliase1)->E1_TIPO,(_cAliase1)->E1_NATUREZ,;
					  (_cAliase1)->E1_PORTADO,(_cAliase1)->E1_AGEDEP,(_cAliase1)->E1_CONTA,;
					  (_cAliase1)->E1_CLIENTE,(_cAliase1)->E1_LOJA,(_cAliase1)->E1_NOMCLI,;
					  STOD((_cAliase1)->E1_EMISSAO),STOD((_cAliase1)->E1_VENCTO),;
					  STOD((_cAliase1)->E1_VENCREA),STOD((_cAliase1)->E1_VENCORI),;
					  TRANSFORM((_cAliase1)->E1_VALOR,"@E 9,999,999,999,999.99"),;
					  TRANSFORM((_cAliase1)->E1_SALDO,"@E 9,999,999,999,999.99"),;
					  (_cAliase1)->E1_ZATEND,;
					  (_cAliase1)->E1_ZSEGMEN,(_cAliase1)->E1_ZDESRED,(_cAliase1)->R_E_C_N_O_,;
					  (_cAliase1)->E1_FILORIG})

		DbSelectArea(_cAliase1)
		Dbskip()
	
	ENDDO
    DbSelectArea(_cAliase1)
	dbclosearea()
	
RETURN(_aSe1rec)
