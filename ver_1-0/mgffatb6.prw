#include "totvs.ch
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"                            
#include "parmtype.ch"
#include "rwmake.ch"

#define CRLF chr(13) + chr(10)   

/*/{Protheus.doc} MGFFATB6 (nome da Função)
Breve descrição... Função para excluir pedidos em abertos com mais de 7 dias(Eliminação de Residuos Customizado)

@description
Detalhamento da funcionalidade.. Filtrar todos os pedidos abertos parcialmente através de uma Query e executar 
a rotina ExecAuto Mata410 com a opção de excluir.

@author Fabio Costa
@since 15/08/2019

@version P12.1.017
@country Brasil
@language Português

@type XXXXXXXX  ("Function" para Funções, "Class" para Classes, "Method" para Métodos, "Property" para Propriedades de classes, "Variable" para Variáveis
@table 

@param
@return

@menu

@history

PRB0040215-Eliminação-de-residuos-PV

/*/

User Function MGFFATB6()

	Local _oProcess
	Local cPerg     := "MGFFATB6"
	Local _aInfo    := {}
	Local _lcontinua := .F.
	Local oproc      := nil
	Local _ndias   	:= 0

	If  !( ISINCALLSTACK("MDIEXECUTE") .OR. ISINCALLSTACK("SIGAADV") )

		_lcontinua := .T.
		
		U_MFCONOUT(' Iniciando processamento exclusão pedidos venda não atendidos...') 

		RPCSetType( 3 )

		PREPARE ENVIRONMENT EMPRESA '01' FILIAL '010041'

		U_MFCONOUT(' Iniciando exclusão para filiais CD...'  )

		 _ndias   	:= SuperGetMv("MGF_FATB6B",,2) 

		MV_PAR02 := DATE() - _ndias
		MV_PAR01 := DATE() - _ndias
		MV_PAR03 := SuperGetMv("MGF_FATB6F",,"010007;010016;010038;010041;010044;010059;010066")

		xMGFB6(oproc,.F.)

		U_MFCONOUT(' Iniciando exclusão para demais filiais...'  )

	 	_ndias   	:= SuperGetMv("MGF_FATB6C",,10) 

		MV_PAR02 := DATE() - _ndias
		MV_PAR01 := DATE() - _ndias
		MV_PAR03 := SuperGetMv("MGF_FATB6D",,"010007;010016;010038;010041;010044;010059;010066")

		xMGFB6(oproc,.T.)



	ElseIf pergunte(cPerg)

		fwmsgrun(,{|oproc| xMGFB6(oproc)},"Aguarde...","Lendo pedidos...")

	Else

		msgbox("Processo cancelado pelo usuário!!","Atenção")

	Endif	

Return

/*/{Protheus.doc} xMGFB6 (nome da Função)
@descrição Função que executa e exclusão pedidos em abertos 
           com mais de 7 dias

@author Fabio Costa
@since 15/08/2019

@version P12.1.017
@country Brasil
@language Português
@chamado/problema PRB0040215-Eliminação-de-residuos-PV
/*/

