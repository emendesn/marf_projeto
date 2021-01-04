#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "TOPCONN.CH"

/*
=====================================================================================
Programa............: MGFCOM93
Autor...............: Tarcisio Galeano
Data................: 07/2018
Descricao / Objetivo: Impressao pedido de compras
Doc. Origem.........: 
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
history : Atualizacoes das Informacoes do Texto 21/05/2020    
=====================================================================================
*/     


User Function MGFMATR()
Return ( U_REL1PCV() )

//U_AN_REL1PC
User Function REL1PCV()
	
	Local lRet 			:= .F.
	Local aAnexos		:= {}
	Local aParam 		:= {}
	Local cCCO 			:= ''
	Local cPara 		:= ''
	Local cCC 			:= ''
	Local cSubject 		:= ''
	Local cBody 		:= ''
	Local cNum 			:= ''
	Local nX
	
	


	Private lViewPDF 	:= .T.
	Private lPreview 	:= .T.
	Private lRecEmail   := .F.
	Private l_Debug     := .F.
	Private cEmailFor  	:= '' //UsrRetMail(RetCodUsr())
	Private cIniFile   	:= GetADV97()
	Private cComprador 	:= ''
	Private cLocEntrega := ''
	
	if IsInCallStack('U_FREL1DEBUG') 
		l_Debug      := .T.
	Endif
	
	//If GetRemoteType() == -1 .Or. l_Debug  //Job, Web ou Working Thread (Sem remote);
	//		
	//	RpcSetType ( 3 )
	//	wfprepenv('01' , '01010001' ,FUNNAME(),,)
		
	//	ChkFile("SX2",.f.)
	//	ChkFile("SX1",.f.)
	//	ChkFile("SIX",.f.)
	//	ChkFile("SX6",.f.)
	//	ChkFile("SX3",.f.)
	//	ChkFile("SM0",.f.)
	//	ChkFile("SC7",.f.)
		
	//	cNum 		:= '001089' //pc
	//	cCCO 		:= UsrRetMail("000050") 
		
	//Else
		
//SELECT DAS SCS
//aqui pega todos os pedidos que nao foram enviados.

//cAlias4	:= GetNextAlias()

//cQuery := " SELECT DISTINCT C7_FILIAL,C7_NUM " 
//cQuery += "	FROM " + RetSqlName("SC7") + " SC7" 
//cQuery += "	WHERE SC7.D_E_L_E_T_<>'*' AND C7_ZWFPC='S' AND C7_NUM ='016849' " //017013

	//If Select("TEMP1") > 0
	//	TEMP1->(dbCloseArea())
	//EndIf
	//cQuery  := ChangeQuery(cQuery)
	//dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TEMP1",.T.,.F.)
	//dbSelectArea("TEMP1")    
	//TEMP1->(dbGoTop())
                                                                                                       
    
	
//While TEMP1->(!Eof())

		cNum 		:= SC7->C7_NUM  //'090623' //
		//cCCO 		:= geteSOLIC() //UsrRetMail(RetCodUsr())
		cFilant     := SC7->C7_FILIAL
	//Endif
	
	//msgalert("entrou no pedido "+cNum)
	
	//aParam := fParm01()
	
	//if len(aParam)>0
		
		cLocEntrega := " " //aParam[1]
		
		//if Val( Left(MV_PAR01,1) )==1 //recebe copia e-mail 1=Sim, 2=Nao
		//	lRecEmail := .T.
		//Endif
		
		// if Val( Left(MV_PAR02,1) )==1 // Abri PDF
		// lViewPDF 	:= .T.
		lPreview 		:= .T.
		// Endif
		
		dbSelectArea("SC7")
		DbSetOrder(1)
		SC7->(dbSetOrder(1))
		If SC7->(MsSeek(xFilial("SC7")+cNum))
		IF SC7->C7_CONAPRO <> 'B' // nao imprimir bloqueado  

			
			SA2->(dbSetOrder(1))
			SA2->(DbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))
			
			cEmailFor 	:= AllTrim( SA2->A2_EMAIL )
			cComprador := UsrFullName(SC7->C7_USER)
			
			EnviaPCV(@aAnexos)
			
			//if l_Debug
			//	cPara 		:= 'tgaleano@totvspartners.com.br'
			//else
				cPara 		:= " " //' tgaleano@outlook.com' //cEmailFor //'tgaleano@outlook.com'
			//Endif
			
			if ( GetEnvServer() ==  "ENVIO PEDIDO DE COMPRAS - TESTE" )
				cLogo1 := "http://localhost:9595/workflow/MODELOS/IMAGENS/logo-america.png"
				cLogo2 := "http://localhost:9595/workflow/MODELOS/IMAGENS/pc_img_1.png"
			Else
				cLogo1 := "http://10.10.3.25:8181/workflow/MODELOS/IMAGENS/logo-america.png"
				cLogo2 := "http://10.10.3.25:8181/workflow/MODELOS/IMAGENS/pc_img_1.png"
			Endif
			cEmpFil := SM0->M0_NOMECOM + '-' + Rtrim(SM0->M0_CIDENT)+'/'+SM0->M0_ESTENT
			//cLocEnt := "Local de Entrega  : " + SM0->M0_ENDENT+"  "+Rtrim(SM0->M0_CIDENT)+"  - "+SM0->M0_ESTENT+" - "+"CEP :"+" "+Trans(Alltrim(SM0->M0_CEPENT),PesqPict("SA2","A2_CEP"))
			
			cStart2Path 	:= GetPvProfString(GetEnvServer(),"RootPath","ERROR", cIniFile )+'\WORKFLOW\HTML\xxx'
			cHtmlTemplate  	:= "\WORKFLOW\HTML\xxxMARFRIG_HTM.HTM"
			cBody 			:= WFLoadFile(cHtmlTemplate)
			cBody 			:= StrTran(cBody,chr(13),"")
			cBody 			:= StrTran(cBody,chr(10),"")
			cBody 			:= StrTran(cBody,"X_LOGO1",cLogo1)
			cBody 			:= StrTran(cBody,"X_LOGO2",cLogo2)
			cBody 			:= StrTran(cBody,"X_TITULO","PEDIDO DE COMPRA")
			cBody 			:= StrTran(cBody,"X_DOCTO","No.: " + cNum)
			cBody 			:= StrTran(cBody,"X_FILIAL",cEmpFil)
			cBody 			:= StrTran(cBody,"X_FORNECEDOR",SA2->A2_NREDUZ)
			cBody 			:= StrTran(cBody,"X_COMPRADOR",cComprador)
			
			//  chtmltexto  := strtran( chtmltexto, "LNK"+aNR_OS[nU][1]+'</td>', Trim(aNR_OS[nU][3]+'</td>') ) // atualiza links no html
			//	chtmltexto  := strtran( chtmltexto, "LNK"+aNR_OS[nU][1]+'</td>', Trim(aNR_OS[nU][3]+'</td>') ) // atualiza links no html
			
			cHtmlFirt := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
			cHtmlFirt +='<html xmlns="http://www.w3.org/1999/xhtml" >'
			cBody := StrTran(cBody , '<html>' , cHtmlFirt )
			//aqui copia
			cCC 		:= "tgaleano@outlook.com" //getesolicv()+";"+"wander.mota@hotmail.com" //UsrRetMail(RetCodUsr()) //Copia para usuario que enviou o pc para o fornecedor.
			cCCO		:= "tarcisio.galeano@totvspartners.com.br" //geteSOLIC()
			cSubject 	:= 'PEDIDO DE COMPRA - No. : ' + cNum
			
			
			cBody 		:= StrTran(cBody , '<html>' , cHtmlFirt )
			
			
			//lErrEml := EnviarMail( /*cFrom*/ , cPara, cCC, cSubject,aAnexos/*cAttach*/, cBody , , /*cSigaDpto*/,cCCO )
			//if !lErrEml
			//	ApMsgAlert('Pedido enviado ao Fornecedor com Sucesso','E-MAIL')
			//		dbSelectArea("SC7")
			//		RecLock('SC7',.F.)
			//			//SC7->C7_XWFID := oProcess:fProcessID
			//			SC7->C7_XWFENV := 'S' // Workflow enviado
			//		MsUnlock()
			//
			//Endif
		Else
		   msgalert("Nao permitido imprimir pedido bloqueado !!!!")
		Endif
		Endif
	//Endif

//TEMP1->(dbSKIP())

//cnum :=""

//EndDo
	
Return

