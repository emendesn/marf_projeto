#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*
==========================================================================================
Programa.:              MGFGFE50
Autor....:              Rafael Garcia
Data.....:              01/04/2019
Descricao / Objetivo:   Reenvio Carga para multiembarcador - chamaado pelo P.E. OM200US           
==========================================================================================
*/

user function MGFGFE50()

Local oproc := nil

If MsgYesNo("Confirma Reenvio da Carga "+DAK->DAK_COD+" para obter CTe e MDFe? ")
	fwmsgrun(,{|oproc| MGFGFE50E(oproc)}, "Aguarde...","Validando Carga...")
ELSE
	msgalert("Processo cancelado pelo usuário!")
Endif

return

/*
==========================================================================================
Programa.:              MGFGFE50E
Autor....:              Josué Danich
Data.....:              28/11/2019
Descricao / Objetivo:   Execução de Reenvio Carga para multiembarcador          
==========================================================================================

Alteração : Paulo Henrique - 05/12/2019
Motivo    : Forçar o reenvio da carga fora do JOB pelo usuário, quando necessário
*/
Static Function MGFGFE50E(oproc)

	local _aareaDAI := DAI->(getarea())
	local _aareaSC5 := SC5->(getarea())
	local _aareaSA4 := SA4->(getarea())
	local _aareaSF2 := SF2->(getarea())
	local _aareaZBS := ZBS->(getarea())
	local cQuery:=""
	local _aheader := {"Filial","Carga","Pedido","Status"}
	
	//Valida condições para envio de gatilho
	aitens := {}
	_lerror := .F.
	DAI->(Dbsetorder(1))
			
	If DAI->(Dbseek(DAK->DAK_FILIAL+DAK->DAK_COD))

		_ni := 0

		While DAK->DAK_FILIAL+DAK->DAK_COD == DAI->DAI_FILIAL+DAI->DAI_COD

			_ni++

			if _ni == 1 .and. !(dtos(DAK->DAK_DATA)>=SUPERGETMV("MGF_DGFE46",,"20491231"))
				aadd(aitens, {DAI->DAI_FILIAL,DAI->DAI_COD,DAI->DAI_PEDIDO,"Carga anterior ao golive do multiembarcador (" + SUPERGETMV("MGF_DGFE46",,"20491231") + ")!"})	
				_lerror := .T.
			Endif

			SC5->(Dbsetorder(1)) //C5_FILIAL + C5_NUM

			If SC5->(Dbseek(DAI->DAI_FILIAL+DAI->DAI_PEDIDO))

				If !(SC5->C5_TPFRETE=='C')
					aadd(aitens, {DAI->DAI_FILIAL,DAI->DAI_COD,DAI->DAI_PEDIDO,"Pedido não é CIF!"})	
					_lerror := .T.
				Endif

				SA4->(Dbsetorder(1)) //A4_FILIAL + A4_COD
				If SA4->(Dbseek(xfilial("SA4")+SC5->C5_TRANSP))	.and. !_lerror

					SF2->(Dbsetorder(1)) //F2_FILIAL+F2_DOC
					If SF2->(Dbseek(DAI->DAI_FILIAL+DAI->DAI_NFISCA))	

						ZBS->(Dbsetorder(1)) //ZBS_FILIAL+ZBS_NUM
						If ZBS->(Dbseek(DAI->DAI_FILIAL+DAI->DAI_NFISCA))

						If ZBS->ZBS_STATUS != "S"
							aadd(aitens, {DAI->DAI_FILIAL,DAI->DAI_COD,DAI->DAI_PEDIDO,"Registro de averbação para nota " + alltrim(SF2->F2_DOC) + " não localizado!"})	
							_lerror := .T.	
						Endif

					Endif

					If !(SF2->F2_ZARQXML<>' ')
						aadd(aitens, {DAI->DAI_FILIAL,DAI->DAI_COD,DAI->DAI_PEDIDO,"Nota Fiscal " + alltrim(SF2->F2_DOC) + " não possui XML!"})	
						_lerror := .T.
					Endif
	
					If !(SA4->A4_ZINTMEM ='1')
						aadd(aitens, {DAI->DAI_FILIAL,DAI->DAI_COD,DAI->DAI_PEDIDO,"Transportador " + alltrim(SC5->C5_TRANSP) + " não integra com MultiEmbarcador!"})	
						_lerror := .T.
					Endif

					If len(aitens) < _ni  //Se não incluiu com erro, inclui aqui.

						If empty(DAI->DAI_XPROTO)	
							aadd(aitens, {DAI->DAI_FILIAL,DAI->DAI_COD,DAI->DAI_PEDIDO,"Pedido pronto para reenvio ao multiembarcador"})	
						Else
							aadd(aitens, {DAI->DAI_FILIAL,DAI->DAI_COD,DAI->DAI_PEDIDO,"Pedido enviado ao Multiembarcador com protocolo " + alltrim(DAI->DAI_XPROTO) })		
						Endif

					Endif

				Endif

			ELSEIF !_LERROR

				aadd(aitens, {DAI->DAI_FILIAL,DAI->DAI_COD,DAI->DAI_PEDIDO,"Transportador não localizado!"})	
					_lerror := .T.
			Endif

		ELSE

			aadd(aitens, {DAI->DAI_FILIAL,DAI->DAI_COD,DAI->DAI_PEDIDO,"Pedido não localizado!"})
			_lerror := .T.

		Endif	

		DAI->(Dbskip())

	Enddo
			