Static Function xMGFB6(oproc,_linverte)

	Local cQuery    := ""
	Local cDtIni    := DtoS(MV_PAR01)  
	Local cDtFim    := DtoS(MV_PAR02)  
	Local lTemFatZ  := .F.
	Local cFilPed   := ""
	Local cPedExc   := ""
	Local cTipPv    := SuperGetMv("MGF_FATB6A",,"VE") 
	Local cTipCd    := SuperGetMv("MGF_FATB6G",,"VE/AV/CC/CH/CR/EO/FF/FG/N1/N2/PR/SQ/VE")
	Local _ntot     := 0
	Local _npos     := 0
	Local _cfiliais := MV_PAR03

	Default oproc := nil
	Default _linverte := .F.

	Private aCab      := {}
	Private _aItensPV := {}

	cQuery := "SELECT DISTINCT C6_FILIAL,C6_NUM,C5_CLIENTE,C5_LOJACLI,C5_ZDTREEM,C5_ZDTEMBA,M0_FILIAL,C5_XNOMECL,C5_EMISSAO,C5_VEND1,A3_NOME,C5_ZTIPPED  "+CRLF
	cQuery += "FROM "+RetSqlName("SC6")+" SC6 "+CRLF    
	cQuery += "INNER JOIN "+RetSqlName("SC5")+" SC5 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC5.D_E_L_E_T_ <> '*' "+CRLF
	cQuery += " LEFT JOIN SYS_COMPANY EMP ON EMP.M0_CODFIL = SC5.C5_FILIAL "+CRLF
	cQuery += " AND EMP.D_E_L_E_T_ <> '*' "+CRLF
	cQuery += " LEFT JOIN SA3010 A3 ON A3_COD = C5_VEND1 "+CRLF
    cQuery += " AND A3.D_E_L_E_T_ <> '*' "+CRLF 

	cQuery += "WHERE SC6.D_E_L_E_T_ <>	'*' "+CRLF
	cQuery += "AND ((C5_ZDTEMBA BETWEEN '"+cDtIni+"'  AND '"+cDtFim+"' AND C5_ZDTREEM = ' ' ) OR "+CRLF
	cQuery += "    (C5_ZDTREEM BETWEEN '"+cDtIni+"'  AND '"+cDtFim+"')) "+CRLF
	
	If !empty(_cfiliais)
	
		If !_linverte
			cQuery += "AND C5_FILIAL IN "+FormatIn(_cfiliais,";")+" "+CRLF
		Else
			cQuery += "AND C5_FILIAL NOT IN "+FormatIn(_cfiliais,";")+" "+CRLF
		Endif
	
	Endif
	cQuery += "AND C6_NOTA = ' ' AND C5_NOTA = ' '"
	cQuery += "AND (C6_QTDVEN-C6_QTDENT) > 0 "
	If !_linverte
		cQuery += "AND C5_ZTIPPED IN "+FormatIn(cTipPv,"/")+" "+CRLF
	Else
		cQuery += "AND C5_ZTIPPED IN "+FormatIn(cTipCD,"/")+" "+CRLF
	Endif
	cQuery += "GROUP BY C6_FILIAL,C6_NUM,C5_CLIENTE,C5_LOJACLI,C5_ZDTREEM,C5_ZDTEMBA,M0_FILIAL,C5_XNOMECL,C5_EMISSAO,C5_VEND1,A3_NOME,C5_ZTIPPED "+CRLF
	cQuery += "ORDER BY C6_FILIAL,C6_NUM,C5_CLIENTE,C5_LOJACLI,C5_ZDTREEM,C5_ZDTEMBA "+CRLF	

	Iif(Select("TRB01")>0,TRB01->(dbCloseArea()),Nil)
	
	cQuery := ChangeQuery(cQuery)

	TCQuery cQuery New Alias "TRB01"
	dbSelectArea("TRB01")

	//Conta pedidos
	Do while !TRB01->(EoF())
		_ntot++
		TRB01->(Dbskip())
	Enddo

	//Carrega tela de visualização de pedidos para confirmar processamento
	_ACOLS := {}
	aheader := {"Filial",;
				"Nome Filial",;
				"Número",;
				"Cliente",;
				"Loja Cliente",;
				"Nome cliente",;
				"Cod Vendedor",;
				"Vendedor",;
				"Emissão",;
				"Embarque",;
				"Reembarque",;
				"Tipo de Pedido"}

	TRB01->(Dbgotop())
	Do while !TRB01->(EoF())

		_npos++
		If  !( ISINCALLSTACK("MDIEXECUTE") .OR. ISINCALLSTACK("SIGAADV") )
		
			U_MFCONOUT("Carregando pedido " + strzero(_npos,6) + " de " + strzero(_ntot,6) + "...") 
		
		Elseif oproc != nil
			oproc:ccaption := "Carregando pedido " + strzero(_npos,6) + " de " + strzero(_ntot,6) + "..."
			ProcessMessages()
		Endif
		
		//Verifica está bloqueado no Taura
		Private inclui := .F.
		Private altera := .F.
		Private exclui := .F.
		_lret := U_TAS01StatPV({SC5->C5_NUM,2},.F.)

		If _lret

			aadd(_ACOLS,{	TRB01->C6_FILIAL,;
							TRB01->M0_FILIAL,;
							TRB01->C6_NUM,;
							TRB01->C5_CLIENTE,;
							TRB01->C5_LOJACLI,;
							TRB01->C5_XNOMECL,;
							TRB01->C5_VEND1,;
							TRB01->A3_NOME,;  
							stod(TRB01->C5_EMISSAO),;            
							stod(TRB01->C5_ZDTEMBA),;
							stod(TRB01->C5_ZDTREEM),;
							TRB01->C5_ZTIPPED } )
					

		Endif

		TRB01->(Dbskip())

	Enddo

	If len(_ACOLS) == 0

		If  !( ISINCALLSTACK("MDIEXECUTE") .OR. ISINCALLSTACK("SIGAADV") )
		
			U_MFCONOUT("Não foram localizados pedidos!")

		Else

			msgbox("Não foram localizados pedidos!")

		Endif

		Return
	
	Endif

	If  !( ISINCALLSTACK("MDIEXECUTE") .OR. ISINCALLSTACK("SIGAADV") ) .or. U_MGListBox( "Pedidos a serem excluidos" , aheader , _ACOLS , .T. , 1 )

		If  !( ISINCALLSTACK("MDIEXECUTE") .OR. ISINCALLSTACK("SIGAADV") )
		
			U_MFCONOUT("Excluindo pedidos...")

		ElseIf oproc != nil
			oproc:ccaption := "Excluindo pedidos..."
			ProcessMessages()
		Endif


		TRB01->(Dbgotop())
		_npos := 1

		_ACOLS := {}
		aheader := {"Filial","Pedido","Dt Embarque","Dt Reembarque","Cliente","Nome cliente","Status"}


		Do while !TRB01->(EoF())

			aCab := {}
			_aItemPV := {}
			_aItensPV := {}


			If  !( ISINCALLSTACK("MDIEXECUTE") .OR. ISINCALLSTACK("SIGAADV") )
		
				U_MFCONOUT("Excluindo pedido "+strzero(_npos,6)+" de "+ strzero(_ntot,6) + "...")

			ElseIf oproc != nil
				oproc:ccaption := "Excluindo pedido "+strzero(_npos,6)+" de "+ strzero(_ntot,6) + "..."
				ProcessMessages()
			Endif

			_npos++

			//Antes de deletar o pedido com qtde de entrega zerado verifica caso tenha mais itens faturados no mesmo pedido, nao efetua a exclusao.
			cFilPed := TRB01->C6_FILIAL
			cPedExc := TRB01->C6_NUM
			SC5->(Dbsetorder(1))
			
			If SC5->(Dbseek(cFilPed+cPedExc))

				_ddtent := SC5->C5_ZDTEMBA
				_ddtrem := SC5->C5_ZDTREEM
				_cclient := SC5->C5_CLIENTE
				_cloja  := SC5->C5_LOJACLI

				//Carrega Array aCab
				Aadd( aCab, { "C5_FILIAL"	,SC5->C5_FILIAL  , Nil})//filial
				Aadd( aCab, { "C5_NUM"    	,SC5->C5_NUM	 , Nil}) 
				Aadd( aCab, { "C5_TIPO"	    ,SC5->C5_TIPO    , Nil})//Tipo de pedido
				Aadd( aCab, { "C5_CLIENTE"	,SC5->C5_CLIENTE , NiL})//Codigo do cliente
				Aadd( aCab, { "C5_CLIENT" 	,SC5->C5_CLIENT	 , Nil}) 
				Aadd( aCab, { "C5_LOJAENT"	,SC5->C5_LOJAENT , NiL})//Loja para entrada
				Aadd( aCab, { "C5_LOJACLI"	,SC5->C5_LOJACLI , NiL})//Loja do cliente
				Aadd( aCab, { "C5_EMISSAO"	,SC5->C5_EMISSAO , NiL})//Data de emissao
				Aadd( aCab, { "C5_TRANSP" 	,SC5->C5_TRANSP	 , Nil}) 
				Aadd( aCab, { "C5_CONDPAG"	,SC5->C5_CONDPAG , NiL})//Codigo da condicao de pagamanto*
				Aadd( aCab, { "C5_VEND1"  	,SC5->C5_VEND1	 , Nil}) 
				Aadd( aCab, { "C5_MOEDA"    ,SC5->C5_MOEDA   , Nil})//Moeda
				Aadd( aCab, { "C5_MENPAD" 	,SC5->C5_MENPAD	 , Nil}) 
				Aadd( aCab, { "C5_LIBEROK"	,SC5->C5_LIBEROK , NiL})//Liberacao Total
				Aadd( aCab, { "C5_TIPLIB"  	,SC5->C5_TIPLIB  , Nil})//Tipo de Liberacao
				Aadd( aCab, { "C5_TIPOCLI"	,SC5->C5_TIPOCLI , NiL})//Tipo do Cliente

				//Carrega Array aItens
				SC6->( DBSeek( SC5->C5_FILIAL + SC5->C5_NUM ) )
				_aItensPV := {}
	
				DO While SC6->( !EOF() ) .And. SC6->( C6_FILIAL + C6_NUM ) == SC5->C5_FILIAL + SC5->C5_NUM
		
					_aItemPV:={}
		
					AAdd( _aItemPV , { "C6_FILIAL"  ,SC6->C6_FILIAL  , Nil }) // FILIAL
					AAdd( _aItemPV , { "C6_NUM"    	,SC6->C6_NUM	 , Nil })
					AAdd( _aItemPV , { "C6_ITEM"    ,SC6->C6_ITEM    , Nil }) // Numero do Item no Pedido
					AAdd( _aItemPV , { "C6_PRODUTO" ,SC6->C6_PRODUTO , Nil }) // Codigo do Produto
					AAdd( _aItemPV , { "C6_UNSVEN"  ,SC6->C6_UNSVEN  , Nil }) // Quantidade Vendida 2 un
					AAdd( _aItemPV , { "C6_QTDVEN"  ,SC6->C6_QTDVEN  , Nil }) // Quantidade Vendida
					AAdd( _aItemPV , { "C6_PRCVEN"  ,SC6->C6_PRCVEN  , Nil }) // Preco Unitario Liquido
					AAdd( _aItemPV , { "C6_PRUNIT"  ,SC6->C6_PRUNIT  , Nil }) // Preco Unitario Liquido
					AAdd( _aItemPV , { "C6_ENTREG"  ,SC6->C6_ENTREG  , Nil }) // Data da Entrega
					AAdd( _aItemPV , { "C6_LOJA"   	,SC6->C6_LOJA	 , Nil })
					AAdd( _aItemPV , { "C6_SUGENTR" ,SC6->C6_SUGENTR , Nil }) // Data da Entrega
					AAdd( _aItemPV , { "C6_VALOR"   ,SC6->C6_VALOR   , Nil }) // valor total do item
					AAdd( _aItemPV , { "C6_UM"      ,SC6->C6_UM      , Nil }) // Unidade de Medida Primar.
					AAdd( _aItemPV , { "C6_TES"    	,SC6->C6_TES	 , Nil })
					AAdd( _aItemPV , { "C6_LOCAL"   ,SC6->C6_LOCAL   , Nil }) // Almoxarifado
					AAdd( _aItemPV , { "C6_CF"     	,SC6->C6_CF		 , Nil })
					AAdd( _aItemPV , { "C6_DESCRI"  ,SC6->C6_DESCRI  , Nil }) // Descricao
					AAdd( _aItemPV , { "C6_QTDLIB"  ,SC6->C6_QTDLIB  , Nil }) // Quantidade Liberada
					AAdd( _aItemPV , { "C6_PEDCLI" 	,SC6->C6_PEDCLI	 , Nil })
	
					AAdd( _aItensPV ,_aItemPV )
     
        			SC6->( DBSkip() )
		
				ENDDO
        
				//Exclui o pedido
				_cretorno := xApagaPed(SC5->C5_FILIAL,SC5->C5_NUM)

				aadd(_ACOLS,{cFilPed,;
				cPedExc,;
				_ddtent,;
				_ddtrem,;
				_cclient+"/"+_cloja,;
				POSICIONE("SA1",1,xfilial("SA1")+_cclient+_cloja,"A1_NREDUZ"),;
				_cretorno})

				
			Else

				aadd(_ACOLS,{cFilPed,;
				cPedExc,;
				_ddtent,;
				_ddtrem,;
				_cclient+"/"+_cloja,;
				POSICIONE("SA1",1,xfilial("SA1")+_cclient+_cloja,"A1_NREDUZ"),;
				"Não localizou pedido de venda"})

			EndIf

			TRB01->(Dbskip())

		Enddo

		If len(_ACOLS) > 0

			if  !( ISINCALLSTACK("MDIEXECUTE") .OR. ISINCALLSTACK("SIGAADV") )

				U_MFCONOUT("Completou exclusão de pedidos de venda não atendidos!")

			Else

				U_MGListBox( "Resultado de exclusão de pedidos" , aheader , _ACOLS , .T. , 1 )

			Endif

		Else

			if  !( ISINCALLSTACK("MDIEXECUTE") .OR. ISINCALLSTACK("SIGAADV") )

				U_MFCONOUT("Nenhum pedido excluído!")

			Else

				msgbox("Nenhum pedido excluído!","Atenção")	

			Endif

		Endif

	Else

		if  !( ISINCALLSTACK("MDIEXECUTE") .OR. ISINCALLSTACK("SIGAADV") )

			U_MFCONOUT("Processo cancelado pelo usuário!")

		Else

			msgbox("Processo cancelado pelo usuário!","Atenção")

		Endif

	Endif


