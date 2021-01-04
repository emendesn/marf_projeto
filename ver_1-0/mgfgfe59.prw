#INCLUDE "protheus.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "MSGRAPHI.CH"  
#include "totvs.ch"


#define CRLF chr(13) + chr(10)             
/*
{Protheus.doc} MGFGFE59 
@description 
	RTASK0010505 - TMS - Importar viagens via Excel (Viagens de busca de matéria-Prima)
	Função que lê excel selecionado pelo usuário, trata os dados e envia pedidos ao TMS via Json.
@author Henrique Vidal Santos
@since 29/01/2020
@version P12.1.017
*/


User Function MGFGFE59()

	DEFINE MSDIALOG oDlgMain TITLE "Enviar pedidos ao TMS" FROM 000, 000  TO 190, 500 COLORS 0, 16777215 PIXEL

		nUltLin    := 15
		nCol       := 15
		@ nUltLin		,nCol SAY "Rotina importa arquivo .csv e envia para ser integrado ao TMS." SIZE 176, 07 OF oDlgMain  PIXEL 
		@ nUltLin + 15	,nCol SAY "Informe o arquivo para prosseguir." SIZE 176, 07 OF oDlgMain  PIXEL 

		oBtn := TButton():New( 015, 186 ,"Importar Csv"   , oDlgMain,{|| MGFIMPCSV() 	},50, 011,,,.F.,.T.,.F.,,.F.,,,.F. ) 
		oBtn := TButton():New( 030, 186 ,"Sair"           , oDlgMain,{|| oDlgMain:End() },50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )   

	ACTIVATE MSDIALOG oDlgMain CENTERED

	
Return 
	

