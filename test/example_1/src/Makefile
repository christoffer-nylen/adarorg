all : build run

run : build
	@cd src; gnatmake adarorg_report.adb
	@mv src/adarorg_report bin/

build : mkdir
	@cd system_under_test; adarorg original/sut.adb; gnatchop -w sut.ror
	@cd test; gnatmake main.adb -I../system_under_test
	@mv test/main bin/

mkdir :
	@mkdir -p bin

filelist :
	@cd src; gnatmake print_filelist.adb
	@mv src/print_filelist bin/

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