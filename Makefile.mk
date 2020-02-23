CXX = g++
CXXFLAGS = -std=c++11 -Wall -g -lpthread
SRC = $(shell pwd)
COPY_DIR = $(CLONE)

OBJECTS = $(addsuffix .o, $(basename $(wildcard *.cpp)))
HEADERS = $(wildcard *.h)
SOURCES = $(wildcard *.cpp)
CLONES = $(addprefix $(COPY_DIR)/, $(SOURCES)) $(addprefix $(COPY_DIR)/, $(HEADERS))

default: $(OBJECTS)

update: $(CLONES)

%.o : %.cpp $(HEADERS)
	$(CXX) $(CXXFLAGS) -c $^

$(COPY_DIR)/%.cpp : %.cpp
ifneq ($(COPY_DIR),)
	cp $^ $(COPY_DIR)/.
endif

$(COPY_DIR)/%.h : %.h 
ifneq ($(COPY_DIR),)
	cp $^ $(COPY_DIR)/.
endif

clean:
	rm -rf *.o