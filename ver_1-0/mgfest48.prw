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
Local _lEst76  := GetMv("MGF_EST76A")   // Ativa ou n�o execu��o da rotina
Local _lFilAut := GetMv("MGF_EST76F")  

If Altera                              
	cSolicit 	:= SUBSTR(UsrFullName(RETCODUSR()),1,25)
	if CSOLIC <>  cSolicit
		msgalert("N�o permitido Alterar S.As de outro Solicitante/Requisitante")
	    lRet := .F.
	endif
Endif

If _lEST76 .And. Altera

	// verifica��es quando o tipo do produto for EM-EMBALAGEM
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
			
				IF aCols[ni,36] = .F. .And. EMPTY(ACOLS[nI,nPosDtUtil]) // SA em aprova��o pelo gerente industrial
					MSGALERT("[MGFEST48] Favor preencher a data de utiliza��o do insumo!!!","Data Utiliza��o Vazia !!!")
					lRet := .F.
					Return lRet
				ENDIF
				IF aCols[ni,36] = .T. .And. aCols[ni,nPoszStatus]='07' // SA em aprova��o pelo gerente industrial
					Msgalert("[MGFEST48] N�o � poss�vel excluir requisi��es que estejam em processo de aprova��o ","Aprova��o Pendente-Embalagem")
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
							MsgAlert("[MGFEST48] N�o � poss�vel alterar produto ou quantidade, pois j� houve aprova��o da Ger�ncia Industrial.","Aprova��o-Embalagem")
						ElseIf _xTipo = '2'
							MsgAlert("[MGFEST48] N�o � poss�vel alterar produto ou quantidade, pois a requisi��o est� em aprova��o da Ger�ncia Industrial.","Bloqueado-SC em Aprova��o")
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

