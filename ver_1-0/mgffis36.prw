#include "protheus.ch"
#define CRLF chr(13) + chr(10)

/*
=====================================================================================
Programa............: MGFFIS36
Autor...............: Natanael Filho
Data................: 15/JUNHO/2018 
Descricao / Objetivo: Fiscal
Doc. Origem.........: Marfrig
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: GAP 358 / Devolução de Venda com ICMS-ST UF: RS
=====================================================================================
*/
User Function MGFFIS36(nOpc)

Local lRet := .T.
Local aArea := Getarea()
Local cUFFil	:= SM0->M0_ESTENT
Local cCFDev := SuperGetMV('MGF_FIS36C',.T.,'1603/2603')
Local cCFAtu
Local cTpDOC
Local lExcl := .F.
Local nCFAtu := 0

If Inclui .and. !IsInCallStack('U_A100DEL')
	nCFAtu := aScan(aHeader,{|x| Alltrim(x[2])=="D1_CF"})
	If nCFAtu > 0 //Valida se foi encontrado a coluna D1_CF a fim de evidar o erro "array out of bounds".
		cCFAtu := Alltrim(aCols[n,nCFAtu])
	EndIf
	cTpDOC := C103TP
ElseIf nOpc = 3 //O Documento está sendo excluído.
	cTpDOC := SF1->F1_TIPO
	lExcl := .T.
EndIf

//GAP apenas para o Rio Grande do Sul, Notas de complemento de ICMS (I) e CFOPs específicos
If cUFFil == 'RS';
 .AND. cTpDOC == 'I' ;
 .AND. (IIF(Empty(cCFAtu),.F.,cCFAtu $ cCFDev) .OR. lExcl) //Se for exclusão não precisa validar o CFOP.

	//nOpc
	//1 - Verificar se existe um cliente (SA1) cadastrado com o mesmo CNPJ do fornecedor informado no Documento de Entrada;
	//2 - Gera a NCC para o cliente no valor do Documento de Entrada. 
	//3 - Valida na exclusão se o NCC já sofreu baixa.
	If nOpc = 1
		lRet := FIS36VCli()
	ElseIf nOpc = 2
		lRet := FIS36NCC()
	ElseIf nOpc = 3
		lRet := FIS36Exc()
	EndIf
EndIf

RestArea(aArea)

Return lRet


//===========================================================
//Programa............: FIS36VCli
//Autor...............: Natanael Filho
//Data................: 15/JUNHO/2018 
//Desc:...............: Verifica se existe um cliente (SA1) cadastrado com o mesmo
//......................CNPJ do fornecedor informado no Documento de Entrada
//===========================================================
Static Function FIS36VCli()
Local lRet := .F.

SA1->(DBSETORDER(3)) //A1_FILIAL+A1_CGC
If SA1->(DBSEEK(xFilial('SA2') + SA2->A2_CGC))
	lRet := .T.
Else
	Help( ,, 'MGFFIS36.FIS36VCli - GAP358',, 'Não foi encontrado o cliente com o CNPJ ' + ;
		Transform(Alltrim(SA2->A2_CGC),"@R 99.999.999/9999-99") + ' para inclusão da NCC.', 1, 0)
EndIf

Return lRet


//===========================================================
//Programa............: FIS36NCC
//Autor...............: Natanael Filho
//Data................: 15/JUNHO/2018 
//Desc:...............: Gera a NCC para o cliente no valor do Documento de Entrada.
//===========================================================
Static Function FIS36NCC()
Local cError     := ''
Local cNatuFin := Alltrim(SuperGetMV('MGF_FIS36N',.T.,'10101')) //Natureza Financeira utilizada no NCC
Local aTitulo
Local cTamParc := Space(TAMSX3("E1_PARCELA")[1]) //Tamanho do campo
Local cHistor := "DEVOLUCAO DE VENDA COM ICMS-ST. DECRETO N 37.699, DE 26 DE AGOSTO DE 1997. UF: RS."

