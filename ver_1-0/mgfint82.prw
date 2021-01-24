#include 'protheus.ch'
#include 'parmtype.ch'
#include 'Totvs.ch'
#Include "TopConn.ch"
#INCLUDE "rwmake.ch"

#define CRLF CHR(13)+CHR(10)

/*/ {Protheus.doc} MGFINT82
Automa��o para inclus�o de movimentos banc�rios, tipos a pagar e receber.

@author Henrique Vidal
@since 01/02/2020
@return Nil
/*/	

User Function MGFINT82()

    Local aArea   := GetArea()
	Local cFile   := ""
	Local cPerg	  := "MGFINT82"

	Private cHash := ""
	Private oproc 
    
    IF Pergunte(cPerg,.T.)
       
       cFile := ALLTRIM(MV_PAR01)
	   cHash := MD5FILE(ALLTRIM(MV_PAR01))
    
	    If !Empty(cFile)

		   // Verifica se existe o c�digo hash (o arquivo j� foi lido anteriormente)
           dbSelectArea("SE5")
		   SE5->(DbOrderNickName('MGFHASH'))
		   
		   If dbSeek(cHash)
			   ApMsgAlert(OemToAnsi("Arquivo j� processado anteriormente. Selecione um novo CSV para importa��o."),;
			              OemToAnsi("MGFINT82 - Importa��o movimentos banc�rios")) 
              RestArea(aArea)
		      Return
           EndIf

		   // Somente importa arquivos .CSV
		   If !".csv"$AllTrim(cFile) .And. !".CSV"$AllTrim(cFile)
	          ApMsgAlert(OemToAnsi("Processo utilizado apenas para importa��o de arquivos .CSV"),;
		                 OemToAnsi(("MGFINT82 - Importa��o movimentos banc�rios")))
              RestArea(aArea)
		      Return
	       Else
		      fwmsgrun(,{|oproc| fGerSe5(cFile,oproc) }, "Aguarde...","Processando Importa��o do arquivo.")
	       EndIf
	
		EndIf   
    
	EndIf

    RestArea(aArea)	

Return

/*/ {Protheus.doc} MGFINT82
Leitura do arquivo, check dos dados. 

@author Henrique Vidal
@since 01/02/2020
@return Nil
/*/	

