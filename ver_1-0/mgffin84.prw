#include "protheus.ch"

/*
=====================================================================================
Programa.:              MGFFIN84
Autor....:              Totvs
Data.....:              Marco/2018
Descricao / Objetivo:   Funcao chamada pelo ponto de entrada F330SE5
Doc. Origem:
Solicitante:            Cliente
Uso......:              
Obs......:
=====================================================================================
*/
User Function MGFFIN84()
Local aArea			:= {SE5->(GetArea()),GetArea()}
Local cTitulo 		:= SE5->E5_TIPO+"/"+SE5->E5_TIPODOC+"/"+SE5->E5_PREFIXO+"/"+SE5->E5_NUMERO+"/"+SE5->E5_PARCELA+"/"+SE5->E5_SEQ+" - "+SE5->E5_CLIFOR+"/"+SE5->E5_LOJA
Local cComplHist	:= ""
// salva recno do SE5 para reposicionamento no final da rotina
Local nSveRecno 	:= SE5->(Recno())
// Titulo NF COMPENSADO
Local cNFFilial		:= SE5->E5_FILIAL
Local cNFPrefixo	:= SE5->E5_PREFIXO
Local cNFTitulo		:= SE5->E5_NUMERO
Local cNFParcela	:= SE5->E5_PARCELA
Local cNFSequen		:= SE5->E5_SEQ
Local cNFCliente	:= SE5->E5_CLIFOR
Local cNFLoja		:= SE5->E5_LOJA
Local cNFTipo		:= SE5->E5_TIPO
Local cNFDocumen	:= SE5->E5_DOCUMEN
// Titulo RA/NCC COMPENSADO
Local cCRPrefixo	:= SubStr(cNFDocumen,1,3)
Local cCRTitulo		:= SubStr(cNFDocumen,4,9)
Local cCRParcela	:= SubStr(cNFDocumen,13,2)
Local cCRSequen		:= SE5->E5_SEQ
Local cCRTipo		:= SubStr(cNFDocumen,15,3)
Local cCRTipoDoc	:= "BA"
Local cCRCliente	:= SE5->E5_CLIFOR
Local cCRLoja		:= SubStr(cNFDocumen,18,2)
Local dCRData		:= SE5->E5_DATA
Local cHistorico	:= ""
/*
Aviso("Dados Compensacao","Tipo/TipoDoc/Pref/Titulo/Parc/Seq/Cliente :" + cTitulo + CHR(10)+CHR(13) +;
 	  "Valor : "+Transform(SE5->E5_VALOR,"@E 999,999,999.99") + CHR(10)+CHR(13) +;
 	  "Historico : " + SE5->E5_HISTOR + CHR(10)+CHR(13) +;
 	  "Documento : " + SE5->E5_DOCUMEN + CHR(10)+CHR(13) +;
 	  "FUNNAME() : " + FUNNAME(),{"Ok"})
*/
If "RA" $ cNFDocumen
	cComplHist := AllTrim(SuperGetMv("MGF_TXTADT",,"ADTO - "))
	cHistorico	:= "Baixa por Compensacao"
ElseIf "NCC" $ cNFDocumen .Or. SE5->E5_TIPO == "NCC"
	If !("MAN"$cNFDocumen) .AND. SE5->E5_PREFIXO != "MAN" //Removido o cComplHist das NCC incluidas manualmente, conforme GAP 566 
		cComplHist := AllTrim(SuperGetMv("MGF_TXTDEV",,"DEVOL - "))
	EndIf
	cHistorico := "Comp. p/Prestacao de Contas"
Endif

// atualiza historico do titulo posicionado
If !(cComplHist $ SE5->E5_HISTOR)
	dbSelectArea("SE5")
	RecLock("SE5",.F.)
	SE5->E5_HISTOR := cComplHist + Iif(!Empty(SE5->E5_HISTOR),SE5->E5_HISTOR,cHistorico)
	SE5->(MsUnLock())
