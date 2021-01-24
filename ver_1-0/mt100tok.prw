#include "protheus.ch"
/*
=====================================================================================
Programa............: MT100TOK
Autor...............: Mauricio Gresele
Data................: 20/10/2016 
Descricao / Objetivo: Ponto de entrada para validar a inclusao da nota de entrada
Doc. Origem.........: Fiscal-FIS13
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: 
=====================================================================================
*/
User Function MT100TOK()

Local lRet := ParamIxb[1]

/*------------------------------------------------------------------------------------+
| Trecho que realiza a checagem de existencia de NFE Devolucao. Esta checagem se faz  |
| necessaria para nao inserir NFE Devolucao de maneira duplicada.                     |
| Trecho incluido por: johnny.osugi@totvspartners.com.br                              |
+------------------------------------------------------------------------------------*/
If ( FunName() == "MATA103" .and. .not. l103Class )  // variavel padrao private l103Class que indica se o procedimento e' de Classificacao da nota. cFormul
   If cFormul == "N" // Passara' pela validacao da gap 609 quando for formulario proprio como "N" (Nao).
      If FindFunction( "U_MGFCHKDUP" )
         If u_MGFChkDup() // Funcao que checa se ha' duplicidade de NFE Devolucao. Funcao localizada no programa-fonte MGFCRM52.prw
            Return( .F. )
         EndIf
      EndIf
   EndIf
EndIf

// Obs: paleativo, pois a rotina padrao MATA920 ( documento de saida manual ) do modulo Livros Fiscal, estava chamando este ponto de entrada
// provavelmente estah errado no fonte padrao.
If !IsInCallStack("MATA920")
	// reposicionamento da tabela sf1, pois a sf1 estah chegando desposicionada, em final de arquivo, neste ponto de entrada
	If SF1->(Eof()) .or. SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA != xFilial("SF1")+cNFiscal+cSerie+cA100For+cLoja
		SF1->(dbSetOrder(1))
		SF1->(dbSeek(xFilial("SF1")+cNFiscal+cSerie+cA100For+cLoja))
	Endif	
Endif	
	
//GAP358, Natanael: Verifica se existe um cliente (SA1) cadastrado com o mesmo CNPJ do fornecedor informado no Documento de Entrada
If findfunction("U_MGFFIS36") .AND. lRet .AND. IsInCallStack("MATA103")
	lRet := U_MGFFIS36(1)
EndIf

If lRet	
	If lRet
		// Obs: paleativo, pois a rotina padrao MATA920 ( documento de saida manual ) do modulo Livros Fiscal, estava chamando este ponto de entrada
		// provavelmente estah errado no fonte padrao.
		If IsInCallStack("MATA920")
			Return(lRet)
		Endif
	Endif	
	
	If lRet
		// validar a inclusao de documentos tipo Normal
		If FindFunction("U_MGFCOM80")
			lRet := U_MGFCOM80()    
		Endif	
	Endif
	
	// Critica dos Campos UF e Municipio Origem e Destino do Transporte
	If lRet .AND. Alltrim(cEspecie) == 'CTE'
		If FindFunction("U_MGFCOMB2")
			lRet := U_MGFCOMB2()
		Endif
	Endif	
	
	// GAP FIS03
	If lRet
		If FindFunction("U_Fis03VldNfe")
			lRet := U_Fis03VldNfe(ParamIxb,cA100For,cLoja,cTipo,cEspecie,cSerie)
		Endif
	Endif	
	
	If lRet
		// GAP Taura Entradas
		If FindFunction("U_MGFTAE08")
			lRet := U_MGFTAE08(3)    
		Endif	
	Endif
	
	If lRet
		If FindFunction("U_Fis18NFE")
			lRet := U_Fis18NFE()
		Endif
	Endif		
	
	// valida inclusao de documento de transporte por modulo diferente do GFE
	If lRet
		If FindFunction("U_MGFEST35")
			lRet := U_MGFEST35()    
		Endif	
	Endif	

	// valida valor total da nota, calculado x digitado
	If lRet
		If FindFunction("U_MGFCOM66")
			lRet := U_MGFCOM66()
		Endif	
	Endif	

	If lRet
		// Valida inclusão de RAMI
		If FindFunction("U_MGFCRM48")
			lRet := U_MGFCRM48()    
		Endif	
	Endif	

	If lRet
		If FindFunction("U_MGFCOM87")
			lRet := U_MGFCOM87(cUfOrig, cTipo, aCols, aHeader)    
		Endif	
	Endif
    
	// gravacao de campos da aba dados adicionais-GFE
	If lRet
		If FindFunction("U_MGFCOM94")
			//lRet := U_MGFCOM94()
		Endif
	Endif

	If lRet
		// Função para validar Manifesto
		If FindFunction("U_MGFFIS50")
			//--------------| Verifica existência de parâmetros e caso não exista cria. |-------------------------
			If !ExisteSx6("MGF_ESPVLD")
				CriarSX6("MGF_ESPVLD", "C", "Especies DE NF que passarão por validação.", "SPED" )	
			EndIf

			If !ExisteSx6("MGF_VLDTIP")
				CriarSX6("MGF_VLDTIP", "C", "Tipo de NF que passarão por validação."	, "N|D" )	
			EndIf

			If cTipo $ ALLTRIM( SuperGetMV("MGF_VLDTIP",.F.,"N|D") ) .AND. ALLTRIM(cEspecie) $ ALLTRIM(SuperGetMV("MGF_ESPVLD",.F.,"SPED"))
				lRet := U_MGFFIS50()
			Endif
		Endif
	Endif

	//Valida código de retenção no array de impostos
	If lRet
		If FindFunction("U_MGFCOMBF")
			lRet := U_MGFCOMBF()
		Endif
	EndIf 

	// Checks na chave da nota de entrada - CTE / SPED - WVN
	If lRet 
		If IsInCallStack("MATA103")
			If Alltrim(cEspecie) $ 'CTE/CTEOS/SPED' .And. cFormul=='N'
				If FindFunction("U_MGFCOMBG")
					lRet := U_MGFCOMBG()    
				Endif
			Endif
		EndIf
	EndIf
	
	//*** OBS: sempre deixar esta funcao por ultimo, pois ela nao estah validando e sim gravando os campos f1_dtdigit e d1_dtdigit
	If lRet
		// altera a data de digitacao da nfe para a database
		If FindFunction("U_MGFEST31")
			lRet := U_MGFEST31()    
		Endif	
	Endif

	// Tratamento de NFE do tipo NFS para que o código do Municipio seja igual ao Municipio da Filial Logado.
	If lRet .AND. Alltrim(cEspecie) == 'NFS'
		If FindFunction("U_MGFCOMB1")
			lRet := U_MGFCOMB1()    
		Endif	
	Endif
Endif

// Obs: paleativo, pois a rotina padrao MATA920 ( documento de saida manual ) do modulo Livros Fiscal, estava chamando este ponto de entrada
// provavelmente estah errado no fonte padrao.
If !IsInCallStack("MATA920")
	// reposicionamento da tabela sf1, pois a sf1 estah chegando desposicionada, em final de arquivo, neste ponto de entrada
	If SF1->(Eof()) .or. SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA != xFilial("SF1")+cNFiscal+cSerie+cA100For+cLoja
		SF1->(dbSetOrder(1))
		SF1->(dbSeek(xFilial("SF1")+cNFiscal+cSerie+cA100For+cLoja))
	Endif	
Endif	
		 
Return(lRet)