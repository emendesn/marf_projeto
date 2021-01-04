#ifdef SPANISH
	#define STR0001 ""
#else
	#ifdef ENGLISH
		#define STR0001 ""
	#else
		Static STR0001 := 'TOTVS PDF Printer'
		Static STR0002 := 'Aguardando instrução de impressão'
		Static STR0003 := 'Iniciando servico de impressao remota
		Static STR0004 := 'Terminando servico de impressao remota'
		Static STR0005 := 'Imprimindo'
		Static STR0006 := ' de '
		Static STR0007 := 'Aguardando instrucao de impressao'
		Static STR0008 := 'Preencha o arquivo PDF'
		Static STR0009 := 'Nao existem threads disponiveis para impressao'
		Static STR0010 := 'Threads em espera'
		Static STR0011 := 'Relatorio com '
		Static STR0012 := ' paginas'
		Static STR0013 := 'Enviando impressao'
		Static STR0014 := 'Nao foi possivel enviar o relatorio'
		Static STR0015 := 'Computador'
		Static STR0016 := 'De'      
		Static STR0017 := 'Ate'     
		Static STR0018 := 'Atual'  
		Static STR0019 := '% Concluido'     
		Static STR0020 := 'Impressao terminada, verifique "Mensagem" para possiveis erros...'
		Static STR0021 := 'Arquivo LOG não pode ser criado'
		Static STR0022 := 'Identificado Erro em uma das impressoras'
		Static STR0023 := 'Mensagem'  
		Static STR0024 := 'Rel. Deletado'
		Static STR0025 := 'Impr. Desligada'
		Static STR0026 := 'Termino Papel'
		Static STR0027 := 'Erro na impr.'
		Static STR0028 := 'Impresso'
		Static STR0029 := 'Enviando'  
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := ""
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