Static Function fParm01()
	Local cCpyEml		:= OemToAnsi("2-Nao")
	Local cOpenPdf		:= OemToAnsi("2-Nao")
	Local aParamBox	 	:= {}
	Local aRet			:= {}
	Local oDlgWizard 	:= Nil
	Local cParFilEmp    := ''
	Local cLocEnt 		:= Space(120)
	
	
	//Private  _mvpar13      := ''    //-- Endereco de Entrega
	
	Pergunte("MTR110",.F.)
	//_mvpar13 := Space( len( MV_PAR13 ) )
	//_mvpar13 := SPACE(100) //MV_PAR13
	
	//aAdd(aParamBox, {2, "Receber uma Copia do E-mail"	, cCpyEml	, { OemToAnsi("2-Nao") , OemToAnsi("1-Sim")}, 100, "", .F.})
	//aAdd(aParamBox, {2, "Visualizar o Pedido"			, cOpenPdf	, { OemToAnsi("2-Nao") , OemToAnsi("1-Sim")}, 100, "", .F.})
	aAdd(aParamBox, {1, "Endereco de Entrega"			, cLocEnt , "@!S90" , , , , 200 , .F.} )
	
	//If ParamBox(aPerg,"SPED - NFe",@aParam,,,,,,,cParNfeExp,.T.,.T.)
	//Executa perguntas
	carqgrv := Alltrim(SM0->M0_CODIGO) + Alltrim(SM0->M0_CODFIL) + RetCodUsr()
	If ParamBox(aParamBox, OemToAnsi('PARAMETROS'), @aRet, , ,.T. , 256 , 130 ,oDlgWizard ,carqgrv ,.T.,.T.)
		varinfo('aRet',aRet)
	Else
		Conout( OemToAnsi('Impressao Canceladas.') )
	EndIf
	
	
Return ( aRet )


