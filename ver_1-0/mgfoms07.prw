#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*
=====================================================================================
Programa.:              MGFGOMS07
Autor....:              Rafael Garcia
Data.....:              01/04/2019
Descricao / Objetivo:   Integração PROTHEUS x Multiembarcador - flag para de Reenvio Carga - 
chamaado pelo P.E. OM200US
Doc. Origem:
Solicitante:            Cliente
Uso......:              Marfrig
Obs......:              
=====================================================================================
*/
User Function MGFOMS07()
	private Coleta		:=DAK->DAK_XCODO
	private lColeta		:=DAK->DAK_XLOJO
	private CnpjColeta	:=DAK->DAK_XCNPJO
	private NomeColeta	:=DAK->DAK_XRAZO
	private cidColeta	:=DAK->DAK_XDCIDO
	private ufColeta	:=DAK->DAK_XUFO
	private Destino		:=DAK->DAK_XCODD
	private lDestino	:=DAK->DAK_XLOJD
	private CnpjDest	:=DAK->DAK_XCNPJD
	private NomeDest	:=DAK->DAK_XRAZD
	private cidDest		:=DAK->DAK_XDCIDD
	private ufDest		:=DAK->DAK_XUFD
	private Exped		:=DAK->DAK_XCODE
	private lExped		:=DAK->DAK_XLOJE
	private CnpjExped	:=DAK->DAK_XCNPJE
	private NomeExped	:=DAK->DAK_XRAZE
	private cidExped	:=DAK->DAK_XDCIDE
	private ufExped		:=DAK->DAK_XUFE
	private Recebe		:=DAK->DAK_XCODR
	private lRecebe		:=DAK->DAK_XLOJR
	private CnpjRecebe	:=DAK->DAK_XCNPJR
	private NomeRecebe	:=DAK->DAK_XRAZR
	private cidRecebe	:=DAK->DAK_XDCIDR
	private ufRecebe	:=DAK->DAK_XUFR
	private Cross		:=DAK->DAK_XCODC
	private lCross		:=DAK->DAK_XLOJC
	private CnpjCross	:=DAK->DAK_XCNPJC
	private NomeCross	:=DAK->DAK_XRAZC
	private cidCross	:=DAK->DAK_XDCIDC
	private ufCross		:=DAK->DAK_XUFC
	private bOk 			:=  { || Coleta <> DAK->DAK_XCODO .Or. lColeta <> DAK->DAK_XLOJO .Or. CnpjColeta <> DAK->DAK_XCNPJO	.Or. ;
		NomeColeta <> DAK->DAK_XRAZO .Or. cidColeta <> DAK->DAK_XDCIDO	.Or. ufColeta <> DAK->DAK_XUFO	.Or. ;
		Destino <> DAK->DAK_XCODD	.Or. lDestino  <> DAK->DAK_XLOJD .Or. CnpjDest  <> DAK->DAK_XCNPJD	 .Or. ;
		NomeDest  <> DAK->DAK_XRAZD	.Or. cidDest <> DAK->DAK_XDCIDD	 .Or. ufDest <> DAK->DAK_XUFD .Or. ;
		Exped  <> DAK->DAK_XCODE	 .Or. lExped  <> DAK->DAK_XLOJE	.Or. CnpjExped <> DAK->DAK_XCNPJE	.Or. ;
		NomeExped <> DAK->DAK_XRAZE	.Or. cidExped  <> DAK->DAK_XDCIDE	.Or. ufExped	 <> DAK->DAK_XUFE	.Or. ;
		Recebe <> DAK->DAK_XCODR .Or. lRecebe	<> DAK->DAK_XLOJR	 .Or. CnpjRecebe <> DAK->DAK_XCNPJR	.Or. ;
		NomeRecebe <> DAK->DAK_XRAZR .Or. cidRecebe <> DAK->DAK_XDCIDR	.Or. ufRecebe <> DAK->DAK_XUFR .or.;
		Cross <> DAK->DAK_XCODC .Or. lCross	<> DAK->DAK_XLOJC	 .Or. CnpjCross <> DAK->DAK_XCNPJC	.Or. ;
		NomeCross <> DAK->DAK_XRAZC .Or. cidCross <> DAK->DAK_XDCIDC	.Or. ufCross <> DAK->DAK_XUFC}

	Private oDlg,lOk,lCancel


	//------------------------------------------------------------
	nLinDlg := 16   //Primeira linha
	nLesp   := 25   //Espaçamento

	DEFINE DIALOG oDlg TITLE "Origem/Destino" FROM 0,0 TO 330,900 PIXEL
	//CONSULTA PADRÃO FOC
	@ nLinDlg,06 SAY "Porto Coleta:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,38 MSGET Coleta SIZE 30,10 OF oDlg PIXEL  VALID VSA2(1)  F3 "SA2CTE"

	@ nLinDlg,76 MSGET lColeta SIZE 10,10 OF oDlg PIXEL PICTURE '@!' when .f.

	@ nLinDlg,94 SAY "Cnpj:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,110 MSGET CnpjColeta SIZE 50,10 OF oDlg PIXEL when .f.

	@ nLinDlg,162 SAY "Razão Social:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,200 MSGET NomeColeta SIZE 90,10 OF oDlg PIXEL when .f.

	@ nLinDlg,292 SAY "Cidade:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,312 MSGET cidColeta SIZE 70,10 OF oDlg PIXEL when .f.

	@ nLinDlg,390 SAY "UF:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,400 MSGET ufColeta SIZE 10,10 OF oDlg PIXEL when .f.
	nLinDlg += nLesp

	@ nLinDlg,06 SAY "Origem TN:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,38 MSGET Destino	 SIZE 30,10 OF oDlg PIXEL  VALID VSA2(2)   F3 "SA2CTE"

	@ nLinDlg,76 MSGET lDestino	 SIZE 10,10 OF oDlg PIXEL PICTURE '@!' when .f.

	@ nLinDlg,94 SAY "Cnpj:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,110 MSGET CnpjDest	 SIZE 50,10 OF oDlg PIXEL when .f.

	@ nLinDlg,162 SAY "Razão Social:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,200 MSGET NomeDest	 SIZE 90,10 OF oDlg PIXEL when .f.

	@ nLinDlg,292 SAY "Cidade:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,312 MSGET cidDest	 SIZE 70,10 OF oDlg PIXEL when .f.

	@ nLinDlg,390 SAY "UF:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,400 MSGET ufDest	 SIZE 10,10 OF oDlg PIXEL when .f.
	nLinDlg += nLesp

	@ nLinDlg,06 SAY "Expedidor:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,38 MSGET Exped	 SIZE 30,10 OF oDlg PIXEL   VALID VSA2(3)  F3 "SA2CTE"

	@ nLinDlg,76 MSGET lExped	 SIZE 10,10 OF oDlg PIXEL PICTURE '@!' when .f.

	@ nLinDlg,94 SAY "Cnpj:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,110 MSGET CnpjExped	 SIZE 50,10 OF oDlg PIXEL when .f.

	@ nLinDlg,162 SAY "Razão Social:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,200 MSGET NomeExped	 SIZE 90,10 OF oDlg PIXEL when .f.

	@ nLinDlg,292 SAY "Cidade:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,312 MSGET cidExped	 SIZE 70,10 OF oDlg PIXEL when .f.

	@ nLinDlg,390 SAY "UF:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,400 MSGET ufExped	SIZE 10,10 OF oDlg PIXEL when .f.

	nLinDlg += nLesp

	@ nLinDlg,06 SAY "Recebedor:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,38 MSGET Recebe	 SIZE 30,10 OF oDlg PIXEL VALID VSA2(4) F3 "SA2CTE"

	@ nLinDlg,76 MSGET lRecebe	 SIZE 10,10 OF oDlg PIXEL PICTURE '@!' when .f.

	@ nLinDlg,94 SAY "Cnpj:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,110 MSGET CnpjRecebe	 SIZE 50,10 OF oDlg PIXEL when .f.

	@ nLinDlg,162 SAY "Razão Social:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,200 MSGET NomeRecebe	 SIZE 90,10 OF oDlg PIXEL when .f.

	@ nLinDlg,292 SAY "Cidade:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,312 MSGET cidRecebe	 SIZE 70,10 OF oDlg PIXEL when .f.

	@ nLinDlg,390 SAY "UF:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,400 MSGET ufRecebe	SIZE 10,10 OF oDlg PIXEL when .f.

	nLinDlg += nLesp

	@ nLinDlg,06 SAY "Cross:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,38 MSGET Cross	 SIZE 30,10 OF oDlg PIXEL VALID VSA2(5) F3 "SA2CTE"

	@ nLinDlg,76 MSGET lCross	 SIZE 10,10 OF oDlg PIXEL PICTURE '@!' when .f.

	@ nLinDlg,94 SAY "Cnpj:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,110 MSGET CnpjCross	 SIZE 50,10 OF oDlg PIXEL when .f.

	@ nLinDlg,162 SAY "Razão Social:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,200 MSGET NomeCross	 SIZE 90,10 OF oDlg PIXEL when .f.

	@ nLinDlg,292 SAY "Cidade:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,312 MSGET cidCross	 SIZE 70,10 OF oDlg PIXEL when .f.

	@ nLinDlg,390 SAY "UF:" SIZE  50,10 OF oDlg PIXEL
	@ nLinDlg,400 MSGET ufCross	SIZE 10,10 OF oDlg PIXEL when .f.

	nLinDlg += nLesp


	oTButton := TButton():New( nLinDlg, 162, "&OK",oDlg	,{||AtualSA2(),;
		AtualZEK(DAK->DAK_FILIAL,DAK->DAK_COD,DAK->DAK_SEQCAR,date(), Time(), Coleta, lColeta, CnpjColeta, NomeColeta, cidColeta, ufColeta, Destino, lDestino, CnpjDest, NomeDest, cidDest,  ufDest, Exped, lExped, CnpjExped, NomeExped, cidExped, ufExped, Recebe, lRecebe, CnpjRecebe, NomeRecebe, cidRecebe, ufRecebe, RetCodUsr() , Substr(Alltrim(UsrFullName(RetCodUsr())),1,25) )  ,;
		oDlg:End() } ,40,10,,,.F.,.T.,.F.,,.F.,bOk,,.F. )

	oTButton := TButton():New( nLinDlg, 212, "&Cancelar",oDlg,{||	oDlg:End() } ,40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

	ACTIVATE DIALOG oDlg CENTERED

Return

STATIC FUNCTION AtualSA2()
	local cQ:=""

	if DAK->DAK_XCODO <> Coleta .or. DAK->DAK_XLOJO<> lColeta

		cQ :=" SELECT A2_COD,A2_LOJA,A2_CGC,A2_NOME,A2_COD_MUN,A2_MUN,A2_EST " +CRLF
		cQ +=" FROM "+retSQLName("SA2")					+CRLF
		cQ +=" WHERE D_E_L_E_T_<>'*' AND  A2_FILIAL='"+XFILIAL("SA2")+"'AND A2_COD='"+Coleta+"' and A2_LOJA ='"+lColeta+"'"

		IF SELECT("QRYSA2") > 0
			QRYSA2->( dbCloseArea() )
		ENDIF

		TcQuery changeQuery(cQ) New Alias "QRYSA2"

		IF !QRYSA2->(EOF())
			Reclock("DAK",.F.)
			DAK->DAK_XCODO	:= QRYSA2->A2_COD
			DAK->DAK_XLOJO	:= QRYSA2->A2_LOJA
			DAK->DAK_XCNPJO := QRYSA2->A2_CGC
			DAK->DAK_XRAZO 	:= QRYSA2->A2_NOME
			DAK->DAK_XCIDO 	:= QRYSA2->A2_COD_MUN
			DAK->DAK_XDCIDO := QRYSA2->A2_MUN
			DAK->DAK_XUFO	:= QRYSA2->A2_EST
			DAK->(MsUnlock())
		else
			Reclock("DAK",.F.)
			DAK->DAK_XCODO	:= ""
			DAK->DAK_XLOJO	:= ""
			DAK->DAK_XCNPJO := ""
			DAK->DAK_XRAZO 	:= ""
			DAK->DAK_XCIDO 	:= ""
			DAK->DAK_XDCIDO := ""
			DAK->DAK_XUFO	:= ""
			DAK->(MsUnlock())
		ENDIF
	endif

	if DAK->DAK_XCODD <> Destino .or. DAK->DAK_XLOJD<> lDestino

		cQ :=" SELECT A2_COD,A2_LOJA,A2_CGC,A2_NOME,A2_COD_MUN,A2_MUN,A2_EST " +CRLF
		cQ +=" FROM "+retSQLName("SA2")					+CRLF
		cQ +=" WHERE D_E_L_E_T_<>'*' AND  A2_FILIAL='"+XFILIAL("SA2")+"'AND A2_COD='"+Destino+"' and A2_LOJA ='"+lDestino+"'"

		IF SELECT("QRYSA2") > 0
			QRYSA2->( dbCloseArea() )
		ENDIF

		TcQuery changeQuery(cQ) New Alias "QRYSA2"

		IF !QRYSA2->(EOF())
			Reclock("DAK",.F.)
			DAK->DAK_XCODD	:= QRYSA2->A2_COD
			DAK->DAK_XLOJD	:= QRYSA2->A2_LOJA
			DAK->DAK_XCNPJD := QRYSA2->A2_CGC
			DAK->DAK_XRAZD 	:= QRYSA2->A2_NOME
			DAK->DAK_XCIDD 	:= QRYSA2->A2_COD_MUN
			DAK->DAK_XDCIDD := QRYSA2->A2_MUN
			DAK->DAK_XUFD	:= QRYSA2->A2_EST
			DAK->(MsUnlock())
		else
			Reclock("DAK",.F.)
			DAK->DAK_XCODD	:= ""
			DAK->DAK_XLOJD	:= ""
			DAK->DAK_XCNPJD := ""
			DAK->DAK_XRAZD 	:= ""
			DAK->DAK_XCIDD 	:= ""
			DAK->DAK_XDCIDD := ""
			DAK->DAK_XUFD	:= ""
			DAK->(MsUnlock())
		ENDIF
	ENDIF
	if DAK->DAK_XCODE <> Exped .or. DAK->DAK_XLOJE<> lExped

		cQ :=" SELECT A2_COD,A2_LOJA,A2_CGC,A2_NOME,A2_COD_MUN,A2_MUN,A2_EST " +CRLF
		cQ +=" FROM "+retSQLName("SA2")					+CRLF
		cQ +=" WHERE D_E_L_E_T_<>'*' AND  A2_FILIAL='"+XFILIAL("SA2")+"'AND A2_COD='"+Exped+"' and A2_LOJA ='"+lExped+"'"

		IF SELECT("QRYSA2") > 0
			QRYSA2->( dbCloseArea() )
		ENDIF

		TcQuery changeQuery(cQ) New Alias "QRYSA2"

		IF !QRYSA2->(EOF())
			Reclock("DAK",.F.)
			DAK->DAK_XCODE	:= QRYSA2->A2_COD
			DAK->DAK_XLOJE	:= QRYSA2->A2_LOJA
			DAK->DAK_XCNPJE := QRYSA2->A2_CGC
			DAK->DAK_XRAZE  := QRYSA2->A2_NOME
			DAK->DAK_XCIDE  := QRYSA2->A2_COD_MUN
			DAK->DAK_XDCIDE := QRYSA2->A2_MUN
			DAK->DAK_XUFE   := QRYSA2->A2_EST
			DAK->(MsUnlock())
		else
			Reclock("DAK",.F.)
			DAK->DAK_XCODE	:= ""
			DAK->DAK_XLOJE	:= ""
			DAK->DAK_XCNPJE := ""
			DAK->DAK_XRAZE 	:= ""
			DAK->DAK_XCIDE 	:= ""
			DAK->DAK_XDCIDE := ""
			DAK->DAK_XUFE	:= ""
			DAK->(MsUnlock())
		ENDIF
	ENDIF
	if DAK->DAK_XCODR <> Recebe .or. DAK->DAK_XLOJR<> lRecebe

		cQ :=" SELECT A2_COD,A2_LOJA,A2_CGC,A2_NOME,A2_COD_MUN,A2_MUN,A2_EST " +CRLF
		cQ +=" FROM "+retSQLName("SA2")					+CRLF
		cQ +=" WHERE D_E_L_E_T_<>'*' AND  A2_FILIAL='"+XFILIAL("SA2")+"'AND A2_COD='"+Recebe+"' and A2_LOJA ='"+lRecebe+"'"

		IF SELECT("QRYSA2") > 0
			QRYSA2->( dbCloseArea() )
		ENDIF

		TcQuery changeQuery(cQ) New Alias "QRYSA2"

		IF !QRYSA2->(EOF())
			Reclock("DAK",.F.)
			DAK->DAK_XCODR	:= QRYSA2->A2_COD
			DAK->DAK_XLOJR	:= QRYSA2->A2_LOJA
			DAK->DAK_XCNPJR := QRYSA2->A2_CGC
			DAK->DAK_XRAZR  := QRYSA2->A2_NOME
			DAK->DAK_XCIDR  := QRYSA2->A2_COD_MUN
			DAK->DAK_XDCIDR := QRYSA2->A2_MUN
			DAK->DAK_XUFR   := QRYSA2->A2_EST
			DAK->(MsUnlock())
		else
			Reclock("DAK",.F.)
			DAK->DAK_XCODR	:= ""
			DAK->DAK_XLOJR	:= ""
			DAK->DAK_XCNPJR := ""
			DAK->DAK_XRAZR 	:= ""
			DAK->DAK_XCIDR 	:= ""
			DAK->DAK_XDCIDR := ""
			DAK->DAK_XUFR	:= ""
			DAK->(MsUnlock())
		ENDIF
	ENDIF
	if DAK->DAK_XCODC <> Cross .or. DAK->DAK_XLOJR<> lCross

		cQ :=" SELECT A2_COD,A2_LOJA,A2_CGC,A2_NOME,A2_COD_MUN,A2_MUN,A2_EST " +CRLF
		cQ +=" FROM "+retSQLName("SA2")					+CRLF
		cQ +=" WHERE D_E_L_E_T_<>'*' AND  A2_FILIAL='"+XFILIAL("SA2")+"'AND A2_COD='"+Cross+"' and A2_LOJA ='"+lCross+"'"

		IF SELECT("QRYSA2") > 0
			QRYSA2->( dbCloseArea() )
		ENDIF

		TcQuery changeQuery(cQ) New Alias "QRYSA2"

		IF !QRYSA2->(EOF())
			Reclock("DAK",.F.)
			DAK->DAK_XCODC	:= QRYSA2->A2_COD
			DAK->DAK_XLOJC	:= QRYSA2->A2_LOJA
			DAK->DAK_XCNPJC := QRYSA2->A2_CGC
			DAK->DAK_XRAZC  := QRYSA2->A2_NOME
			DAK->DAK_XCIDC  := QRYSA2->A2_COD_MUN
			DAK->DAK_XDCIDC := QRYSA2->A2_MUN
			DAK->DAK_XUFC   := QRYSA2->A2_EST
			DAK->(MsUnlock())
		else
			Reclock("DAK",.F.)
			DAK->DAK_XCODC	:= ""
			DAK->DAK_XLOJC	:= ""
			DAK->DAK_XCNPJC := ""
			DAK->DAK_XRAZC 	:= ""
			DAK->DAK_XCIDC 	:= ""
			DAK->DAK_XDCIDC := ""
			DAK->DAK_XUFC	:= ""
			DAK->(MsUnlock())
		ENDIF
	ENDIF
	IF SELECT("QRYSA2") > 0
		QRYSA2->( dbCloseArea() )
	ENDIF
return


STATIC FUNCTION VSA2(n)

	local lRet:= .t.
	do case
	case n==1
		if empty(Coleta)
			lColeta		:=SPACE(LEN(DAK->DAK_XLOJO))
			CnpjColeta	:=SPACE(LEN(DAK->DAK_XCNPJO))
			NomeColeta	:=SPACE(LEN(DAK->DAK_XRAZO))
			cidColeta	:=SPACE(LEN(DAK->DAK_XDCIDO))
			ufColeta	:=SPACE(LEN(DAK->DAK_XUFO))
		else
			lret:=EXISTCPO("SA2",Coleta+lColeta)
		endif

	case n==2
		if empty(Destino)
			lDestino	:=SPACE(LEN(DAK->DAK_XLOJD))
			CnpjDest	:=SPACE(LEN(DAK->DAK_XCNPJD))
			NomeDest	:=SPACE(LEN(DAK->DAK_XRAZD))
			cidDest		:=SPACE(LEN(DAK->DAK_XDCIDD))
			ufDest		:=SPACE(LEN(DAK->DAK_XUFD))
		else
			lret:=EXISTCPO("SA2",Destino+lDestino)
		endif

	case n==3
		if empty(Exped)
			lExped		:=SPACE(LEN(DAK->DAK_XLOJE))
			CnpjExped	:=SPACE(LEN(DAK->DAK_XCNPJE))
			NomeExped	:=SPACE(LEN(DAK->DAK_XRAZE))
			cidExped	:=SPACE(LEN(DAK->DAK_XDCIDE))
			ufExped		:=SPACE(LEN(DAK->DAK_XUFE))
		else
			lret:=EXISTCPO("SA2",Exped+lExped)
		endif

	case n==4
		if empty(Recebe)
			lRecebe		:=SPACE(LEN(DAK->DAK_XLOJR))
			CnpjRecebe	:=SPACE(LEN(DAK->DAK_XCNPJR))
			NomeRecebe	:=SPACE(LEN(DAK->DAK_XRAZR))
			cidRecebe	:=SPACE(LEN(DAK->DAK_XDCIDR))
			ufRecebe	:=SPACE(LEN(DAK->DAK_XUFR))
		else
			lret:=EXISTCPO("SA2",Recebe+lRecebe)
		endif
	case n==5
		if empty(Cross)
			lCross		:=SPACE(LEN(DAK->DAK_XLOJC))
			CnpjCross	:=SPACE(LEN(DAK->DAK_XCNPJC))
			NomeCross	:=SPACE(LEN(DAK->DAK_XRAZC))
			cidCross	:=SPACE(LEN(DAK->DAK_XDCIDC))
			ufCross		:=SPACE(LEN(DAK->DAK_XUFC))
		else
			lret:=EXISTCPO("SA2",Cross+lCross)
		endif
	endcase
return lRet

Static Function AtualZEK(cFilZek, cNumZek, cSeqNum, dDatSze,dHrSZE , Coleta, lColeta, CnpjColeta, NomeColeta, cidColeta, ufColeta, Destino, lDestino, CnpjDest, NomeDest, cidDest,  ufDest, Exped, lExped, CnpjExped, NomeExped, cidExped, ufExped, Recebe, lRecebe, CnpjRecebe, NomeRecebe, cidRecebe, ufRecebe , cUsrSZE , cNameSZE )

	Reclock("ZEK",.T.)
	ZEK_FILIAL 	:= 	cFilZek
	ZEK_COD   		:= 	cNumZek
	ZEK_SEQCAR		:= 	cSeqNum
	ZEK_DTGRV		:= 	dDatSze
	ZEK_HORA		:= 	dHrSZE
	ZEK_XCODO		:= 	Coleta
	ZEK_XLOJO		:= 	lColeta
	ZEK_XCNPJO		:= 	CnpjColeta
	ZEK_XRAZO		:= 	NomeColeta
	ZEK_XDCIDO		:= 	cidColeta
	ZEK_XUFO		:= 	ufColeta
	ZEK_XCODD		:= 	Destino
	ZEK_XLOJD		:= 	lDestino
	ZEK_XCNPJD		:= 	CnpjDest
	ZEK_XRAZD		:= 	NomeDest
	ZEK_XDCIDD		:= 	cidDest
	ZEK_XUFD		:= 	ufDest
	ZEK_XCODE		:= 	Exped
	ZEK_XLOJE		:= 	lExped
	ZEK_XCNPJE		:= 	CnpjExped
	ZEK_XRAZE		:= 	NomeExped
	ZEK_XDCIDE		:= 	cidExped
	ZEK_XUFE		:= 	ufExped
	ZEK_XCODR		:= 	Recebe
	ZEK_XLOJR		:= 	lRecebe
	ZEK_XCNPJR		:= 	CnpjRecebe
	ZEK_XRAZR		:= 	NomeRecebe
	ZEK_XDCIDR		:= 	cidRecebe
	ZEK_XUFR		:= 	ufRecebe
	ZEK_XCODC		:= 	Cross
	ZEK_XLOJC		:= 	lCross
	ZEK_XCNPJC		:= 	CnpjCross
	ZEK_XRAZC		:= 	NomeCross
	ZEK_XDCIDC		:= 	cidCross
	ZEK_XUFC		:= 	ufCross
	ZEK_USER  		:= 	cUsrSZE
	ZEK_NOMEUS		:= cNameSZE
	ZEK->(MsUnlock())

Return
