#include 'protheus.ch'
#include 'parmtype.ch'
#include 'Totvs.ch'
#Include "TopConn.ch"

#define CRLF CHR(13)+CHR(10)

/*/{Protheus.doc} MGFINT71
Automa��o do processo de inclus�o de RA

@author Paulo da Mata
@since 18/11/2019
@version P12.1.17
@return Nil
/*/

User Function MGFINT71()

    Local aArea   := GetArea()
	Local cFile   := ""
    Local cFila   := ""
	Local cPerg	  := "MGFINT71"

	Private cHash := ""
    
    IF Pergunte(cPerg,.T.)
       
       cFila := MV_PAR01
       cFile := ALLTRIM(MV_PAR02)
	   cHash := MD5FILE(ALLTRIM(MV_PAR02))
    
	    If !Empty(cFile)

		   // Verifica se existe o c�digo hash (o arquivo j� foi lido anteriormente)
           dbSelectArea("SE1")
		   dbSetOrder(33)
		   
		   If dbSeek(cHash)
			   ApMsgAlert(OemToAnsi("Arquivo j� processado anteriormente. Selecione um novo CSV para importa��o."),;
			              OemToAnsi("MGFINT71 - Importa��o RA")) 
              RestArea(aArea)
		      Return
           EndIf

		   // Somente importa arquivos .CSV
		   If !".csv"$AllTrim(cFile) .And. !".CSV"$AllTrim(cFile)
	          ApMsgAlert(OemToAnsi("Processo utilizado apenas para importa��o de arquivos .CSV"),;
		                 OemToAnsi(("MGFINT71 - Importa��o RA")))
              RestArea(aArea)
		      Return
	       Else
		      fwmsgrun(,{|oproc| fGerSe1(cFila,cFile,oproc) }, "Aguarde...","Processando Importa��o do RA")
	       EndIf
	
		EndIf   
    
	EndIf

    RestArea(aArea)	

Return

/*/{Protheus.doc} FGERSE1
L� o .CSV e efetua a gera��o dos RA's no SE1 (Contas a Receber)

@author Paulo da Mata
@since 18/11/2019
@version P12.1.17
@return Nil
/*/

Static Function fGerSe1(cFila,cFile,oproc)
 
Local cLinha    := ""

Local cPrefixo 	:= ""
Local cNumero 	:= ""
Local cParcela 	:= ""
Local cTipo 	:= ""
Local cCliente 	:= ""

Local cLoja 	:= ""
Local cNomCli 	:= ""
Local cHist 	:= ""

Local cFlt      := ""
Local cQry      := ""

Local cNatureza := Space(TamSx3("ED_CODIGO")[1])
Local cBanco 	:= Space(TamSx3("A6_COD")[1])
Local cAgencia 	:= Space(TamSx3("A6_AGENCIA")[1])
Local cConta 	:= Space(TamSx3("A6_NUMCON")[1])

Local dEmissao 	:= CtoD(Space(08))
Local dVencto 	:= CtoD(Space(08))
Local dVencReal := CtoD(Space(08))

Local i         := 0
Local n         := 0
Local nValor 	:= 0

Local lPrim     := .T.
Local lOk       := .F.

Local aDados    := {}
Local aCampos   := {}
Local aVetSE1   := {}

Local aFail     := {}

If FT_FUse(cFile) > 0
   
   FT_FGOTOP()
   
   While !FT_FEOF()

      If valtype(oproc) == "O"
	     oproc:cCaption := ("Efetuando Leitura do Arquivo - Linha : "+StrZero(n++,6))
	     processmessages()
	  Endif

	  cLinha := FT_FREADLN()
	  
	  If Empty(cLinha)
		 FT_FSKIP()
		 Loop
	  EndIf

	  If lPrim
	     aCampos := StrTokArr2(cLinha,";",.T.)
		 AADD(aCampos,"Status")
		 lPrim := .F.
	  Else
	     cLinha += ";"
	     AADD(aDados,StrTokArr2(cLinha,";",.T.))
	  EndIf

      FT_FSkip()

	EndDo  

Else

	ApMsgAlert(OemToAnsi("N�o foi poss�vel ler o arquivo: " + cFile),OemToAnsi("ATEN��O"))
	ApMsgInfo(OemToAnsi("Processo Interrompido"),OemToAnsi("ATEN��O"))
	Return

EndIf

