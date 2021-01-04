#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

#DEFINE XLSFILIAL		1	// Codigo da Filial
#DEFINE XLSMOTIVO		2	// Motivo da rejeicao
#DEFINE XLSVENCTO		3	// Vencimento
#DEFINE XLSVALOR		4	// Valor do titulo
#DEFINE XLSTITULO		5	// Numero do titulo
#DEFINE XLSCARTEI		6	// Carteira
#DEFINE XLSNUMBCO		7   // Nosso Numero
#DEFINE XLSOBSERV		8 	// Observacao
#DEFINE XLSDDA			9	// DDA

/*
=====================================================================================
Programa.:              MGFINA3
Autor....:              Paulo Fernandes        
Data.....:              11/06/2018
Descricao / Objetivo:   Importa planilha excel FIDC para recompra manual 
Doc. Origem:            Contrato - CRE09
Solicitante:            Cliente
Uso......:              
Obs......:              
=====================================================================================
*/
User Function MGFFINA3()
Private oLeTxt

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,001 TO 380,380 DIALOG oLeTxt TITLE "Leitura de Planilha Recompra - FIDC"
@ 002,010 TO 080,190
@ 010,018 Say " Este programa ira ler o conteudo de um arquivo .CSV, conforme"
@ 018,018 Say " os parametros definidos pelo usuario, com os registros.

@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

Return
//-------------------------------------------------------------------
/*/{Protheus.doc} OkLeTxt

Executa a leitura do arquivo texto.
@sample	
@param		 
@author		Paulo Fernandes
@since		11/06/2016
@version	P12 
/*/
//-------------------------------------------------------------------
Static Function OkLeTxt()

//���������������������������������������������������������������������Ŀ
//� Abertura do arquivo texto                                           �
//�����������������������������������������������������������������������

Private cArqTxt := Upper(cGetFile("Arquivos CSV|*.CSV|Todos os arquivos|*.*","Selecione",0,,.T.,GETF_LOCALHARD+GETF_NETWORKDRIVE))
Private cArq    := ""

If !File(cArqTxt)
	Aviso("Atencao","Arquivo "+cArqTxt+" nao existe!",{"Ok"})
	Return
EndIf
//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������

Processa({|| RunCont() },"Processando...")
Return
//-------------------------------------------------------------------
/*/{Protheus.doc} RunCont

Executa a leitura do arquivo texto, monta Grid de Recompra manual
@sample	
@param		 
@author		Paulo Fernandes
@since		11/06/2016
@version	P12 
/*/
//-------------------------------------------------------------------
Static Function RunCont()
Local cLinha 		:= ""
Local nI     		:=  0
Local cAux   		:= ""
Local aAux   		:={}
Local aHeadPla		:={}
Local lFirst 		:= .T.
Local cAliasTit		:= GetNextAlias()
Local nVlrTit		:= 0
Local cTitulo		:= ""
Local cParcela		:= ""
Local cVencto		:= ""
Local nVlrTit		:= 0
Local oModel		:= FwModelActive()
Local oMdlZA7		:= oModel:GetModel('ZA7MASTER')
Local oMdlZA8		:= oModel:GetModel('ZA8GRID')
Local nLinha		:= oMdlZA8:Length()
Local nLidos		:= 0
Local nRejeita		:= 0
Local aTitRej		:= {}
Local aMotRecompra	:= {}
Local cMotRec		:= ""
Local nPosRec		:= 0
Local cNumBco		:= ""

// GDN - 19/09/2018 - Parametro para Inverter do FIDC para Banco Original
Local cBcoRETFIDC	:= Iif(nMgBco==1,SuperGetMv("MGF_FIN45A",,"341/2938/23081/001"),SuperGetMv("MGF_FIN45B",,"237/2373/34098/001"))
Local aBcoRETFIDC	:= StrToKArr(cBcoRETFIDC,"/")
Local cAgeRETFIDC, cCtaRETFIDC, cSubRETFIDC

cBcoRETFIDC	:= aBcoRETFIDC[1]
cAgeRETFIDC	:= Stuff( Space( TamSX3("A6_AGENCIA")[1] ), 1 , Len(AllTrim(aBcoRETFIDC[2])) , Alltrim(aBcoRETFIDC[2]) )
cCtaRETFIDC	:= Stuff( Space( TamSX3("A6_NUMCON")[1] ) , 1 , Len(AllTrim(aBcoRETFIDC[3])) , Alltrim(aBcoRETFIDC[3]) )
cSubRETFIDC	:= Stuff( Space( TamSX3("EE_SUBCTA")[1] ) , 1 , Len(AllTrim(aBcoRETFIDC[4])) , Alltrim(aBcoRETFIDC[4]) )
//--------------------------------------------------------------------------