SA1->(DBSETORDER(3)) //A1_FILIAL+A1_CGC
If SA1->(DBSEEK(xFilial('SA2') + SA2->A2_CGC))
	
	Begin Transaction
		aTitulo := {{ "E1_PREFIXO", SF1->F1_SERIE, NIL },;
		{ "E1_NUM"      , SF1->F1_DOC    , NIL },;
		{ "E1_PARCELA"  , cTamParc       , NIL },;
		{ "E1_TIPO"     , "NCC"          , NIL },;
		{ "E1_NATUREZ"  , cNatuFin       , NIL },;
		{ "E1_CLIENTE"  , SA1->A1_COD    , NIL },;
		{ "E1_LOJA"     , SA1->A1_LOJA   , NIL },;
		{ "E1_EMISSAO"  , dDataBase      , NIL },;
		{ "E1_VENCTO"   , dDataBase      , NIL },;
		{ "E1_HIST"    , cHistor         , NIL },;
		{ "E1_SITUACA" , '0'             , NIL },; 
		{ "E1_ORIGEM"  , 'MGFFIS36'      , NIL },;
		{ "E1_VALOR"    , SF1->F1_VALBRUT	, NIL }}
		
		lMsErroAuto := .F.
		MsExecAuto( { |x,y| FINA040(x,y)} , aTitulo, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
		If lMsErroAuto // SE ENCONTROU ALGUM ERRO
			msgAlert('MGFFIS36.FIS36NCC - GAP358','Erro na geração do titulo (NCC).')
			If (!IsBlind()) // COM INTERFACE GRÁFICA
		         MostraErro()
		    Else // EM ESTADO DE JOB
		        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
		
		        ConOut(PadC("Automatic routine ended with error", 80))
		        ConOut("Error: "+ cError)
		    EndIf
			DisarmTransaction()
			Break
		Else
			MsgInfo('MGFFIS36.FIS36NCC - GAP358','NCC gerada com sucesso.')
		EndIf
	
	End Transaction
	
EndIf

Return Nil


//===========================================================
//Programa............: FIS36Exc
//Autor...............: Natanael Filho
//Data................: 15/JUNHO/2018 
//Desc:...............: Valida na exclusão se o NCC já sofreu baixa.
//===========================================================
Static Function FIS36Exc()
Local lRet := .F.
Local cTamParc := Space(TAMSX3("E1_PARCELA")[1]) //Tamanho do campo
Local cError     := ''
SA1->(DBSetOrder(3)) //A1_FILIAL+A1_CGC
If SA1->(DBSeek(xFilial('SA2') + SA2->A2_CGC))
	SE1->(DBSetOrder(2)) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	IF SE1->(DBSeek(xFilial('SF1') + SA1->(A1_COD + A1_LOJA) + SF1->(F1_SERIE + F1_DOC) + cTamParc + "NCC" ) )
	
		Begin Transaction
			aTitulo := {{ "E1_PREFIXO"		, SF1->F1_SERIE, NIL },;
				{ "E1_NUM"      , SF1->F1_DOC    , NIL },;
				{ "E1_PARCELA"  , cTamParc       , NIL },;
				{ "E1_TIPO"     , "NCC"          , NIL },;
				{ "E1_CLIENTE"  , SA1->A1_COD    , NIL },;
				{ "E1_LOJA"     , SA1->A1_LOJA   , NIL }}
			
			lMsErroAuto := .F.
			MsExecAuto( { |x,y| FINA040(x,y)} , aTitulo, 5)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
			If lMsErroAuto // SE ENCONTROU ALGUM ERRO
				msgAlert("Não foi possível excluir a NCC")
				If (!IsBlind()) // COM INTERFACE GRÁFICA
			         MostraErro()
			    Else // EM ESTADO DE JOB
			        cError := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
			
			        ConOut(PadC("Automatic routine ended with error", 80))
			        ConOut("Error: "+ cError)
			    EndIf
				DisarmTransaction()
				Break
			Else
				MsgInfo('MGFFIS36.FIS36NCC - GAP358','NCC excluída com sucesso.')
				lRet := .T.
			EndIf
		
		End Transaction
	Else
		lRet := .T.	
	EndIf
Else
	lRet := .T.
EndIf

Return lRet