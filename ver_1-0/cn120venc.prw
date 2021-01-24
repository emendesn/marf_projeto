#include "protheus.ch"

//��������������������������������������������������Ŀ
//�Ponto de entrada para validar o encerramento da   �
//�medicao                                           �
//����������������������������������������������������
user function CN120VENC()
	local lRet := .T.

	if isInCallStack("MATA460")
		return lRet
	endif

	if isInCallStack("MATA410") // Pedido de Venda
		return lRet
	endif

	if isInCallStack("MATA460A") // DOCUMENTO DE SAIDA E OMS
		return lRet
	endif

	if isInCallStack("MATA460B") // DOCUMENTO DE SAIDA - OMS
		return lRet
	endif

	if findFunction("U_cntVerCC")
		lRet := U_cntVerCC()
	endif

	if lRet .and. findFunction("U_xM10vGrd") .and. !(isInCallStack("MATA460B")) .and. !Empty(CND->CND_FORNEC)
		cCC := u_getCCCnt()
		lRet := U_xM10vGrd(cCC)
		if !lRet
			msgAlert('N�o existe grade para Pedido cadastrado para este CENTRO DE CUSTO .Esse PC n�o ser� gravado. Entre em contato com o respons�vel pelo cadastramento da grade e informe esta mensagem.')
		endif
	endif

	// MATA121 - Pedido de Compra
	// MATA410 - Pedido de Venda
return lRet