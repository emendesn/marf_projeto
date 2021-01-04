//#Include "rwmake.ch"

//
//
User Function SD1_SDA()

	local cCaminho  := cGetFile( "*.CSV" , "Textos (CSV)",,, .T. ,,,)
	private cDrive, cDir, cNome, cExt

	SplitPath( cCaminho, @cDrive, @cDir, @cNome, @cExt )

	If Upper(cExt) <> ".CSV"
		MsgStop("Informe arquivo com extensão CSV")
		return
	Endif

	Processa({|| AtuSDA(cCaminho) },"Processando...")

Return









Static Function AtuSDA(cCaminho)

	local nLinhas   := 0
	local nRegAtu   := 0
	local nRegLidos := 0
	local aItens   := {}
	Local cBuffer   := ""
	Local nHandle   := 0

	Local _cFilial  := ""
	Local _cDOC     := ""
	Local _cCOD     := ""
	Local _nQUANT   := 0
	Local _CHVNFE   := ""


	nHandle := FT_FUSE(cCaminho)

	IF nHandle == -1
		MsgStop("Não foi possível abrir o arquivo: "+cCaminho)
		Return
	ENDIF

	FT_FGOTOP()


	While !FT_FEOF()
		nLinhas++
		FT_FSKIP()
	EndDo

	FT_FGOTOP()

	procregua(nLinhas)

	While !FT_FEOF()

		IncProc()
		cBuffer    := FT_FREADLN()

		aItens     := Separa(AllTrim(cBuffer) ,";", .T. )

		_cFilial   := PadR(aItens[1],TAMSX3("D1_FILIAL")[1])

		_cCOD      := PadR(aItens[3],TAMSX3("D1_COD")[1])

		_CHVNFE    := PadR(aItens[5],TAMSX3("F1_CHVNFE")[1])


		SF1->(DbSetOrder(8))
		SF1->(DbSeek(_cFilial+_CHVNFE))
		if SF1->(Found())

			SD1->(DbSetOrder(1))
			SD1->(DbSeek(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+_cCOD))
			if SD1->(Found())

				SDA->(DbSetOrder(1))
				SDA->(DbSeek(SD1->D1_FILIAL+SD1->D1_COD+SD1->D1_LOCAL+SD1->D1_NUMSEQ+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA))
				if !SDA->(Found())
					RecLock("SDA", .T. )

					SDA->DA_FILIAL  :=  SD1->D1_FILIAL
					SDA->DA_PRODUTO	:=	SD1->D1_COD
					SDA->DA_QTDORI	:=  SD1->D1_QUANT
					SDA->DA_SALDO	:=  SD1->D1_QUANT
					SDA->DA_DATA	:=  SD1->D1_DTDIGIT
					SDA->DA_LOCAL	:=	SD1->D1_LOCAL
					SDA->DA_DOC		:=	SD1->D1_DOC
					SDA->DA_SERIE	:=  SD1->D1_SERIE
					SDA->DA_CLIFOR	:=  SD1->D1_FORNECE
					SDA->DA_LOJA	:=  SD1->D1_LOJA
					SDA->DA_TIPONF	:=  SD1->D1_TIPO
					SDA->DA_ORIGEM	:=  "SD1"
					SDA->DA_NUMSEQ	:=  SD1->D1_NUMSEQ

					SDA->(MsUnLock())
					nRegAtu++
				endif
			endif
		endif

		nRegLidos++

		FT_FSKIP()

	EndDo

	If !FCLOSE(nHandle)
		MsgStop("Erro ao fechar arquivo, erro numero: ",FERROR() )
	EndIf

	FT_FUSE()

	msginfo(alltrim(str(nRegLidos))+" notas lidas " + " - " + alltrim(str(nRegAtu))+" endereçamento(s) gerado(s) ","")

return
