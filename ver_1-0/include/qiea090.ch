#ifdef SPANISH
	#define STR0001 "Confirmar"
	#define STR0002 "Reescribir"
	#define STR0003 "Anular"
	#define STR0004 "B&uscar  "
	#define STR0005 "Visualizar"
	#define STR0006 "Incluir"
	#define STR0007 "Modificar"
	#define STR0008 "Borrar "
	#define STR0009 "Skip-Test individual"
	#define STR0011 "El Skip-Test referente al ensayo esta definido por grupo."
	#define STR0012 "Atencion"
	#define STR0013 "Valor invalido del Skip-Teste para el (los) ensayo(s):"
	#define STR0014 "No se ubic� el v�nculo del producto con el proveedor."
#else
	#ifdef ENGLISH
		#define STR0001 "OK      "
		#define STR0002 "Retype  "
		#define STR0003 "Quit    "
		#define STR0004 "Search   "
		#define STR0005 "View      "
		#define STR0006 "Insert "
		#define STR0007 "Edit   "
		#define STR0008 "Delete "
		#define STR0009 "Individual Skip-Test "
		#define STR0011 "The Skip-Test refering to the test is defined per group."
		#define STR0012 "Attention"
		#define STR0013 "Skip-Test Invalid Value for the test(s):"
		#define STR0014 "No binding of product with supplier was located."
	#else
		#define STR0001 "Confirma"
		#define STR0002 "Redigita"
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Abandonar", "Abandona" )
		#define STR0004 "Pesquisar"
		#define STR0005 "Visualizar"
		#define STR0006 "Incluir"
		#define STR0007 "Alterar"
		#define STR0008 "Excluir"
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Skip-teste Individual", "Skip-Teste Individual" )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "O ignorar teste referente a ensaio est� definido por grupo.", "O Skip-Teste referente a ensaio est� definido por grupo." )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Aten��o", "Aten��o" )
		#define STR0013 "Valor inv�lido do Skip-Teste para o(os) ensaio(os):"
		#define STR0014 "N�o foi localizado amarra��o do produto com fornecedor."
	#endif
#endif
