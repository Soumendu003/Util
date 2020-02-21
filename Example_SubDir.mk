VERSION = -O 
TFLAGS = $(TOPFLAGS)
FLAGS = $(PFLAGS)
LIB_TYPE = $(LIB)
CXX = $(COMPILER)
LINK = $(LINKER)
RL = $(RANLIB)
 
############################ INCLUDE DIRECTORIES ################################
#//###IF PM_VHDL_ANALYZER 
INCLUDE += vhdl
#//###ENDIF PM_VHDL_ANALYZER
#//###IF PM_HIERARCHY_TREE
INCLUDE += hier_tree
#//###ENDIF PM_HIERARCHY_TREE
#//###IF PM_SDF_READER
INCLUDE += sdf
#//###ENDIF PM_SDF_READER
#//###IF (PM_VERILOG_RTL_ELABORATOR || PM_VHDL_RTL_ELABORATOR || PM_VERILOG_NETLIST_READER || PM_SYNLIB_READER || PM_EDIF_READER)
INCLUDE += database
#//###ENDIF (PM_VERILOG_RTL_ELABORATOR || PM_VHDL_RTL_ELABORATOR || PM_VERILOG_NETLIST_READER || PM_SYNLIB_READER || PM_EDIF_READER)
INCLUDE += containers util

############################ OBJECT/HEADER FILES ################################

# Analysis Object Files
OBJECTS = veri_yacc.o veri_lex.o veri_file.o VeriExpression.o  VeriMisc.o \
	  VeriModuleItem.o VeriTreeNode.o VeriId.o VeriModule.o VeriStatement.o   \
	  VeriConstVal.o VeriScope.o VeriVisitor.o VeriLibrary.o VeriPrettyPrint.o \
          VeriVarUsage.o VeriCopy.o VeriReplace.o VeriExplicitStateMachine.o \
          VeriCrossLanguageConversion.o VeriPrintIPXACT.o

# Analysis Header Files
HEADERS = VeriExpression.h VeriMisc.h VeriModuleItem.h VeriTreeNode.h \
          veri_file.h VeriId.h VeriModule.h VeriStatement.h VeriConstVal.h \
	  VeriScope.h VeriClassIds.h VeriVisitor.h veri_tokens.h VeriCompileFlags.h \
	  VeriLibrary.h VeriVarUsage.h VeriCopy.h VeriExplicitStateMachine.h VeriRuntimeFlags.h


#//###IF PM_VERILOG_ASSERTION_SYNTHESIS
# Assertion Synthesis Object Files
OBJECTS += VeriAssertionSynthesis.o
#//###ENDIF PM_VERILOG_ASSERTION_SYNTHESIS


#//###IF PM_VERILOG_STATIC_ELABORATOR
# Static Elaboration Object Files
OBJECTS += VeriElab_Stat.o VeriExprWidth_Stat.o \
	  VeriExprEval_Stat.o  VeriGenElab_Stat.o \
	  VeriUtil_Stat.o VeriBaseValue_Stat.o veri_file_Stat.o  

# Static Elaboration Header Files
HEADERS += VeriElab_Stat.h VeriUtil_Stat.h VeriBaseValue_Stat.h 

#//###ENDIF PM_VERILOG_STATIC_ELABORATOR

#//###IF PM_VERILOG_RTL_ELABORATOR
# RTL Elaboration Object Files
OBJECTS += veri_file_Elab.o VeriExpression_Elab.o VeriMisc_Elab.o VeriModuleItem_Elab.o  \
  	   VeriTreeNode_Elab.o VeriId_Elab.o VeriModule_Elab.o VeriStatement_Elab.o  \
	   VeriConstVal_Elab.o VeriValue_Elab.o VeriDataFlow_Elab.o VeriScope_Elab.o 

# RTL Elaboration Header Files
HEADERS += VeriValue_Elab.h VeriDataFlow_Elab.h

#//###ENDIF PM_VERILOG_RTL_ELABORATOR


#//###IF PM_VERILOG_PSL_ANALYZER
# PSL Analysis Object Files
OBJECTS += VeriPslDeclaration.o VeriPslDirective.o VeriPslExpression.o VeriPslId.o \
           VeriPslProperty.o VeriPslUnit.o

# PSL Analysis Header Files
HEADERS += VeriPslDeclaration.h VeriPslDirective.h VeriPslExpression.h VeriPslId.h \
           VeriPslProperty.h VeriPslUnit.h 

#//###IF PM_VERILOG_RTL_ELABORATOR
# PSL RTL Elaboration Object Files
OBJECTS += VeriPslDirective_Elab.o VeriPslProperty_Elab.o VeriPslDeclaration_Elab.o \
	   VeriPslExpression_Elab.o VeriPslId_Elab.o VeriPslValue_Elab.o VeriPslUnit_Elab.o

# PSL RTL Elaboration Header Files
HEADERS += VeriPslValue_Elab.h

#//###ENDIF PM_VERILOG_RTL_ELABORATOR
#//###ENDIF PM_VERILOG_PSL_ANALYZER

#//###IF PM_VERILOG_AMS_ANALYZER
# AMS Analysis Object Files
OBJECTS += VeriAmsExpression.o  VeriAmsId.o  VeriAmsMisc.o  VeriAmsModuleItem.o \
           VeriAmsStatement.o

