#IFNDEF _FILDFLT_CH
	
	#DEFINE _FILDFLT_CH
	
	/*  
	�������������������������������������������������������������Ŀ
	�Begin Comando de Traducao para as Atualizacoes das  Variaveis�
	�Mv's. 														  �
	���������������������������������������������������������������*/
	#xcommand DEFAULTFIL	<uVar1> := <uVal1> =>;
							<uVar1> := (;
										 __cSvFilAnt := IF( Type("__cSvFilAnt") == "U" , cFilAnt , __cSvFilAnt ),;
							  			 IF( <uVar1> == NIL .or. cFilStatic != __cSvFilAnt , <uVal1>, <uVar1> )	 ;
						 				)
	/*  
	�������������������������������������������������������������Ŀ
	�End  Comando  de Traducao para as Atualizacoes das  Variaveis�
	�Mv's. 														  �
	���������������������������������������������������������������*/			 				

#ENDIF