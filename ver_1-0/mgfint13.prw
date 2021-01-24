#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'

/*
=====================================================================================
Programa.:              MGFINT13
Autor....:              Luis Artuso
Data.....:              06/09/2016
Descricao / Objetivo:   Efetua a operacao do P.E. FA420NAR
Doc. Origem:            Contrato - GAP MGFINT03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
User Function MGFINT13()

	Local lContinua	 := .F.
	Local cMvPar01	 := AllTrim(SuperGetMv('MGF_DIRGER',NIL,"")) // Pasta onde será salvo o arquivo de remessa
	Local cMvPar02	 := AllTrim(SuperGetMv('MGF_DIRENV',NIL,"")) // Pasta dos arquivos a serem enviados

	Local cRet		 := ""
	Local cNomePar01 := 'MGF_DIRGER'
	Local cNomePar02 := 'MGF_DIRENV'

	lContinua := U_fVldMvPar(cMvPar01 , cMvPar02 ,  ,  , .F. , cNomePar01 , cNomePar02) // Oriundo do fonte MGFINT18

	If ( lContinua )
		cRet := fNomeArq()
	EndIf

Return cRet

/*
=====================================================================================
Programa.:              fNomeArq
Autor....:              Luis Artuso
Data.....:              05/09/2016
Descricao / Objetivo:   Retorna o nome para geracao do arquivo CNAB
Doc. Origem:            Contrato - GAP MGFINT03
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:
=====================================================================================
*/
Static Function fNomeArq()

	Local cNumBord	:= Alltrim(Mv_Par02)  // Retorna o numero do bordero
	Local cNomeArq	:= &(AllTrim(SuperGetMv('MGF_NMECNB'))) // Retorna o nome do arquivo destino
	Local cDirDest	:= AllTrim(SuperGetMv('MGF_DIRGER',NIL,""))
	Local cCntDbSA  := AllTrim(SuperGetMv('MGF_CNTDBSA',,"237/2372/18787"))
	Local cCntDbAt  := AllTrim(Mv_Par05)+"/"+AllTrim(Mv_Par06)+"/"+AllTrim(Mv_Par07)
	Local cRet		:= ""
	
	// Condição exclusiva para geração do arquivo do CNAB - Filial 010007 - Santo André
	If cCntDbAt == cCntDbSa
	   cNomeArq := AllTrim("07PG"+SUBSTR(ALLTRIM(SA6->A6_NREDUZ),1,4))
	EndIf   

	If ( !Empty(cNumBord) .AND. !(Empty(cNomeArq)) )
	
		If !(Right(cDirDest , 1) == "\")
			cDirDest += "\"
		EndIf

		cRet := cDirDest + cNomeArq + cNumBord + "." + TRIM(SEE->EE_EXTEN)
	
	EndIf

Return cRet