Static Function EnviaPCV(aAnexos)
	
	Local nX
	Local oPrinter
	Local _aArea    	:= GetArea()
	Local a_Anexos 		:= {}
	Local nRecnoSC7		:= SC7->(Recno())
	Local nDescProd 	:= 0
	Local cPictVUnit 	:= PesqPict("SC7","C7_PRECO",16)
	Local cPictVTot  	:= PesqPict("SC7","C7_TOTAL",, SC7->C7_MOEDA)
	Local nTxMoeda   	:= IIF(SC7->C7_TXMOEDA > 0,SC7->C7_TXMOEDA,Nil)
	Local cLocEnt 		:= ''
	Local cLocCob 		:= ''
	Local nTotIpi	   := 0
	Local nTotIcms	   := 0
	Local nTotDesp	   := 0
	Local nTotFrete	   := 0
	Local nTotalNF	   := 0
	Local nTotSeguro   := 0
	Local nTotMerc     := 0
	Local npipi        := 0
	Local npicm        := 0
	Local nI
	
	
	Private cTitulo		:= "Pedido de Compras"
	
	Private cBitmap	:= R110Logo()
	Private cBitAss	:= R110Logo()
	Private cFiltro		:= ""
	Private cCdPedido	:= SC7->C7_NUM
	
	Private cQy			:= ""
	Private nBor		:= 10
	Private nLin		:= 50
	Private nEsp		:= 50
	Private nColFim     := 2200
	Private cPath2 		:= ''
	
	
	Conout("Gerando pedido de compra para o fornecedor")
	
	
	oFont08  := TFont():New( "Courier New",,08,,.F.,,,,,.F. )
	oFont08B := TFont():New( "Courier New",,08,,.T.,,,,,.F. )
	oFont09  := TFont():New( "Courier New",,09,,.F.,,,,,.F. )
	oFont09B := TFont():New( "Courier New",,09,,.T.,,,,,.F. )
	oFont10  := TFont():New( "Courier New",,10,,.F.,,,,,.F. )
	oFont10B := TFont():New( "Courier New",,10,,.T.,,,,,.F. )
	oFont11  := TFont():New( "Courier New",,10,,.F.,,,,,.F. )
	oFont11B := TFont():New( "Courier New",,11,,.T.,,,,,.F. )
	oFont12  := TFont():New( "Courier New",,12,,.F.,,,,,.F. )
	oFont12B := TFont():New( "Courier New",,12,,.T.,,,,,.F. )
	oFont14B := TFont():New( "Courier New",,14,,.T.,,,,,.F. )
	oFont16  := TFont():New( "Courier New",,16,,.F.,,,,,.F. )
	oFont16B := TFont():New( "Courier New",,16,,.T.,,,,,.F. )
	oFont17  := TFont():New( "Courier New",,17,,.F.,,,,,.F. )
	oFont17B := TFont():New( "Courier New",,17,,.T.,,,,,.F. )
	oFont18  := TFont():New( "Courier New",,18,,.F.,,,,,.F. )
	oFont18B := TFont():New( "Courier New",,18,,.T.,,,,,.F. )
	
	
	//oFont18  := TFont():New( 'Courier New', 8, 18 )
	
	
	
	
	
	//������������������������������������������������������������������Ŀ
	//� Inicio objeto de impressao                                       �
	//��������������������������������������������������������������������
	
	
	oBrush := TBrush():New(,(0,0,0))
	
	
	//������������������������������������������������������������������Ŀ
	//� Inicio da Impressao                                              �
	//��������������������������������������������������������������������
	
	
	If oPrinter == Nil
		
		
		cStart1Path 	:= GetPvProfString(GetEnvServer(),"RootPath","ERROR", cIniFile )+'\WORKFLOW\ENV_PC_FORNECEDOR\'
		
		//CRIA DIRETORIOS
		MakeDir(Trim(Upper(cStart1Path)))
		
		
		cPath 	:= GetPvProfString(GetEnvServer(),"RootPath","ERROR", cIniFile )+'\WORKFLOW\ENV_PC_FORNECEDOR\PC_'+AlltoChar(Alltrim(SC7->C7_NUM))+CFILANT+'\'
		
		//cPath2 	:= '\WORKFLOW\ENV_PC_FORNECEDOR\PC_'+AlltoChar(Alltrim(SC7->C7_NUM))+'\'
		//cPath2 	:= '\WORKFLOW\EMP01\TEMP\PC_'+AlltoChar(Alltrim(SC7->C7_NUM))+CFILANT+'\'
		cPath2 	:= '\WORKFLOW\EMP01\TEMP\'
		
		//MontaDir(cPath2)
		
		cFileFull := cPath2 + cCdPedido+cFilant+".pdf"
		
		cTempMaq := GETTEMPPATH()
		
		//if file(cPath+cCdPedido+".pdf")
		//	FErase(cPath+cCdPedido+".pdf")
		//Endif
		
		//if file(cFileFull)
		//	FErase(cFileFull)
		//Endif
		
		oPrinter := FWMSPrinter():New(cCdPedido+cFilant,6,.T.,,.T.)
		
		//FWMsPrinter(): New ( 'don', 6, .F.,, .T.,,,,,, [ lRaw],.F.,)
		
		oPrinter:SetPortrait()
		//oPrinter:Setup()
		oPrinter:SetPaperSize(9)
		oPrinter:SetMargin(60,60,60,60)
		
		// MakeDir(Trim(Upper(cPath))) //CRIA DIRETOTIO ENTRADA
		
		oPrinter:lServer := .T.
		//oPrinter:cPathPDF := cPath
		oPrinter:cPathPDF := cTempMaq
		oPrinter:SetViewPDF(lViewPDF)
		
	EndIF
	
	//inicio impressao cabecalho
	Impcabec(oPrinter)
	//fim cabecalho
	
	//-- itens
	SC7->(dbSetOrder(1))
	if SC7->(MsSeek( xFilial("SC7") + cCdPedido ))
		nCneg := 50
		nC_0 := 35
		//nC_1 := 100-nCneg
		//nC_2 := 200-nCneg
		//nC_3 := 400-nCneg
		//nC_4 := 600-nCneg  + 400
		//nC_5 := 750-nCneg  + 320
		//nC_6 := 1000-nCneg + 350
		//nC_7 := 1300-nCneg + 350
		//nC_8 := 1650-nCneg + 240
		//nC_9 := 1800-nCneg + 350

		nC_1 := 50
		nC_2 := 150
		nC_3 := 350
		nC_4 := 850  
		nC_5 := 950  
		nC_6 := 1200
		nC_7 := 1500 
		nC_8 := 1700 
		nC_9 := 1900 
		nC_10 := 2000 
		nC_11 := 2100 
		
		nTPC := 0
		
		oPrinter:Say(nLin, 	nC_0 	,"|", oFont11)
		oPrinter:FillRect({nLin ,0050,nLin+(nBor-5),nColFim } , oBrush) //Linha            
		oPrinter:Say(nLin,	nC_9+300	,"|",oFont11)
		
		nLin+= -10
		
		oPrinter:Say(nLin-10 , nC_0 	, "|"	 				, oFont11)
		oPrinter:Say(nLin-10 , nC_1 	, "Item" 				, oFont11B 	,, CLR_BLUE)
		oPrinter:Say(nLin-10 , nC_2 	, "Produto" 			, oFont11B 	,, CLR_BLUE)
		oPrinter:Say(nLin-10 , nC_3 	, "Descricao" 			, oFont11B 	,, CLR_BLUE)
		oPrinter:Say(nLin-10 , nC_4 	, "UM" 					, oFont11B 	,, CLR_BLUE)
		oPrinter:Say(nLin-10 , nC_5 	, "Quantidade" 			, oFont11B	,, CLR_BLUE)
		oPrinter:Say(nLin-10 , nC_6 	, "Vr. Unitario" 		, oFont11B	,, CLR_BLUE)
		oPrinter:Say(nLin-10 , nC_7 	, "Vr.Total" 			, oFont11B	,, CLR_BLUE)
		oPrinter:Say(nLin-10 , nC_8 	, "Dt.Entrega" 			, oFont11B	,, CLR_BLUE)
		oPrinter:Say(nLin-10 , nC_9 	, "Moeda" 				, oFont11B	,, CLR_BLUE)
		oPrinter:Say(nLin-10 , nC_10 	, "%ICMS" 				, oFont11B	,, CLR_BLUE)
		oPrinter:Say(nLin-10 , nC_11 	, "%IPI" 				, oFont11B	,, CLR_BLUE)
		oPrinter:Say(nLin,	nC_9+300	,"|",oFont11)
		
		//nLin += nEsp-20
		nTotal     	:= 0
		nTotMerc   	:= 0
		lPriVez 	:= .T.
		cObs_x 		:= ''
		While !SC7->(EOF()) .And. xFilial("SC7") == SC7->C7_FILIAL .And. cCdPedido == SC7->C7_NUM
			
			dbSelectArea("SB1")
			dbSetOrder(1)
			If MsSeek(xFilial("SB1")+SC7->C7_PRODUTO)
				
				if lPriVez
					cFiltro := ""
					MaFisEnd()
					R110FIniPC(SC7->C7_NUM,,,cFiltro)
					lPriVez:= .f.
				endif
				
				cmoeda := ""
				if SC7->C7_MOEDA = 1
				   	cmoeda="R$"
				ENDIF
				if SC7->C7_MOEDA = 2
					cmoeda="US$"
				endif
				if SC7->C7_MOEDA = 3
					cmoeda="UFIR"
				endif
				if SC7->C7_MOEDA = 4
					cmoeda="EUR"
				endif
				if SC7->C7_MOEDA = 5
					cmoeda="YEN"
				endif
				if SC7->C7_MOEDA = 6
					cmoeda="GBP"
				endif
				if SC7->C7_MOEDA = 7
					cmoeda="CHF"
				endif
				if SC7->C7_MOEDA = 8
					cmoeda="UPF"
				endif
				if SC7->C7_MOEDA = 9
					cmoeda="UFERMS"
				endif
				if SC7->C7_MOEDA = 10
					cmoeda="A$"
				endif
				if SC7->C7_MOEDA = 11
					cmoeda="$C"
				endif
				if SC7->C7_MOEDA = 12
					cmoeda="EURC"
				endif
				if SC7->C7_MOEDA = 13
					cmoeda="FRC"
				endif
			
				//IF SC7->C7_ZWFPC='S'				
					nTPC += SC7->C7_TOTAL
					nLin += nEsp-12
					oPrinter:Say(nLin, 	nC_0 	,"|"				   		, oFont11)
					oPrinter:Say(nLin, 	nC_1 	,SC7->C7_ITEM				, oFont11)
					oPrinter:Say(nLin, 	nC_2 	,SC7->C7_PRODUTO			, oFont11)
					oPrinter:Say(nLin, 	nC_3 	,LEFT(SC7->C7_DESCRI,30)	, oFont11)
					oPrinter:Say(nLin,	nC_4	,SC7->C7_UM  , oFont11)
					oPrinter:Say(nLin,	nC_5-100	,Transform(SC7->C7_QUANT , PesqPict("SC7","C7_QUANT") ),oFont11)
					oPrinter:Say(nLin,	nC_6-80	,Transform(SC7->C7_PRECO , PesqPict("SC7","C7_PRECO") ),oFont11)
					oPrinter:Say(nLin,	nC_7-120	,Transform(SC7->C7_TOTAL , PesqPict("SC7","C7_TOTAL") ),oFont11)
					oPrinter:Say(nLin,	nC_8+10	,dtoc(SC7->C7_DATPRF) ,oFont11)
					oPrinter:Say(nLin,	nC_9	,CMOEDA ,oFont11)
					oPrinter:Say(nLin,	nC_10	,Transform(SC7->C7_PICM , PesqPict("SC7","C7_PICM") ),oFont11)
					oPrinter:Say(nLin,	nC_11	,Transform(SC7->C7_IPI , PesqPict("SC7","C7_IPI") ),oFont11)
					oPrinter:Say(nLin,	nC_9+300	,"|",oFont11)
                                
					IF len(alltrim(SC7->C7_DESCRI)) > 30
					nLin += nEsp-12
					oPrinter:Say(nLin, 	nC_0 	,"|"				   		, oFont11)
					oPrinter:Say(nLin,	nC_9+300	,"|",oFont11)
					oPrinter:Say(nLin, 	nC_3 	,SUBSTR(SC7->C7_DESCRI,31,30)				, oFont11)
                	ENDIF
                //endif
			Endif

				nLin += nEsp-12
				oPrinter:Say(nLin, 	nC_0 	,"|"				   		, oFont11)
				oPrinter:Say(nLin,	nC_9+300	,"|",oFont11)
				oPrinter:FillRect({nLin,0050,nLin+(nBor-5),nColFim } , oBrush) //Linha

			
			If SC7->C7_DESC1 != 0 .Or. SC7->C7_DESC2 != 0 .Or. SC7->C7_DESC3 != 0
				nDescProd+= CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
			Else
				nDescProd+=SC7->C7_VLDESC
			Endif
			
			If !EMPTY(SC7->C7_OBS)
				cObs_x+= '[ It: '+SC7->C7_ITEM + '-' + Alltrim(SC7->C7_OBS) + ' ] '
			Endif
			
		if nLin > 2500	
			oPrinter:EndPage()
            nlin := 50
            nEsp := 50
            Impcabec(oprinter)
		endif	

			SC7->(dbSkip())
		EndDo
		
		
	Endif
	
	SC7->(dbGoto(nRecnoSC7))
	
	nTotIpi	  := MaFisRet(,'NF_VALIPI')
	nTotIcms  := MaFisRet(,'NF_VALICM')
	nTotDesp  := MaFisRet(,'NF_DESPESA')
	nTotFrete := MaFisRet(,'NF_FRETE')
	nTotSeguro:= MaFisRet(,'NF_SEGURO')
	nTotalNF  := MaFisRet(,'NF_TOTAL')
	nTotMerc   := MaFisRet(,"NF_TOTAL")
	//MaFisEnd()
	
	if nLin < 500	
		nLin += 1500 //170
	else
		nLin += 500 //170
	endif
	
	oPrinter:FillRect({nLin ,0050,nLin+(nBor-5),nColFim } , oBrush) //Linha
	nLin += nEsp
	oPrinter:Say(nLin-20,	nC_1		,'D E S C O N T O S --> ',oFont11)
	oPrinter:Say(nLin-20,	nC_5-100		,Transform(SC7->C7_DESC1 , "999.99" )+ " %    " ,oFont11)
	oPrinter:Say(nLin-20,	nC_6-100		,Transform(SC7->C7_DESC2 , "999.99" )+ " %    " ,oFont11)
	oPrinter:Say(nLin-20,	nC_7-100		,Transform(SC7->C7_DESC3 , "999.99" )+ " %    " ,oFont11)
	oPrinter:Say(nLin-20,	nC_8-100 	,TransForm( xMoeda(nDescProd,SC7->C7_MOEDA,1,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , PesqPict("SC7","C7_VLDESC",12)) ,oFont11)
	
	//nLin += 20
	oPrinter:FillRect({nLin ,0050,nLin+(nBor-5),nColFim } , oBrush) //Linha
	nLin += nEsp
	//CONDPAGTO
	SE4->(dbSetOrder(1))//E4_FILIAL+E4_CODIGO
	SE4->(dbSeek(xFilial("SE4")+SC7->C7_COND))
	
	//ASIGNA CONDICION PAGO
	cCondPag		:= SE4->E4_CODIGO + " - " + RTRIM(SE4->E4_DESCRI)
	
	oPrinter:Say(nLin,0100,"Condicao de Pagamento: ",oFont10B)
	oPrinter:Say(nLin,0550,cCondPag,oFont10)
	
	nLin += nEsp
	
	oPrinter:FillRect({nLin,0050,nLin+(nBor-5),nColFim } , oBrush) //Linha
	
	nLin += nEsp
	
	//��������������������������������������������������������������Ŀ
	//� Posiciona o Arquivo de Empresa SM0.                          �
	//� Imprime endereco de entrega do SM0 somente se o MV_PAR13 =" "�
	//� e o Local de Cobranca :                                      �
	//����������������������������������������������������������������
	
	//nLin += nEsp
	
	
	SM0->(dbSetOrder(1))
	nRecnoSM0 := SM0->(Recno())
	SM0->(dbSeek(SC7->C7_FILENT))
	
	cCident := IIF(len(SM0->M0_CIDENT)>20,Substr(SM0->M0_CIDENT,1,15),SM0->M0_CIDENT)
	cCidcob := IIF(len(SM0->M0_CIDCOB)>20,Substr(SM0->M0_CIDCOB,1,15),SM0->M0_CIDCOB)
	
	//Pergunte("MTR110",.F.)
	
	//If Empty(cLocEntrega) //"Local de Entrega  : "
		cLocEnt := "Local de Entrega  : " + SM0->M0_ENDENT+"  "+Rtrim(SM0->M0_CIDENT)+"  - "+SM0->M0_ESTENT+" - "+"CEP :"+" "+Trans(Alltrim(SM0->M0_CEPENT),PesqPict("SA2","A2_CEP"))
	//Else
		//--imprime o endereco digitado na pergunte
	//	cLocEnt := "Local de Entrega  : " + Alltrim(cLocEntrega)
	//Endif
	SM0->(dbGoto(nRecnoSM0))
	
	// "Local de Cobranca : "
	cLocCob := "Local de Cobranca : " + SM0->M0_ENDCOB+"  "+Rtrim(SM0->M0_CIDCOB)+"  - "+SM0->M0_ESTCOB+" - "+"CEP :"+" "+Trans(Alltrim(SM0->M0_CEPCOB),PesqPict("SA2","A2_CEP"))
	
	oPrinter:Say(nLin,	nC_1	,cLocEnt,oFont11)
	nLin += nEsp
	oPrinter:Say(nLin,	nC_1	,cLocCob,oFont11)
	
	nLin += 20
	oPrinter:FillRect({nLin ,0050,nLin+(nBor-5),nColFim } , oBrush) //Linha
	nLin += nEsp
	oPrinter:Say(nLin,	nC_1	    ,'Solicitante           : ' +getSOLICV()   ,oFont11)
	nLin += nEsp
	oPrinter:Say(nLin,	nC_1	    ,'Comprador Responsavel : ' +getcompradV()   ,oFont11)
	
	//transportadora
	frx := ""
	frx := IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF",IF(SC7->C7_TPFRETE $ "T","Por Conta Terceiros"," " )))
	nLin += 20
	oPrinter:FillRect({nLin ,0050,nLin+(nBor-5),nColFim } , oBrush) //Linha
	nLin += nEsp
	oPrinter:Say(nLin,	nC_1	    ,'Tipo de Frete : '+frx+'  Transportadora         : ' +gettranspV()   ,oFont11)
	
	//-- TOTAL MERCADORIA / IMPOSTOS.
	nLin += 20
	oPrinter:FillRect({nLin ,0050,nLin+(nBor-5),nColFim } , oBrush) //Linha
	nLin += nEsp
	
//INTERA��O PARA IMPORTA��O 26/09/18 - RAFA E ALEX
IF  SA2->A2_TIPO = "X"
	//oPrinter:Say(nLin,	nC_1	    ,'IPI......: ' + Transform(xMoeda(nTotIPI ,SC7->C7_MOEDA,1,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotIpi ,14,MsDecimais(1))),oFont11)
	//oPrinter:Say(nLin,	nC_3+200	,'ICM......: ' + Transform(xMoeda(nTotIcms,SC7->C7_MOEDA,1,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotIcms,14,MsDecimais(1))),oFont11)
	oPrinter:Say(nLin,	nC_1	    ,'IPI ......: '+ trans(nTotIPI,"99,999,999.99"),oFont11)
	oPrinter:Say(nLin,	nC_3+200	,'ICM ......: '+ trans(nTotIcms,"99,999,999.99"), oFont11)

	oPrinter:Say(nLin,	nC_7-220	, 'Total das Mercadorias...: ' + trans(nTPC,"99,999,999.99") , oFont11)

	nLin += nEsp

	oPrinter:Say(nLin,	nC_1		, 'Frete....: ' + trans(nTotFrete,"99,999,999.99") , oFont11)
	oPrinter:Say(nLin,	nC_3+200	, 'Despesas.: ' + trans(nTotDesp,"99,999,999.99")  , oFont11)
	nLin += nEsp
	oPrinter:Say(nLin,	nC_1		, 'Seguro...: ' + trans(nTotSeguro,"99,999,999.99") , oFont11)

	nTotMerc := nTPC+nTotFrete+nTotDesp+nTotSeguro-nDescProd+nTotIPI

	oPrinter:Say(nLin,	nC_7-220	, 'Total com Impostos......: ' + trans(nTotMerc,"99,999,999.99")  ,oFont11)

ELSE
	//oPrinter:Say(nLin,	nC_1	    ,'IPI......: ' + Transform(xMoeda(nTotIPI ,SC7->C7_MOEDA,1,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotIpi ,14,MsDecimais(1))),oFont11)
	//oPrinter:Say(nLin,	nC_3+200	,'ICM......: ' + Transform(xMoeda(nTotIcms,SC7->C7_MOEDA,1,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotIcms,14,MsDecimais(1))),oFont11)
	oPrinter:Say(nLin,	nC_1	    ,'IPI ......: '+ Transform(xMoeda(nTotIPI ,SC7->C7_MOEDA,1,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotIpi ,14,MsDecimais(1))),oFont11)
	oPrinter:Say(nLin,	nC_3+200	,'ICM ......: '+ Transform(xMoeda(nTotIcms,SC7->C7_MOEDA,1,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotIcms,14,MsDecimais(1))),oFont11)

	oPrinter:Say(nLin,	nC_7-220	, 'Total das Mercadorias...: ' + Transform(xMoeda(nTPC,SC7->C7_MOEDA,1,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTPC,14,MsDecimais(1)) ),oFont11)

	nLin += nEsp

	oPrinter:Say(nLin,	nC_1		, 'Frete....: ' + Transform(xMoeda(nTotFrete,SC7->C7_MOEDA,1,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotFrete,14,MsDecimais(1))),oFont11)
	oPrinter:Say(nLin,	nC_3+200	, 'Despesas.: ' + Transform(xMoeda(nTotDesp ,SC7->C7_MOEDA,1,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotDesp ,14,MsDecimais(1))),oFont11)
	nLin += nEsp
	oPrinter:Say(nLin,	nC_1		, 'Seguro...: ' + Transform(xMoeda(nTotSeguro ,SC7->C7_MOEDA,1,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotSeguro ,14,MsDecimais(1))),oFont11)

	nTotMerc := nTPC+nTotFrete+nTotDesp+nTotSeguro-nDescProd+nTotIPI

	oPrinter:Say(nLin,	nC_7-220	, 'Total com Impostos......: ' + Transform(xMoeda(nTotMerc,SC7->C7_MOEDA,1,SC7->C7_DATPRF,MsDecimais(SC7->C7_MOEDA),nTxMoeda) , tm(nTotMerc,14,MsDecimais(1)) ) ,oFont11)

ENDIF
	
	//-- OBSERVACOES
	
	/*nLin += 20
	oPrinter:FillRect({nLin ,0050,nLin+(nBor-5),nColFim } , oBrush) //Linha
	nLin += nEsp
	
	oPrinter:Say(nLin,	nC_1		,  'OBSERVA��O'  ,oFont11)
	
	if len(cObs_x) <170
		nLin += nEsp
		oPrinter:Say(nLin,	nC_1		,  cObs_x  ,oFont09)
	Else
		nLin += nEsp
		oPrinter:Say(nLin,	nC_1		,  Substr(cObs_x,1,170)  ,oFont09)
		nLin += nEsp
		oPrinter:Say(nLin,	nC_1		,  Substr(cObs_x,171,170)  ,oFont09)
		if len(cObs_x)>(187*2)+1
			nLin += nEsp
			oPrinter:Say(nLin,	nC_1		,  Substr(cObs_x,341,170)  ,oFont09)
		Endif
	Endif
	
	
	nLin += 20
	oPrinter:FillRect({nLin ,0050,nLin+(nBor-5),nColFim } , oBrush) //Linha
	nLin += nEsp
	*/
	
	// OSERVACAO 2
	nLin += 20
	oPrinter:FillRect({nLin ,0050,nLin+(nBor-5),nColFim } , oBrush) //Linha
	nLin += nEsp
	
//	oPrinter:Say(nLin,	nC_1		, 'NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do nosso Pedido de Compras.',oFont11B)
	
			oPrinter:Say(nLin,	nC_1		, "O B S E R V A C O E S",oFont11 )
			nLin += nEsp   
			oPrinter:Say(nLin,	nC_1		, "1. Qualquer hipotese de desconto  ou  recebimento  antecipado  dos valores advindos da presente  relacao � vedada, sendo ", oFont10B ) 
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "   permitida apenas se autorizada pela contratante.", oFont10B )
			nLin += nEsp                                                                                                                                             
			nLin += nEsp   

			oPrinter:Say(nLin,	nC_1		, "2. Encaminhar a nota fiscal eletronica para o endereco de e-mail: recebe_nfe@marfrig.com.br. Essa conta de e-mail nao ", oFont11 )
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "   recebera XML, PDF ou boleto das NFs de servico;", oFont11 )
			nLin += nEsp                                                                                                                                             
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "3. Comunicamos a todos os fornecedores  que  em  atendimento  ao  ajuste SINIEF 11/2008 que estabelece a obrigacao de ", oFont11 )
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "   disponibilizacao do arquivo XML referente emissao de nota fiscal eletronica a partir de 01/10/2013 as empresas  do ", oFont11 ) 
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "   Grupo Marfrig s� recebera mercadorias cujo o arquivo XML tenha previamente sido enviado para o  e-mail  a  seguir: ", oFont11 ) 
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "   recebe_nfe@marfrig.com.br, DANFE, cujo XML nao tenha sido  previamente  enviado  sera  recusado  juntamente com  a ", oFont11 ) 
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "   mercadoria  no momento  do  recebimento.  NF  de servi��s devem ser enviadas para e-mails dos Estados no qual sera ", oFont11 ) 
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "   efetuada a prestacao de servico, conforme abaixo:", oFont11 )
			nLin += nEsp                                                                                                                                             
			nLin += nEsp                                                                                                                                             
            IF SM0->M0_ESTENT="RS"
			oPrinter:Say(nLin,	nC_1		, "RS recebe.notafiscalservico-rs@marfrig.com.br", oFont11 )
			nLin += nEsp                                                                                                                                             
			ENDIF
            IF SM0->M0_ESTENT="GO"
			oPrinter:Say(nLin,	nC_1		, "GO recebe.notafiscalservico-go@marfrig.com.br", oFont11 )
			nLin += nEsp                                                                                                                                             
			ENDIF
            IF SM0->M0_ESTENT="MT"
			oPrinter:Say(nLin,	nC_1		, "MT recebe.notafiscalservico-mt@marfrig.com.br", oFont11 )
			nLin += nEsp                                                                                                                                             
			ENDIF
            IF SM0->M0_ESTENT="MS"
			oPrinter:Say(nLin,	nC_1		, "MS recebe.notafiscalservico-ms@marfrig.com.br", oFont11 )
			nLin += nEsp                                                                                                                                             
			ENDIF
            IF SM0->M0_ESTENT="PR"
			oPrinter:Say(nLin,	nC_1		, "PR recebe.notafiscalservico-pr@marfrig.com.br", oFont11 )
			nLin += nEsp                                                                                                                                             
			ENDIF
            IF SM0->M0_ESTENT="SP"
			oPrinter:Say(nLin,	nC_1		, "SP recebe.notafiscalservico-sp@marfrig.com.br", oFont11 )
			nLin += nEsp                                                                                                                                             
			ENDIF
            IF SM0->M0_ESTENT="PA"
			oPrinter:Say(nLin,	nC_1		, "PA recebe.notafiscalservico-pa@marfrig.com.br", oFont11 )
			nLin += nEsp                                                                                                                                             
			ENDIF
            IF SM0->M0_ESTENT="RO"
			oPrinter:Say(nLin,	nC_1		, "RO recebe.notafiscalservico-ro@marfrig.com.br", oFont11 )
			nLin += nEsp                                                                                                                                             
			ENDIF
            IF SM0->M0_ESTENT="RJ"
			oPrinter:Say(nLin,	nC_1		, "RJ recebe.notafiscalservico-rj@marfrig.com.br", oFont11 )
			nLin += nEsp                                                                                                                                             
            ENDIF
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "Empresas que nao se enquadram nesta obrigacao favor desconsiderar esta mensagem.", oFont11 )
			nLin += nEsp                                                                                                                                             
			nLin += nEsp                                                                                                                                             

		//if nLin > 2500	
			oPrinter:EndPage()
            nlin := 50
            nEsp := 50
            Impcabec(oprinter)
		//endif	


			oPrinter:Say(nLin,	nC_1		, "4. O arquivo XML devera conter obrigatoriamente as informacoes abaixo:", oFont11 )
			nLin += nEsp                                                                                                                                             
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "   Numero do Pedido de Compra", oFont11 )
			nLin += nEsp                                                                                                                                             
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "   Codigo do Item - Marfrig", oFont11 )
			nLin += nEsp                                                                                                                                             
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "5. A data de vencimento para pagamento, assim como todas as retencoes de impostos devem estar destacados no corpo da NF;", oFont11 )
			nLin += nEsp                                                                                                                                             
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "6. Os pagamentos serao efetuados somente para contas bancarias cadastradas no mesmo CNPJ contida na NF;", oFont11 )
			nLin += nEsp                                                                                                                                             
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "7. Para que nao haja divergencia entre NF e Pedido, observe todos os itens do pedido de compras e em caso de  duvidas", oFont11 )
			nLin += nEsp                                                                                                                                             
		    oPrinter:Say(nLin,	nC_1		, "	  entre em contato com o comprador;", oFont11 )
			nLin += nEsp                                                                                                                                             
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "8. � obrigatorio o uso da transportadora indicada no pedido de compra com o Frete FOB. Caso  nao ocorra, o  valor  do ", oFont11 )
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "	  frete sera revertido para o fornecedor;", oFont11 )
			nLin += nEsp                                                                                                                                             
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "9. O nao cumprimento destas regras acarretar� em bloqueio do pagamento da nota fiscal. Duvidas  entrar em contato com", oFont11 )
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "	  o comprador;", oFont11 )
			nLin += nEsp                                                                                                                                             
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "10. Para agendamento de entregas no CD Itupeva, entrar em contato atraves do telefone (11) 4591-6005  ou  por  e-mail: ", oFont10B ) 
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "   agendamento.almoxarifado@marfrig.com.br;", oFont10B )
			nLin += nEsp                                                                                                                                             
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "11. Recebimento de insumos (embalagens, quimicos e ingredientes) � proibido o recebimentos desses materiais sem a  ", oFont11 ) 
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "   apresentacao do laudo de qualidade referente ao lote de descarga;", oFont11 )
			nLin += nEsp                                                                                                                                             
			nLin += nEsp                                                                                                                                             
			
			oPrinter:Say(nLin,	nC_1		, "12. Horario de Recebimento: das 08:00 as 15:00 horas.", oFont11 )
			nLin += nEsp                                                                                                                                             
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "Regras especificas para contratacao de servi��s externos abaixo de 200 mil reais:", oFont11 )
			nLin += nEsp                                                                                                                                             
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "A subcontratacao do servico ora contratado � vedada, sendo permitida apenas se autorizada pela contratante.", oFont11 )
			nLin += nEsp                                                                                                                                             
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "Caso a contratada nao entregue os servicos no prazo sob as  condicoes  estipuladas  incidirao multa  diaria  de 1%  do ", oFont11 ) 
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "valor contratado, por dia de atraso, limitada a 10%.", oFont11 )
			nLin += nEsp                                                                                                                                              
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "Caso nao haja disposicao expressa da contatada que indique prazo maior  de  garantia  contratual,  prevalecer�  prazo ", oFont11 ) 
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "manimo de garantia contratual de 90 dias.", oFont11 )
			nLin += nEsp                                                                                                                                             
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "A cessao do presente termo � vedada a contratada, sendo permitida apenas se autorizada pela contratante.", oFont10B )
			nLin += nEsp                                                                                                                                             
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "A contratada se compromete a manter sigilo sobre todas as informacoes tecnicas, industriais  e comerciais a  que teve ", oFont11 )
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "acesso, pelo per��odo de 5 anos.", oFont11 )
			nLin += nEsp                                                                                                                                             
			nLin += nEsp                                                                                                                                             
			                                                                                                                                       
			oPrinter:Say(nLin,	nC_1		, "A contratada compromete-se a nao incorrer em qualquer das condutas do artigo 5 da lei anticorrupcao, e que ressarcira ", oFont11 )
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "a contratante de quaisquer prejuizos a que der causa.", oFont11 )
			nLin += nEsp                                                                                                                                             
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "A contratada  declara  se  ciente do  Codigo  de  conduta  e  etica da  Marfrig  e  de  sua  politica  anticorrupcao, ", oFont11 )
			nLin += nEsp                                                                                                                                             
			oPrinter:Say(nLin,	nC_1		, "disponibilizados no site: http://compliance.marfrig.com.br", oFont11 )
			nLin += nEsp                                                                                                                                             
			nLin += nEsp                                                                                                                                             
	
	
	
	nLin += 20
	oPrinter:FillRect({nLin ,0050,nLin+(nBor-5),nColFim } , oBrush) //Linha
	nLin += nEsp
	
	//-- RODAPE.
	/*nLin := 2700+200
	nCNeg:= 10
	oPrinter:FillRect({nLin,0050,nLin+(nBor-5),nColFim } , oBrush) //Linha
	nLin += nEsp-nCNeg
	oPrinter:Say(nLin,0800,SM0->M0_ENDCOB,oFont11B)
	nLin += nEsp-nCNeg
	oPrinter:Say(nLin,0800,Alltrim(SM0->M0_BAIRCOB)+" - "+Alltrim(SM0->M0_CIDCOB)+" - "+Alltrim(SM0->M0_ESTCOB);
		+" - CEP: "+Transform(Alltrim(SM0->M0_CEPCOB),PesqPict("SA2","A2_CEP")),oFont11B)
	nLin += nEsp-nCNeg
	//oPrinter:Say(nLin,0500-200,"Telefone: "+Alltrim(SM0->M0_TEL)+" - EnviarMail: " + UsrRetMail(RetCodUsr()) + " - Home Page: www.americanet.com.br",oFont11B)
	oPrinter:Say(nLin,0500,"Telefone: "+Alltrim(SM0->M0_TEL)+" - EnviarMail: " + UsrRetMail(RetCodUsr()) ,oFont11B)
	nLin += nEsp-nCNeg
	oPrinter:Say(nLin,0790,"CNPJ: "+Transform(Alltrim(SM0->M0_CGC),PesqPict("SA2","A2_CGC"))+" - Inscri��o Estadual: "+Alltrim(SM0->M0_INSC),oFont11B)
	oPrinter:EndPage()
	
	//Atualizo o campo do SD2
	//cQuery:=" UPDATE "+RetSQlName("SD2")+" SET D2_NOMCERT='"+cCdPedido+".pdf' WHERE D2_ITEM='"+TMP1->D2_ITEM+"' AND D2_COD='"+TMP1->D2_COD+"' AND D_E_L_E_T_='' "
	//cQuery+=" AND D2_DOC='"+TMP1->D2_DOC+"' AND D2_SERIE='"+TMP1->D2_SERIE+"'
	//TcSQlExec(cQuery)
	*/
	
	If lPreview
		oPrinter:Preview()
	EndIf
	
	*****************************************************
	// Copia arquivos do remote local para o servidor, sem compactar antes de transmitir
	*****************************************************
	//if file(cTempMaq+cCdPedido+cFilant+".pdf")
		//lCpSrvOk := CpyT2S( cTempMaq+cCdPedido+cFilant+".pdf", cPath2 , .F. )
		
		//if lCpSrvOk
	  //		aAdd(a_Anexos,cPath2+cCdPedido+cFilant+".pdf")
		//Endif
		
	//endif
	//vick
	//aAdd(a_Anexos,cPath2+cCdPedido+".pdf")
	
	//if len(a_Anexos)>0
	//	aAnexos := aClone(a_Anexos)
	//Endif
	
	FreeObj(oPrinter)
	oPrinter := Nil
	
	
	FT_PFLUSH()
	
	