Static Function fGerSe5(cFile,oproc)
 
	Local cLinha    := ""
	Local cHist 	:= ""

	Local cFlt      := ""
	Local cQry      := ""

	Local cBanco 	:= Space(TamSx3("A6_COD")[1])
	Local cAgencia 	:= Space(TamSx3("A6_AGENCIA")[1])
	Local cConta 	:= Space(TamSx3("A6_NUMCON")[1])

	Local dDtMov 	:= CtoD(Space(08))

	Local i         := 0
	Local n         := 0
	Local nValor 	:= 0

	Local lCabec    := .T.
	Local lOk       := .F.

	Private  aDados    := {}
	Private  aCampos   := {}
	Private  aFail     := {}
	Private  nPTpMvto, nPFilial, nPDtMov, nPNumera, nPVlrMov, nPNature, nPBanco, nPAgc, nPConta, nPCCusto, nPHistor, nPStatus := 0

	If FT_FUse(cFile) > 0
	
		FT_FGOTOP()
		While !FT_FEOF()

			If valtype(oproc) == "O"
				oproc:cCaption := ("Efetuando Leitura do Arquivo - Linha : "+StrZero(n++,6))
				processmessages()
			Endif

			cLinha := FT_FREADLN()
		
			If !Empty(cLinha)

				If lCabec
					aCampos := StrTokArr2(cLinha,";",.T.)
					AADD(aCampos,"Status")
					lCabec := .F.
				Else
					cLinha += ";"
					AADD(aDados,StrTokArr2(cLinha,";",.T.))
				EndIf

			EndIf 

		FT_FSkip()
		EndDo  
		FT_FUSE()

	Else
		ApMsgAlert(OemToAnsi("N�o foi poss�vel ler o arquivo: " + cFile),OemToAnsi("ATEN��O"))
		ApMsgInfo(OemToAnsi("Processo Interrompido"),OemToAnsi("ATEN��O"))
		Return
	EndIf

	IF !ChkEstru()
		ApMsgInfo(OemToAnsi("Importa��o de movimentos banc�rios n�o efetuada."),OemToAnsi("FALHA"))
		Return
	EndIf 

	If !ChkDados()
		U_MGListBox( "Log de Processamento - Movimentos Banc�rios" , aCampos , aFail , .T. , 1 )
		ApMsgInfo(OemToAnsi("Importa��o de movimentos banc�rios n�o efetuada."),OemToAnsi("FALHA"))
		Return
	EndIf 

	If !U_MGListBox( "Movimentos a Processar - Deseja Continuar ?" , aCampos , aDados , .T. , 1 )   
		ApMsgInfo(OemToAnsi("Importa��o de movimentos banc�rios n�o efetuada."),OemToAnsi("FALHA"))
		Return
	EndIf

	// Grava importa��o dos dados j� validados
	cBkpFil 	:= cFilAnt

	For i := 1 to Len(aDados)

		If valtype(oproc) == "O" 
		oproc:cCaption := ("Importando movimentos - Registro : "+StrZero(i,6)+" de "+StrZero(Len(aDados),6))
		processmessages()
		Endif
		
		// Efetua a Busca dos dados do banco (Via Filtro no Banco)
		cQry := "SELECT A6_COD,A6_AGENCIA,A6_NUMCON " + CRLF
		cQry += "FROM "+RetSqlName("SA6")+" " + CRLF
		cQry += "WHERE D_E_L_E_T_ = ' ' " + CRLF
		cQry += "AND A6_COD     = '"+aDados[i,nPBanco]+"' " + CRLF
		cQry += "AND A6_AGENCIA = '"+aDados[i,nPAgc]+"' " + CRLF
		cQry += "AND A6_NUMCON  = '"+aDados[i,nPConta]+"' " + CRLF

		TcQuery cQry New Alias "SA6TMP"

		If SA6TMP->(!Eof())
			cBanco   := SA6TMP->A6_COD
			cAgencia := SA6TMP->A6_AGENCIA
			cConta 	:= SA6TMP->A6_NUMCON
		Else
			cBanco	:= "" 
			cConta	:= ""
			cAgencia :="" 
		EndIf

		SA6TMP->(dbCloseArea())

		dDtMov	 	:= CtoD(aDados[i,nPDtMov])			
		nValor 	    := Val(StrTran(StrTran(adados[i,nPVlrMov],".",""),",","."))	
		cHist 		:= AllTrim(aDados[i,nPHistor])		

		cFilAnt 	:= aDados[i,nPFilial]
		aFINA100 	:= { {"E5_DATA"    ,dDtMov             	,Nil},;
						{"E5_MOEDA"    ,aDados[i,nPNumera]	,Nil},;
						{"E5_VALOR"    ,nValor             	,Nil},;
						{"E5_NATUREZ"  ,aDados[i,nPNature] 	,Nil},;
						{"E5_BANCO"    ,cBanco             	,Nil},;
						{"E5_AGENCIA"  ,cAgencia           	,Nil},;
						{"E5_CONTA"    ,cConta             	,Nil},;
						{"E5_CCUSTO"   ,aDados[i,nPCCusto] 	,Nil},;
						{"E5_HISTOR"   ,cHist				,Nil}}

		Begin Transaction		
			
			lMsErroAuto := .F.

			If Upper(aDados[i,nPTpMvto]) == 'R'
				MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,4)
			ElseIf Upper(aDados[i,nPTpMvto]) == 'P' 
				MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,3)
			EndIf 

			If lMsErroAuto
				DisarmTransaction()
				If (!IsBlind()) 
					aDados[i,nPStatus] := MostraErro("/dirdoc", "error.log") 
				Else // EM ESTADO DE JOB
					cError := MostraErro("/dirdoc", "error.log") 
					ConOut(PadC("Automatic routine ended with error", 80))
					ConOut("Error: "+ cError)
				EndIf
			Else
				aDados[i,nPStatus] := "Movimento banc�rio efetuado com sucesso"
				lOk := .T.

				SE5->(RecLock("SE5", .F. ))
					SE5->E5_ZHASH   := cHash
				SE5->(MsUnLock())
			
			EndIF

		End Transaction
		
	Next i

	cFilAnt  := cBkpFil 

	U_MGListBox( "Log de Processamento - Movimentos Banc�rios" , aCampos , aDados , .T. , 1 )

	If lOk
		ApMsgInfo(OemToAnsi("Importa��o de movimentos banc�rios conclu�da com sucesso!"),OemToAnsi("SUCESSO"))
	EndIf   
 
Return

