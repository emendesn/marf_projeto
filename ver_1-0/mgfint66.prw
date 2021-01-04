#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'FWBROWSE.CH'
#INCLUDE 'FWMVCDEF.CH'           

/*
===========================================================================================
Programa............: MGFINT66
Autor...............: Marcelo Carneiro
Data................: 22/08/2019
Descricao / Objetivo: Inclusão do Log de Conhecimento no cadastro de Motorista e Veiculos
Doc. Origem.........: o	RITM0016132 – cadastro de motorista / veículo – gravar data/hora e 
					  usuário que realizou upload de documento
Solicitante.........: Cliente
Uso.................: Marfrig
Obs.................: Chamado pelos PE : OM040BRW e OM060BRW
===========================================================================================
*/
User Function MGFINT66(cTabela)
	

Local cQuery  	:= ""
Local aCoors	:= 	FWGetDialogSize( oMainWnd )
Local oDlg		:= nil
Local cCodigo   := ''
Local cDesc     := ''
Local cDbLink   := Alltrim(GetMV('MGF_INT66',.F.,"FLUIGT_DBLINK")) 

Private oConhec		:= nil
Private aDados      := {}

IF cTabela == 'DA3'
	cCodigo := DA3->DA3_COD                                                             
	cDesc   := DA3->DA3_DESC
ElseIF cTabela =='DA4'
	cCodigo := DA4->DA4_COD                                                             
	cDesc   := DA4->DA4_NOME
EndIF
    

cQuery += " SELECT TO_CHAR(DT_CRIACAO, 'YYYY-MM-DD HH24:MI:SS') DT_CRIACAO ,                                   "
cQuery += "        TO_CHAR(DT_ATUALIZACAO, 'YYYY-MM-DD HH24:MI:SS') DT_ATUALIZACAO,                            "
cQuery += "        NR_DOCUMENTO,                                                                               "
cQuery += "        DS_PRINCIPAL_DOCUMENTO,                                                                     "
cQuery += "        COD_EMPRESA,                                                                                "
cQuery += "        VERSAO_ATIVA, CD_MATRICULA,                                                                 "
cQuery += "        CD_DOCUMENTO_EXT,                                                                           "
cQuery += "        COD_MIME_TYPE,	                                                                           "
cQuery += "        NM_ARQUIVO_FISICO,                                                                          "
cQuery += "        NR_DOCUMENTO_PAI                                                                            "
cQuery += " FROM documento@"+cDbLink+" DOC  "
cQuery += "       , ( Select x.NR_DOCUMENTO DOCPAI, x.DS_PRINCIPAL_DOCUMENTO TABELA         "
cQuery += "           FROM documento@"+cDbLink+"  x                                               "
cQuery += "           Where x.TP_DOCUMENTO = 1 AND x.COD_EMPRESA=4 AND x.VERSAO_ATIVA=1 )  "
cQuery += " Where COD_EMPRESA=4                                                                                "
cQuery += "   AND TP_DOCUMENTO = 2                                                                               "
cQuery += "   AND DOCPAI = NR_DOCUMENTO_PAI                                                                      "
IF cTabela == 'DA3'
	cQuery += "   AND TABELA in ('DA3')                                                                        "
ElseIF cTabela =='DA4'
	cQuery += "   AND TABELA in ('DA4')                                                                        "
EndIF
cQuery += "   AND CD_DOCUMENTO_EXT like '%"+Alltrim(cCodigo)+"%'                                                             "
cQuery := ChangeQuery( cQuery )

If Select("QRY_DADOS") > 0
	QRY_DADOS->(dbCloseArea())
EndIf
cQuery  := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY_DADOS",.T.,.F.)
If !QRY_DADOS->(EOF())
	
	While !QRY_DADOS->(EOF())
		AAdd(aDados, {QRY_DADOS->DT_CRIACAO,;    
		              QRY_DADOS->DT_ATUALIZACAO,;
		              QRY_DADOS->NR_DOCUMENTO,;
		              cCodigo,;
		              cDesc,;
		              QRY_DADOS->DS_PRINCIPAL_DOCUMENTO,;
		              QRY_DADOS->NM_ARQUIVO_FISICO,;
		              QRY_DADOS->CD_MATRICULA,;
		              QRY_DADOS->COD_MIME_TYPE,;
		              QRY_DADOS->VERSAO_ATIVA})			
		QRY_DADOS->(DBSkip())
	EndDo
	
	
	DEFINE MSDIALOG oDlg TITLE 'Consulta Log Conhecimento' FROM aCoors[1], aCoors[2] TO aCoors[3], aCoors[4] PIXEL STYLE DS_MODALFRAME
		oConhec := FwBrowse():New()
		oConhec:SetDataArray()
		oConhec:SetArray(aDados)
		oConhec:DisableConfig()
		oConhec:DisableReport()
		oConhec:SetOwner(oDlg)
		oConhec:AddLegend("aDados[oConhec:nAt,10]==1","GREEN" ,"Documento Ativo")
		oConhec:AddLegend("aDados[oConhec:nAt,10]==0","RED" ,"Documento Inativo")
		oConhec:AddColumn({"Dt.Criação"       , {||aDados[oConhec:nAt,1]}, "C", , 1, 15 })
		oConhec:AddColumn({"Dt.Atualização"   , {||aDados[oConhec:nAt,2]}, "C", , 1, 15 })
		oConhec:AddColumn({"No. Docummento"   , {||aDados[oConhec:nAt,3]}, "C", , 1, 10 })
		oConhec:AddColumn({"Código"           , {||aDados[oConhec:nAt,4]}, "C", , 1, 07 })
		oConhec:AddColumn({"Descrição"        , {||aDados[oConhec:nAt,5]}, "C", , 1, 22 })
		oConhec:AddColumn({"Texto"            , {||aDados[oConhec:nAt,6]}, "C", , 1, 20 })
		oConhec:AddColumn({"Nome do Arquivo"  , {||aDados[oConhec:nAt,7]}, "C", , 1, 20 })
		oConhec:AddColumn({"Usuário"          , {||aDados[oConhec:nAt,8]}, "C", , 1, 08 })
		oConhec:AddColumn({"Tipo do Arquivo"  , {||aDados[oConhec:nAt,9]}, "C", , 1, 18 })
				
		oConhec:Activate(.T.)

		EnchoiceBar(oDlg, { ||  oDlg:end() } , { || oDlg:end() })
	ACTIVATE MSDIALOG oDlg CENTER

Else
		
	MsgAlert("Não foi encontrado documentos para este registro !!")
Endif

QRY_DADOS->(DBCloseArea())

Return