Return



Static Function EnviarMail( cDe, cPara, cCc, cAssunto, aAnexo, cMsg , lExibInfo , cSigaDpto , cCCO)
	Local lErrEml := .F.
	Local cCtaEml := ''
	Local cSenEml := ''
	
	DEFAULT lExibInfo 	:= .F.
	DEFAULT cSigaDpto 	:= ''
	
	/*
	if !Empty(cSigaDpto)
		cCtaEml := U_R9CtaPsw(1,cSigaDpto)   //'CHAMADOS.FIN@AAAAAA.COM.BR'
		cSenEml := U_R9CtaPsw(2,cSigaDpto)   //'Senha*622'
	Endif
	*/
	
	If EnvMail( cDe, cPara, cCc, cAssunto, aAnexo, cMsg , /*cCtaEml*/ , /*cSenEml*/ , cCCO )
		if lExibInfo
			MsgInfo( 'E-mail enviado com sucesso.' )
		Endif
	Else
		lErrEml := .T.
		if lExibInfo
			Alert( 'Erro ao enviar e-mail.' )
		Endif
	EndIf
	
Return ( lErrEml )



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � EnvMail  �Autor  �Ernani Forastieri   � Data �             ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina Generica de Envio de E-mail                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function EnvMail( cDe, cPara, cCc, cAssunto, aAnexos , cMsg ,cCtaEml ,cSenEml, cCCO )
	
	Local lResulConn := .T.
	Local lResulsend := .T.
	Local cError     := ''
	Local cServer    := Trim( GetMV( 'MV_RELSERV',, '' ) )  // "smtp.a85.com.br:587"
	Local cEmail     := Trim( GetMV( 'MV_RELACNT',, '' ) )  //"reltotvs@a85.com.br" 	//Trim( GetMV( 'MV_RELACNT',, '' ) )  // "workflow_totvs_teste@a85.com.br"
	Local cPass      := Trim( GetMV( 'MV_RELPSW' ,, '' ) ) // "22j4V#PO"   			//Trim( GetMV( 'MV_RELPSW' ,, '' ) )  // "T0Tv$@mN&t17"
	Local lAuth      := GetMV( 'MV_RELAUTH',, .F.  )  // .T.
	Local cContAuth  := Trim( GetMV( 'MV_RELACNT',, '' ) )  // "reltotvs@a85.com.br"   // // "workflow_totvs_teste@a85.com.br"
	Local cPswAuth   := cPass  //Trim( GetMV( 'MV_RELAPSW',, '' ) ) //"22j4V#PO"  // // "T0Tv$@mN&t17"
	Local cFrom	     := Trim(GetMV('MV_RELFROM'))  // "reltotvs@a85.com.br"   //		// "workflow_totvs_teste@a85.com.br"/ e-mail utilizado no campo From'MV_RELACNT' ou 'MV_RELFROM' e 'MV_RELPSW'
	Local lRet       := .T.
	Local nA         := 0
	Local cAnexoAux  := ''
	Local nLoopAux 	 := 0
	
	DEFAULT cMsg       := ''
	DEFAULT cCtaEml    := ''
	DEFAULT cSenEml    := ''
	DEFAULT cCCO       := ''
	DEFAULT cCc        := ''
	DEFAULT cPara      := ''
	DEFAULT aAnexos    := {}
	
	
	For nLoopAux := 1 to Len(aAnexos)
		cAnexoAux += Alltrim(aAnexos[nLoopAux])
		If nLoopAux < Len(aAnexos)
			cAnexoAux += ";"
		Endif
	Next nLoopAux
	
	cAnexo := cAnexoAux
	
	If ( !Empty( cCtaEml ) .And. !Empty(cSenEml) )
		cEmail      := cCtaEml
		cContAuth   := cCtaEml
		cFrom	    := cCtaEml
		cServer     := '' //'smtp-gw.aaaaaa.com.br:587'
		lAuth       := .T.
		cPass       := cSenEml // "Senha*886"
		cPswAuth    := cSenEml // "Senha*886"
	Endif
	
	
	If Empty( cServer ) .AND. Empty( cEmail ) .AND. Empty( cPass )
		lRet := .F.
		cMsg := 'Nao foram definidos um ou mais parametros de configura��o para envio de e-mail pelo Protheus.'
		
		ConOut( cMsg )
		
		If !IsBlind()
			ApMsgStop( cMsg, cAssunto )
		EndIf
		
		Return lRet
	EndIf
	
	cDe      := IIf( cDe == NIL, cFrom, AllTrim( cDe ) )
	cDe      := IIf( Empty( cDe ), cEmail, cDe )
	cPara    := AllTrim( cPara )
	cCC      := AllTrim( cCC )
	cCCO     := AllTrim( cCCO )
	cAssunto := IIf( Empty( cAssunto), '<sem assunto>', AllTrim( cAssunto ) )
	cAnexo   := AllTrim( cAnexo )
	cAnexo   := IIf(  Left( cAnexo, 1 ) == ';', SubStr( cAnexo, 2 )                  , cAnexo )
	cAnexo   := IIf( Right( cAnexo, 1 ) == ';', SubStr( cAnexo, 1, Len( cAnexo) - 1 ), cAnexo )
	
	If lAuth
		If Empty( cContAuth ) .OR. Empty( cPswAuth )
			lRet := .F.
			cMsg := 'Nao foram definidos conta ou senha de autentica��o para envio de e-mail pelo Protheus.'
			
			ConOut( cMsg )
			
			If !IsBlind()
				ApMsgStop( cMsg, cAssunto )
			EndIf
			
			Return lRet
		EndIf
	EndIf
	
	
	CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPass RESULT lResulConn
	
	If !lResulConn
		lRet := .F.
		
		GET MAIL ERROR cError
		cMsg := 'Falha na conexao para envio de e-mail ( ' + cError + ' ) '
		ConOut( cMsg )
		
		If !IsBlind()
			ApMsgStop( cMsg, cAssunto )
		EndIf
		
		Return lRet
	EndIf
	
	If lAuth
		//
		// Primeiro tenta fazer a Autenticacao de E-mail utilizando o e-mail completo
		//
		If !( lRet := MailAuth( cContAuth, cPswAuth )   )
			//
			// Se nao conseguiu fazer a Autenticacao usando o E-mail completo,
			// tenta fazer a autenticacao usando apenas o nome de usuario do E-mail
			//
			If !lRet
				nA        := At( '@', cContAuth )
				cContAuth := If( nA > 0, SubStr( cContAuth, 1, nA - 1 ), cContAuth )
				
				If !( lRet  := MailAuth( cContAuth, cPswAuth ) )
					lRet := .F.
					cMsg := 'Nao conseguiu autenticar conta de e-mail ( ' + cContAuth + ' ) '
					
					ConOut( cMsg )
					
					If !IsBlind()
						ApMsgAlert( cMsg )
					EndIf
					
					DISCONNECT SMTP SERVER
					
					Return lRet
				EndIf
				
			EndIf
		EndIf
	EndIf
	
	cFrom := cDe
	If AllTrim( Lower( cDe ) ) <> AllTrim( Lower( cEmail ) )
		cFrom := AllTrim( cDe ) + ' <' + AllTrim( cEmail ) + '>'
	EndIf
	
	if Empty(cAnexo)
		SEND MAIL FROM cFrom TO cPara CC cCc BCC cCCO SUBJECT cAssunto BODY cMsg RESULT lResulSend
	else
		SEND MAIL FROM cFrom TO cPara CC cCc BCC cCCO SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend
	endif
	
	
	If !lResulSend
		GET MAIL ERROR cError
		lRet := .F.
		cMsg := 'Falha no envio do e-mail ( ' + cError + ' ) '
		
		ConOut( cMsg )
		
		If !IsBlind()
			ApMsgStop( cMsg, cAssunto )
		EndIf
		
	Else
		ConOut( 'Enviado e-mails para:')
		ConOut( 'De ...........: [' + cFrom    + ']'  )
		ConOut( 'Para .........: [' + cPara    + ']'  )
		ConOut( 'Copia ........: [' + cCc    + ']'  )
		ConOut( 'Copia Oculta .: [' + '*'    + ']'  )
		ConOut( 'Assunto ......: [' + cAssunto + ']'  )
		ConOut( 'Anexo.........: [' + cAnexo + ']'  )
	EndIf
	
	DISCONNECT SMTP SERVER
	
