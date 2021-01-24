#include 'protheus.ch'
#include 'parmtype.ch'
#include 'Totvs.ch'

/*/{Protheus.doc} MGFFINBD
Automação do processo de inclusão de RA

@author Paulo da Mata
@since 18/11/2019
@version P12.1.17
@return Nil
/*/

User Function MGFFINBD()

    Local aArea   := GetArea()
	Local cFile   := ""
    Local cFilAtu := ""
    Local cPerg	  := "FFINBD"
    
    IF Pergunte(cPerg,.T.)
       
       cFilAtu := MV_PAR01
       cFile   := MV_PAR02
	
	    If !Empty(cFile)
		    fGerSe1(cFIlAtu,cFile)
	    EndIf

    EndIf

RestArea(aArea)	
Return

/*/{Protheus.doc} FLERARQ
Monta a tela para escolha dos Arquivos

@author Paulo da Mata
@since 18/11/2019
@version P12.1.17
@return Nil
/*/

User Function fLerArq()

	Local cMascara 	:= "Todos os Arquivos|*.csv"
	Local cTitulo	:= OemToAnsi("Informe o diretório onde se encontra o arquivo.")
	Local cFile		:= " "

//	cFile := cGetFile(cMascara, cTitulo, 0, "\", .F., GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)
    cFile := cGetFile(cMascara, cTitulo, 0, "\", .F., GETF_LOCALHARD ,.T.)
Return cFile


/*/{Protheus.doc} FGERSE1
Lê o .CSV e efetua a geração dos RA's no SE1 (Contas a Receber)

@author Paulo da Mata
@since 18/11/2019
@version P12.1.17
@return Nil
/*/

Static Function fGerSe1(cFIlAtu,cFile)
 
Local cLinha    := ""

Local cPrefixo 	:= ""
Local cNumero 	:= ""
Local cParcela 	:= ""
Local cTipo 	:= ""
Local cBanco 	:= ""
Local cAgencia 	:= ""
Local cConta 	:= ""
Local cNatureza := ""
Local cCliente 	:= ""
Local cLoja 	:= ""
Local cNomCli 	:= ""
Local dEmissao 	:= ""
Local dVencto 	:= ""
Local dVencReal := ""
Local nValor 	:= ""
Local cHist 	:= ""

Local lPrim     := .T.
Local aDados    := {}
Local aCampos   := {}
Local aVetSE1   := {}

Local aFail     := {}

Local i
 
If FT_FUse(cFile) > 0
   
   ProcRegua(FT_FLASTREC())
   FT_FGOTOP()
   
   While !FT_FEOF()
      
	  IncProc(OemToAnsi("Efetuando Leitura do Arquivo"))
	  
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
	     AADD(aDados,StrTokArr2(cLinha,";",.T.))
	  EndIf

      FT_FSkip()

	EndDo  

Else

	ApMsgAlert(OemToAnsi("Não foi possível ler o arquivo: " + cFile),OemToAnsi("ATENÇÃO"))
	ApMsgInfo(OemToAnsi("Processo Interrompido"),OemToAnsi("ATENÇÂO"))

	Return

EndIf

// Verifica se existe campos em branco no CSV
ProcRegua(Len(aDados))

For i := 1 to Len(aDados)

	IncProc("Verificando Inconsistências...")

	If Empty(aDados[i,1]) .Or. Empty(aDados[i,3]) .Or. Empty(aDados[i,4]) .Or. ;
	   Empty(aDados[i,5]) .Or. Empty(aDados[i,6]) .Or. Empty(aDados[i,7]) .Or. ;
	   Empty(aDados[i,8]) .Or. Empty(aDados[i,9]) .Or. Empty(aDados[i,10]) .Or. ; 
	   Empty(aDados[i,11]) .Or. Empty(aDados[i,12]) .Or. Empty(aDados[i,13])

	   AADD(aFail,{aDados[i,1],;
	               aDados[i,2],;
				   aDados[i,3],;
				   aDados[i,4],;
				   aDados[i,5],;
	               aDados[i,6],;
				   aDados[i,7],;
				   aDados[i,8],;
				   aDados[i,9],;
				   aDados[i,10],;
				   aDados[i,11],;
				   aDados[i,12],;
				   aDados[i,13],;
				   aDados[i,14],;
				   "Verifique campos não preenchidos"}) 
	Endif   

Next

If !Empty(aFail)
   U_MGListBox( "Log de Processamento - Importação RA" , aCampos , aFail , .T. , 1 )
   ApMsgInfo(OemToAnsi("Geração dos RA's não efetuado"),OemToAnsi("FALHA"))
   Return
Else
   If !U_MGListBox( "Titulos a Processar - Deseja Continuar ?" , aCampos , aDados , .T. , 1 )   
      ApMsgInfo(OemToAnsi("Geração dos RA's não efetuado"),OemToAnsi("FALHA"))
      Return
   EndIf
EndIf

ProcRegua(Len(aDados))

For i := 1 to Len(aDados)
 
	IncProc("Gerando RA's...")

	// Carrega as variáveis para as críticas
	cPrefixo 	:= aDados[i,1] 					// Prefixo
    cNumero 	:= GETSX8NUM("SE1","E1_NUM")	// Titulo
	cParcela 	:= aDados[i,3]					// Parcela
	cTipo 		:= aDados[i,4]					// Tipo
	cBanco 		:= aDados[i,5]					// Banco 
	cAgencia 	:= aDados[i,6]					// Agência
	cConta 		:= aDados[i,7]					// COnta
	cNatureza 	:= aDados[i,8]					// Natureza
	cCliente 	:= aDados[i,9]					// Cliente
	cLoja 		:= aDados[i,10]					// Loja
	cNomCli 	:= AllTrim(Posicione("SA1",1,xFilial("SA1")+aDados[i,9]+aDados[i,10],"A1_NOME")) // Nome
	dEmissao 	:= CtoD(aDados[i,11])			// Data de Emissão
	dVencto 	:= CtoD(aDados[i,12])			// Data de Vencimento
	dVencReal 	:= CtoD(aDados[i,12])			// Data de Vencimento Real
	nValor 		:= VAL(aDados[i,13])			// Valor
	cHist 		:= AllTrim(aDados[i,14])		// Histórico

	aVetSE1 := {}

	aAdd(aVetSE1, {"E1_FILIAL"  , cFilAtu	, Nil})
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
	    
		//Chama a rotina automática
		lMsErroAuto := .F.
		MSExecAuto({|x,y| FINA040(x,y)}, aVetSE1, 3)

		//Se houve erro, mostra o erro ao usuário e desarma a transação
		If lMsErroAuto
		    aDados[i,15] := "Erro na Geração do RA"
		Else
		    aDados[i,15] := "RA Gerado com Sucesso"	
		EndIf

	End Transaction
	
Next i

U_MGListBox( "Log de Processamento - Importação RA" , aCampos , aDados , .T. , 1 )   

ApMsgInfo(OemToAnsi("Geração dos Recebimentos Antecipados Concluída com Sucesso!"),OemToAnsi("SUCESSO"))
 
Return