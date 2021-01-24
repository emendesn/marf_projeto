#Include 'Protheus.ch'
#INCLUDE "TOPCONN.CH"

#Define CRLF chr(13)+chr(10)
/*
=====================================================================================
Programa.:              MGFFINBA
Autor....:              Natanael Filho
Data.....:              09/04/2019
Descricao / Objetivo:   Geração dos arquivos XML das NF-e relacinadas aos títulos do FIDC
Doc. Origem:
Solicitante:            Cliente: Eder Dias - Contas a Pagar
Uso......:              Marfrig
Obs......:              Chamado através do Menudef do MGFFIN43
=====================================================================================
*/
User Function MGFFINBA()

	Processa({|| MGFFINBA01() },"Aguarde - Gerando Arquivos...")

Return

Static Function MGFFINBA01()

	Local cStatPerm	:= Alltrim(SuperGetMV("MGF_FINBAA",.T.,"1/2")) // 1=Envio Pendente;2=Enviado;3=Reenvio Pendente;4=Reenviado;5=Cancelado
	Local cLocal  := GetMv("MGF_FIN90A",,"X:\CNABCOB\") // Local para geração dos arquivos
	Local cAlias
	Local nQtdRec // Quantidade de Registros resultante da Query
	Local nLinAtu := 0 //Linha Da Query
	Local cCodBco := ""

	// Verifica o estado do borderô/Remessa que permitirá a impressão do XML
	If !(ZA7->ZA7_STATUS $ cStatPerm) //1=Envio Pendente;2=Enviado;3=Reenvio Pendente;4=Reenviado;5=Cancelado
		Help( ,, ProcName() + ' - ' + Str(ProcLine()),, 'Os arquivos *.xml só podem ser gerados para os status ' + cStatPerm + ".", 1, 0)
		Return
	ElseIf 1 != Aviso("FIDC - Geração de Arquivo","Deseja gerar os arquivos *.XMLs de NF-e?"+CRLF+;
					  "Esse processo pode levar muito tempo para ser concluído.",{"Sim","Não"})
		Return
	EndIf
	
	// Verifica se o diretório MGF_FIN90A está pode ser criado ou já existe.
	If !U_zMakeDir(Alltrim(cLocal) + "\","XMLs - Local em MGF_FIN90A")
		Return
	EndIf

	// Query para relacionar com a tabela SE1 e retornar as informações das Notas Fiscais
	cAlias	:= GetNextAlias()
	BeginSQL Alias cAlias

		SELECT SE1.R_E_C_N_O_ E1_RECNO, ZA8.R_E_C_N_O_ ZA8_RECNO, SE1.*, ZA8.*
		FROM %table:SE1% SE1
		INNER JOIN %table:ZA8% ZA8 ON ZA8.D_E_L_E_T_ = ''
			AND ZA8_FILORI = E1_FILIAL
			AND ZA8_PREFIX = E1_PREFIXO
			AND ZA8_NUM = E1_NUM
			AND ZA8_PARCEL = E1_PARCELA
			AND ZA8_TIPO = E1_TIPO
			AND ZA8_CODREM = %Exp:ZA7->ZA7_CODREM%
			AND ZA8_FILIAL = %Exp:ZA7->ZA7_FILIAL%
			AND ZA8_STATUS IN ('1','2')
		WHERE SE1.D_E_L_E_T_ = ' '
			AND E1_SITUACA = '1'
		ORDER BY E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO

	EndSQL

	// Processa resultado da query
	Count to nQtdRec
	ProcRegua(nQtdRec)
	(cAlias)->(dbGoTop())

	While (cAlias)->(!Eof())

		nLinAtu++
		IncProc()
		
		cCodBco := (cAlias)->ZA8_BANCO

		// Criação dos XMLs
		U_xMFT90Gr((cAlias)->E1_RECNO, AllTrim(ZA7->ZA7_FILIAL) + ZA7->ZA7_CODREM,cLocal,cCodBco)

		(cAlias)->(dbSkip())

	EndDo

	dbSelectArea(cAlias)
	dbCloseArea()

Return