Return lRet



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �R110FIniPC� Autor � Edson Maricate        � Data �20/05/2000���
�������������������������������������������������������������������������Ĵ��
���Descricao � Inicializa as funcoes Fiscais com o Pedido de Compras      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � R110FIniPC(ExpC1,ExpC2)                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 := Numero do Pedido                                  ���
���          � ExpC2 := Item do Pedido                                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR110,MATR120,Fluxo de Caixa                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R110FIniPC(cPedido,cItem,cSequen,cFiltro)
	
	Local aArea		:= GetArea()
	Local aAreaSC7	:= SC7->(GetArea())
	Local cValid		:= ""
	Local nPosRef		:= 0
	Local nItem		:= 0
	Local cItemDe		:= IIf(cItem==Nil,'',cItem)
	Local cItemAte	:= IIf(cItem==Nil,Repl('Z',Len(SC7->C7_ITEM)),cItem)
	Local cRefCols	:= ''
	DEFAULT cSequen	:= ""
	DEFAULT cFiltro	:= ""
	
	dbSelectArea("SC7")
	dbSetOrder(1)
	If dbSeek(xFilial("SC7")+cPedido+cItemDe+Alltrim(cSequen))
		MaFisEnd()
		MaFisIni(SC7->C7_FORNECE,SC7->C7_LOJA,"F","N","R",{})
		While !Eof() .AND. SC7->C7_FILIAL+SC7->C7_NUM == xFilial("SC7")+cPedido .AND. ;
				SC7->C7_ITEM <= cItemAte .AND. (Empty(cSequen) .OR. cSequen == SC7->C7_SEQUEN)
			
			// Nao processar os Impostos se o item possuir residuo eliminado
			If &cFiltro
				dbSelectArea('SC7')
				dbSkip()
				Loop
			EndIf
			
			// Inicia a Carga do item nas funcoes MATXFIS
			nItem++
			MaFisIniLoad(nItem)
			dbSelectArea("SX3")
			dbSetOrder(1)
			dbSeek('SC7')
			While !EOF() .AND. (X3_ARQUIVO == 'SC7')
				cValid	:= StrTran(UPPER(SX3->X3_VALID)," ","")
				cValid	:= StrTran(cValid,"'",'"')
				If "MAFISREF" $ cValid .And. SX3->X3_CONTEXT <> "V"
					nPosRef  := AT('MAFISREF("',cValid) + 10
					cRefCols := Substr(cValid,nPosRef,AT('","MT120",',cValid)-nPosRef )
					// Carrega os valores direto do SC7.
					MaFisLoad(cRefCols,&("SC7->"+ SX3->X3_CAMPO),nItem)
				EndIf
				dbSkip()
			End
			MaFisEndLoad(nItem,2)
			dbSelectArea('SC7')
			dbSkip()
		End
	EndIf
	
	RestArea(aAreaSC7)
	RestArea(aArea)
	
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �R110Logo  � Autor � Materiais             � Data �07/01/2015���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorna string com o nome do arquivo bitmap de logotipo    ���
�����������������������������￝��������������������������������������������Ĵ��
��� Uso      � MATR110                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function R110Logo()