Static Function MGFIMPCSV()

	Local cArq := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diretório onde se encontra o arquivo."), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)
	Local lContinua	:= .T.
	Local lFirst	:= .T.
	Local nColunas	:= 28
	Local aDados	:= {}
	Local aErros	:= {}
	Local cErros 	:= ""
	Local cLinha
	

	Private aCampos	:= {}

	If !File(cArq)
		MsgStop("O arquivo " +cArq + " não foi selecionado. A importação será abortada!","ATENCAO")
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
				If Len(aCampos) < nColunas
					lContinua := .F.
				Endif
			Else
				aAdd(aDados,Separa(cLinha,";",.T.))
				If Len(aDados[Len(aDados)]) < nColunas
					lContinua := .F.
				Endif
			EndIf
			
			FT_FSKIP()
		EndDo
	FT_FUSE()

	Private npAction := aScan(aCampos,"ACTION")
	Private npNumPed := aScan(aCampos,"NUMEROPEDIDO") 
	Private npNumExp := aScan(aCampos,"NUMEROEXP") 	
	Private npCTipPe := aScan(aCampos,"CODIGOTIPOPEDIDO")
	Private npStatsP := aScan(aCampos,"STATUSPEDIDO")
	Private npDtEmis := aScan(aCampos,"DATAEMISSAO")
	Private npDtEmbr := aScan(aCampos,"DATAEMBARQUE")
	Private npDtEntr := aScan(aCampos,"DATAENTREGA")
	Private npCTipPr := aScan(aCampos,"TIPODEPRODUTO")
	Private npQtdTot := aScan(aCampos,"QTDETOTAL")                
	Private npUnMtot := aScan(aCampos,"UNIDADEMEDIDATOTAL")
	Private npObsPed := aScan(aCampos,"OBSERVACAOPEDIDO")
	Private npNmVend := aScan(aCampos,"NOMEVENDEDOR")
	Private npCnpjFl := aScan(aCampos,"CNPJFILIAL")
	Private npCodFil := aScan(aCampos,"CODIGOFILIAL")
	Private npNmFil  := aScan(aCampos,"NOMEFILIAL")
	Private npEndFil := aScan(aCampos,"ENDERECOFILIAL")
	Private npCepFil := aScan(aCampos,"CEPFILIAL")
	Private npMunFil := aScan(aCampos,"MUNICIPIOFILIAL")
	Private npUfFil  := aScan(aCampos,"UFFILIAL")
	Private npPaisFl := aScan(aCampos,"PAISFILIAL")
	Private npCodCli := aScan(aCampos,"CODIGOCLIENTE")
	Private npNmCli  := aScan(aCampos,"NOMECLIENTE")
	Private npEndent := aScan(aCampos,"ENDERECOENTREGA")
	Private npCepent := aScan(aCampos,"CEPENDEROENTREGA")
	Private npMunEnt := aScan(aCampos,"MUNICIPIOENDERECOENTREGA")
	Private npUfEEnt := aScan(aCampos,"UFENDERECOENTREGA")
	Private npPaisEnt := aScan(aCampos,"PAISENDERECOENTREGA")

	
	If !lContinua
		APMsgStop(	"Estrutura do arquivo .CSV inválido, cada linha deve ter 28 colunas, conforme abaixo:"+CRLF+CRLF+;
					"Action;Numeropedido;Numeroexp;Codigotipopedido;Statuspedido; " 	+CRLF +; 
					"Dataemissao;Dataembarque;Dataentrega;Tipodeproduto;Qtdetotal;" 	+CRLF +; 
					"Unidademedidatotal;Observacaopedido;Nomevendedor;Cnpjfilial;" 		+CRLF +; 
					"Codigofilial;Nomefilial;Enderecofilial;Cepfilial;Municipiofilial;"	+CRLF +;  
					"Uffilial;Paisfilial;Codigocliente;Nomecliente;Enderecoentrega;" 	+CRLF +;  
					"Cependeroentrega;Municipioenderecoentrega;Ufenderecoentrega;Paisenderecoentrega" )
 		Return(lContinua)
	Endif
	
	If npDtEntr == 0 
		cErros += "Campo DATAENTREGA não localizado verifique se o mesmo está mencionado de forma correta no arquivo."+ CRLF
	EndIf
	
	If npCTipPr == 0 
		cErros += "Campo TIPODEPRODUTO não localizado verifique se o mesmo está mencionado de forma correta no arquivo."+ CRLF
	EndIf
	
	If npQtdTot == 0 
		cErros += "Campo QTDETOTAL não localizado verifique se o mesmo está mencionado de forma correta no arquivo."+ CRLF                
	EndIf
	
	If npUnMtot == 0 
		cErros += "Campo UNIDADEMEDIDATOTAL não localizado verifique se o mesmo está mencionado de forma correta no arquivo."+ CRLF
	EndIf

	If npObsPed == 0 
		cErros += "Campo OBSERVACAOPEDIDO não localizado verifique se o mesmo está mencionado de forma correta no arquivo."+ CRLF
	EndIf

	If npNmVend == 0 
		cErros += "Campo NOMEVENDEDOR não localizado verifique se o mesmo está mencionado de forma correta no arquivo."+ CRLF
	EndIf

	If npCnpjFl == 0 
		cErros += "Campo CNPJFILIAL não localizado verifique se o mesmo está mencionado de forma correta no arquivo."+ CRLF
	EndIf

	If npCodFil == 0 
		cErros += "Campo CODIGOFILIAL não localizado verifique se o mesmo está mencionado de forma correta no arquivo."+ CRLF
	EndIf

	If npNmFil  == 0 
		cErros += "Campo NOMEFILIAL não localizado verifique se o mesmo está mencionado de forma correta no arquivo."+ CRLF
	EndIf

	If npEndFil == 0 
		cErros += "Campo ENDERECOFILIAL não localizado verifique se o mesmo está mencionado de forma correta no arquivo."+ CRLF
	EndIf

	If npCepFil == 0 
		cErros += "Campo CEPFILIAL não localizado verifique se o mesmo está mencionado de forma correta no arquivo."+ CRLF
	EndIf

	If npMunFil == 0 
		cErros += "Campo MUNICIPIOFILIAL não localizado verifique se o mesmo está mencionado de forma correta no arquivo."+ CRLF
	EndIf

	If npUfFil  == 0 
		cErros += "Campo UFFILIAL não localizado verifique se o mesmo está mencionado de forma correta no arquivo."+ CRLF
	EndIf

	If npPaisFl == 0 
		cErros += "Campo PAISFILIAL não localizado verifique se o mesmo está mencionado de forma correta no arquivo."+ CRLF
	EndIf

	If npCodCli == 0 
		cErros += "Campo CODIGOCLIENTE não localizado verifique se o mesmo está mencionado de forma correta no arquivo."+ CRLF
	EndIf

	If npNmCli  == 0 
		cErros += "Campo NOMECLIENTE não localizado verifique se o mesmo está mencionado de forma correta no arquivo."+ CRLF
	EndIf

	If npEndent == 0 
		cErros += "Campo ENDERECOENTREGA não localizado verifique se o mesmo está mencionado de forma correta no arquivo."+ CRLF
	EndIf

	If npCepent == 0 
		cErros += "Campo CEPENDEROENTREGA não localizado verifique se o mesmo está mencionado de forma correta no arquivo."+ CRLF
	EndIf

	If npMunEnt == 0 
		cErros += "Campo MUNICIPIOENDERECOENTREGA não localizado verifique se o mesmo está mencionado de forma correta no arquivo."+ CRLF
	EndIf

	If npUfEEnt == 0 
		cErros += "Campo UFENDERECOENTREGA não localizado verifique se o mesmo está mencionado de forma correta no arquivo."+ CRLF
	EndIf

	If npPaisEnt == 0 
		cErros += "Campo PAISENDERECOENTREGA não localizado verifique se o mesmo está mencionado de forma correta no arquivo."+ CRLF
	EndIf

	If !Empty(cErros)
		lContinua := .F.
		APMsgStop(cErros)
		Return(lContinua)
	EndIf

	IF lContinua
		Processa( {|| xEnviaTms(aCampos, aDados) },'Aguarde...', 'Processando registros',.F. )
	EndIf

