#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "MSGRAPHI.CH" 

#DEFINE CRLF ( chr(13) + chr(10) )
/*/   {Protheus.doc} MGFFINX8

Descri��o : Fun��o para atualizar o cadastro de cliente a partir da importa��o de arquvivo (.csv)
	
	a. MGFFINX8 : Tela para importar e tratar o arquivo .csv

	b. O csv ser� herdado da rotina Mgf06r02. Essa rotina foi ajustada para contemplar novos campos. 

	c. Fun��es de grava��o dos dados procFin08(), getZB1() , showLog() foram herdadas da importa��o antiga Mgffin07, conforme solicitado pelo usu�rio. 

@author Henrique Vidal
@since 23/07/2020
@return Null
/*/

User Function MGFFINX8()

	Local aSizeAut    := MsAdvSize(,.F.,400)
	Local oBtn
	Local oBold
		
	Private oDlcsv     := Nil               
	Private aBrowse    := {} 
	Private aObjects
	Private aInfo
	Private aPosObj
	Private bSair      := .F.     
	// Campos obrigat�rios no Excel, utilizado para gravar dados.
	Private nPCodCli,nPLoja,nPCodRd,nPVlrLCr,nPVlCred,nPCondPg,nPStaCli,nPGerBol,nPClaCli,nPPenFin,nPInaCom,nPBloSin,nPAutTem,nPEmaCob,nPGraRed,nPObsObs 
	// Campos utilizados somente no browser.	
	Private nPNome, nPCnpj, nPMunicp, nPEst, nPCodSeg, nPDesSeg, nPDCdPg, nPDRede, nPExp, nPdtCad, nPNmPais, nPVlrAcm, nPVlrMCP, nPUtCmp

	Private cArq
	
	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
	
	aObjects := {}
	AAdd( aObjects, { 0,    65, .T., .F. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	AAdd( aObjects, { 0,    75, .T., .F. } )
	aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	
	IF !MGFIMPCSV()
		 RollbackSX8()  
		 Return
	EndIF
	
	DEFINE MSDIALOG oDlcsv FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE "Atualiza��o cadastral financeira via arquivo (.CSV)"  PIXEL
			  
		oBrowseDados := TWBrowse():New( 50,4,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]+10,;
								  ,,,oDlcsv, , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
		oBrowseDados:SetArray(aBrowse)                                    
		oBrowseDados:bLine := {|| aEval(aBrowse[oBrowseDados:nAt],{|z,w| aBrowse[oBrowseDados:nAt,w] } ) }
		oBrowseDados:bHeaderClick:= {|oBrw,nCol| OrdenaCab(nCol,.T.)}

		oBrowseDados:addColumn(TCColumn():new('C�d. do Cliente'				,{||aBrowse[oBrowseDados:nAt][nPCodCli]}		,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('C�d. da Loja'				,{||aBrowse[oBrowseDados:nAt][nPLoja]}			,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Nome do Cliente'				,{||aBrowse[oBrowseDados:nAt][nPNome]}			,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('CNPJ do Cliente'				,{||aBrowse[oBrowseDados:nAt][nPCnpj]}		,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Municipio'					,{||aBrowse[oBrowseDados:nAt][nPMunicp]}		,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Estado'	 					,{||aBrowse[oBrowseDados:nAt][nPEst]}			,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))	
		oBrowseDados:addColumn(TCColumn():new('C�d. do Segmento'			,{||aBrowse[oBrowseDados:nAt][nPCodSeg]} 		,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Descri��o do Segmento'		,{||aBrowse[oBrowseDados:nAt][nPDesSeg]}			,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Condi��o de Pagamento'		,{||aBrowse[oBrowseDados:nAt][nPCondPg]}		,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Descri��o Condi��o de Pagto'	,{||aBrowse[oBrowseDados:nAt][nPDCdPg]}		,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('C�digo de rede'				,{||aBrowse[oBrowseDados:nAt][nPCodRd]}			,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Descri��o Rede'				,{||aBrowse[oBrowseDados:nAt][nPDRede]}		,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Exposi��o'					,{||aBrowse[oBrowseDados:nAt][nPExp]}			,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Vlr. Limite Credito Cliente',{||aBrowse[oBrowseDados:nAt][nPVlrLCr]}		,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Data Limite Credito Cliente',{||aBrowse[oBrowseDados:nAt][nPVlCred]}		,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Data de Cadastro'			,{||aBrowse[oBrowseDados:nAt][nPdtCad]}		,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Status do Cliente'			,{||aBrowse[oBrowseDados:nAt][nPStaCli]}		,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Flg. Grandes Redes'			,{||aBrowse[oBrowseDados:nAt][nPGraRed]}		,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Nome do Pa�s'				,{||aBrowse[oBrowseDados:nAt][nPNmPais]}		,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Vlr. Acumulado'				,{||aBrowse[oBrowseDados:nAt][nPVlrAcm]}			,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Vlr. Maior Compra'			,{||aBrowse[oBrowseDados:nAt][nPVlrMCP]}		,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Vlr. Ult. Compra 180 Dias'	,{||aBrowse[oBrowseDados:nAt][nPUtCmp]}		,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Gera Boleto'					,{||aBrowse[oBrowseDados:nAt][nPGerBol]}		,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Pend�ncia Financeira'		,{||aBrowse[oBrowseDados:nAt][nPPenFin]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Inatividade de Compra'		,{||aBrowse[oBrowseDados:nAt][nPInaCom]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('E-mail Cobran�a'				,{||aBrowse[oBrowseDados:nAt][nPEmaCob]}		,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Autoriz. Temp.'				,{||aBrowse[oBrowseDados:nAt][nPAutTem]}	,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Bloq Sintegra'				,{||aBrowse[oBrowseDados:nAt][nPBloSin]}	,"@!"����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Classe Cliente'				,{||aBrowse[oBrowseDados:nAt][nPClaCli]}		,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new('Observa��o'					,{||aBrowse[oBrowseDados:nAt][nPObsObs]}		,"@!"�����,,,"LEFT"���,40,.F.,.F.,,,,,))
		oBrowseDados:Setfocus() 

		DEFINE FONT oBold NAME "Arial" SIZE 0, -14 BOLD
			
		@ 004	, 004 SAY "DADOS IMPORTADOS : "       SIZE 369, 009 OF oDlcsv FONT oBold COLOR CLR_RED   PIXEL //CLR_BLUE
		oBtn := TButton():New( 016				, aPosObj[1][4] - 50,'Processar'		, oDlcsv,{|| MGFFINXZ()   ,oDlcsv:End(),IIF(bSair,oDlcsv:End(),bSair := .F.)  }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )   
		oBtn := TButton():New( 031 				, aPosObj[1][4] - 50,'Cancelar'		, oDlcsv,{|| RollbackSX8(),oDlcsv:End()}  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
		//oBtn := TButton():New( 016				, 750,'Importar Csv'	, oDlcsv,{|| MGFIMPCSV()  }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )   

		
	ACTIVATE MSDIALOG oDlcsv CENTERED
	
Return 

/*/   {Protheus.doc} MGFIMPCSV : Trata e valida o arvivo .csv
		a. Exibe log de erros quando existente
		b. Prepara dados para serem gravados  
@author Henrique Vidal
@since 23/07/2020
/*/	

Static Function MGFIMPCSV()

	Local lContinua	:= .T.
	Local lFirst	:= .T.
	Local nColunas	:= 9
	Local aDados	:= {}
	Local aErros	:= {}
	Local cLinha
	Private  cArq := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diret�rio onde se encontra o arquivo."), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)
	
	If !File(cArq)
		MsgStop("O arquivo " +cArq + " n�o foi selecionado. A importa��o ser� abortada!","ATENCAO")
		Return
	EndIf

	FT_FUSE(cArq)
	FT_FGOTOP()
	cLinha := FT_FREADLN()

	FT_FGOTOP()
		While !FT_FEOF()
			cLinha := FT_FREADLN()
			If lFirst
				aCampos := Separa(cLinha,";",.T.) 
				lFirst 	:= .F.
				lContinua := ChkEstru()
			Else
				aAdd(aDados,Separa(cLinha,";",.T.))
				If Len(aDados[Len(aDados)]) < nColunas
					lContinua := .F.
				Endif
			EndIf
			aBrowse := aDados
			FT_FSKIP()
		EndDo
	FT_FUSE()

Return(lContinua)

/*/   {Protheus.doc} ChkEstru : Valida exist�ncia dos campos, e erros no arquivo.
@author Henrique Vidal
@since 23/07/2020
/*/	
Static Function ChkEstru()
	Local lContinua := .T. 
	Local aErros	:= {}
	
	// Campos obrigat�rios no Excel, utilizado para gravar dados.
	nPCodCli	:= aScan(aCampos,{|x|�Alltrim(x)�==�"C�d. do Cliente"})	 			//	1
	nPLoja		:= aScan(aCampos,{|x|�Alltrim(x)�==�"C�d. da Loja"}) 	 			//	2
	nPNome		:= aScan(aCampos,{|x|�Alltrim(x)�==�"Nome do Cliente"})		
	nPCodRd		:= aScan(aCampos,{|x|�Alltrim(x)�==�"C�digo de rede"})				//	4
	nPVlrLCr	:= aScan(aCampos,{|x|�Alltrim(x)�==�"Vlr. Limite Credito Cliente"})	//	9
	nPVlCred	:= aScan(aCampos,{|x|�Alltrim(x)�==�"Data Limite Credito Cliente"})	//	10
	nPCondPg	:= aScan(aCampos,{|x|�Alltrim(x)�==�"Condi��o de Pagamento"})		//	11
	nPStaCli	:= aScan(aCampos,{|x|�Alltrim(x)�==�"Status do Cliente"})			//	23
	nPGerBol	:= aScan(aCampos,{|x|�Alltrim(x)�==�"Gera Boleto"})					//	24
	nPClaCli	:= aScan(aCampos,{|x|�Alltrim(x)�==�"Classe Cliente"})				//	25
	nPPenFin	:= aScan(aCampos,{|x|�Alltrim(x)�==�"Pend�ncia Financeira"})		//	26
	nPInaCom	:= aScan(aCampos,{|x|�Alltrim(x)�==�"Inatividade de Compra"})		//	27
	nPBloSin	:= aScan(aCampos,{|x|�Alltrim(x)�==�"Bloq Sintegra"})				//	28
	nPAutTem	:= aScan(aCampos,{|x|�Alltrim(x)�==�"Autoriz. Temp."})				//	29
	nPEmaCob	:= aScan(aCampos,{|x|�Alltrim(x)�==�"E-mail Cobran�a"})				//	30
	nPGraRed	:= aScan(aCampos,{|x|�Alltrim(x)�==�"Flg. Grandes Redes"})			//	31
	nPObsObs	:= aScan(aCampos,{|x|�Alltrim(x)�==�"Observa��o"})					//	32

	// Campos utilizados somente no browser.
	nPCnpj		:= aScan(aCampos,{|x|�Alltrim(x)�==�"CNPJ do Cliente"})		
	nPMunicp	:= aScan(aCampos,{|x|�Alltrim(x)�==�"Municipio"})		
	nPEst		:= aScan(aCampos,{|x|�Alltrim(x)�==�"Estado"})	
	nPCodSeg	:= aScan(aCampos,{|x|�Alltrim(x)�==�"C�d. do Segmento"})		
	nPDesSeg	:= aScan(aCampos,{|x|�Alltrim(x)�==�"Descri��o do Segmento"})		
	nPDCdPg		:= aScan(aCampos,{|x|�Alltrim(x)�==�"Descri��o Condi��o de Pagto"})		
	nPDRede		:= aScan(aCampos,{|x|�Alltrim(x)�==�"Descri��o Rede"})		
	nPExp		:= aScan(aCampos,{|x|�Alltrim(x)�==�"Exposi��o"})		
	nPdtCad		:= aScan(aCampos,{|x|�Alltrim(x)�==�"Data de Cadastro"})		
	nPNmPais	:= aScan(aCampos,{|x|�Alltrim(x)�==�"Nome do Pa�s"})		
	nPVlrAcm	:= aScan(aCampos,{|x|�Alltrim(x)�==�"Vlr. Acumulado"})		
	nPVlrMCP	:= aScan(aCampos,{|x|�Alltrim(x)�==�"Vlr. Maior Compra"})		
	nPUtCmp		:= aScan(aCampos,{|x|�Alltrim(x)�==�"Vlr. Ult. Compra 180 Dias"})	
		
	If nPCodCli	== 0 
		AADD(aErros , { '1' , " Campo: C�d. do Cliente - n�o localizado no cabe�alho da planilha. Linha 1."})	 			//	1
	 	lContinua := .F. 
  	EndIf 
	If nPLoja		== 0 
		AADD(aErros , { '1' , " Campo: C�d. da LojaHvs - n�o localizado no cabe�alho da planilha. Linha 1."})  				//	2
	 	lContinua := .F. 
  	EndIf 
	If nPNome		== 0 
		AADD(aErros , { '1' , " Campo: Nome do Cliente - n�o localizado no cabe�alho da planilha. Linha 1."})		
	 	lContinua := .F. 
  	EndIf 
	If nPCodRd		== 0 
		AADD(aErros , { '1' , " Campo: C�digo de rede - n�o localizado no cabe�alho da planilha. Linha 1."})				//	4
	 	lContinua := .F. 
  	EndIf 
	If nPVlrLCr	== 0 
		AADD(aErros , { '1' , " Campo: Vlr. Limite Credito Cliente - n�o localizado no cabe�alho da planilha. Linha 1."})	//	9
	 	lContinua := .F. 
  	EndIf 
	If nPVlCred	== 0 
		AADD(aErros , { '1' , " Campo: Data Limite Credito Cliente - n�o localizado no cabe�alho da planilha. Linha 1."})	//	10
	 	lContinua := .F. 
  	EndIf 
	If nPCondPg	== 0 
		AADD(aErros , { '1' , " Campo: Condi��o de Pagamento - n�o localizado no cabe�alho da planilha. Linha 1."})			//	11
	 	lContinua := .F. 
  	EndIf 
	If nPStaCli	== 0 
		AADD(aErros , { '1' , " Campo: Status do Cliente - n�o localizado no cabe�alho da planilha. Linha 1."})				//	23
	 	lContinua := .F. 
  	EndIf 
	If nPGerBol	== 0 
		AADD(aErros , { '1' , " Campo: Gera Boleto - n�o localizado no cabe�alho da planilha. Linha 1."})					//	24
	 	lContinua := .F. 
  	EndIf 
	If nPClaCli	== 0 
		AADD(aErros , { '1' , " Campo: Classe Cliente - n�o localizado no cabe�alho da planilha. Linha 1."})				//	25
	 	lContinua := .F. 
  	EndIf 
	If nPPenFin	== 0 
		AADD(aErros , { '1' , " Campo: Pend�ncia Financeira - n�o localizado no cabe�alho da planilha. Linha 1."})			//	26
	 	lContinua := .F. 
  	EndIf 
	If nPInaCom	== 0 
		AADD(aErros , { '1' , " Campo: Inatividade de Compra - n�o localizado no cabe�alho da planilha. Linha 1."})			//	27
	 	lContinua := .F. 
  	EndIf 
	If nPBloSin	== 0 
		AADD(aErros , { '1' , " Campo: Bloq Sintegra - n�o localizado no cabe�alho da planilha. Linha 1."})					//	28
	 	lContinua := .F. 
  	EndIf 
	If nPAutTem	== 0 
		AADD(aErros , { '1' , " Campo: Autoriz. Temp. - n�o localizado no cabe�alho da planilha. Linha 1."})				//	29
	 	lContinua := .F. 
  	EndIf 
	If nPEmaCob	== 0 
		AADD(aErros , { '1' , " Campo: E-mail Cobran�a - n�o localizado no cabe�alho da planilha. Linha 1."})				//	30
	 	lContinua := .F. 
  	EndIf 
	If nPGraRed	== 0 
		AADD(aErros , { '1' , " Campo: Flg. Grandes Redes - n�o localizado no cabe�alho da planilha. Linha 1."})			//	31
	 	lContinua := .F. 
  	EndIf 
	If nPObsObs	== 0 
		AADD(aErros , { '1' , " Campo: Observa��o - n�o localizado no cabe�alho da planilha. Linha 1."})					//	32
	 	lContinua := .F. 
  	EndIf 

	//Campos somente para preenchimento do browser
	If nPCnpj		== 0 
		AADD(aErros , { '1' , " Campo: CNPJ do Cliente - n�o localizado no cabe�alho da planilha. Linha 1."})		
	 	lContinua := .F. 
  	EndIf 
	If nPMunicp	== 0 
		AADD(aErros , { '1' , " Campo: Municipio - n�o localizado no cabe�alho da planilha. Linha 1."})		
	 	lContinua := .F. 
  	EndIf 
	If nPEst		== 0 
		AADD(aErros , { '1' , " Campo: Estado - n�o localizado no cabe�alho da planilha. Linha 1."})	
	 	lContinua := .F. 
  	EndIf 
	If nPCodSeg	== 0 
		AADD(aErros , { '1' , " Campo: C�d. do Segmento - n�o localizado no cabe�alho da planilha. Linha 1."})		
	 	lContinua := .F. 
  	EndIf 
	If nPDesSeg	== 0 
		AADD(aErros , { '1' , " Campo: Descri��o do Segmento - n�o localizado no cabe�alho da planilha. Linha 1."})		
	 	lContinua := .F. 
  	EndIf 
	If nPDCdPg		== 0 
		AADD(aErros , { '1' , " Campo: Descri��o Condi��o de Pagto - n�o localizado no cabe�alho da planilha. Linha 1."})		
	 	lContinua := .F. 
  	EndIf 
	If nPDRede		== 0 
		AADD(aErros , { '1' , " Campo: Descri��o Rede - n�o localizado no cabe�alho da planilha. Linha 1."})		
	 	lContinua := .F. 
  	EndIf 
	If nPExp		== 0 
		AADD(aErros , { '1' , " Campo: Exposi��o - n�o localizado no cabe�alho da planilha. Linha 1."})		
	 	lContinua := .F. 
  	EndIf 
	If nPdtCad		== 0 
		AADD(aErros , { '1' , " Campo: Data de Cadastro - n�o localizado no cabe�alho da planilha. Linha 1."})		
	 	lContinua := .F. 
  	EndIf 
	If nPNmPais	== 0 
		AADD(aErros , { '1' , " Campo: Nome do Pa�s - n�o localizado no cabe�alho da planilha. Linha 1."})		
	 	lContinua := .F. 
  	EndIf 
	If nPVlrAcm	== 0 
		AADD(aErros , { '1' , " Campo: Vlr. Acumulado - n�o localizado no cabe�alho da planilha. Linha 1."})		
	 	lContinua := .F. 
  	EndIf 
	If nPVlrMCP	== 0 
		AADD(aErros , { '1' , " Campo: Vlr. Maior Compra - n�o localizado no cabe�alho da planilha. Linha 1."})		
	 	lContinua := .F. 
  	EndIf 
	If nPUtCmp		== 0 
		AADD(aErros , { '1' , " Campo: Vlr. Ult. Compra 180 Dias - n�o localizado no cabe�alho da planilha. Linha 1."})	
	 	lContinua := .F. 
  	EndIf 
	
	If !lContinua
		MostraErr(aErros)
	EndIf 

Return lContinua

/*/MostraErr : Exibe erros na valida��o do arquivo.
@author Henrique Vidal
@since 23/07/2020 /*/	
Static Function MostraErr(aErros)

	Local aSizeAut    := MsAdvSize(,.F.,400)
	Local oDlg                    
	Local aBrwErr    	:= aErros 
	Local aObjects
	Local aInfo
	Local aPosObj
	
	aObjects := {}
	AAdd( aObjects, { 0		,  20, .T., .F. } )
	AAdd( aObjects, { 100	, 100, .T., .T. } )
	AAdd( aObjects, { 0		, 10, .T., .T. } )
	aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects ,.T. )


	DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE "Log: Leitura de erros no arquivo"  PIXEL
			  
		oBrw_Log := TWBrowse():New( 004,4,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]+10,;
								  ,,,oDlg, , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
		oBrw_Log:SetArray(aBrwErr)                                    
		oBrw_Log:bLine := {|| aEval(aBrwErr[oBrw_Log:nAt],{|z,w| aBrwErr[oBrw_Log:nAt,w] } ) }
		
		oBrw_Log:addColumn(TCColumn():new('Linha'			 ,{||aBrwErr[oBrw_Log:nAt][01]},"@!"        ,,,"LEFT"   ,020,.F.,.F.,,,,,))
		oBrw_Log:addColumn(TCColumn():new('Descri��o do Erro',{||aBrwErr[oBrw_Log:nAt][02]},"@!"        ,,,"LEFT"   ,050,.F.,.F.,,,,,))

		oBrw_Log:Setfocus() 
		oBtn := TButton():New( aSizeAut[4]-25	, 450,'Ok'			, oDlg,{|| oDlg:End()       }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
		
	ACTIVATE MSDIALOG oDlg CENTERED

Return()


Static Function MGFFINXZ()
	Private aArea     := GetArea()
	Private aArray    := {}
	Private _nAtu     := 0
	Private _cAtu     := " "
	Private _cTextCR  := " "
	Private _nAraux   := 0
	Private _cCond1	  := ''

	fwMsgRun(, {|oSay| procFin08( oSay ) }, "Processando arquivo", "Aguarde. Processando arquivo..." )

	RestArea( aArea )
Return

/*/Fun��es de grava��o dos dados:
	procFin08(), getZB1() , showLog() 
	foram herdadas da importa��o antiga Mgffin07, conforme solicitado pelo usu�rio. 
/*/	
Static Function procFin08()

	Local cClasse	:= ''
	Local cStatus	:= ''
	Local cGerBol	:= ''
	Local cLogSA1	:= ""
	Local aArray	:= aBrowse  // Alimentando vari�vel aArray para manter hist�rico da fun��o procFin08 herdada do programa MGFFin08

	For _nAraux := 1 To Len(aArray)
		_cCod   := Alltrim(aArray[_nAraux][nPCodCli])
		_cLoja  := Alltrim(aArray[_nAraux][nPLoja])
		_nLC    := VAL(Replace(aArray[_nAraux][nPVlrLCr],'.',''))    	//LC
		_dVLC   := cTOd(aArray[_nAraux][nPVlCred])         	//Validade LC
		_cCond  := StrTran(aArray[_nAraux][nPCondPg],chr(160))  //Condi��o Pgto

		cStatus := Alltrim(aArray[_nAraux][nPStaCli])
		cGerBol := Alltrim(aArray[_nAraux][nPGerBol])
		cClasse := Alltrim(aArray[_nAraux][nPClaCli])

		If UPPER(cStatus) == "LIBERADO"
			cStatus := "2"
		Else
			cStatus := "1"
		EndIf

		If UPPER(cGerBol) == "SIM"
			cGerBol := "S"
		Else
			cGerBol := "N"
		EndIf

		
		If !Empty(aArray[_nAraux][nPObsObs])//len(aArray[_nAraux]) > 31
			_cTextCR := aArray[_nAraux][nPObsObs]
		Else
			_cTextCR := ""
		Endif

		If !Empty( _cCond )

			If LEN(_cCond) < 2
				_cCond1 := "00" + _cCond
			ElseIf LEN(_cCond) < 3
				_cCond1 := "0" + _cCond
			Else
				_cCond1 := _cCond
			EndIf

			DbSelectArea("SE4")
			DbSetOrder(1)

			If !DbSeek(xFilial("SE4")+_cCond1)
				MSGAlert("Condi��o Pagto n�o encontrada. " + _cCond1 ,"Aten��o!")
				RestArea( aArea )
				Return()
			EndIf

		EndIf

		DbSelectArea("SA1")
		DbSetOrder(1)

		If DbSeek( xFilial( "SA1" ) + _cCod + _cLoja )
			cGrade := ""
			cGrade := getZB1()

			if !empty( cGrade )
				cLogSA1 += "CNPJ " + SA1->A1_CGC + " est?pendente na Grade de Aprova��o: " + cGrade + CRLF
			else
				if ( allTrim( aArray[ _nAraux ][ nPStaCli ] ) == "LIBERADO" .and. ( allTrim( aArray[ _nAraux ][ nPPenFin ] ) == "SIM" .or. allTrim( aArray[ _nAraux ][ nPInaCom ] ) == "SIM" ) );
					.OR.;
					( allTrim( aArray[ _nAraux ][ nPStaCli ] ) == "BLOQUEADO" .and. allTrim( aArray[ _nAraux ][ nPPenFin ] ) == "NAO" .and. allTrim( aArray[ _nAraux ][ nPInaCom ] ) == "NAO" )

					cLogSA1 += "Cliente " + SA1->A1_COD + "-" + SA1->A1_LOJA + " est?com bloqueio de cadastro inconsistente! " + CRLF
				else
					recLock("SA1", .F.)

					// MUDA FLAGS PARA ATUALIZAR OS SISTEMAS INTEGRADOS
					SA1->A1_XINTECO	:= '0' // ECOMMERCE
					SA1->A1_XINTSFO	:= 'P' // SALESFORCE
					SA1->A1_XINTEGX	:= 'P' // SFA

					SA1->A1_LC		:= _nLC
					SA1->A1_VENCLC	:= _dVLC

					if allTrim( aArray[ _nAraux ][ nPPenFin ] ) == "SIM" .or. allTrim( aArray[ _nAraux ][ nPInaCom ] ) == "SIM"
						SA1->A1_MSBLQL	:= "1"
					elseif allTrim( aArray[ _nAraux ][ nPPenFin ] ) == "NAO" .and. allTrim( aArray[ _nAraux ][ nPInaCom ] ) == "NAO"
						SA1->A1_MSBLQL	:= "2"
					endif

					// SA1->A1_MSBLQL	:= iif( allTrim( aArray[ _nAraux ][ 23 ] ) == "BLOQUEADO"	, "1" , "2" )

					SA1->A1_XPENFIN	:= iif( allTrim( aArray[ _nAraux ][ nPPenFin ] ) == "SIM"			, "S" , "N" )
					SA1->A1_ZINATIV	:= iif( allTrim( aArray[ _nAraux ][ nPInaCom ] ) == "SIM"			, "1" , "0" )
					SA1->A1_XBLQREC	:= iif( allTrim( aArray[ _nAraux ][ nPBloSin ] ) == "SIM"			, "S" , "N" )
					SA1->A1_XTEMPOR	:= iif( allTrim( aArray[ _nAraux ][ nPAutTem ] ) == "SIM"			, "S" , "N" )

					//SA1->A1_ZREDE	:= allTrim( aArray[ _nAraux ][ 04 ] )
					SA1->A1_ZREDE	:= allTrim( strTran( aArray[ _nAraux ][ nPCodRd ] , chr(160) , chr(32) ) )
					//SA1->A1_XMAILCO	:= allTrim( aArray[ _nAraux ][ 30 ] )
					SA1->A1_XMAILCO	:= allTrim( strTran( aArray[ _nAraux ][ nPEmaCob ] , chr(160) , chr(32) ) )

					SA1->A1_ZGDERED	:= iif( allTrim( aArray[ _nAraux ][ nPGraRed ] ) == "SIM" , "S" , "N" )

					If Alltrim(SA1->A1_ZBOLETO) <> cGerBol
						SA1->A1_ZBOLETO := cGerBol
					EndIf

					If Alltrim(SA1->A1_ZCLASSE) <> cClasse
						IF cClasse $ 'ABCDE'
							SA1->A1_ZCLASSE := cClasse
						Else
							SA1->A1_ZCLASSE := ' '
						EndIF
					EndIf

					if !Empty(_cTextCR)
						if Empty(SA1->A1_ZALTCRED)
							SA1->A1_ZALTCRED := DtoC(ddatabase)+" - "+SubStr(cUsuario,7,15)+" - Obs: "+_cTextCR
						Else
							SA1->A1_ZALTCRED := Alltrim(SA1->A1_ZALTCRED)+CRLF+DtoC(ddatabase)+" - "+SubStr(cUsuario,7,15)+" - Obs: "+_cTextCR
						Endif
					Endif
					If !Empty(_cCond1)
						SA1->A1_COND   := _cCond1
					EndIf
					_nAtu ++
					//_TMP_ARQ       := _cArqLog
					("SA1")->(MsUnlock())
				endif
			endif
		Else
			MSGAlert("Cliente n�o encontrado. " +  _cCod+" Loja "+_cLoja ,"Aten��o!")
		EndIf
	Next _nAraux
	_cAtu := STR(_nAtu)
	MSGInfo("Atualizac�ess:  " + (_cAtu) ,"Aten��o!")

	if !empty( cLogSA1 )
		cLogSA1 := "CNPJs que n�o foram atualizados:" + CRLF + cLogSA1
		showLog( cLogSA1 )
	endif
return

/*/Fun��es de grava��o dos dados:
	procFin08(), getZB1() , showLog() 
	foram herdadas da importa��o antiga Mgffin07, conforme solicitado pelo usu�rio. 
/*/	
static function getZB1()
	local aAreaX		:= getArea()
	local cQryZB1		:= ""
	local cApprovals	:= ""

	cQryZB1 := "SELECT ZB1.R_E_C_N_O_ ZB1RECNO , ZB6_NOME, ZB2.R_E_C_N_O_ ZB2RECNO"			+ CRLF
	cQryZB1 += " FROM "			+ retSQLName( "ZB1" ) + " ZB1"								+ CRLF
	cQryZB1 += " INNER JOIN "	+ retSQLName( "ZB2" ) + " ZB2"								+ CRLF
	cQryZB1 += " ON"																		+ CRLF
	cQryZB1 += " 		ZB2.ZB2_ID		=	ZB1.ZB1_ID"										+ CRLF
	cQryZB1 += " 	AND	ZB2.ZB2_STATUS	<>	'1'"											+ CRLF
	cQryZB1 += " 	AND	ZB2.ZB2_FILIAL	=	'" + xFilial("ZB2")	+ "'"						+ CRLF
	cQryZB1 += " 	AND	ZB2.D_E_L_E_T_	<>	'*'"											+ CRLF
	cQryZB1 += " LEFT JOIN "	+ retSQLName( "ZB6" ) + " ZB6"								+ CRLF
	cQryZB1 += " ON"																		+ CRLF
	cQryZB1 += " 		ZB6.ZB6_ID    	=	ZB2.ZB2_IDSET"									+ CRLF
	cQryZB1 += " 	AND	ZB6.ZB6_FILIAL	=	'" + xFilial("ZB6")	+ "'"						+ CRLF
	cQryZB1 += " 	AND	ZB6.D_E_L_E_T_	<>	'*'"											+ CRLF
	cQryZB1 += " WHERE"																		+ CRLF
	cQryZB1 += "		ZB1.ZB1_RECNO	=	'" + alltrim( str( SA1->( RECNO() ) ) ) + "'"	+ CRLF
	cQryZB1 += " 	AND	ZB1.ZB1_STATUS	IN	( '3' , '4' )"									+ CRLF // Solicita��o Aberta / Aprova��o em Andamento
	cQryZB1 += " 	AND	ZB1.ZB1_CAD		=	'1'"											+ CRLF // SA1 - Clientes
	cQryZB1 += " 	AND	ZB1.ZB1_FILIAL	=	'" + xFilial("ZB1")	+ "'"						+ CRLF
	cQryZB1 += " 	AND	ZB1.D_E_L_E_T_	<>	'*'"											+ CRLF

	tcQuery cQryZB1 new alias "QRYZB1"

	while !QRYZB1->( EOF() )
		cApprovals += allTrim( QRYZB1->ZB6_NOME ) + ";"

		QRYZB1->( DBSkip() )
	enddo

	if !empty( cApprovals )
		cApprovals := left( cApprovals , len( cApprovals ) - 1 )
	endif

	QRYZB1->( DBCloseArea() )

	restArea( aAreaX )
return cApprovals

/*/Fun��es de grava��o dos dados:
	procFin08(), getZB1() , showLog() 
	foram herdadas da importa��o antiga Mgffin07, conforme solicitado pelo usu�rio. 
/*/	
static function showLog( xMsg, cTitulo, cLabel, aButtons, bValid, lQuebraLinha )
	local oDlg
	local oMemo
	local oFont				:= TFont():New("Courier New",09,15)
	local bOk				:= { || oDlg:end() }
	local bCancel			:= { || oDlg:end() }
	local cMsg				:= ""
	local nQuebra			:= 68

	default xMsg			:= ""
	default cTitulo			:= ""
	default cLabel			:= ""
	default aButtons		:= {}
	default bValid			:= {|| .T. }
	default lQuebraLinha	:= .F.

   aadd( aButtons, { "NOTE" ,{ ||  openNotePa( .f., cMsg, "log.txt" ) }, "NotePad", } )

   // ** JPM - 06/10/05
   If ValType(xMsg) = "C"
      cMsg := xMsg
   ElseIf ValType(xMsg) = "A"
      For i := 1 To Len(xMsg)
         If xMsg[i][2] // Posi��o que define se far?quebra de linha
            For j := 1 To MLCount(xMsg[i][1],nQuebra)
               cMsg += MemoLine(xMsg[i][1], nQuebra, j) + ENTER
            Next
         Else
            cMsg += xMsg[i][1]
         EndIf
      Next
   EndIf

   Define MsDialog oDlg Title cTitulo From 9,0 To 39,85 of oDlg

      oPanel:= TPanel():New(0, 0, "", oDlg,, .F., .F.,,, 90, 165) //MCF - 15/07/2015 - Ajustes Tela P12.
      oPanel:Align:= CONTROL_ALIGN_ALLCLIENT

      @ 05,05 To 190,330 Label cLabel Pixel Of oPanel
      @ 10,10 Get oMemo Var cMsg MEMO HSCROLL FONT oFont Size 315,175 READONLY Of oPanel  Pixel

      oMemo:lWordWrap := lQuebraLinha
      oMemo:EnableVScroll(.t.)
      oMemo:EnableHScroll(.t.)

   Activate MsDialog oDlg On Init Enchoicebar(oDlg,bOk,bCancel,,,,,,aButtons,) Centered // BHF - 01/08/08 -> Trocado Enchoicebar por AvButtonBar

return