Local cBitmap := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP" // Empresa+Filial

//��������������������������������������������������������������Ŀ
//� Se nao encontrar o arquivo com o codigo do grupo de empresas �
//� completo, retira os espacos em branco do codigo da empresa   �
//� para nova tentativa.                                         �
//����������������������������������������������������������������
If !File( cBitmap )
	cBitmap := "LGRL" + AllTrim(SM0->M0_CODIGO) + SM0->M0_CODFIL+".BMP" // Empresa+Filial
EndIf

//��������������������������������������������������������������Ŀ
//� Se nao encontrar o arquivo com o codigo da filial completo,  �
//� retira os espacos em branco do codigo da filial para nova    �
//� tentativa.                                                   �
//����������������������������������������������������������������
If !File( cBitmap )
	cBitmap := "LGRL"+SM0->M0_CODIGO + AllTrim(SM0->M0_CODFIL)+".BMP" // Empresa+Filial
EndIf

//��������������������������������������������������������������Ŀ
//� Se ainda nao encontrar, retira os espacos em branco do codigo�
//� da empresa e da filial simultaneamente para nova tentativa.  �
//����������������������������������������������������������������
If !File( cBitmap )
	cBitmap := "LGRL" + AllTrim(SM0->M0_CODIGO) + AllTrim(SM0->M0_CODFIL)+".BMP" // Empresa+Filial