Return(lContinua)

Static Function xEnviaTms(aCampos, aDados)

	Local cUrl 		:= Alltrim(GetMv("MGF_TMSUR2"))
	Local cMsgErro	:= ""
	Local cHeadRet 	:= ""
	Local aHeadOut	:= {}
	Local aEnvErr	:= {}
	Local aEnvOk	:= {}

	Local cJson		:= ""
	Local oJson		:= Nil
	Local oDetRet 	:= nil

	Local cTimeIni	:= ""
	Local cTimeProc	:= ""

	Local xPostRet	:= Nil
	Local nTimeOut	:= 120
	Local nStatuHttp	:= 0

	aadd( aHeadOut, 'Content-Type: application/json' )
	aadd( aHeadOut, 'Accept-Charset: utf-8' )
	
	For _x := 1 to Len(aDados)
	
		oJson	:= JsonObject():new()
		
		oJson['ACTION']					:= 	aDados[_x][npAction]
		oJson['NUMEROPEDIDO']			:=	aDados[_x][npNumPed] 
		oJson['NUMEROEXP']				:=	Alltrim(aDados[_x][npNumExp])	
		oJson['CODIGOTIPOPEDIDO']		:=	aDados[_x][npCTipPe]
		oJson['STATUSPEDIDO']			:=  aDados[_x][npStatsP]
		oJson['DATAEMISSAO']			:=	aDados[_x][npDtEmis]
		oJson['DATAEMBARQUE']			:=	aDados[_x][npDtEmbr]
		oJson['DATAENTREGA']			:=	aDados[_x][npDtEntr]
		oJson['CEPENDEROENTREGA']		:= 	aDados[_x][npCepent]
		oJson['CEPFILIAL']				:= 	aDados[_x][npCepFil]
		oJson['CNPJFILIAL']				:= 	aDados[_x][npCnpjFl]
		oJson['CODIGOCLIENTE']			:= 	aDados[_x][npCodCli]
		oJson['CODIGOFILIAL']			:= 	aDados[_x][npCodFil]
		oJson['NOMECLIENTE']			:=	aDados[_x][npNmCli]
		oJson['NOMEFILIAL']				:=	aDados[_x][npNmFil]
		oJson['NOMEVENDEDOR']			:=	aDados[_x][npNmVend]
		oJson['ENDERECOENTREGA']		:=	aDados[_x][npEndent]
		oJson['ENDERECOFILIAL']			:=	aDados[_x][npEndFil]
		oJson['MUNICIPIOFILIAL']		:=	aDados[_x][npMunFil]
		oJson['OBSERVACAOPEDIDO']		:=	aDados[_x][npObsPed]
		oJson['PAISENDERECOENTREGA']	:=	aDados[_x][npPaisEnt]
		oJson['PAISFILIAL']				:=	aDados[_x][npPaisFl]
		oJson['QTDETOTAL']				:=	aDados[_x][npQtdTot]			
		oJson['TIPODEPRODUTO']			:=	aDados[_x][npCTipPr]
		oJson['UFENDERECOENTREGA']		:= 	aDados[_x][npUfEEnt]
		oJson['UFFILIAL']				:=	aDados[_x][npUfFil]
		oJson['UNIDADEMEDIDATOTAL']		:=	aDados[_x][npUnMtot]
		oJson['MUNICIPIOENDERECOENTREGA']	:=	aDados[_x][npMunEnt]
		oJson['ITENS']					:=	{}

		cJson	:= ""
		cJson	:= oJson:toJson()
		
		cTimeIni := time()

		if !empty( cJson )
			xPostRet := httpQuote( cUrl /*<cUrl>*/, "POST" /*<cMethod>*/, /*[cGETParms]*/, cJson/*[cPOSTParms]*/, nTimeOut /*[nTimeOut]*/, aHeadOut /*[aHeadStr]*/, @cHeadRet /*[@cHeaderRet]*/ )
			fwJsonDeserialize( xPostRet, @oDetRet )
		endif

		nStatuHttp	:= 0
		nStatuHttp	:= httpGetStatus()

		cTimeFin	:= time()
		cTimeProc	:= elapTime( cTimeIni, cTimeFin )

		MemoWrite( GetTempPath(.T.) + "AAA_" + FunName() +".TXT",cJson)
		
		conout(" [MGFWSS10] * * * * * Status da integracao * * * * *"								)
		conout(" [MGFWSS10] Inicio.......................: " + cTimeIni + " - " + dToC( dDataBase ) )
		conout(" [MGFWSS10] Fim..........................: " + cTimeFin + " - " + dToC( dDataBase ) )
		conout(" [MGFWSS10] Tempo de Processamento.......: " + cTimeProc 							)
		conout(" [MGFWSS10] URL..........................: " + cUrl									)
		conout(" [MGFWSS10] HTTP Method..................: " + "POST" 								)
		conout(" [MGFWSS10] Status Http (200 a 299 ok)...: " + allTrim( str( nStatuHttp ) ) 		)
		conout(" [MGFWSS10] cJson........................: " + allTrim( cJson ) 					)
		conout(" [MGFWSS10] Retorno......................: " + allTrim( xPostRet ) 					)
		conout(" [MGFWSS10] * * * * * * * * * * * * * * * * * * * * "								)
		
		If Valtype(oDetRet) <> 'U'
			
			IF Valtype(oDetRet:Status ) == "C" 
				oDetRet:Status :=  	Val(oDetRet:Status)  // Devido a outra ponta Web, estar retornando com tipo diferente dependendo do retorno. 
			EndIf 

			If oDetRet:Status == 500 
				aadd(aEnvErr, aDados[_x] )
			ElseIf  oDetRet:Status >= 200 .and.  oDetRet:Status <= 299
				aadd(aEnvOk, aDados[_x] )
			EndIf 

		Elseif Valtype(xPostRet) == 'C'
			cMsgErro := xPostRet
		EndIf

		freeObj( oJson )
			
	Next _x 
	
	If Len(aEnvErr) > 0 
		GFE59_RET(aEnvErr , "Registros com falha ao importar no TMS.")
	EndIf 

	If Len(aEnvOk) > 0 
		GFE59_RET(aEnvOk , "Registros integrados com sucesso - TMS.")
	EndIf 

	If !Empty(cMsgErro)
			APMsgStop(cMsgErro , "Totvs - Erro ao importar .CSV " )
	EndIf

