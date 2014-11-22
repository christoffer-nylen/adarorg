###############################################################################
# Set PATH to ASIS library below (default corresponds to the case where you
# installed ASIS in the Gnat directory)

ASIS_TOP = /usr/gnat-2012/

###############################################################################
# Depending on your version of ASIS, the ASIS directory  may be split into  
# several directories or not. Uncomment the set of declarations that matches
# your installation (default corresponds to the current versions of GnatPro and
# GnatGPL):

# ASIS_INCLUDE = ${ASIS_TOP}
# ASIS_OBJ = ${ASIS_TOP}
# ASIS_LIB = ${ASIS_TOP}

# ASIS_INCLUDE = ${ASIS_TOP}/src
# ASIS_OBJ = ${ASIS_TOP}/obj
# ASIS_LIB = ${ASIS_TOP}/lib

ASIS_INCLUDE = ${ASIS_TOP}/include/asis
ASIS_OBJ = ${ASIS_TOP}/lib/asis
ASIS_LIB = ${ASIS_TOP}/lib/asis

###############################################################################
# SYSTEM COMMANDS (do not change)

W32_RM   = del /q /s /f
W32_EXT  = .exe
W32_EXEC = 

UNIX_RM  = rm -f
UNIX_EXT =
UNIX_EXEC = ./


###############################################################################
# GNAT options, adjust to your taste

GARGS = -gnatf -gnatwa -aI${ASIS_INCLUDE} -aO${ASIS_OBJ} -g
CARGS = -cargs -O2 -gnatWh -gnat05 -gnato
BARGS = -bargs -E
LARGS = -largs -L${ASIS_LIB} -lasis

###############################################################################
# Choose your system by adding/removing comment tags

#RM  = ${W32_RM}
#EXT = ${W32_EXT}
#EXEC = ${W32_EXEC}

RM  = ${UNIX_RM}
EXT = ${UNIX_EXT}
EXEC = ${UNIX_EXEC}

###############################################################################
# Do not change anything below this line

.PHONY : *

help :
	@echo "---------------------------------------------------------------"
	@echo "--                                                           --"
	@echo "--    make <entry>                                           --"
	@echo "--                                                           --"
	@echo "--    <entry> ::= help       -- print this message           --"
	@echo "--              | build      -- build all executables        --"
	@echo "--              | adarorg    -- build AdaRORG                --"
	@echo "--              | expr       -- build expr                   --"
	@echo "--              | clean      -- delete object files          --"
	@echo "--                                                           --"
	@echo "---------------------------------------------------------------"

build : adarorg adarorg_report filelist

adarorg : mkdir
	@cd src; gnatmake adarorg.adb ${GARGS} ${CARGS} ${CARGS_EXTRA} ${BARGS} ${LARGS}
	@mv src/adarorg bin/

adarorg_report :
	@cd src; gnatmake adarorg_report.adb
	@mv src/adarorg_report bin/

filelist :
	@cd src; gnatmake print_filelist.adb
	@mv src/print_filelist bin/

mkdir :
	@mkdir -p bin

expr:
	gnatmake test/expr*.adb -largs -lasis

expr_1:
	- ${RM} -rf test/*.ror
	@cd test/; ../bin/adarorg original/expr_1.adb -Ioriginal/spec/
	@cd test/; gnatchop -w expr_1.ror;
	@cd test/; gnatmake expr_1.adb -Ioriginal/ -Ioriginal/spec/ -I../src/
expr_2:
	./adarorg test/expr_2.adb
	gnatchop -w expr_2.ror
expr_3:
	./adarorg test/expr_3.adb
	gnatchop -w expr_3.ror
expr_4:
	./adarorg test/expr_4.adb
	gnatchop -w expr_4.ror
expr_5:
	./adarorg test/expr_5.adb
	gnatchop -w expr_5.ror
expr_6:
	./adarorg test/expr_6.adb
	gnatchop -w expr_6.ror
expr_7:
	./adarorg test/expr_7.adb
	gnatchop -w expr_7.ror
expr_8:
	./adarorg test/expr_8.adb
	gnatchop -w expr_8.ror
expr_9:
	./adarorg test/expr_9.adb
	gnatchop -w expr_9.ror
expr_10:
	./adarorg test/expr_10.adb
	gnatchop -w expr_10.ror

clean:	clean_debug
	- ${RM} -rf src/*.o src/*.ali src/b~*
clean_debug:
	- ${RM} -rf *coverage.dat *.adt *.ror filelist.dat