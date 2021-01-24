#XCOMMAND TRY => 	SmTry() ;;
					BEGIN SEQUENCE

#XCOMMAND CATCH [TO <oError>] => 	RECOVER ;;
									[<oError> := ] SmCatch()

#XCOMMAND ENDTRY => END SEQUENCE ;;
					SmEndTry()

#XCOMMAND THROW <cError> => UserException(<cError>)