// Efetua todas as consist�ncias antes de gerar os RA's
For i := 1 to Len(aDados)

    If valtype(oproc) == "O" 
       oproc:cCaption := ("Verificando Inconsist�ncias - Registro : "+StrZero(i,6)+" de "+StrZero(Len(aDados),6))
       processmessages()
    Endif

	// Verifica se h� campos em branco
	If Empty(aDados[i,1]) .Or. Empty(aDados[i,4]) .Or. Empty(aDados[i,5]) .Or. ;
	   Empty(aDados[i,6]) .Or. Empty(aDados[i,7]) .Or. Empty(aDados[i,8]) .Or. ;
	   Empty(aDados[i,9]) .Or. Empty(aDados[i,10]) .Or. Empty(aDados[i,11]) .Or. ;
	   Empty(aDados[i,12]) .Or. Empty(aDados[i,13]) .Or. Empty(aDados[i,14])

	   aDados[i,15] += "Verifique campos n�o preenchidos" 

    EndiF

	// Verifica a exist�ncia do cadastro de bancos e se existem cadastros bloqueados
    If !Empty(aDados[i,5])
       cFlt := "SELECT A6_COD,A6_AGENCIA,A6_NUMCON,A6_BLOCKED " + CRLF
       cFlt += "FROM "+RetSqlName("SA6")+" " + CRLF
       cFlt += "WHERE D_E_L_E_T_ = ' ' " + CRLF
       cFlt += "AND A6_COD     = '"+aDados[i,5]+"' " + CRLF
       cFlt += "AND A6_AGENCIA = '"+aDados[i,6]+"' " + CRLF
       cFlt += "AND A6_NUMCON  = '"+aDados[i,7]+"' " + CRLF
	   
	   TcQuery cFlt New Alias "SA6TRB"

	   If SA6TRB->(!Eof())
	      If SA6TRB->A6_BLOCKED == "1"
	         aDados[i,15] += "Cadastro de Banco / Agencia / Conta bloqueado"
	      EndIf	 
	   Else
	      aDados[i,15] += "Banco / Agencia / Conta n�o cadastrado" 
       EndIf

        SA6TRB->(dbCloseArea())

    EndIf

    // Verifica a exist�ncia do cadastro do cliente e se existem cadastros bloqueados
	If !Empty(aDados[i,9])

       cCliente := aDados[i,9]
       cLoja 	:= aDados[i,10]

	   dbSelectArea("SA1")
	   dbSetOrder(1)

	   If dbSeek(xFilial("SA1")+cCliente+cLoja)
	      If SA1->A1_MSBLQL == "1"
	         aDados[i,15] += "Cadastro do Cliente est� bloqueado"
		  EndIf
	   Else	  	 
	      aDados[i,15] += "Cliente n�o cadastrado" 
       EndIf

	Endif

	// Verifica a exist�ncia do cadastro da natureza e se existem cadastros bloqueados
	If !Empty(aDados[i,8])
	   cNatureza := aDados[i,8]

	   dbSelectArea("SED")
	   dbSetOrder(1)

	   If dbSeek(xFilial("SED")+cNatureza)
	      If SED->ED_MSBLQL == "1"
		     aDados[i,15] += "O Cadastro da Natureza est� bloqueado"
		  EndIf
	   Else
	      aDados[i,15] += "Natureza n�o cadastrada" 
	   EndIf	  	 
    EndIf

    // Se o ultimo campo do array aDados estiver preenchido
	If !Empty(aDados[i,15])
	   AADD(aFail,{aDados[i,1],aDados[i,2],aDados[i,3],aDados[i,4],aDados[i,5],;
	               aDados[i,6],aDados[i,7],aDados[i,8],aDados[i,9],aDados[i,10],;
				   aDados[i,11],aDados[i,12],aDados[i,13],aDados[i,14],aDados[i,15]})
    EndIf

Next

// Ap�s as consist�ncias, executa a condi��o abaix
If !Empty(aFail) // Se a matriz estiver preencuida, exibe tela ao usu�rio com as consist�ncias e sai do processo
   U_MGListBox( "Log de Processamento - Importa��o RA" , aCampos , aFail , .T. , 1 )
   ApMsgInfo(OemToAnsi("Gera��o dos RA's n�o efetuado"),OemToAnsi("FALHA"))
   Return
Else // Sen�o, mostra as RA's a serem geradas
   If !U_MGListBox( "Titulos a Processar - Deseja Continuar ?" , aCampos , aDados , .T. , 1 )   
      ApMsgInfo(OemToAnsi("Gera��o dos RA's n�o efetuado"),OemToAnsi("FALHA"))
      Return
   EndIf
EndIf

