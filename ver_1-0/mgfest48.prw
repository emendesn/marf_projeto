#include "totvs.ch"
#include "protheus.ch"

/*
==========================================================================================================
Programa.:              MT105GRV
Autor....:              Tarcisio Galeano         
Data.....:              11/2018 
Descricao / Objetivo:   Tratamento solicit. armazem                        
Doc. Origem:            
Solicitante:            Cliente
Uso......:              Marfrig
==========================================================================================================
*/
User Function MGFEST48()

Local lRet     := .T.
Local nOpcap   := PARAMIXB
Local nI   	   := 0
Local _lEst76  := .F.
Local _lFilaut := ''
Local _lEst76  := GetMv("MGF_EST76A")   // Ativa ou não execução da rotina
Local _lFilAut := GetMv("MGF_EST76F")  

If Altera                              
	cSolicit 	:= SUBSTR(UsrFullName(RETCODUSR()),1,25)
	if CSOLIC <>  cSolicit
		msgalert("Não permitido Alterar S.As de outro Solicitante/Requisitante")
	    lRet := .F.
	endif
Endif

If _lEST76 .And. Altera

	// verificações quando o tipo do produto for EM-EMBALAGEM
	Private nPoszStatus := aScan(aHeader,{|x| Alltrim(x[2])="CP_ZSTATUS"})
	Private nPosDtUtil  := aScan(aHeader,{|x| Alltrim(x[2])="CP_ZDTUTIL"})
	Private nPosprod    := aScan(aHeader,{|x| Alltrim(x[2])="CP_PRODUTO"})
	Private nPosQuant   := aScan(aHeader,{|x| Alltrim(x[2])="CP_QUANT"})
	Private nPosItem    := aScan(aHeader,{|x| Alltrim(x[2])="CP_ITEM"})
	Private nLinha		:= n
	Private _xTipo		:= ''
	FOR nI := 1 TO LEN(aCOLS)
		
		SB1->(DBSEEK(XFILIAL("SB1")+ACOLS[nI,nPosProd]))
		
		IF SB1->B1_TIPO='EM'
			
			IF cFilAnt $_lFilAut
			
				IF aCols[ni,36] = .F. .And. EMPTY(ACOLS[nI,nPosDtUtil]) // SA em aprovação pelo gerente industrial
					MSGALERT("[MGFEST48] Favor preencher a data de utilização do insumo!!!","Data Utilização Vazia !!!")
					lRet := .F.
					Return lRet
				ENDIF
				IF aCols[ni,36] = .T. .And. aCols[ni,nPoszStatus]='07' // SA em aprovação pelo gerente industrial
					Msgalert("[MGFEST48] Não é possível excluir requisições que estejam em processo de aprovação ","Aprovação Pendente-Embalagem")
					lRet := .F.
					Return lRet
				Endif
				IF aCols[ni,36] = .F. .And. aCols[ni,nPoszStatus] $ '08|07' // SA aprovada pelo gerente industrial
					If aCols[ni,nPoszStatus] $ '08'
						_xTipo = '1'
					ElseIf aCols[ni,nPoszStatus] $ '07'
						_xTipo = '2'
					EndIf
					SCP->(DbSeek(xfilial("SCP")+SCP->CP_NUM+ACOLS[NI,nPosItem]))
					IF SCP->CP_PRODUTO <> aCols[nI,nPosprod]
						lRet := .F.
					Endif
					IF SCP->CP_QUANT <> aCols[nI,nPosQuant] .Or. SCP->CP_QUANT == aCols[nI,nPosQuant]
						lRet := .F.
					Endif
					If ! lRet 
						If _xTipo = '1'
							MsgAlert("[MGFEST48] Não é possível alterar produto ou quantidade, pois já houve aprovação da Gerência Industrial.","Aprovação-Embalagem")
						ElseIf _xTipo = '2'
							MsgAlert("[MGFEST48] Não é possível alterar produto ou quantidade, pois a requisição está em aprovação da Gerência Industrial.","Bloqueado-SC em Aprovação")
						Endif
						Return lRet
					Endif
				EndIf
				IF aCols[ni,36] = .F. .And. aCols[ni,nPoszStatus]='09' // SA rejeitada pelo gerente industrial
					lRet := .F.
					SCP->(DbSeek(xfilial("SCP")+SCP->CP_NUM+ACOLS[NI,nPosItem]))
					IF SCP->CP_PRODUTO <> aCols[nI,nPosprod]
						lRet := .T.
					Endif
					IF SCP->CP_QUANT <> aCols[nI,nPosQuant]
						lRet := .T.
					Endif
					Return lRet
				Endif
			EndIf
		EndIf
	NEXT
	n := nLinha
ENDIF
Return lRet