Return Nil


/*/{Protheus.doc} xApagaPed (nome da Função)
@descrição Função que executa a exclusão dos pedidos de vendas, via MsExecAuto

@author Fabio Costa
@since 15/08/2019

@version P12.1.017
@country Brasil
@language Português
@chamado/problema PRB0040215-Eliminação-de-residuos-PV
/*/

Static Function xApagaPed(cFilPed,cPed)

	Local cQuery := ""
	Local lMsErroAuto := .F.
	Local _cretorno := "Erro não previsto"

	If  !( ISINCALLSTACK("MDIEXECUTE") .OR. ISINCALLSTACK("SIGAADV") ) 
		_cusuario := "JOB"
	Else
		_cusuario := cusername
	Endif

	cQuery := "SELECT C5_FILIAL, C5_NUM, C5_CLIENTE, C5_LOJACLI, "+CRLF
	cQuery += "       A1_NOME, C5_EMISSAO, C5_ZDTEMBA, C5_PESOL, "+CRLF
	cQuery += "       C5_PBRUTO, C5_FECENT, C5_ZTIPPED "+CRLF
	cQuery += "FROM "+RetSqlName("SC5") + " SC5 "+CRLF
	cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND SC5.D_E_L_E_T_ <> '*' "+CRLF 
	cQuery += "WHERE SC5.D_E_L_E_T_ <> '*' "+CRLF
	cQuery += "AND C5_FILIAL =  '"+cFilPed+"' "+CRLF
	cQuery += "AND C5_NUM = '"+cPed+"' "+CRLF

	Iif(Select("TRB02")>0,TRB02->(dbCloseArea()),Nil)
			
	cQuery := ChangeQuery(cQuery)
			
	TCQuery cQuery New Alias "TRB02"
	TCSetField("TRB02","C5_EMISSAO","D")
	TCSetField("TRB02","C5_FECENT","D")
	TCSetField("TRB02","C5_ZDTEMBA","D")

	dbSelectArea("TRB02")
	TRB02->(dbGoTop())

	While !TRB02->(EoF())

		Begin Transaction

			lMsErroAuto := .F.
			SC5->(Dbsetorder(1))
			If SC5->(Dbseek(cFilPed+cPed))

				cfilori := cfilant
				cfilant := SC5->C5_FILIAL
				Reclock("SC5",.F.)
				MSExecAuto({|x,y,z| Mata410(x,y,z)}, aCab,_aItensPV,5)
				SC5->(Msunlock())
				cfilant := cfilori

			Else

				_cretorno := "Erro na exclusão do pedido - Pedido não localizado"

			Endif


			If lMsErroAuto
				DisarmTransaction()
				aErro := GetAutoGRLog() // Retorna erro em array
				cErro := " "

				for nX := 1 to len(aErro)
					cErro += aErro[nX] + " "
				next nX

				_cretorno := "Erro na exclusão do pedido - " + cErro

			Else 

				SC5->(Dbsetorder(1))
				If SC5->(Dbseek(cFilPed+cPed))
					DisarmTransaction()
					_cretorno := "Erro na exclusão do pedido"

				Elseif _cretorno == "Erro não previsto"
	
					_cretorno := "Pedido excluido com sucesso!"

				Endif

			EndIf

				
		End Transaction

		DBSELECTAREA("ZEI")

		ZEI->(RecLock("ZEI",.T.))
		ZEI->ZEI_FILIAL  := TRB02->C5_FILIAL 
		ZEI->ZEI_PEDIDO  := TRB02->C5_NUM
		ZEI->ZEI_CLIENT  := TRB02->C5_CLIENTE
		ZEI->ZEI_LOJA    := TRB02->C5_LOJACLI
		ZEI->ZEI_RAZAO   := TRB02->A1_NOME
		ZEI->ZEI_EMISSA  := TRB02->C5_EMISSAO
		ZEI->ZEI_EMBARQ  := TRB02->C5_ZDTEMBA
		ZEI->ZEI_ENTREG  := TRB02->C5_FECENT 
		ZEI->ZEI_ESPECI  := TRB02->C5_ZTIPPED
		ZEI->ZEI_PESO    := TRB02->C5_PESOL
		ZEI->ZEI_PESOB   := TRB02->C5_PBRUTO
		ZEI->ZEI_DTEXCL  := Date()
		ZEI->ZEI_CODMOT  := "999999"
		ZEI->ZEI_DESCMO  := "EXCLUIDO VIA ROTINA AUTOMATICA"
		ZEI->ZEI_USER    := _cusuario
		ZEI->ZEI_DATA    := DATE()
		ZEI->ZEI_HORA    := TIME()
		ZEI->ZEI_STATUS  := _cretorno
		ZEI->(MsUnlock())
					
		TRB02->(DbSkip())

	EndDo

	dbSelectArea("TRB02")
	TRB02->(Dbclosearea())

Return _cretorno