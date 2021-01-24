#Include 'Protheus.ch'
#include "totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FWMVCDEF.CH'
/*
=====================================================================================
Programa.:              MGFINT09
Autor....:              Marcelo Carneiro
Data.....:              30/08/2016
Descricao / Objetivo:   Integração Protheus x Inventti
Doc. Origem:            Contrato - GAP MGFINT02
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              Programa para recebimento do xml do fornecedor

Últimas Alterações
RTASK0011511 - 08/09/2020 - Luiz Cesar Silva (DMS) - Importação de XML para Fornecedores autorizados.

=====================================================================================

[OnStart]
jobs=zCallMG9
RefreshRate=300

[zCallMG9]
Environment=SCHD03
Main=U_zCallMG9
nParms=2
Parm1=01
Parm2=020001

*/

User Function zCallMG9(cPar1,cPar2)

	Local aParam	:= {}
	Local aExec		:= {}

	If ValType(cPar1) == "C"
		aAdd( aParam , cPar1)
	EndIf
	If ValType(cPar2) == "C"
		aAdd( aParam , cPar2)
	EndIf

	If Len(aParam) == 2
		aExec :={{aParam[1],aParam[2]}}
		u_MGFINT09(aExec)
	else
		conout("O Fonte MGFINT09, para ser executado precisa receber 2 paramentros Grupo de empresa e Filial, exp: '01' e '010041'")
	EndIf

return

User function zcall09()

	Local aParam := {{ "01", "010005" }}

	u_MGFINT09(aParam)

return