EndIf

//��������������������������������������������������������������Ŀ
//� Se nao encontrar o arquivo por filial, usa o logo padrao     �
//����������������������������������������������������������������
If !File( cBitmap )
	cBitmap := "LGRL"+SM0->M0_CODIGO+".BMP" // Empresa
EndIf

Return cBitmap

//------------------------------------------------------------------------
// 
//------------------------------------------------------------------------
static function impcabec(oprinter)
	oPrinter:StartPage()
	oPrinter:SayBitmap(nLin+120,0100,cBitMap,230+150,60+100) //[4]-> largura [5]-> altura
	nLin += (nEsp*4)
	//oPrinter:Say(nLin+40,0100,Alltrim(SM0->M0_CODFIL) + '-' + Alltrim(SM0->M0_NOMECOM),oFont14B)
	//oPrinter:Say(nLin+40,0100,Alltrim(SM0->M0_NOMECOM)+"                        PEDIDO DE COMPRA N.� "+cCdPedido,oFont17B,,CLR_HRED)
	
    IF SUBST(SC7->C7_OBS,1,2) = "SC"
		oPrinter:Say(nLin+40,0100,"                                      AUTORIZAC�o DE ENTREGA N� "+cCdPedido,oFont17B,,CLR_HRED)
	else
		oPrinter:Say(nLin+40,0100,"                                            PEDIDO DE COMPRA N� "+cCdPedido,oFont17B,,CLR_HRED)
    endif
	//oPrinter:Say(nLin+100,0850,"PEDIDO DE COMPRA N.� "+cCdPedido,oFont17B,,CLR_HRED)
	
	nLin += nEsp
	oPrinter:FillRect({nLin,0050,nLin+nBor,nColFim } , oBrush) //Linha
	
	//nLin += nEsp
	//oPrinter:Say(nLin+20,0850,"PEDIDO DE COMPRA N.� "+cCdPedido,oFont17B,,CLR_HRED)
	
	//nLin += (nEsp*2)-30
	
	//oPrinter:Say(nLin,0100,"Data Emissao:",oFont10B)
	//oPrinter:Say(nLin,0350,DTOC(SC7->C7_EMISSAO),oFont10)
	
	//SM0->(dbSetOrder(1))
	//SM0->(dbSeek(substr(cFilAnt,1,2)+cFilAnt))
		
	SM0->(dbSetOrder(1))//M0_CODIGO + M0_CODFIL
	SM0->(dbSeek(SM0->M0_CODIGO + cFilAnt))

	//nLin += nEsp
    CEND  :=""
    CENDF :=""
    CCNPJ :="" 
    CEND  := Transform(SM0->M0_CEPENT,PesqPict("SA2","A2_CEP"))+ " - " + RTRIM(SM0->M0_CIDENT) + " - " + SM0->M0_ESTENT+space(40)
    CENDF := Transform(Alltrim(SA2->A2_CEP),PesqPict("SA2","A2_CEP"))+" - "+Alltrim(SA2->A2_BAIRRO)+" - "+Alltrim(SA2->A2_MUN)+" - "+SA2->A2_EST
    //CCNPJ := Transform(Alltrim(SA2->A2_CGC),PesqPict("SA2","A2_CGC"))+"  IE :"+SA2->A2_INSCR+SPACE(40)
    CCNPJ := Transform(Alltrim(SM0->M0_CGC),PesqPict("SA2","A2_CGC"))+"  IE :"+SM0->M0_INSC+SPACE(40)
	nEsp	:= 30
	//nLin += nEsp
	
	//oPrinter:Say(nLin+40,0050,"|" + SPACE(072)+" | "+SPACE(063)+"|",oFont10B)
	//nLin += nEsp
	oPrinter:Say(nLin+40,0035,"|" ,oFont10B)
	oPrinter:Say(nLin+40,0100,"EMPRESA  :" + SUBSTR(SM0->M0_NOMECOM,1,60)+" | Razão Social : "+SUBSTR(SA2->A2_NOME,1,60),oFont10B)
	oPrinter:Say(nLin+40,0050,+space(140)+"|" ,oFont10B)
	nLin += nEsp
	oPrinter:Say(nLin+40,0035,"|" ,oFont10B)
	oPrinter:Say(nLin+40,0100,"CNPJ     :" + SUBSTR(CCNPJ,1,60)+" | CNPJ         : "+Transform(Alltrim(SA2->A2_CGC),PesqPict("SA2","A2_CGC"))+"  IE :"+SA2->A2_INSCR,oFont10B)
	oPrinter:Say(nLin+40,0050,+space(140)+"|" ,oFont10B)
	nLin += nEsp
	oPrinter:Say(nLin+40,0035,"|" ,oFont10B)
	oPrinter:Say(nLin+40,0100,"Endereco :" + SUBSTR(SM0->M0_ENDENT,1,60)+" | Endereco     : "+SUBSTR(Alltrim(SA2->A2_END),1,60),oFont10B)
	oPrinter:Say(nLin+40,0050,+space(140)+"|" ,oFont10B)
	nLin += nEsp
	oPrinter:Say(nLin+40,0035,"|" ,oFont10B)
	oPrinter:Say(nLin+40,0100,"CEP      :" + SUBSTR(CEND,1,60)+" | CEP          : "+SUBSTR(CENDF,1,60),oFont10B)
	oPrinter:Say(nLin+40,0050,+space(140)+"|" ,oFont10B)
	nLin += nEsp
	oPrinter:Say(nLin+40,0035,"|" ,oFont10B)
	oPrinter:Say(nLin+40,0100,"Telefone :" + SM0->M0_TEL+"                                               | Telefone     : "+SA2->A2_DDD+" "+SA2->A2_TEL,oFont10B)                                    
	oPrinter:Say(nLin+40,0050,+space(140)+"|" ,oFont10B)
	//nLin += nEsp
	nLin += nEsp

	nEsp	:= 40
	nLin += nEsp
	
	oPrinter:FillRect({nLin,0050,nLin+(nBor-5),nColFim } , oBrush) //Linha
	
	//nLin += nEsp
	//nLin += nEsp
	nLin += nEsp