// Gera a matriz para cria��o das RA's com os dados j� criticados
For i := 1 to Len(aDados)

    If valtype(oproc) == "O" 
	   oproc:cCaption := ("Gerando RA's - Registro : "+StrZero(i,6)+" de "+StrZero(Len(aDados),6))
	   processmessages()
	Endif

     // Efetua a Busca dos dados do banco (Via Filtro no Banco)
    cQry := "SELECT A6_COD,A6_AGENCIA,A6_NUMCON " + CRLF
    cQry += "FROM "+RetSqlName("SA6")+" " + CRLF
    cQry += "WHERE D_E_L_E_T_ = ' ' " + CRLF
    cQry += "AND A6_COD     = '"+aDados[i,5]+"' " + CRLF
    cQry += "AND A6_AGENCIA = '"+aDados[i,6]+"' " + CRLF
    cQry += "AND A6_NUMCON  = '"+aDados[i,7]+"' " + CRLF

    TcQuery cQry New Alias "SA6TMP"

    If SA6TMP->(!Eof())
       cBanco   := SA6TMP->A6_COD
       cAgencia := SA6TMP->A6_AGENCIA
       cConta 	:= SA6TMP->A6_NUMCON
    EndIf

    SA6TMP->(dbCloseArea())

    cCliente := If(IsNumeric(aDados[i,9]),StrZero(Val(aDados[i,9]),6),aDados[i,9])	// Cliente
	cLoja 	 := StrZero(Val(aDados[i,10]),2)	// Loja

     // Efetua a busca do nome do cliente
    cNomCli := AllTrim(Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_NOME")) // Raz�o Social

	// Carrega o restante dos dados
	cPrefixo 	:= aDados[i,1] 					// Prefixo
    cNumero 	:= GETSXENUM("SE1","E1_NUM")	// Titulo
	cParcela 	:= aDados[i,3]					// Parcela
	cTipo 		:= aDados[i,4]					// Tipo
    cNatureza 	:= aDados[i,8]					// Natureza
	dEmissao 	:= CtoD(aDados[i,11])			// Data de Emiss�o
	dVencto 	:= CtoD(aDados[i,12])			// Data de Vencimento
	dVencReal 	:= CtoD(aDados[i,12])			// Data de Vencimento Real
	nValor 	    := Val(StrTran(StrTran(adados[i,13],".",""),",","."))	// Valor
	cHist 		:= AllTrim(aDados[i,14])		// Hist�rico

    aVetSE1 := {}
    
	aAdd(aVetSE1, {"E1_FILIAL"  , cFila     , Nil})
	aAdd(aVetSE1, {"E1_PREFIXO" , cPrefixo  , Nil})
	aAdd(aVetSE1, {"E1_NUM"     , cNumero	, Nil})
	aAdd(aVetSE1, {"E1_PARCELA" , cParcela	, Nil})
	aAdd(aVetSE1, {"E1_TIPO"    , cTipo		, Nil})
    aAdd(aVetSE1, {"E1_PORTADO" , cBanco	, Nil})
	aAdd(aVetSE1, {"E1_AGEDEP"  , cAgencia	, Nil})
	aAdd(aVetSE1, {"E1_CONTA"   , cConta	, Nil})
	aAdd(aVetSE1, {"E1_NATUREZ" , cNatureza	, Nil})
	aAdd(aVetSE1, {"E1_CLIENTE" , cCliente	, Nil})
	aAdd(aVetSE1, {"E1_LOJA"    , cLoja		, Nil})
	aAdd(aVetSE1, {"E1_NOMCLI"  , cNomCli	, Nil})
	aAdd(aVetSE1, {"E1_EMISSAO" , dEmissao	, Nil})
	aAdd(aVetSE1, {"E1_VENCTO"  , dVencto	, Nil})
	aAdd(aVetSE1, {"E1_VENCREA" , dVencReal	, Nil})
	aAdd(aVetSE1, {"E1_VALOR"   , nValor	, Nil})
	aAdd(aVetSE1, {"E1_HIST"    , cHist		, Nil})

	Begin Transaction		
	    
		//Chama a rotina autom�tica
		lMsErroAuto := .F.
		MSExecAuto({|x,y| FINA040(x,y)}, aVetSE1, 3)

		//Se houve erro, mostra o erro ao usu�rio e desarma a transa��o
		If lMsErroAuto
			DisarmTransaction()
			If (!IsBlind()) // COM INTERFACE GR�FICA
                aDados[i,15] := MostraErro("/dirdoc", "error.log") // "Erro na Gera��o do RA"
		    Else // EM ESTADO DE JOB
		        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
		        ConOut(PadC("Automatic routine ended with error", 80))
		        ConOut("Error: "+ cError)
		    EndIf
        Else

			SE1->(RecLock("SE1", .F. ))
			
			// Paulo Henrique - 28/11/2019 - For�o a grava��o da filial na SE1 e SE5

			SE1->E1_FILIAL  := If(SE1->E1_FILIAL!=cFila,cFila,SE1->E1_FILIAL) 
			SE1->E1_FILORIG := If(SE1->E1_FILORIG!=cFila,cFila,SE1->E1_FILORIG)
			SE1->E1_ZHASH   := cHash
			MsUnLock()

			SE5->(RecLock("SE5", .F. ))
			SE5->E5_FILIAL  := If(SE5->E5_FILIAL!=cFila,cFila,SE5->E5_FILIAL)
			SE5->E5_FILORIG := If(SE5->E5_FILORIG!=cFila,cFila,SE5->E5_FILORIG)

            aDados[i,15] := "RA Gerado com Sucesso"
			lOk := .T.

		EndIF

	End Transaction
	
Next i

U_MGListBox( "Log de Processamento - Importa��o RA" , aCampos , aDados , .T. , 1 )

If lOk
   ApMsgInfo(OemToAnsi("Gera��o dos Recebimentos Antecipados Conclu�da com Sucesso!"),OemToAnsi("SUCESSO"))
EndIf   
 
Return