User Function MGFINT09(aParam)
	Local cError 	:= ""
	Local cWarning  := ""
	Local cDirXML	:= ""
	Local cXml 	    := ""
	Local cXmlRet 	:= ""
	Local cArqOri	:= ""
	Local cArqDest	:= ""
	Local cArqRej	:= ""
	Local cMsg		:= ""
	Local aArqXML 	:= {}
	Local oXML
	Local oProd
	Local w         := 0
	Local cDirArq 	:= ""
	Local cDirPro 	:= ""
	Local cDirRej 	:= ""
	Local cDirLog 	:= ""
	Local aDados    := {}
	Local aTables 	:= {"SF1","SF2","SB1","SA2","SA5","SD1"}
	Local cFilBK    := ''
    
	Private _lJob	:= IsBlind() .OR. Type("__LocalDriver") == "U"

	//	Private _lJob	:= .T.

   	If _lJob             
   	   //	RpcSetType(3)
	    RpcSetEnv( aParam[1][1], aParam[1][2] )
		conout(cFilant)
    Endif

	/*Parametrização de Diretórios
	MGF_XMLARQ = Diretório de Arquivos a processar
	MGF_XMLNFE = Diretório pai das pasta do processo, xml
	MGF_XMLEXC = Diretório de registros processados
	MGF_XMLREJ = Diretório de registros rejeitados
	*/

	cDirArq := SuperGetMv("MGF_XMLARQ",,"\AUTORIZADAS"	)
	cDirXml := SuperGetMv("MGF_XMLNFE",,"\XML"			)
	cDirPro := SuperGetMv("MGF_XMLEXC",,"\EXECUTADOS"	)
	cDirRej := SuperGetMv("MGF_XMLREJ",,"\REJEITADOS"	)

	//Cria diretórios automaticamente, caso não exista, conforme parametros acima
	MakeDir(cDirXml)
	MakeDir(cDirXml+cDirArq)
	MakeDir(cDirXml+cDirPro)
	MakeDir(cDirXml+cDirRej)

	//Carrega todos os arquivos presentes no diretório de registros a processar
	aArqXML := Directory(cDirXml+cDirArq+ "\"+ "*.xml" )
	conout(len(aArqXML))

	//Array com todos os arquivos importados do diretório
	cFilBK    := cFilAnt
	For w := 1 to Len(aArqXML)
		cArqOri	:=	cDirXML + cDirArq+"\" +Alltrim(aArqXML[w,01])

		//Nomenclatura para arquivos processados
		cArqDest  	:=	Alltrim(aArqXML[w,01])//Left( Alltrim(aArqXML[w,01]) , ( At( "." , Alltrim(aArqXML[w,01]) ) - 1 ) )
		//cArqDest	+=	"_" + DtoS(dDataBase) + "_" + StrTran(Substr(Time(),01,05),":","_") + ".xml"
		cArqDest  	:=	cDirXML + cDirPro+"\" + cArqDest

		//Nomenclatura para arquivos rejeitados
		cArqRej  	:=	Alltrim(aArqXML[w,01])//Left( Alltrim(aArqXML[w,01]) , ( At( "." , Alltrim(aArqXML[w,01]) ) - 1 ) )
		//cArqRej	+=	"_" + DtoS(dDataBase) + "_" + StrTran(Substr(Time(),01,05),":","_") + ".xml"
		cArqRej	:=	cDirXML + cDirRej+"\" + cArqRej

		//Importação do xml
		//cXml := MemoRead(cArqOri)
		cXml := ""
		Ft_FUse( cArqOri )
		While !FT_FEof()
			// -- Leitura
			cXml+=FT_FReadLn()
			FT_FSkip()
		EndDo
		Ft_FUse()

		oXML := XmlParser(cXml, "_", @cError, @cWarning )

		If Valtype(oXML) <> 'O'

			cXml := FwNoAccent( cXml )
			oXML := XmlParser(cXml, "_", @cError, @cWarning )

			If Valtype(oXML) <> 'O'

				cXml := EncodeUtf8( cXml )

				If cXml <> nil //!Empty(cXml)
					oXML := XmlParser(cXml, "_", @cError, @cWarning )
				EndIf
			EndIf
		EndIf

		if valType( oXML ) == "O"
            IF !Empty(XmlChildEx(oXML,"_NFEPROC"))
				oXML := XmlGetChild(oXML:_NFEPROC, 3)  // pega o 3º elemento a partir do elemento _NFEPROC
				//Gera Pré Nota e grava na pasta processados
				aDados := {}
				If GeraPreNota(cXML,@cMsg,@aDados)
					__CopyFile( cArqOri , cArqDest )
					If	File( cArqOri )
						Copy File &( cArqOri ) to &( cArqDest )
					EndIf
	
					If	File( cArqDest )
						fErase( cArqOri )
					Endif
	
					//Se rejeitado, grava arquivo na pasta de rejeitados
				Else
					//Gera log de erro
					GeraLog(Alltrim(aArqXML[w,01]),aDados, @cMSG)
					__CopyFile( cArqOri , cArqRej)
					If	File( cArqOri )
						Copy File &( cArqOri ) to &( cArqRej )
					EndIf
					If	File( cArqRej )
						fErase( cArqOri )
					Endif
				EndIf
			EndIF
		EndIf
		
		oXML := Nil
		DelClassIntF()
	Next w

	cFilAnt := cFilBK
	If _lJob
		If ValType ( aParam ) == 'A'
			RpcClearEnv()
		Endif
	Endif

Return
//----------------------------------------------------------------------------------
//Faz a validação e gera a pré nota
//----------------------------------------------------------------------------------
Static Function GeraPreNota(cXML,cMsg, aDados)
	Local lRet 		    := .T.
	Local lRetPC	    := .T.
	Local nI   		    := 0
	Local nY   		    := 0
	Local aProd 	    := {}
	Local cProd	 	    := ""
	Local cCliFor 	    := ""
	Local cLoja	 	    := ""
	Local cNome	 	    := ""
	Local cTpCliFor	    := ""
	Local cError 		:= ""
	Local cWarning		:= ""
	Local cSitTrib		:= ""
	Local cCF			:= ""
	Local cTexto		:= ""
	Local cPedido		:= ""
	Local cItPed		:= ""
	Local cTpDoc		:= ""
	Local cRazFor       := GetInfXML(cXml, "<xNome>")
	Local cChvNfe		:= GetInfXML(cXml, "<chNFe>")
	Local cNf  		    := STRZERO(Val(GetInfXML(cXML, "<nNF>"	)),TamSx3("F1_DOC")[1])
	Local cSerie		:= GetInfXML(cXML, "<serie>")
	Local dEmis 		:= SToD(Substr(StrTran(GetInfXML(cXML, "<dhEmi>"),'-',''),1,8))
	Local cTRANSP 		:= ""
	Local cPLACA 		:= ""
	Local cCodTrans		:= ""
	Local cCNPJ 		:= GetInfXML(cXML, "<CNPJ>")
	Local nTpDoc		:= Val(GetInfXML(cXML, "<finNFe>"))  // Tipo da Nota 1=NF-e normal /2=NF-e complementar / 3=NF-e de ajuste / 4=Devolução/Retorno
	Local nOpc 		    := 0
	Local oProd
	Local oPlaca
	Local oTransp
	Local oImp
	Local lCliente		:= IIf(nTpDoc == 4, .T., .F.)  //Notas do Tipo Devolução ou Beneficiamento
	Local aSitTrib		:= {}
	Local cPed          := ''
	Local cItem         := ''
	Local aSM0          := {}
	Local oEmitente     := NIL
	Local cEmitente     := ''
	Local nPos          := 0
	Local bPedObr       := .F.

    Local bFornAut      := .f. // RTASK0011511 - Luiz Cesar (DMS) - Flag para validar fornecedor autorizado para importação XML

	Local cLocaPad      := ''
	Local _nQent        := 0
	Local oDestino      := Nil
	Local cDestino      := ''

	Local cUm			:= ''
	Local cCC			:= ''
	Local cConta		:= ''
	Local cItemCta		:= ''
	Local cClassVal		:= ''
	Local cContTrans	:= ''
	Local nTransIni		:= 0
	Local nTransFim		:= 0
	Local oTotal
	Local nValTot := 0

	Private aCabec		:= {}
	Private aItens		:= {}
	Private aLinha		:= {}
	Private lMsErroAuto := .F.

	cMSG := ''
	AADD(aDados, dEmis )
	AADD(aDados, cNf )
	AADD(aDados, cSerie )
	

	aSM0 := FWLoadSM0()

	oDestino := XmlParser(GetInfXML(cXML, "infNFe",.T.) , "_", @cError, @cWarning )
	IF !Empty(XmlChildEx(oDestino:_INFNFE:_DEST,"_CNPJ"))
	    cDestino := oDestino:_INFNFE:_DEST:_CNPJ:TEXT
	ElseIF !Empty(XmlChildEx(oDestino:_INFNFE:_DEST,"_CPF"))
	    cDestino := oDestino:_INFNFE:_DEST:_CPF:TEXT
	Else
		lRet := .F.
		cMSG += "Não achada as Tags CNPJ/CPF do destinatario"
	EndIF
	nPos      := ASCAN(aSM0,{|x| Alltrim(x[18]) == Alltrim(cDestino)})
	IF nPos == 0
		lRet := .F.
		cMSG += "Destinatário da nota não cadastro da tabela de gestão corporativa do Protheus CNPJ Inválido: "+cDestino+CRLF
	Else
		cFilAnt :=  aSM0[nPos][02]
	EndIF
	
	cCNPJ := ''
	IF !Empty(XmlChildEx(oDestino:_INFNFE:_EMIT,"_CNPJ"))
	    cCNPJ := oDestino:_INFNFE:_EMIT:_CNPJ:TEXT
	ElseIF !Empty(XmlChildEx(oDestino:_INFNFE:_EMIT,"_CPF"))
	    cCNPJ := oDestino:_INFNFE:_EMIT:_CPF:TEXT
	Else
		lRet := .F.
		cMSG += "Não achada as Tags CNPJ/CPF do Emitende"
	EndIF
	AADD(aDados, Alltrim(cCNPJ)+'-'+Alltrim(cRazFor))
	

	nPos := ASCAN(aSM0,{|x| Alltrim(x[18]) == Alltrim(cCNPJ)})
	IF /*nPos == 0 .and.*/ substr(cCNPJ,1,8) <> substr(cDestino,1,8)
		bPedObr := .T.
		//Else
		//	lRet := .F.
		//	cMSG += "Não é permitida a inclusão de XML para processo intercompany"
	EndIF

	Do Case //NDIPBC
		//1=NF-e normal
		Case nTpDoc == 1
		cTpDoc := "N"
		//2=NF-e complementar
		Case nTpDoc == 2
		cTpDoc := "C"
		//3=NF-e de ajuste
		Case nTpDoc == 3
		cTpDoc := "P"
		//4=Devolução/Retorno
		Case nTpDoc == 4
		cTpDoc := "D"
	EndCase

	dbSelectArea("SA2")
	dbSelectArea("SB1")
	dbSelectArea("SA5")
	dbSelectArea("SF1")
	dbSelectArea("SC7")
	dbSelectArea("SBZ")


	aadd(aSitTrib,"00")
	aadd(aSitTrib,"10")
	aadd(aSitTrib,"20")
	aadd(aSitTrib,"30")
	aadd(aSitTrib,"40")
	aadd(aSitTrib,"41")
	aadd(aSitTrib,"50")
	aadd(aSitTrib,"51")
	aadd(aSitTrib,"60")
	aadd(aSitTrib,"70")
	aadd(aSitTrib,"90")
	//---------------------------------------------------------------------------------
	//Ajustes para notas de outros tipos, <finNFe> - 24/04/2014 - Thomas Galvao
	//---------------------------------------------------------------------------------
	
	If lCliente
		SA1->(dbSetOrder(3)) //A1_FILIAL+A1_CGC
		If SA1->(DbSeek(xFilial("SA1")+cCnpj))
			cCliFor := SA1->A1_COD
			cLoja	:= SA1->A1_LOJA
			cNome	:= SA1->A1_NOME
			cTpCliFor := "Cliente"
		Else
			lRet := .F.
			cMSG += "Cliente não cadastrado, CPF Inválido: "+cCnpj+CRLF
		EndIf
	Else
		SA2->(dbSetOrder(3)) //A2_FILIAL+A2_CGC
		If SA2->(DbSeek(xFilial("SA2")+cCnpj))
			cCliFor := SA2->A2_COD
			cLoja	:= SA2->A2_LOJA
			cNome	:= SA2->A2_NOME
			cTpCliFor := "Fornecedor"

			// RTASK0011511 - Luiz Cesar Silva - Busca Fornecedor autorizado para importar xml e atualiza flag bFornAut
			dbselectarea("SHB")
			SHB->(dbsetorder(1))
			bFornAut := ZHB->(dbseek(xFilial("ZHB")+cCliFor+cLoja+cProd))

		Else
			lRet := .F.
			cMSG += "Fornecedor não cadastrado, CNPJ Inválido: "+cCnpj+CRLF
		EndIf
	EndIf
	//---------------------------------------------------------------------------------

	If lRet
		//Se já existir este documento, rejeita documento
		SF1->(dbSetOrder(1))
		If SF1->(dbSeek(xFilial("SF1")+PadR(cNf,TamSx3("F1_DOC")[1])+PadR(cSerie,TamSx3("F1_SERIE")[1])+cCliFor+cLoja))
			cMSG += "NFE já importada: Doc.: "+AllTrim(SF1->F1_DOC)+", Série: "+AllTrim(SF1->F1_SERIE)+", "+cTpCliFor+"/Loja:" +cCliFor+"/"+cLoja+" - "+cNome+CRLF
			lRet := .F.
		EndIf

		//Itens
		oProd:= XmlParser(GetInfXML(cXML, "infNFe",.T.) , "_", @cError, @cWarning )
		oTotal := oProd:_InfNfe:_Total
		oProd:= oProd:_INFNFE:_DET
		nValTot := Val(oTotal:_ICMSTOT:_vNF:TEXT) // valor total da nfe

		// Validaçao de NFs, foi notado que quando a nota tem apenas um Item, a tag nao vem em formato array

		If ValType(oProd) != 'A'
			oProd:= XmlParser(GetInfXML(cXML, "infNFe",.T.) , "_", @cError, @cWarning )
//			oImp := oProd:_INFNFE:_DET:_IMPOSTO:_ICMS
			oProd:= oProd:_INFNFE:_DET:_PROD
			cProd:= oProd:_CPROD:TEXT
			//@ticket TTIKAA - T10729 - Isabella Rodrigues – Alteração do tamanho do Space.
			//cProd:= Subs(cProd+Space(15),1,15)
			cProd:= Subs(cProd+Space(TamSX3("B1_COD")[1]),1,TamSX3("B1_COD")[1])

			//@ticket TSUPQG - Ricardo Munhoz: Verificar 1o na SA5, depois posicionar na SB1
			//Verifica amarração produtoxfornecedor
			If bPedObr

				If cTpCliFor == "Fornecedor"

                    // RTASK0011511 - Luiz Cesar Silva (DMS)- Remanejada sequencia de validação do fornecedor efetuando tratamento 
					// para verificação de Fornecedores autorizados para importar xml.
					// Fornecedor autorizado identifica produto pela tag XPED no pedido de compras
					dbSelectArea("SA5")
					SA5->(DbSetOrder(14))
					If  SA5->(DbSeek(xFilial("SA5")+cCliFor+cLoja+cProd))
						cProd := SA5->A5_PRODUTO
						SB1->(dbSeek(xFilial("SB1")+cProd)) //Produto existe e está amarrado. Posiciona SB1
					Else
                        // Fornecedor não encontrado na tabela ZHB - Fornecedores autorizados para importar xml
                        if !bFornAut 
						   cMSG += "Fornecedor não consta em autorizados para importar xml "+Alltrim(cClifor)+"-"+alltrim(cLoja)+" "+CRLF
						   lRet := .F.

                        // Fornecedor autorizado identifica produto pela tag XPED no pedido de compras
                        Elseif !Empty(XmlChildEx(oProd,'_XPED')) 
					       
					       cPedido	:= StrZero(VAL(GetInfXML(cXml, "<xPed>"	)),TamSX3('C7_NUM')[1])
 						   cPed  	:= PADL(cPedido,TamSX3('C7_NUM')[1],'0')
                           cItPed	:= GetInfXML(cXml, "<nItemPed>"	)
						   
						   SC7->(dbSetOrder(1))
					       IF SC7->(dbSeek(xFilial('SC7')+cPed+cItem))
					          cProd := SC7->C7_PRODUTO
						   Endif	 

						Else
			//			   cMSG += "Amarração Produto x Fornecedor (SA5), produto, "+Alltrim(cProd)+", não cadastrado! "+CRLF
			//			   lRet := .F.
						endif
					EndIf                    

				Else
					dbSelectArea("SA7")
					SA7->(DbSetOrder(1))
					If SA7->(DbSeek(xFilial("SA7")+cCliFor+cLoja+cProd))
						cProd := SA7->A7_PRODUTO
						SB1->(dbSeek(xFilial("SB1")+cProd)) //Produto existe e está amarrado. Posiciona SB1
					Else
						cMSG += "Amarração Produto x Cliente (SA7), produto, "+Alltrim(cProd)+", não cadastrado! "+CRLF
						lRet := .F.
					EndIf
				EndIf
			Endif
			cLocaPad      := ''
			IF SBZ->(dbSeek(xFilial()+cProd))
				cLocaPad := SBZ->BZ_LOCPAD
			ElseIf SB1->(dbSeek(xFilial()+cProd))
				cLocaPad := SB1->B1_LOCPAD
			EndiF

			//Verifica se existe nota fiscal de referencia para esta nota
			cTexto := GetInfXML(cXml, "NFRef",.T.)
			If !Empty(cTexto)
				cNfRef := GetInfXML(cTexto, "<nNF>")
				cSerRef:= GetInfXML(cTexto, "<serie>")
				If !Empty(cNfRef) .And. !Empty(cSerRef)
					dbSelectArea("SD2")
					SD2->(dbSetOrder(3)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
					If SD2->(dbSeek(xFilial("SD2")+cNfRef+cSerRef+cCliFor+cLoja+cProd))
						dbSelectArea("SF4")
						SF4->(dbSetOrder(1))
						SF4->(dbSeek(xFilial("SF4")+SD2->D2_TES))
						If SF4->F4_PODER3 == "R"
							cTpDoc := "B"
						EndIf
					EndIf
				EndIf
			EndIf

			//Verifica qual o Grupo de Tributação: ICMS
			For nY := 1 To Len(aSitTrib)
				If !Empty(cImpIcms := GetInfXML(cXML, "<ICMS"+aSitTrib[nY]+">"))
					cSitTrib := GetInfXML(cImpIcms, "<orig>")
					cSitTrib := IIF(cSitTrib=="1", "2",cSitTrib)
					cSitTrib +=	GetInfXML(cImpIcms, "<CST>")
					Exit
				EndIf
			Next nY

			IF  bPedObr
				If Empty(XmlChildEx(oProd,'_XPED')) //.AND. Empty(XmlChildEx(oProd,'_NITEMPED'))
					cMSG += "Tag xPed não encontrada no arquivo XML da nota fiscal: "+AllTrim(cNf)+"-"+AllTrim(cSerie)+CRLF
					lRet := .F.
				Elseif Empty(XmlChildEx(oProd,'_NITEMPED'))	.and. bFornAut
					cMSG += "Tag NItemPed não encontrada no arquivo XML da nota fiscal: "+AllTrim(cNf)+"-"+AllTrim(cSerie)+CRLF
					lRet := .F.
				Else
					cPedido		:= StrZero(VAL(GetInfXML(cXml, "<xPed>"	)),TamSX3('C7_NUM')[1])
				Endif
				IF Empty(Alltrim(cPedido)) .OR. val(cPedido) == 0 .AND. bPedObr
					cMSG += "É Obrigatorio ter Pedido de Compra"+CRLF
					lRet := .F.
				EndIF
			EndIF
			IF lRet
				If bPedObr
					cPed  := PADL(cPedido,TamSX3('C7_NUM')[1],'0')
					// RTASK0011511 - Luiz Cesar (DMS) - Busca produto no pedido quando o Fornecedor for encontrado na tabela ZHB - Fornecedores autorizados
					if bFornAut
					   SC7->(dbSetOrder(1))
					   IF SC7->(dbSeek(xFilial('SC7')+cPed+cItem))
					      cProd := SC7->C7_PRODUTO
					   endif   
					   cItem := xRetItPed(cFilAnt,cPed,cProd)
					endif   
					If Empty(cItem)
						cMSG += "Item do pedido: "+ cPed + " do produto: "+ cProd +" não encontrado."
						lRet := .F.
					Endif
					SC7->(dbSetOrder(1))
					IF SC7->(!dbSeek(xFilial('SC7')+cPed+cItem))
						cMSG += "Pedido/Item não cadastrado: "+Alltrim(cPed)+"-"+Alltrim(cItem)+CRLF
						lRet := .F.
					Else
						IF SC7->C7_TPOP == 'P' .OR. SC7->C7_CONAPRO == 'B' .OR. !Empty(SC7->C7_RESIDUO) .OR. !Empty(SC7->C7_ENCER)
							cMSG += "Pedido/Item Previsto, Bloqueado, Eliminado Residuo ou Encerrado :"+Alltrim(cPed)+"-"+Alltrim(cItem)+CRLF
							lRet := .F.
						ELSE
							IF (SC7->C7_QUANT - SC7->C7_QUJE ) <= 0
								cMSG += "Pedido/Item sem saldo para entrada :"+Alltrim(cPed)+"-"+Alltrim(cItem)+CRLF
								lRet := .F.
							EndIF
						EndIF

						//Verifica se o fornecedor tem entrega por terceiro (tabela CPX)
						If GetMv("MV_FORPCNF")
							SA2->(dbSetOrder(1)) //A2_FILIAL+A2_CODIGO+A2_LOJA
							If SA2->(DbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))
								If Alltrim(cCNPJ) != Alltrim(SA2->A2_CGC)
									SA2->(dbSetOrder(3)) //A2_FILIAL+A2_CGC
									SA2->(DbSeek(xFilial("SA2")+cCNPJ))
									cCodFXml := SA2->A2_COD
									cLojFXml := SA2->A2_LOJA
									CPX->(dbSetOrder(1)) //CPX_FILIAL+CPX_CODIGO+CPX_LOJA+CPX_CODFOR+CPX_LOJFOR
									If !CPX->(DbSeek(xFilial("CPX")+SC7->C7_FORNECE+SC7->C7_LOJA+cCodFXml+cLojFXml))
										cMSG += "Fornecedor "+Alltrim(cCodFXml)+"-"+Alltrim(cLojFXml)+" não cadastrado como entrega terceiro."+CRLF
										lRet := .F.
									EndIf
								Endif
							Endif
						Else
						
							cMSG += "Parametro MV_FORPCNF está desabilitado!"+CRLF
							lRet := .F.
						Endif

						cUm			:= SC7->C7_UM
						cCC			:= SC7->C7_CC
						cConta		:= SC7->C7_CONTA
						cItemCta	:= SC7->C7_ITEMCTA
						cClassVal	:= SC7->C7_CLVL

					EndIF
				Else
					cPed  := Space(TamSX3('C7_NUM')[1])
					cItem := Space(TamSX3('C7_ITEM')[1])
				Endif
			EndIf

			IF lRet
				CadAlmox(cLocaPad,cProd)
			EndIF

			aLinha		:= {}
			AAdd(aLinha ,{'D1_COD'  		,cProd					   				,NIL})
			AAdd(aLinha ,{'D1_ITEM' 		,StrZero(1,TamSx3('D1_ITEM')[1]) 	    ,NIL} )
			//AAdd(aLinha ,{'D1_UM'   		,oProd:_UCOM:TEXT		   				,NIL})
			IF !Empty(Alltrim(cPedido))
				Aadd(aLinha,  {'D1_PEDIDO',cPed	  ,NIL})
				Aadd(aLinha,  {'D1_ITEMPC', cItem,NIL})
			EndIF
			AAdd(aLinha ,{'D1_QUANT' 	    ,Val(oProd:_QCOM:TEXT)	  			    ,NIL})
			AAdd(aLinha ,{'D1_VUNIT' 	    ,Val(oProd:_VUNCOM:TEXT)   	            ,NIL})
			AAdd(aLinha ,{'D1_TOTAL' 	    ,Val(oProd:_VPROD:TEXT)	   			    ,NIL})
			AAdd(aLinha ,{'D1_CLASFIS' 	    ,cSitTrib				   				,NIL})
			AAdd(aLinha ,{'D1_LOCAL'		,Alltrim(cLocaPad)	                    ,NIL})

			If !Empty(cUm)
				AAdd(aLinha ,{'D1_UM' 	    ,cUm		,NIL})
			EndIf

			If !Empty(cCC)
				AAdd(aLinha ,{'D1_CC' 	    ,cCC		,NIL})
			EndIf

			If !Empty(cConta)
				AAdd(aLinha ,{'D1_CONTA ' 	,cConta		,NIL})
			EndIf

			If !Empty(cItemCta)
				AAdd(aLinha ,{'D1_ITEMCTA ' ,cItemCta	,NIL})
			EndIf

			If !Empty(cClassVal)
				AAdd(aLinha ,{'D1_CLVL ' 	,cClassVal	,NIL})
			EndIf

			AAdd(aItens,aLinha)
		
		Else // Validação do processo com a verificação do array.

			For nI:= 1 To Len(oProd)
				If !Empty(XmlChildEx(oProd[nI]:_PROD,'_XPED')) // .AND. !Empty(XmlChildEx(oProd[nI]:_PROD,'_NITEMPED'))
					cProd 	:= oProd[nI]:_PROD:_CPROD:TEXT
					cPedido	:= StrZero(VAL(oProd[nI]:_PROD:_XPED:TEXT),TamSX3('C7_NUM')[1])
					if !Empty(XmlChildEx(oProd[nI]:_PROD,'_NITEMPED'))
					   cItPed	:= StrZero(VAL(oProd[nI]:_PROD:_NITEMPED:TEXT),TamSX3('C7_ITEM')[1])
					else
					   cItped := ""
					endif   
					cProd	:= Subs(cProd+Space(TamSX3("B1_COD")[1]),1,TamSX3("B1_COD")[1])


					If bPedObr
						cPed  	:= PADL(cPedido,TamSX3('C7_NUM')[1],'0')
						//cItem 	:= PADL(cItPed,TamSX3('C7_ITEM')[1],'0')

						//@ticket TTIKAA - T10729 - Isabella Rodrigues – Alteração do tamanho do Space.
						//cProd	:= Subs(cProd+Space(15),1,15)

						SB1->(DbSetOrder(1))
						If !SB1->(dbSeek(xFilial("SB1")+cProd))

                            // RTASK0011511 - Luiz Cesar (DMS) - Remanejada sequencia de validação do fornecedor 
							// efetuando tratamento para verificação de Fornecedores autorizados para importar xml.
							If cTpCliFor == "Fornecedor"

								dbSelectArea("SA5")
								SA5->(DbSetOrder(14))
								If  SA5->(DbSeek(xFilial("SA5")+cCliFor+cLoja+cProd))
									cProd := SA5->A5_PRODUTO
									SB1->(dbSeek(xFilial("SB1")+cProd)) //Produto existe e está amarrado. Posiciona SB1
								Else
                                    // Fornecedor não encontrado na tabela ZHB - Fornecedores autorizados para importar xml
                                    // Fornecedor autorizado identifica produto pela tag XPED no pedido de compras
                        			if !bFornAut 
						   				cMSG += "Fornecedor não consta em autorizados para importar xml "+Alltrim(cClifor)+"-"+alltrim(cLoja)+" "+CRLF
						   				lRet := .F.

                                    // Fornecedor autorizado identifica produto pela tag XPED no pedido de compras
                        			Elseif !Empty(XmlChildEx(oProd[nI]:_PROD,'_XPED')) 
					       					   
						 		  			SC7->(dbSetOrder(1))
					       					IF SC7->(dbSeek(xFilial('SC7')+cPed+cItPed))
					          					cProd := SC7->C7_PRODUTO
						   					Endif	 
									Else

			//			   				cMSG += "Amarração Produto x Fornecedor (SA5), produto, "+Alltrim(cProd)+", não cadastrado! "+CRLF
			//			   				lRet := .F.
									endif

								EndIf                    

								//Verifica amarração produtoxcliente
							Else
								dbSelectArea("SA7")
								SA7->(DbSetOrder(1))
								If SA7->(DbSeek(xFilial("SA7")+cCliFor+cLoja+cProd))
									cProd := SA7->A7_PRODUTO
									SB1->(dbSeek(xFilial("SB1")+cProd))
								Else
									cMSG += "Amarração Produto x Cliente (SA7), produto, "+Alltrim(cProd)+", não cadastrado! "+CRLF
									lRet := .F.
								EndIf
							EndIf

                            if bFornAut .and. !Empty(XmlChildEx(oProd[nI]:_PROD,'_NITEMPED'))
                               cItem := cItPed
							else   
							   cItem := xRetItPed(cFilAnt,cPed,cProd)
							endif   
							If Empty(cItem)
								cMSG += "Item do pedido: "+ cPed + " do produto: "+ cProd +" não encontrado."
								lRet := .F.
							Endif

						EndIf

						//Verifica qual o Grupo de Tributação: ICMS
						nPos1 	:= At('<det nItem="'+cValToChar(nI)+'">',cXml)
						nPos2 	:= At('<det nItem="'+cValToChar(nI+1)+'">',cXml)
						nPos2 	:= IIF(nPos2 <= 0,At('<total>',cXml), nPos2)
						cTexto 	:= Substring(cXml, nPos1, nPos2-nPOs1)
						cPedido := GetInfXML(cTexto, "<xPed>")

						//Verifica se existe nota fiscal de referencia para esta nota
						cNfRef := GetInfXML(cTexto, "<nNF>")
						cSerRef:= GetInfXML(cTexto, "<serie>")
						If !Empty(cNfRef) .And. !Empty(cSerRef)
							dbSelectArea("SD2")
							SD2->(dbSetOrder(3)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
							If SD2->(dbSeek(xFilial("SD2")+cNfRef+cSerRef+cCliFor+cLoja+cProd))
								dbSelectArea("SF4")
								SF4->(dbSetOrder(1))
								SF4->(dbSeek(xFilial("SF4")+SD2->D2_TES))
								If SF4->F4_PODER3 == "R"
									cTpDoc := "B"
								EndIf
							EndIf
						EndIf

						For nY := 1 To Len(aSitTrib)
							If !Empty(cImpIcms := GetInfXML(cTexto, "<ICMS"+aSitTrib[nY]+">"))
								cSitTrib := GetInfXML(cImpIcms, "<orig>")
								cSitTrib := IIF(cSitTrib=="1", "2",cSitTrib)
								cSitTrib +=	GetInfXML(cImpIcms, "<CST>")
								Exit
							EndIf
						Next nY

						//cCF := IIF( Substr(oProd[nI]:_PROD:_CFOP:TEXT,1,10)=="5" , "1" , "2" ) + Substr(oProd[nI]:_PROD:_CFOP:TEXT,2,3)

						IF Empty(Alltrim(cPedido)) .OR. val(cPedido) == 0 //.AND. Empty(Alltrim(cItPed)) .OR. val(cItPed) == 0
							cMSG += "É Obrigatorio ter Pedido de Compra"+CRLF
							lRet := .F.
						Else
							SC7->(dbSetOrder(1))
							IF SC7->(!dbSeek(xFilial('SC7')+cPed+cItem))
								cMSG += "Pedido/Item não cadastrado: "+Alltrim(cPed)+"-"+Alltrim(cItem)+CRLF
								lRet := .F.
							Else
								IF SC7->C7_TPOP == 'P' .OR. SC7->C7_CONAPRO == 'B' .OR. !Empty(SC7->C7_RESIDUO) .OR. !Empty(SC7->C7_ENCER)
									cMSG += "Pedido/Item Previsto, Bloqueado, Eliminado Residuo ou Encerrado :"+Alltrim(cPed)+"-"+Alltrim(cItem)+CRLF
									lRet := .F.
								ELSE
									IF (SC7->C7_QUANT - SC7->C7_QUJE ) <= 0
										cMSG += "Pedido/Item sem saldo para entrada :"+Alltrim(cPed)+"-"+Alltrim(cItem)+CRLF
										lRet := .F.
									EndIF
								EndIF
								//Verifica se o fornecedor tem entrega por terceiro (tabela CPX)
								If GetMv("MV_FORPCNF")
									SA2->(dbSetOrder(1)) //A2_FILIAL+A2_CODIGO+A2_LOJA
									If SA2->(DbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))
										If Alltrim(cCNPJ) != Alltrim(SA2->A2_CGC)
											SA2->(dbSetOrder(3)) //A2_FILIAL+A2_CGC
											SA2->(DbSeek(xFilial("SA2")+cCNPJ))
											cCodFXml := SA2->A2_COD
											cLojFXml := SA2->A2_LOJA
											CPX->(dbSetOrder(1)) //CPX_FILIAL+CPX_CODIGO+CPX_LOJA+CPX_CODFOR+CPX_LOJFOR
											If !CPX->(DbSeek(xFilial("CPX")+SC7->C7_FORNECE+SC7->C7_LOJA+cCodFXml+cLojFXml))
												cMSG += "Fornecedor "+Alltrim(cCodFXml)+"-"+Alltrim(cLojFXml)+" não cadastrado como entrega terceiro."+CRLF
												lRet := .F.
											EndIf
										Endif
									Endif
								Else
									cMSG += "Parametro MV_FORPCNF está desabilitado!"+CRLF
									lRet := .F.
								Endif

								cUm			:= SC7->C7_UM
								cCC			:= SC7->C7_CC
								cConta		:= SC7->C7_CONTA
								cItemCta	:= SC7->C7_ITEMCTA
								cClassVal	:= SC7->C7_CLVL
							EndIf
						EndIf
					Endif

					cLocaPad      := ''
					IF SBZ->(dbSeek(xFilial()+cProd))
						cLocaPad := SBZ->BZ_LOCPAD
					ElseIf SB1->(dbSeek(xFilial()+cProd))
						cLocaPad := SB1->B1_LOCPAD
					EndiF

					IF lRet
						CadAlmox(cLocaPad,cProd)
					EndIF

					aLinha		:= {}
					AAdd(aLinha ,{'D1_COD'  		,cProd					   				,NIL})
					AAdd(aLinha ,{'D1_ITEM' 		,StrZero(nI,TamSx3('D1_ITEM')[1])    	,NIL})
					//AAdd(aLinha ,{'D1_UM'   		,oProd[nI]:_PROD:_UCOM:TEXT		   		,NIL})
					IF !Empty(Alltrim(cPedido))
						Aadd(aLinha,  {'D1_PEDIDO',cPed	  ,NIL})
						Aadd(aLinha,  {'D1_ITEMPC', cItem ,NIL})
					EndIF
					AAdd(aLinha ,{'D1_QUANT' 	    ,Val(oProd[nI]:_PROD:_QCOM:TEXT)  ,NIL})
					AAdd(aLinha ,{'D1_VUNIT' 	    ,Val(oProd[nI]:_PROD:_VUNCOM:TEXT),NIL})
					AAdd(aLinha ,{'D1_TOTAL' 	    ,Val(oProd[nI]:_PROD:_VPROD:TEXT) ,NIL})
					AAdd(aLinha ,{'D1_CLASFIS' 	    ,cSitTrib				   		  ,NIL})
					AAdd(aLinha ,{'D1_LOCAL'		,Alltrim(cLocaPad)	              ,NIL})

					If !Empty(cUm)
						AAdd(aLinha ,{'D1_UM' 	    ,cUm		,NIL})
					EndIf

					If !Empty(cCC)
						AAdd(aLinha ,{'D1_CC' 	    ,cCC		,NIL})
					EndIf

					If !Empty(cConta)
						AAdd(aLinha ,{'D1_CONTA ' 	,cConta		,NIL})
					EndIf

					If !Empty(cItemCta)
						AAdd(aLinha ,{'D1_ITEMCTA ' ,cItemCta	,NIL})
					EndIf

					If !Empty(cClassVal)
						AAdd(aLinha ,{'D1_CLVL ' 	,cClassVal	,NIL})
					EndIf

					AAdd(aItens,aLinha)
				Endif
			Next nI
		EndIf
	EndIf

	//Caso não tenha tido problemas de validação ou se o XML for intercompany, executa a gravação da Pre Nota

	//Transportadora

	oTransp := XmlParser(GetInfXML(cXML, "infNFe",.T.) , "_", @cError, @cWarning )
	oPlaca  := XmlParser(GetInfXML(cXML, "infNFe",.T.) , "_", @cError, @cWarning )
	cTransp := ""
	cPlaca  := ""

	If at("<TRANSPORTA>",upper(cXML)) > 0

		nTransIni	:= at("<TRANSPORTA>",upper(cXML))
		nTransFim	:= at("</TRANSPORTA>",upper(cXML))
		cContTrans	:= Substr(cXML,nTransIni,(nTransFim-nTransIni))
		oTransp:= oTransp:_INFNFE:_TRANSP:_TRANSPORTA
		If at("<CNPJ>",upper(cContTrans)) > 0
			cTransp:= oTransp:_CNPJ:TEXT
		Endif
	Endif
	If at("<VEICTRANSP>",upper(cXML)) > 0
		oPlaca:= oPlaca:_INFNFE:_TRANSP:_VEICTRANSP
		cPlaca:= oPlaca:_PLACA:TEXT
	Endif

	If !Empty(cTransp)
		DbSelectArea("SA4")
		SA4->(DbSetOrder(3)) // A4_FILIAL + A4_CGC
		If SA4->(DbSeek(xFilial("SA4")+cTransp))
			cCodTrans := SA4->A4_COD
		Endif
	Endif

	If lRet
		//Cabeçalho
		aCabec := { {'F1_FILIAL'    , cFilAnt  ,NIL},;
		{'F1_DOC'  	    ,cNf	   ,NIL},;
		{'F1_SERIE' 	,cSerie	   ,NIL},;
		{'F1_EMISSAO'	,dEmis	   ,NIL},;
		{'F1_FORNECE'	,cCliFor   ,NIL},;
		{'F1_ESPECIE'	,"SPED"	   ,NIL},;
		{'F1_CHVNFE' 	,cChvNfe   ,NIL},;
		{'F1_TIPO'	 	,cTpDoc	   ,NIL},;
		{'F1_LOJA'		,cLoja	   ,NIL},;
		{'F1_TRANSP' 	,cCodTrans ,NIL},;
		{'F1_PLACA' 	,cPlaca    ,NIL},;
		{'F1_ZVLRTOT' 	,nValTot   ,NIL},;
		{'F1_ORIGEM' 	,'MGFINT09',NIL}}

		//Itens intercompany
		If !bPedObr
			If ValType(oProd) != 'A'
				cProd 	:= oProd:_CPROD:TEXT
				cProd	:= Subs(cProd+Space(TamSX3("B1_COD")[1]),1,TamSX3("B1_COD")[1])
				cUm 	:= oProd:_UCOM:TEXT
				cUm		:= Subs(cUm+Space(TamSX3("B1_UM")[1]),1,TamSX3("B1_UM")[1])

				cLocaPad      := ''
				IF SBZ->(dbSeek(xFilial()+cProd))
					cLocaPad := SBZ->BZ_LOCPAD
				ElseIf SB1->(dbSeek(xFilial()+cProd))
					cLocaPad := SB1->B1_LOCPAD
				EndiF

				aLinha		:= {}
				aItens      := {}
				AAdd(aLinha ,{'D1_COD'  		,cProd					   				,NIL})
				AAdd(aLinha ,{'D1_ITEM' 		,StrZero(1,TamSx3('D1_ITEM')[1])    	,NIL})
				AAdd(aLinha ,{'D1_QUANT' 	    ,Val(oProd:_QCOM:TEXT)  ,NIL})
				AAdd(aLinha ,{'D1_VUNIT' 	    ,Val(oProd:_VUNCOM:TEXT),NIL})
				AAdd(aLinha ,{'D1_TOTAL' 	    ,Val(oProd:_VPROD:TEXT) ,NIL})
				AAdd(aLinha ,{'D1_CLASFIS' 	    ,cSitTrib	    		,NIL})
				AAdd(aLinha ,{'D1_LOCAL'		,Alltrim(cLocaPad)	    ,NIL})

				If !Empty(cUm)
					AAdd(aLinha ,{'D1_UM' 	    ,cUm		,NIL})
				EndIf

				AAdd(aItens,aLinha)
			Else
				aItens      := {}
				For nI:= 1 To Len(oProd)
					cProd 	:= oProd[nI]:_PROD:_CPROD:TEXT
					cProd	:= Subs(cProd+Space(TamSX3("B1_COD")[1]),1,TamSX3("B1_COD")[1])
					cUm 	:= oProd[nI]:_PROD:_UCOM:TEXT
					cUm		:= Subs(cUm+Space(TamSX3("B1_UM")[1]),1,TamSX3("B1_UM")[1])

					cLocaPad      := ''
					IF SBZ->(dbSeek(xFilial()+cProd))
						cLocaPad := SBZ->BZ_LOCPAD
					ElseIf SB1->(dbSeek(xFilial()+cProd))
						cLocaPad := SB1->B1_LOCPAD
					EndiF

					aLinha		:= {}
					AAdd(aLinha ,{'D1_COD'  		,cProd					   		  ,NIL})
					AAdd(aLinha ,{'D1_ITEM' 		,StrZero(nI,TamSx3('D1_ITEM')[1]) ,NIL})
					AAdd(aLinha ,{'D1_QUANT' 	    ,Val(oProd[nI]:_PROD:_QCOM:TEXT)  ,NIL})
					AAdd(aLinha ,{'D1_VUNIT' 	    ,Val(oProd[nI]:_PROD:_VUNCOM:TEXT),NIL})
					AAdd(aLinha ,{'D1_TOTAL' 	    ,Val(oProd[nI]:_PROD:_VPROD:TEXT) ,NIL})
					AAdd(aLinha ,{'D1_CLASFIS' 	    ,cSitTrib				   		  ,NIL})
					AAdd(aLinha ,{'D1_LOCAL'		,Alltrim(cLocaPad)	              ,NIL})

					If !Empty(cUm)
						AAdd(aLinha ,{'D1_UM' 	    ,cUm		,NIL})
					EndIf

					AAdd(aItens,aLinha)
				Next nI
			Endif
		Endif

		MsExecAuto({|x,y,z| MATA140(x,y,z)}, aCabec, aItens, 3)

		If lMsErroAuto
			lRet := .F.
			cMsg += "Erro na gravação dos registros via ExecAuto."+CRLF+CRLF
			cMsg += MemoRead(NomeAutoLog())
			Ferase(NomeAutoLog())
		EndIf
	EndIf

	oDestino := Nil
	oProd	 := Nil
	oTransp  := Nil
	oPlaca   := Nil
	DelClassIntF()
	ConOut(cMsg)

Return lRet

//----------------------------------------------------------------------------------
//Pega informações do XML via Tag
//----------------------------------------------------------------------------------
Static Function GetInfXML(cText, cTag, lTag)
	Local cTagFim := ""
	Local nPosIni := 0
	Local nPosFim := 0
	Local xRetorno:= ""

	Default lTag := .F.

	cTagFim := IIF( At("<",cTag)==0, "<"+cTag, cTag)
	cTagFim := IIF( At(">",cTag)==0, cTagFim+">", cTagFim)
	cTagFim := StrTran(cTagFim, "<", "</")

	nPosIni := IIF( At("<",cTag)   ==0, At("<"+cTag	  , cText) ,At(cTag   , cText)) + IIF( At(cTag, cText) > 0 .And. !lTag, Len(cTag),0)
	nPosFim := IIF( At(">",cTagFim) ==0, At(">"+cTagFim , cText) ,At(cTagFim, cText))
	xRetorno:= Substring(cText, nPosIni,IIF(lTag,(nPosFim-nPosIni)+Len(cTagFim),(nPosFim-nPosIni)))
Return xRetorno

//----------------------------------------------------------------------------------
//Gera log de erro
//----------------------------------------------------------------------------------
Static Function GeraLog(cArq,aDados,cMSG)

	ChkFile('SZ8')
	dbSelectArea('SZ8')
	RecLock('SZ8',.T.)
	SZ8->Z8_FILIAL  := xFilial('SZ8')
	SZ8->Z8_ARQUIVO := cArq
	SZ8->Z8_EMISSAO := aDados[1]
	SZ8->Z8_DOC     := aDados[2]
	SZ8->Z8_SERIE   := aDados[3]
	SZ8->Z8_FORNECE := aDados[4]
	SZ8->Z8_ERRO    := cMSG
	SZ8->Z8_STATUS  := '1'
	SZ8->Z8_DTLOG	:= dDataBase
	SZ8->Z8_HRLOG	:= Time()
	SZ8->(MsUnLock())

	Return

	********************************************************
Static Function CadAlmox(cAlmox,cProd)

	dbSelectArea('SB2')
	SB2->(dbSetOrder(2))
	IF SB2->(!dbSeek(xFilial('SB2')+cAlmox+cProd))
		CriaSB2(cProd,cAlmox,cFilAnt)
	EndIF

Return

//****************************************************
//FUNÇÃO USADA PARA TESTAR O MSEXECAUTO
//****************************************************
User Function ZMATA140()

  Local cError     := ''
	Local aRotAuto	:= {}

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.

	aCabec := { {'F1_FILIAL'    , '010041'  ,NIL},;
	{'F1_DOC'  	    ,'000009999',NIL},;
	{'F1_SERIE' 	,'003'	    ,NIL},;
	{'F1_EMISSAO'	,stod('20180524')	   ,NIL},;
	{'F1_FORNECE'	,'000411'   ,NIL},;
	{'F1_ESPECIE'	,'SPED'	    ,NIL},;
	{'F1_CHVNFE' 	,'11170803853896005370550030000054531030054533'   ,NIL},;
	{'F1_TIPO'	 	,'N'	    ,NIL},;
	{'F1_LOJA'		,'27'	    ,NIL},;
	{'F1_ORIGEM' 	,'MGFINT09' ,NIL} }


	aLinha		:= {}
	aItens		:= {}
	AAdd(aLinha ,{'D1_COD'  		,'809351'	,NIL})
	AAdd(aLinha ,{'D1_ITEM' 		,StrZero(1,TamSx3('D1_ITEM')[1])    	,NIL})
	AAdd(aLinha ,{'D1_QUANT' 	    ,15    ,NIL})
	AAdd(aLinha ,{'D1_VUNIT' 	    ,26    ,NIL})
	AAdd(aLinha ,{'D1_TOTAL' 	    ,390   ,NIL})
	AAdd(aLinha ,{'D1_CLASFIS' 	    ,'001' ,NIL})
	AAdd(aLinha ,{'D1_UM' 	        ,'UN'  ,NIL})

	AAdd(aItens,aLinha)

	// Chamada da rotina automatica
	MsExecAuto({|x,y,z| MATA140(x,y,z)},aCabec,aItens,3)

	// Mostra Erro na geracao de Rotinas automaticas
	If lMsErroAuto
		If (!IsBlind()) // COM INTERFACE GRÁFICA
		conout(MostraErro())
		MostraErro()
	    Else // EM ESTADO DE JOB
	        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
	
	        ConOut(PadC("Automatic routine ended with error", 80))
	        ConOut("Error: "+ cError)
	  EndIf
	EndIf

Return

//----------------------------------------------------------------------------------
//Faz a busca do item no pedido com base no xPed do arquivo XML
//----------------------------------------------------------------------------------

Static function xRetItPed(xcFil,xPed,xProd)

	Local cRet := ""
	Local cNextAlias := GetNextAlias()

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

	BeginSql Alias cNextAlias

	SELECT
	C7_ITEM
	FROM
	%Table:SC7% SC7

	WHERE
	SC7.C7_FILIAL = %Exp:xcFil% AND
	SC7.C7_NUM  = %Exp:xPed% AND
	SC7.C7_PRODUTO = %Exp:xProd% AND
	SC7.%NotDel%

	ORDER BY C7_ITEM

	EndSql

	(cNextAlias)->(DbGoTop())

	While (cNextAlias)->(!EOF())
		cRet := (cNextAlias)->C7_ITEM
		(cNextAlias)->(dbSkip())
	EndDo

	If Select(cNextAlias) > 0
		(cNextAlias)->(DbClosearea())
	Endif

return cRet
