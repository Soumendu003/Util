SRC = /home/soumendu/newVerilog/
FLAGS = $(TOPFLAGS)
VERSION = -g 
#LIB_TYPE = {static,shared}
LIB_TYPE = $(LIB)
CXX = $(COMPILER)

ifeq ($(LIB_TYPE),shared)
   LIB_EXT = so
else
   LIB_EXT = a
endif

OBJECTS = veri_top.o main.o veri_dot.o

#//###IF PM_HDL_ENCRYPTOR
INCLUDE += hdl_encrypt
LINKDIRS += hdl_encrypt
#//###ENDIF PM_HDL_ENCRYPTOR

#//###IF PM_VERILOG_FILE_SORTER
INCLUDE += verilog_sort
LINKDIRS += verilog_sort
#//###ENDIF PM_VERILOG_FILE_SORTER

#//###IF PM_VHDL_FILE_SORTER
INCLUDE += vhdl_sort
LINKDIRS += vhdl_sort
#//###ENDIF PM_VHDL_FILE_SORTER

#//###IF PM_AUTO_DISCOVERY
INCLUDE += auto_discover
LINKDIRS += auto_discover
#//###ENDIF PM_AUTO_DISCOVERY

#//###IF PM_HDL_FILE_SORTER
INCLUDE += hdl_file_sort
LINKDIRS += hdl_file_sort
#//###ENDIF PM_HDL_FILE_SORTER

#//###IF PM_VERILOG_ANALYZER
INCLUDE += verilog
LINKDIRS += verilog
#//###ENDIF PM_VERILOG_ANALYZER

#//###IF PM_VHDL_ANALYZER
INCLUDE += vhdl
LINKDIRS += vhdl
#//###ENDIF PM_VHDL_ANALYZER

#//###IF PM_HIERARCHY_TREE
INCLUDE += hier_tree
LINKDIRS += hier_tree
#//###ENDIF PM_HIERARCHY_TREE

#//###IF PM_EDIF_READER
INCLUDE += edif
LINKDIRS += edif
#//###ENDIF PM_EDIF_READER

#//###IF PM_VERILOG_NETLIST_READER
INCLUDE += verilog_nl
LINKDIRS += verilog_nl
#//###ENDIF PM_VERILOG_NETLIST_READER

#//###IF PM_SYNLIB_READER
INCLUDE += synlib
LINKDIRS += synlib
#//###ENDIF PM_SYNLIB_READER

#//###IF PM_SDF_READER
INCLUDE += sdf
LINKDIRS += sdf
#//###ENDIF PM_SDF_READER

#//###IF PM_UPF_READER
INCLUDE += upf
LINKDIRS += upf
#//###ENDIF PM_UPF_READER

#//###IF PM_SIMULATION
INCLUDE += simulation
LINKDIRS += simulation
#//###ENDIF SIMULATION

#//###IF (PM_VHDL_RTL_ELABORATOR || PM_VERILOG_RTL_ELABORATOR || PM_SYNLIB_READER || PM_EDIF_READER || PM_SDF_READER || PM_VERILOG_NETLIST_READER)
INCLUDE += database
LINKDIRS += database
#//###ENDIF (PM_VHDL_RTL_ELABORATOR || PM_VERILOG_RTL_ELABORATOR || PM_SYNLIB_READER || PM_EDIF_READER || PM_SDF_READER || PM_VERILOG_NETLIST_READER)



INCLUDE += util containers
LINKDIRS += util containers

HEADERS = 

COMPILEDIRS = 

# 'libxnet' does not seem to be available on older SunOS5 systems.
# so use the finer set of many small .so files.
# 
# -pg version needs -ldl if -xnet is used only.
#
ifeq ($(shell uname),Darwin)
  OS = mac
  EXTLIBS = $(STATIC) -ltcl -ldl -lm -lc
endif
ifeq ($(shell uname),SunOS)
   EXTLIBS = -ldl -lsocket -lnsl -lm -lc
   OS = solaris
endif
ifeq ($(shell uname),Linux)
   EXTLIBS = -ldl -lnsl -lm -lc
   OS = linux
endif
LINKTARGET = test-$(OS)

#//###IF PM_OPEN_ACCESS_WRITER && (PM_VHDL_RTL_ELABORATOR || PM_VERILOG_RTL_ELABORATOR || PM_SYNLIB_READER || PM_EDIF_READER || PM_SDF_READER || PM_VERILOG_NETLIST_READER)
# OpenAccess support.  Compile flag DB_OPEN_ACCESS_WRITER must be enabled (database/DBCompileFlags.h).
#OALIBDIR = /mnt/tools/OpenAccess/lib/linux_rhel21_32/dbg
#EXTLIBS += -L$(OALIBDIR) -loaBaseD -loaCommonD -loaDesignD -loaDMD -loaTechD -loaPlugInD
#//###ENDIF PM_OPEN_ACCESS_WRITER && (PM_VHDL_RTL_ELABORATOR || PM_VERILOG_RTL_ELABORATOR || PM_SYNLIB_READER || PM_EDIF_READER || PM_SDF_READER || PM_VERILOG_NETLIST_READER)

#//###IF PM_SQL_MANAGER
EXTLIBS += -lpthread
#//###ENDIF PM_SQL_MANAGER

##########################################################################
# Stable for each Makefile

CFLAGS = -Wall
CFLAGS += $(FLAGS)

CC = gcc
ifeq ($(CXX),)
    CXX = g++
endif

##########################################################################
# Now the make rules 

default: all

.SUFFIXES: .c .cpp .o 

.cpp.o:
	$(CXX) -c -I. $(patsubst %,-I$(SRC)/%,$(INCLUDE)) $(VERSION) $(CFLAGS) $<

lib:
ifdef ($(COMPILEDIRS)
	for p in $(COMPILEDIRS); do \
		$(MAKE) -C ../../$$p VERSION=$(VERSION)  lib ;\
	done
endif

$(LINKTARGET) : $(OBJECTS) lib 
	$(CXX) $(VERSION) -o $(LINKTARGET) $(OBJECTS) $(patsubst %,$(SRC)/%/*-$(OS).$(LIB_EXT),$(LINKDIRS)) $(EXTLIBS)  $(CFLAGS)

all : $(LINKTARGET) 

# Header file dependency : All my headers, and all included dir's headers
$(OBJECTS) : $(HEADERS) $(patsubst %,$(SRC)/%/*.h,$(INCLUDE)) 
 
clean:
	rm -f $(LINKTARGET) $(OBJECTS)