aAdd(aMotRecompra,{"PAGAMENTO"	,"75"})
aAdd(aMotRecompra,{"ABATIMENTO"	,"72"})
aAdd(aMotRecompra,{"DEVOLUCAO"	,"73"})
aAdd(aMotRecompra,{"PRORROGAECO","72"})
aAdd(aMotRecompra,{"PRORROGACAO","72"})
aAdd(aMotRecompra,{"PRORROGACAO","72"})

FT_FUse(cArqTxt)
FT_FGotop()
ProcRegua(FT_flastrec())               
While ( !FT_FEof() )   
	cLinha 	  := FT_FREADLN()

	For nI:=1 TO Len(cLinha)
		If (SubStr(cLinha,nI,1) == ";")
			If !Empty(cAux)
				If lFirst
					aAdd(aHeadPla,cAux)
				Else
					aAdd(aAux,AjTexto(cAux))
				EndIf
			Else
				aAdd(aAux,cAux)
			EndIf
			cAux:= ""
		Else 
			cAux+= SubStr(cLinha,nI,1)
		EndIf	
	Next nI

	If !Empty(cAux)
		If lFirst
			aAdd(aHeadPla,cAux)
		Else
			aAdd(aAux,AjTexto(cAux))
		EndIf
		cAux:= ""
	Endif	

	If !lFirst
		If (Len(aAux) == 0)	
			Return
		EndIf
		cTitulo		:= "000"+SubStr(aAux[6],1,6)
		cParcela	:= SubStr(aAux[6],7,2)
		cVencto		:= DTOS(CTOD(aAux[4]))
		nVlrTit		:= Val(StrTran(StrTran(aAux[5],".",""),",","."))
		nPosRec		:= Ascan(aMotRecompra,{|x| AllTrim(aAux[3]) == AllTrim(x[1])})
		cNumBco		:= SubStr(AllTrim(aAux[8]),1,8)
		If nPosRec > 0
			cMotRec	:= aMotRecompra[nPosRec][2]
		Else
			cMotRec	:= "72"
		Endif
		// Busca Recompra Manual
		//=================================================================================================================//
		// Alteracao realizada por Paulo Fernandes																		   //
		// Em 23/04/2018 foi solicitado pelo Eder(Financeiro) e Claudio(TOTVS) que retirasse  							   //
		// o a condicao de portador (AND E1_PORTADO = %Exp:cBcoFIDC% AND E1_AGEDEP || E1_CONTA = %Exp:cAgeFIDC+cCtaFIDC%   //
		// da clausula WHERE para selecao de titulos em recompra manual													   //
		//=================================================================================================================//
			
		BeginSQL Alias cAliasTit
				
			SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_VENCREA, E1_PORTADO, E1_AGEDEP, E1_CONTA, 
				   E1_NUMBOR, E1_DATABOR, E1_VALOR,	ZA8_CODREM
			FROM %table:SE1% SE1
			INNER JOIN %table:ZA8% ZA8 ON ZA8.%notDel%
				AND ZA8_FILORI = E1_FILIAL
				AND ZA8_PREFIX = E1_PREFIXO
				AND ZA8_NUM = E1_NUM
				AND ZA8_PARCEL = E1_PARCELA
				AND ZA8_TIPO = E1_TIPO
				AND ZA8_STATUS IN ('1','2')
				AND ZA8_RECOMP NOT IN  ('1','2')
				AND SUBSTR(ZA8_FILIAL,1,2) = %Exp:Subs(cFilAnt,1,2)%
			INNER JOIN %table:ZA7% ZA7 ON ZA7.%notDel%
				AND ZA7_FILIAL = ZA8_FILIAL
				AND ZA7_CODREM = ZA8_CODREM
				AND ZA7_STATUS IN ('1','2')
				AND ZA7_TIPO = '1'
				AND ZA7_DATA <> '        '
				AND SUBSTR(ZA7_FILIAL,1,2) = %Exp:Subs(cFilAnt,1,2)%
				WHERE SE1.%notDel%
				AND E1_FILIAL = %Exp:aAux[1]%
				AND E1_NUM = %Exp:cTitulo%
				AND E1_PARCELA = %Exp:cParcela%
				AND SubString(E1_NUMBCO,1,8) = %EXP:cNumBco%
				AND E1_VALOR = %EXP:nVlrTit%
				AND E1_SITUACA = '1'
				AND E1_IDCNAB <> ' '	
		EndSQL
			
		aQuery := GetLastQuery()
			
		MemoWrit( "C:\TEMP\"+FunName()+"-RecMan-"+DTOS(Date())+StrTran(Time(),":")+".SQL" , aQuery[2] )
		//[1] Tabela temp
		//[2] Query
		//..[5]
			
		If Empty( (cAliasTit)->(!EOF()) )
			nRejeita++
			aAdd(aTitRej,aAux)
		Else
			nLidos++
			oMdlZA8:SetNoInsertLine(.F.)
			While !(cAliasTit)->(EOF())
					
				oMdlZA8:GoLine(nLinha)
					
				If !Empty( oMdlZA8:GetValue('ZA8_NUM') )
					nLinha++
						
					oMdlZA8:AddLine()
					oMdlZA8:GoLine( nLinha )
				EndIf
					
				oMdlZA8:SetValue("ZA8_STATUS"	, "1"							)
				oMdlZA8:SetValue("ZA8_PREFIX"	, (cAliasTit)->E1_PREFIXO			)
				oMdlZA8:SetValue("ZA8_NUM"		, (cAliasTit)->E1_NUM				)
				oMdlZA8:SetValue("ZA8_PARCEL"	, (cAliasTit)->E1_PARCELA			)
				oMdlZA8:SetValue("ZA8_TIPO"		, (cAliasTit)->E1_TIPO				)
				oMdlZA8:SetValue("ZA8_VENCRE"	, STOD((cAliasTit)->E1_VENCREA)	)
				oMdlZA8:SetValue("ZA8_VALOR"	, (cAliasTit)->E1_VALOR			)
				oMdlZA8:SetValue("ZA8_BANCO"	, (cAliasTit)->E1_PORTADO			)
				oMdlZA8:SetValue("ZA8_AGENCI"	, cAgeRETFIDC			)		// gdn
				oMdlZA8:SetValue("ZA8_CONTA"	, cCtaRETFIDC			)		// gdn
				oMdlZA8:SetValue("ZA8_NUMBOR"	, (cAliasTit)->ZA8_CODREM			)
				oMdlZA8:SetValue("ZA8_DATBOR"	, STOD((cAliasTit)->E1_DATABOR)	)
				oMdlZA8:SetValue("ZA8_MOTREC"	, cMotRec						)
				oMdlZA8:SetValue("ZA8_FILORI"	, (cAliasTit)->E1_FILIAL			)
				(cAliasTit)->( dbSkip() )
			EndDo
				
			oMdlZA8:SetNoInsertLine(.T.)
		Endif
		dbSelectArea(cAliasTit)
		dbCloseArea()
	
		aAux:={}
		cAux:= ""
	EndIf
	
	IncProc("Processando linha...[" + StrZero(nLidos+nRejeita,5) + " de " + StrZero(FT_flastrec(),5) + "]...")

	lFirst:=.F.
	FT_FSkip()

//	If nRejeita == 10
//		Exit
//	Endif

End

FT_FUse()

Close(oLeTxt)

Aviso("Resumo","Titulos lidos.................. : " + StrZero(nLidos+nRejeita-1,5) + CHR(13)+CHR(10)  + ;
	  		   "Titulos enviados para Recompra..: " + StrZero(nLidos,5) + CHR(13)+CHR(10)  + ;
	  		   "Titulos nao encontrados.........: " + StrZero(nRejeita,5),{"Ok"})

If !Empty(nRejeita) .and. Len(aHeadPla) > 0				// gdn 10/9/2018 - Tratar o array
	FA3EXCEL(aTitRej,aHeadPla)
Endif

Return(0)
//-------------------------------------------------------------------
/*/{Protheus.doc} AjTexto

eliminar caracteres invalidos na impressao
@sample	
@param		_Texto 
@author		Paulo Fernandes
@since		11/06/2016
@version	P12 
/*/
//-------------------------------------------------------------------
Static Function AjTexto(_cTexto)

Local _cInvalido	:= "����������������������������������������������()����Ƶ���ֶ"
Local _cValido		:= "cCaAeEiIoOuUaAeEiIoOuUaAoOaAeEiIoOuUaAeEiIoOuU    oiecaaeuocia"
Local _cChar		:= ""
Local _cResp		:= ""
Local _nPos			:= 0
Local _nValido		:= 0

// Ajustar outros caracteres que a Mickey informou como invalidos
_cInvalido	+= CHR(34) // aspas
_cInvalido	+= CHR(39) // aspas simples
_cInvalido	+= CHR(42) // asterisco

_cValido	+= SPACE(3) // substituir por espaco os invalidos incluidos

For _nPos := 1 To Len(_cTexto)
	_cChar		:= SubStr(_cTexto,_nPos,1)
	
	If !Empty(AllTrim(_cChar))
		_nValido	:= AT(_cChar,_cInvalido)
		_cChar		:= IIF(_nValido>0,SubStr(_cValido,_nValido,1),_cChar)
		_cChar		:= IIF(ASC(_cChar)<=32.OR.ASC(_cChar)>122,"",_cChar)
	EndIf
	
	_cResp 		+= _cChar
Next _nPos

Return Upper(_cResp)    
/*
=====================================================================================
Programa............: FA3EXCEL
Autor...............: Marcos Andrade
Data................: 27/10/2016
Descricao / Objetivo: Acompanhamento de cobranca
Doc. Origem.........: Contrato - GAP CRE025
Solicitante.........: Cliente
Uso.................: 
Obs.................: Gerar Excel
=====================================================================================
*/
Static Function FA3EXCEL(aExcelTit,aExcelHea)

Processa({ || PA3EXCEL(aExcelTit,aExcelHea)})
		
Return()


Static Function PA3EXCEL(aExcelTit,aExcelHea) 		

Local nI			:= 0
Local xTo			:= ""
Local xFil			:=""
local cArq			:= ""
local oExcel		:= FwMSExcel():New()
local aLinha		:= {}
local cTable		:= "Recompra Manual - Titulos nao encontrados" // "Table"
local cTableSum		:= "Recompra Manual"
local cLocArq		:= ""
local oExcelApp		:= MsExcel():New()
local cWorkSheet	:= "Recompra" // "WorkSheet"
local cWorkShSum	:= "Recompra"
Local nMaxComp      := 0
Local lExcel		:= .F.
Local aAreaSE1		:= SE1->( GetArea() )
Local cAliasB		:= GetNextAlias()
Local cFilSE1		:= ""
Local bFiltro := { || }
Local nCount := 0
	
Default aExcelTit	:= {}	
Default aExcelHea	:= {}		

// Sum�rio
oExcel:AddworkSheet(cWorkSheet)			//Cria Planilha
oExcel:AddTable(cWorkSheet, cTable) 	//Cria Tabela

// adiciona colunas
For nI:=1 To 8 //alterado Rodrigo len(aExcelHea) por 8 para limitar numero de colunes no relatorio
	oExcel:AddColumn(cWorkSheet, cTable, aExcelHea[nI]			, 1, 1)
Next

ProcRegua(nCount)
			
For nI:=1 To Len(aExcelTit)
	For nX:=1 To 8// alterado para 8 Rodrigo antes ->Len(aExcelTit[nI])
		aadd(aLinha, aExcelTit[nI][nX])
	Next
	oExcel:addRow(cWorkSheet, cTable, aLinha)
	aLinha:={}
	lExcel := .T.
Next		
		
IncProc("Abrindo Excel...")
	
If lExcel
	//Ativa a planilha e deixa pronta para gerar arquivo.
	oExcel:Activate()
	cArq := CriaTrab(NIL, .F.) + ".xml"
	oExcel:GetXMLFile(cArq)
		
	cLocArq := cGetFile("Todos os Arquivos|*.*", OemToAnsi("Informe o diretorio para gravacao do arquivo Excel"), 0, "SERVIDOR\", .T., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY)
	if __CopyFile(cArq, cLocArq + cArq)
		MsgInfo("Relatorio gerado em: " + cLocArq + cArq)
		oExcelApp:WorkBooks:Open(cLocArq + cArq)
		oExcelApp:SetVisible(.T.)
	else
		MsgInfo("Arquivo nao copiado para o Diretorio " + cLocArq + cArq)
	endif
Endif

return