# AMS Analysis Header Files
HEADERS += VeriAmsExpression.h  VeriAmsId.h  VeriAmsMisc.h  VeriAmsModuleItem.h \
           VeriAmsStatement.h

#//###ENDIF PM_VERILOG_AMS_ANALYZER

#//###IF PM_BIT_LEVEL_ANALYSIS
# Bit level analysis object files
OBJECTS += VeriBitLevelAnalysis.o

HEADERS += VeriBitLevelAnalysis.h
#//###ENDIF PM_BIT_LEVEL_ANALYSIS
#//###IF PM_VERILOG_BINARY_SAVERESTORE
# Binary Save/Restore Object Files
OBJECTS += VeriBinarySaveRestore.o

#//###ENDIF PM_VERILOG_BINARY_SAVERESTORE

######################### STABLE FOR EACH MAKEFILE #######################

LIB_EXT = so
ifeq ($(shell uname),Darwin)
   OS = mac
   LIB_EXT = dylib
endif
ifeq ($(strip $(shell uname)),SunOS)
   OS = solaris
endif
ifeq ($(strip $(shell uname)),Linux)
   OS = linux
endif

ifeq ($(CXX),)
    CXX = g++
endif

#//###IF PM_WARNINGS
ifeq ($(WFLAGS),)
    WFLAGS = -Wall -Wshadow
    ifeq ($(shell expr `$(CXX) -dumpversion` \>= 3.4),1)
        WFLAGS += -Wextra
    endif
    ifeq ($(shell expr `$(CXX) -dumpversion` \>= 4.2),1)
        WFLAGS += -Waddress
    endif
endif
#//###ENDIF PM_WARNINGS
CFLAGS = $(TFLAGS)
CFLAGS += $(WFLAGS)
CFLAGS += $(PFLAGS)

ifeq ($(LIB_TYPE),shared)
   TARGET = libverilog-$(OS).$(LIB_EXT)
   CFLAGS += -fPIC
else
   TARGET = verilog-$(OS).a
endif

ifeq ($(LINK),)
   LINK = ar
endif
ifeq ($(RL),)
   RL = ranlib
endif

############################ RULE DEFINITIONS ############################
default: lib

.SUFFIXES: .cpp .o 

.cpp.o:
	$(CXX) -c -I. $(patsubst %,-I../%,$(INCLUDE)) $(VERSION) $(CFLAGS) $<

lexyacc : veri_yacc.cpp veri_lex.cpp 

depend:
	makedepend -Y $(patsubst %,-I../%,$(INCLUDE)) $(OBJECTS:.o=.cpp) 2>/dev/null

veri_yacc.cpp: verilog.y
	@ # Call Bison, (with -b option) so that generated .c/.h files have predictable names across versions.
	bison -y -v -d -l -p veri -b veri_yacc verilog.y
	mv veri_yacc.tab.c veri_yacc.cpp
	mv veri_yacc.tab.h veri_yacc.h

veri_lex.cpp: verilog.l
	flex -Pveri -L -overi_lex.cpp verilog.l
	@ # Comment out POSIX-only include
	@ sed -e 's/#include <unistd\.h>/\/\/#include <unistd\.h> \/\/ Needed for POSIX only/' veri_lex.cpp > .veri_lex.tmp
	@ mv .veri_lex.tmp veri_lex.cpp

ifeq ($(LIB_TYPE),shared)
$(TARGET) : $(OBJECTS)
    ifeq ($(shell uname),Darwin)
	$(CXX) -shared -Wl,-undefined,dynamic_lookup,-install_name,$(TARGET) -o $(TARGET) $(OBJECTS) $(CFLAGS)
    else
	$(CXX) -shared -Wl,-soname,$(TARGET) -o $(TARGET) $(OBJECTS) $(CFLAGS)
    endif
else
$(TARGET) : $(OBJECTS)
	$(LINK) -r $(TARGET) $(OBJECTS)
	$(RL) $(TARGET)
endif

lib : $(TARGET)

# Object Build file dependency : All my headers, and all included dir's headers
$(OBJECTS) : $(HEADERS) $(patsubst %,../%/*.h,$(INCLUDE))

clean :
	rm -f $(OBJECTS) $(TARGET) *.a *.$(LIB_EXT)

clean_lexyacc :
	rm -f *_lex* *_yacc*

# LINT SUPPORT BEGIN --------------------------------
.SUFFIXES: .lob
PROJECT = verilog
LOBS = $(subst .o,.lob,$(OBJECTS))

.cpp.lob : 
	- flexelint -zero -b -u $(PROJECT).lnt +os\($(PROJECT).lnt.out\) -oo $<

flint : remove_lnt_out $(LOBS)
	- flexelint -zero -b $(PROJECT).lnt +os\($(PROJECT).lnt.out\) $(LOBS)
	@ cat $(PROJECT).lnt.out

pclp : remove_lnt_out $(OBJECTS)
	- pclp -b $(PROJECT).lnt -os\($(PROJECT).lnt.out\) $(subst .o,.cpp,$(OBJECTS))
	@ cat $(PROJECT).lnt.out

$(LOBS) : $(subst .o,.cpp,$(OBJECTS)) $(HEADERS) $(patsubst %,../%/*.h,$(INCLUDE)) $(PROJECT).lnt ../verific.lnt

remove_lnt_out : 
	rm -f $(PROJECT).lnt.out

clean_flint :
	rm -f *.lob $(PROJECT).lnt.out
# LINT SUPPORT END ----------------------------------