return


//------------------------------------------------------------------------
// 
//------------------------------------------------------------------------
static function getCompradV()
	local cRetSC1 := ""
	local ctel    := ""
	local cemail  := ""

	If !Empty(SC7->C7_COMPRA)

		cRetSC1 := GetAdvFVal( "SY1","Y1_NOME",xFilial( "SY1" ) +  SC7->C7_COMPRA , 1, "" ) 
	Else	
		cRetSC1 := GetAdvFVal( "SY1","Y1_NOME",xFilial( "SY1" ) + GetAdvFVal('SC1', 'C1_CODCOMP', xFilial( 'SC1' ) + SC7->( C7_NUMSC + C7_ITEMSC ), 1, ''), 1, "" ) 
	Endif
		ctel   := GetAdvFVal( "SY1","Y1_TEL",xFilial( "SY1" ) +  SC7->C7_COMPRA , 1, "" ) 
		cemail := GetAdvFVal( "SY1","Y1_EMAIL",xFilial( "SY1" ) +  SC7->C7_COMPRA , 1, "" ) 
	
	if !empty( cRetSC1 )
		cRetSC1 := left( cRetSC1, 25 )+" - "+ctel+" - "+cemail
	endif

return cRetSC1
//------------------------------------------------------------------------
// 
//------------------------------------------------------------------------
static function getsolicV()
	local cRetSC1 := ""
	local cnome := ""
    local cmail := ""
    local ctel  := ""

	//Local cUser := UsrFullName(GetAdvFVal('SC1', 'C1_SOLICIT', xFilial( 'SC1' ) + SUBST(SC7->C7_OBS,6,6) , 1, ''))

	    cNextAlias := GetNextAlias()
        
        // AQUI TRATAR O SOLICIANTE PARA A AE
        
        IF SUBST(SC7->C7_OBS,1,2) = "SC"
			cUser := AllTrim(GetAdvFVal('SC1', 'C1_SOLICIT', xFilial( 'SC1' ) + SUBST(SC7->C7_OBS,6,6) , 1, ''))
			ctel  := AllTrim(GetAdvFVal('SAI', 'AI_TEL', xFilial( 'SC1' ) + SUBST(SC7->C7_OBS,6,6) , 1, ''))

        ELSE
			cUser := AllTrim(GetAdvFVal('SC1', 'C1_SOLICIT', xFilial( 'SC1' ) + SC7->C7_NUMSC , 1, ''))
        ENDIF


		BeginSql Alias cNextAlias

			SELECT
				USR_NOME,USR_EMAIL
			FROM
				SYS_USR USR
			WHERE
				USR.D_E_L_E_T_ =' ' and
				USR.USR_CODIGO = %exp:cUser%
		EndSql

		(cNextAlias)->(dbGoTop())

		While (cNextAlias)->(!EOF())
			cnome := (cNextAlias)->USR_NOME
            cmail := (cNextAlias)->USR_EMAIL
			Exit
			(cNextAlias)->(dbSkip())
		EndDo

	     //msgalert("soliitante"+SC1->C1_SOLICIT+"  "+cNOME)
	If !Empty(CNOME)
		cRetSC1 := CNOME+" - "+CMAIL+" - "+CTEL 
	Endif
	
	//if !empty( cRetSC1 )
	//	cRetSC1 := left( cRetSC1, 25 )
	//endif

return cRetSC1
                                                                        
//----------------------------------------------
// Retorna a transportadora
//----------------------------------------------
static function getTranspV()
	local cRetTransp	:= ""
	local cQrySC8		:= ""

	cQrySC8 := "SELECT C8_ZTRANSP, A4_NOME"
	cQrySC8 += " FROM "			+ retSQLName( "SC8" ) + " SC8"
	cQrySC8 += " INNER JOIN "	+ retSQLName( "SA4" ) + " SA4"
	cQrySC8 += " ON"
	cQrySC8 += " 		SA4.A4_COD		=	SC8.C8_ZTRANSP"
	cQrySC8 += " 	AND	SA4.A4_FILIAL	=	'" + xFilial( "SA4" )	+ "'"
	cQrySC8 += " 	AND	SA4.D_E_L_E_T_	<>	'*'"
	cQrySC8 += " WHERE"
	cQrySC8 += " 		SC8.C8_NUMPED	=	'" + SC7->C7_NUM		+ "'"
	cQrySC8 += " 	AND	SC8.C8_FILIAL	=	'" + xFilial( "SC8" )	+ "'"
	cQrySC8 += " 	AND	SC8.D_E_L_E_T_	<>	'*'"

	TcQuery cQrySC8 New Alias "QRYSC8"

	if !QRYSC8->( EOF() )
		cRetTransp := QRYSC8->A4_NOME
	endif

	QRYSC8->(DBCloseArea())
return cRetTransp
//------------------------------------------------------------------------
// 
//------------------------------------------------------------------------
static function getesolicV()
	local cRetSC1 := ""
	local cnome := ""
    local cmail := ""
    local ctel  := ""

	//Local cUser := UsrFullName(GetAdvFVal('SC1', 'C1_SOLICIT', xFilial( 'SC1' ) + SUBST(SC7->C7_OBS,6,6) , 1, ''))

	    cNextAlias := GetNextAlias()
        
        // AQUI TRATAR O SOLICIANTE PARA A AE
        
        IF SUBST(SC7->C7_OBS,1,2) = "SC"
			cUser := AllTrim(GetAdvFVal('SC1', 'C1_SOLICIT', xFilial( 'SC1' ) + SUBST(SC7->C7_OBS,6,6) , 1, ''))
			ctel  := AllTrim(GetAdvFVal('SAI', 'AI_TEL', xFilial( 'SC1' ) + SUBST(SC7->C7_OBS,6,6) , 1, ''))

        ELSE
			cUser := AllTrim(GetAdvFVal('SC1', 'C1_SOLICIT', xFilial( 'SC1' ) + SC7->C7_NUMSC , 1, ''))
        ENDIF


		BeginSql Alias cNextAlias

			SELECT
				USR_NOME,USR_EMAIL
			FROM
				SYS_USR USR
			WHERE
				USR.D_E_L_E_T_ =' ' and
				USR.USR_CODIGO = %exp:cUser%
		EndSql

		(cNextAlias)->(dbGoTop())

		While (cNextAlias)->(!EOF())
			cnome := (cNextAlias)->USR_NOME
            cmail := (cNextAlias)->USR_EMAIL
			Exit
			(cNextAlias)->(dbSkip())
		EndDo

	     //msgalert("soliitante"+SC1->C1_SOLICIT+"  "+cNOME)
	If !Empty(CNOME)
		cRetSC1 := CMAIL 
	Endif
	
	//if !empty( cRetSC1 )
	//	cRetSC1 := left( cRetSC1, 25 )
	//endif

return cRetSC1

//------------------------------------------------------------------------
// 
//------------------------------------------------------------------------
static function geteCompradV()
	local cRetSC1 := ""
	local ctel    := ""
	local cemail  := ""

	If !Empty(SC7->C7_COMPRA)

		cRetSC1 := GetAdvFVal( "SY1","Y1_NOME",xFilial( "SY1" ) +  SC7->C7_COMPRA , 1, "" ) 
	Else	
		cRetSC1 := GetAdvFVal( "SY1","Y1_NOME",xFilial( "SY1" ) + GetAdvFVal('SC1', 'C1_CODCOMP', xFilial( 'SC1' ) + SC7->( C7_NUMSC + C7_ITEMSC ), 1, ''), 1, "" ) 
	Endif
		ctel   := GetAdvFVal( "SY1","Y1_TEL",xFilial( "SY1" ) +  SC7->C7_COMPRA , 1, "" ) 
		cemail := GetAdvFVal( "SY1","Y1_EMAIL",xFilial( "SY1" ) +  SC7->C7_COMPRA , 1, "" ) 
	
	if !empty( cRetSC1 )
		cRetSC1 := cemail
	endif

return cRetSC1
