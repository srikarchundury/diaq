# -*- mode:Makefile -*-
#

CXX	    	:= c++

# Maximum optimization effort: -Ofast -march=native -DNDEBUG
OPTS        	:= -O3 -march=native -DNDEBUG
DEBUG		:= 
PROFILE		:= 
LANG        	:= -std=c++11
PICKY       	:= -Wall
DIAG		:= 
# REPORT	:=  -Rpass=loop-vectorize -Rpass-missed=loop-vectorize
INCLUDES	:= -I../include

VPATH		= ../include:../src

CXXFLAGS	+= $(DEFS) $(XDEFS) $(OPTS) $(DEBUG) $(PROFILE) $(LANG) $(PICKY) $(INCLUDES) $(DIAG)

ifeq (, $(shell which ${CXX}))
  CXX := c++
  ifeq (, $(shell which ${CXX}))
  CXX := g++
  ifeq (, $(shell which ${CXX}))
  CXX := g++-9
  ifeq (, $(shell which ${CXX}))
  $(error "No ${CXX} in $(PATH) -- set CXX to an appropriate compiler in Makefile")
  endif
  endif
  endif
endif

CXXVERSION 	:= $(shell ${CXX} --version | head -1)

ifeq 'g++' '$(findstring g++, $(CXXVERSION))'
  CXXFAM := gnu
endif

ifeq 'clang' '$(findstring clang, $(CXXVERSION))'
  CXXFAM := clang
endif

OS		:= $(shell uname -s)

ifeq ($(OS),Darwin)
ifeq ($(CXXFAM),clang)
  XDEFS         += -Xpreprocessor
  LIBS		+= -lpthread -lomp
endif
ifeq ($(CXXFAM),gnu)
  LIBS		+= -L/usr/local/lib -lomp
endif
endif

XDEFS		+= -fopenmp

ifeq ($(OS),Linux)
ifeq ($(CXXFAM),clang)
	LIBS	+= -lpthread
endif
endif

SOURCES		= $(TARGETS:.exe=.cpp) $(TESTS:.exe=.cpp) 
HEADERS		= $(SOURCES:.cpp=.hpp) $(LINC)
OBJECTS		= $(SOURCES:.cpp=.o)   $(LOBJ)
PCHS		= $(HEADERS:=.gch)

LSRC		:= quantumSparseTensor.h diagonal.h denseTensor.h
LINC		:= $(LSRC:.cpp=.hpp)
XSRC		:= ../src/amath583.cpp ../src/amath583IO.cpp ../src/amath583sparse.cpp
LOBJ		:= $(LSRC:.cpp=.o)

$SHELL		= bash

.PHONY		: defreport optreport clean depend all verify %.test
.SUFFIXES	: .exe .test
.PRECIOUS   	: %.o



test.exe : 