ELSE

	aadd(aitens, {DAK->DAK_FILIAL,DAK->DAK_COD,"N/C","Não foram localizados pedidos para a carga!"})
	_lerror := .T.

Endif

If _lerror //Tem erro na carga e não vai reenviar

	U_MGListBox( "Carga não será enviada para Multiembarcador!" , _aheader , aitens , .T. , 1 )
	msgalert("Gatilho de carga não foi enviado!")

Elseif U_MGListBox( "Confirma envio de carga para multiembarcador?" , _aheader , aitens , .T. , 1 ) //Reenvia carga
		
	oproc:ccaption := "Marcando carga para enviar ao multiembarcador..."
	processmessages()

	cQuery := " UPDATE " + RetSqlname("DAK") + " "
	cQuery += " SET 	DAK_XINTME = ' ', "
	cQuery += " DAK_XOPEME='R',"
	cQuery += " DAK_XSTCAN=' '"
	cQuery += " WHERE DAK_FILIAL = '" + DAK->DAK_FILIAL + "' "
	cQuery += "	AND DAK_COD = '" + DAK->DAK_COD + "' "
	cQuery += "	AND D_E_L_E_T_ <> '*' "
	TcSqlExec(cQuery)

	cQuery := " UPDATE " + RetSqlname("SF2") + " "
	cQuery += " SET F2_XSTCANC = ' ' "
	cQuery += " WHERE F2_FILIAL = '" + DAK->DAK_FILIAL + "' "
	cQuery += "	AND F2_DOC||F2_SERIE IN ( SELECT DISTINCT(DAI.DAI_NFISCA||DAI.DAI_SERIE) "
	cQuery += " FROM "+retSQLName("DAI")+" DAI"
	cQuery += " INNER JOIN  "+retSQLName("DAK")+" DAK"
	cQuery += " ON DAK.DAK_COD=DAI.DAI_COD"
	cQuery += " AND DAK.DAK_FILIAL=DAI.DAI_FILIAL"
	cQuery += " AND DAK.D_E_L_E_T_      <>  '*'"
	cQuery += " WHERE DAI.DAI_FILIAL = '" +  DAK->DAK_FILIAL+ "' "
	cQuery += "	AND DAK.DAK_COD = '" +DAK->DAK_COD + "' "
	cQuery += "	AND DAI.D_E_L_E_T_ <> '*' )"
	cQuery += "	AND D_E_L_E_T_ <> '*' "
	TcSqlExec(cQuery)

	cQuery := " UPDATE " + RetSqlname("DAI") + " "
	cQuery += " SET DAI_XINTME = ' ',"
	cQuery += " DAI_XOPEME='R',"
	cQuery += " DAI_XPROTO=' ',"
	cQuery += " DAI_XPROPV=' '"
	cQuery += " WHERE DAI_FILIAL = '" + DAK->DAK_FILIAL + "' "
	cQuery += "	AND DAI_COD IN ( SELECT DISTINCT(DAI.DAI_COD) "
	cQuery += " FROM "+retSQLName("DAI")+" DAI"
	cQuery += " INNER JOIN  "+retSQLName("DAK")+" DAK"
	cQuery += " ON DAK.DAK_COD=DAI.DAI_COD"
	cQuery += " AND DAK.DAK_FILIAL=DAI.DAI_FILIAL"
	cQuery += " AND DAK.D_E_L_E_T_      <>  '*'"
	cQuery += " WHERE DAI.DAI_FILIAL = '" +  DAK->DAK_FILIAL+ "' "
	cQuery += "	AND DAK.DAK_COD = '" +DAK->DAK_COD + "' "
	cQuery += "	AND DAI.D_E_L_E_T_ <> '*' )"
	cQuery += "	AND D_E_L_E_T_ <> '*' "
	TcSqlExec(cQuery)

	msgalert("Gatilho de carga enviado para o MultiEmbarcador!")

Else
	msgalert("Processo cancelado pelo usuário!")	
Endif

DAI->(Restarea(_aareaDAI))
SC5->(Restarea(_aareaSC5))
SA4->(Restarea(_aareaSA4))
SF2->(Restarea(_aareaSF2))

return