/*/   {Protheus.doc} ChkEstru : Valida exist�ncia dos campos, e erros no arquivo.
@author Henrique Vidal
@since 02/12/2020
/*/	
Static Function ChkEstru()
	Local lContinua := .T.
	Local aErrStru 	:= {"Linha","Descri��o do Erro"} 
	Local aErros	:= {}
	
	// Campos obrigat�rios no Excel, utilizado para gravar dados.
	nPTpMvto	:= aScan(aCampos,{|x|�Alltrim(x)�==�"Tipo movimento"})
	nPFilial	:= aScan(aCampos,{|x|�Alltrim(x)�==�"Filial"})
	nPDtMov		:= aScan(aCampos,{|x|�Alltrim(x)�==�"Dt Movimento"})
	nPNumera	:= aScan(aCampos,{|x|�Alltrim(x)�==�"Numerario"})
	nPVlrMov	:= aScan(aCampos,{|x|�Alltrim(x)�==�"Vlr. Movimento"})
	nPNature	:= aScan(aCampos,{|x|�Alltrim(x)�==�"Natureza"})
	nPBanco		:= aScan(aCampos,{|x|�Alltrim(x)�==�"Banco"})
	nPAgc		:= aScan(aCampos,{|x|�Alltrim(x)�==�"Agencia"})
	nPConta		:= aScan(aCampos,{|x|�Alltrim(x)�==�"Conta Banco"})
	nPCCusto	:= aScan(aCampos,{|x|�Alltrim(x)�==�"C. de Custo"})
	
	// Campos n�o obrigat�rios.
	nPHistor	:= aScan(aCampos,{|x|�Alltrim(x)�==�"Historico"})
	nPStatus	:= aScan(aCampos,{|x|�Alltrim(x)�==�"Status"})

	If nPTpMvto	== 0 
		AADD(aErros , { '1' , " Campo: Tipo movimento - n�o localizado no cabe�alho da planilha. Linha 1."})	 			//	1
	 	lContinua := .F. 
  	EndIf 
	If nPFilial		== 0 
		AADD(aErros , { '1' , " Campo: Filial - n�o localizado no cabe�alho da planilha. Linha 1."})  				//	2
	 	lContinua := .F. 
  	EndIf 
	If nPDtMov		== 0 
		AADD(aErros , { '1' , " Campo: Nome do Dt Movimen - n�o localizado no cabe�alho da planilha. Linha 1."})		
	 	lContinua := .F. 
  	EndIf 
	If nPNumera		== 0 
		AADD(aErros , { '1' , " Campo: Numerario - n�o localizado no cabe�alho da planilha. Linha 1."})				//	4
	 	lContinua := .F. 
  	EndIf 
	If nPVlrMov	== 0 
		AADD(aErros , { '1' , " Campo: Vlr. Movim. - n�o localizado no cabe�alho da planilha. Linha 1."})	//	9
	 	lContinua := .F. 
  	EndIf 
	If nPNature	== 0 
		AADD(aErros , { '1' , " Campo: Natureza - n�o localizado no cabe�alho da planilha. Linha 1."})	//	10
	 	lContinua := .F. 
  	EndIf 
	If nPBanco	== 0 
		AADD(aErros , { '1' , " Campo: Banco - n�o localizado no cabe�alho da planilha. Linha 1."})			//	11
	 	lContinua := .F. 
  	EndIf 
	If nPAgc	== 0 
		AADD(aErros , { '1' , " Campo: Agencia - n�o localizado no cabe�alho da planilha. Linha 1."})				//	23
	 	lContinua := .F. 
  	EndIf 
	If nPConta	== 0 
		AADD(aErros , { '1' , " Campo: Conta Banco - n�o localizado no cabe�alho da planilha. Linha 1."})					//	24
	 	lContinua := .F. 
  	EndIf 
	If nPCCusto	== 0 
		AADD(aErros , { '1' , " Campo: C. de Custo - n�o localizado no cabe�alho da planilha. Linha 1."})				//	25
	 	lContinua := .F. 
  	EndIf 
	If nPHistor	== 0 
		AADD(aErros , { '1' , " Campo: Historico - n�o localizado no cabe�alho da planilha. Linha 1."})				//	25
	 	lContinua := .F. 
  	EndIf 
	
	If !lContinua
		//MostraErr(aErros)
		U_MGListBox( "Log: Leitura de erros no arquivo" , aErrStru , aErros , .T. , 1 )
   		ApMsgInfo(OemToAnsi("Importa��o de movimentos banc�rios n�o efetuada."),OemToAnsi("Estrutura"))
	EndIf 

Return lContinua