Endif
If FUNNAME() $ "FINA330|FINA740|"
	// atualiza historico titulo RA / NCC
	dbSetOrder(2)		//FILIAL+TIPODOC+PREFIXO+NUMERO+PARCELA+TIPO+DATA+CLIENTE+LOJA+SEQ
	If SE5->(dbSeek(cNFFilial+cCRTipoDoc+cCRPrefixo+cCRTitulo+cCRParcela+cCRTipo+Dtos(dCRData)+cCRCliente+cCRLoja+cCRSequen))
		If !(cComplHist $ SE5->E5_HISTOR)
			RecLock("SE5",.F.)
			SE5->E5_HISTOR := cComplHist + Iif(!Empty(SE5->E5_HISTOR),SE5->E5_HISTOR,cHistorico)
			SE5->(MsUnLock())
		Endif
	Endif
Endif

aEval(aArea,{|x| RestArea(x)})

// posiciona SE5
SE5->(dbGoTo(nSveRecno))

Return()

User Function FIN84BxNCC(cChave,cSeq,lPesq,lEstorno,cDoc)

Local cQ := ""
Local cAliasTrb := GetNextAlias()
Local aRet := {0,.F.}

cQ := "SELECT R_E_C_N_O_ SE5_RECNO,E5_TIPO "
cQ += "FROM "+RetSqlName("SE5")+" SE5 "
cQ += "WHERE SE5.D_E_L_E_T_ = ' ' "
cQ += "AND E5_FILIAL = '"+xFilial("SE5")+"' "
cQ += "AND E5_PREFIXO = '"+Subs(cChave,1,Len(SE5->E5_PREFIXO))+"' "
cQ += "AND E5_NUMERO = '"+Subs(cChave,Len(SE5->E5_PREFIXO)+1,Len(SE5->E5_NUMERO))+"' "
cQ += "AND E5_PARCELA = '"+Subs(cChave,Len(SE5->E5_PREFIXO)+Len(SE5->E5_NUMERO)+1,Len(SE5->E5_PARCELA))+"' "
cQ += "AND E5_TIPO = '"+Subs(cChave,Len(SE5->E5_PREFIXO)+Len(SE5->E5_NUMERO)+Len(SE5->E5_PARCELA)+1,Len(SE5->E5_TIPO))+"' "
cQ += "AND E5_LOJA = '"+Subs(cChave,Len(SE5->E5_PREFIXO)+Len(SE5->E5_NUMERO)+Len(SE5->E5_PARCELA)+Len(SE5->E5_TIPO)+1,Len(SE5->E5_LOJA))+"' "
cQ += "AND E5_SEQ = '"+cSeq+"' "
cQ += "AND E5_MOTBX = 'CMP' "
//cQ += "AND E5_RECPAG = 'R' " // nao habilitar esta linha, pois alguns registros do estorno da SE5 estao ficando com o tipo P
cQ += "AND E5_SITUACA <> 'C' "
cQ += "AND E5_DOCUMEN = '"+cDoc+"' "
If !lEstorno
	cQ += "AND E5_TIPODOC = 'CP' "
Else
	cQ += "AND E5_TIPODOC = 'ES' "
Endif
If lPesq
	cQ += "AND E5_TIPO IN ('"+MV_CRNEG+"','"+MVRECANT+"') "
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

If (cAliasTrb)->(!Eof())
	aRet[1] := (cAliasTrb)->SE5_RECNO
	aRet[2] := IIf(Alltrim((cAliasTrb)->E5_TIPO)==Alltrim(MV_CRNEG),.T.,.F.)
Endif

(cAliasTrb)->(dbCloseArea())

Return(aRet)

User Function FIN84TitOri(cPref,cNum,cParc,cTipo,cCli,cLoja)

Local cQ := ""
Local cAliasTrb := GetNextAlias()
Local lRet := .F.

cQ := "SELECT 1 "
cQ += "FROM "+RetSqlName("SE1")+" SE1 "
cQ += "WHERE SE1.D_E_L_E_T_ = ' ' "
cQ += "AND E1_FILIAL = '"+xFilial("SE1")+"' "
cQ += "AND E1_PREFIXO = '"+cPref+"' "
cQ += "AND E1_NUM = '"+cNum+"' "
cQ += "AND E1_PARCELA = '"+cParc+"' "
cQ += "AND E1_TIPO = '"+cTipo+"' "
cQ += "AND E1_CLIENTE = '"+cCli+"' "
cQ += "AND E1_LOJA = '"+cLoja+"' "
cQ += "AND E1_ORIGEM = 'MATA100' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

If (cAliasTrb)->(!Eof())
	lRet := .T.
Endif

(cAliasTrb)->(dbCloseArea())

Return(lRet)