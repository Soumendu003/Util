CXX = g++
CXXFLAGS = -std=c++11 -Wall -g -lpthread

OBJECTS = $(addsuffix .o, $(basename $(wildcard *.cpp)))
HEADERS = $(wildcard *.h)

default: $(OBJECTS)

%.o : %.cpp $(HEADERS)
	$(CXX) $(CXXFLAGS) -c $^

clean:
	rm -rf *.o