Static Function ChkDados()

	Local lRet := .T.

	For i := 1 to Len(aDados)

		If valtype(oproc) == "O" 
			oproc:cCaption := ("Verificando Inconsist�ncias - Registro : "+StrZero(i,6)+" de "+StrZero(Len(aDados),6))
			processmessages()
		Endif

		// Verifica se h� campos em branco
		If Empty(aDados[i,nPTpMvto]) .Or. Empty(aDados[i,nPFilial]) .Or. Empty(aDados[i,nPDtMov]) .Or. ;
			Empty(aDados[i,nPNumera]) .Or. Empty(aDados[i,nPVlrMov]) .Or. Empty(aDados[i,nPNature]) .Or. ;
			Empty(aDados[i,nPBanco]) .Or. Empty(aDados[i,nPAgc]) .Or. Empty(aDados[i,nPConta]) .Or. Empty(aDados[i,nPCCusto])

			aDados[i,nPStatus] += "Verifique campos n�o preenchidos" 

		EndiF

		If !( Upper(aDados[i,nPTpMvto]) $ "P/R" )
			aDados[i,nPStatus] += "Tipo de movimento inv�lido. Somente ser� importado Pagar e Receber." 
		EndIf 
		
		If !Empty(aDados[i,nPFilial]) .and. !ExistCpo("SM0",'01'+aDados[i,nPFilial])  
			If !ExistCpo("SM0",'02'+aDados[i,nPFilial])  
				aDados[i,nPStatus] += "Filial inv�lida." 
			EndIf 
		EndIf 

		IF aDados[i,nPNumera] == 'TR'
			aDados[i,nPStatus] += "Programa efetua somente pagamento e recebimento simples. Para transfer�ncia utilize op��o manual." 
		Else 
			dbSelectArea("SX5")
			If !(dbSeek(xFilial("SX5")+"06"+ Padr(aDados[i,nPNumera], TamSX3('E5_MOEDA')[1] )))
				aDados[i,nPStatus] += "Moeda inv�lida." 
			EndIf
		EndIf

		// Verifica a exist�ncia do cadastro de bancos e se existem cadastros bloqueados
		If !Empty(aDados[i,nPBanco])
			cFlt := "SELECT A6_COD,A6_AGENCIA,A6_NUMCON,A6_BLOCKED " + CRLF
			cFlt += "FROM "+RetSqlName("SA6")+" " + CRLF
			cFlt += "WHERE D_E_L_E_T_ = ' ' " + CRLF
			cFlt += "AND A6_COD     = '"+aDados[i,nPBanco]+"' " + CRLF
			cFlt += "AND A6_AGENCIA = '"+aDados[i,nPAgc]+"' " + CRLF
			cFlt += "AND A6_NUMCON  = '"+aDados[i,nPConta]+"' " + CRLF
			
			TcQuery cFlt New Alias "SA6TRB"

			If SA6TRB->(!Eof())
				If SA6TRB->A6_BLOCKED == "1"
					aDados[i,nPStatus] += "Cadastro de Banco / Agencia / Conta bloqueado"
				EndIf	 
			Else
				aDados[i,nPStatus] += "Banco / Agencia / Conta n�o cadastrado" 
			EndIf

			SA6TRB->(dbCloseArea())

		EndIf
		
		// Verifica a exist�ncia do cadastro da natureza e se existem cadastros bloqueados
		If !Empty(aDados[i,nPNature])
			dbSelectArea("SED")
			dbSetOrder(1)

			If dbSeek(xFilial("SED")+aDados[i,nPNature])
				If SED->ED_MSBLQL == "1"
					aDados[i,nPStatus] += "O Cadastro da Natureza est� bloqueado"
				EndIf
			Else
				aDados[i,nPStatus] += "Natureza n�o cadastrada" 
			EndIf	  	 
		EndIf
		
		If !Empty(aDados[i,nPCCusto])
			dbSelectArea("CTT")
			dbSetOrder(1)

			If dbSeek(xFilial("CTT")+aDados[i,nPCCusto])
				If CTT->CTT_BLOQ == "1"
					aDados[i,nPStatus] += "O Cadastro de C.Custo est� bloqueado"
				EndIf
			Else
				aDados[i,nPStatus] += "C.Custo n�o cadastrado" 
			EndIf	  	 
		EndIf

		// Se o ultimo campo do array aDados estiver preenchido
		If !Empty(aDados[i,nPStatus])
			AADD(aFail,{aDados[i,nPTpMvto] , aDados[i,nPFilial] , aDados[i,nPDtMov] , aDados[i,nPNumera] ,;
						aDados[i,nPVlrMov] , aDados[i,nPNature] , aDados[i,nPBanco] , aDados[i,nPAgc] ,;
						aDados[i,nPConta] ,  aDados[i,nPHistor] , aDados[i,nPCCusto] ,aDados[i,nPStatus] })
			lRet := .F.
		EndIf

	Next i

Return lRet