Return

Static Function GFE59_RET(aDados , cTitulo )

	Local aSizeAut    := MsAdvSize(,.F.,400)
	Local oBtn
	Local oBold	
	Local oDlg                    
	Local aBrowse    := aDados 
	Local aObjects
	Local aInfo
	Local aPosObj

	Default cTitulo := "Rotina GFE59_RET"
                                                                                     
	
	aObjects := {}
	AAdd( aObjects, { 0		,  20, .T., .F. } )
	AAdd( aObjects, { 100	, 100, .T., .T. } )
	AAdd( aObjects, { 0		,  20, .T., .T. } )
	aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects ,.T. )

	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD	
			 

	DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE "Log: " + cTitulo  PIXEL
			  
		oBrowseDados := TWBrowse():New( 004,4,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]+10,;
								  ,,,oDlg, , , ,,{||}, , , , ,,,.F.,,.T.,,.F.,,, )
		oBrowseDados:SetArray(aBrowse)                                    
		oBrowseDados:bLine := {|| aEval(aBrowse[oBrowseDados:nAt],{|z,w| aBrowse[oBrowseDados:nAt,w] } ) }

		oBrowseDados:addColumn(TCColumn():new(acampos[01],{||aBrowse[oBrowseDados:nAt][01]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[02],{||aBrowse[oBrowseDados:nAt][02]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[03],{||aBrowse[oBrowseDados:nAt][03]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[04],{||aBrowse[oBrowseDados:nAt][04]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[05],{||aBrowse[oBrowseDados:nAt][05]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[06],{||aBrowse[oBrowseDados:nAt][06]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[07],{||aBrowse[oBrowseDados:nAt][07]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[08],{||aBrowse[oBrowseDados:nAt][08]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[09],{||aBrowse[oBrowseDados:nAt][09]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[10],{||aBrowse[oBrowseDados:nAt][10]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[11],{||aBrowse[oBrowseDados:nAt][11]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[12],{||aBrowse[oBrowseDados:nAt][12]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[13],{||aBrowse[oBrowseDados:nAt][13]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[14],{||aBrowse[oBrowseDados:nAt][14]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[15],{||aBrowse[oBrowseDados:nAt][15]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[16],{||aBrowse[oBrowseDados:nAt][16]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[17],{||aBrowse[oBrowseDados:nAt][17]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[18],{||aBrowse[oBrowseDados:nAt][18]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[19],{||aBrowse[oBrowseDados:nAt][19]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[20],{||aBrowse[oBrowseDados:nAt][20]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[21],{||aBrowse[oBrowseDados:nAt][21]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[22],{||aBrowse[oBrowseDados:nAt][22]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[23],{||aBrowse[oBrowseDados:nAt][23]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[24],{||aBrowse[oBrowseDados:nAt][24]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[25],{||aBrowse[oBrowseDados:nAt][25]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[26],{||aBrowse[oBrowseDados:nAt][26]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[27],{||aBrowse[oBrowseDados:nAt][27]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		oBrowseDados:addColumn(TCColumn():new(acampos[28],{||aBrowse[oBrowseDados:nAt][28]},"@!"    ,,,"LEFT"   ,,.F.,.F.,,,,,))
		

		oBrowseDados:Setfocus() 

		oBtn := TButton():New( aSizeAut[4]-25	, 300,'Ok'			, oDlg,{|| oDlg:End()       }  ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
		
	ACTIVATE MSDIALOG oDlg CENTERED
	
Return() 