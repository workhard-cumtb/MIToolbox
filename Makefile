#makefile for MIToolbox
#Author: Adam Pocock, apocock@cs.man.ac.uk
#Created 11/3/2010
#Updated 22/2/2014 - Added make install
#
#
#Copyright 2010 Adam Pocock, The University Of Manchester
#www.cs.manchester.ac.uk
#
#This file is part of MIToolbox.
#
#MIToolbox is free software: you can redistribute it and/or modify
#it under the terms of the GNU Lesser General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#MIToolbox is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU Lesser General Public License for more details.
#
#You should have received a copy of the GNU Lesser General Public License
#along with MIToolbox.  If not, see <http://www.gnu.org/licenses/>.

PREFIX = /usr/local
CFLAGS = -O3 -fPIC -std=c89 -Wall
COMPILER = gcc
objects = ArrayOperations.o CalculateProbability.o Entropy.o \
          MutualInformation.o RenyiEntropy.o RenyiMutualInformation.o \
		  WeightedEntropy.o WeightedMutualInformation.o
          
libMIToolbox.so : $(objects)
	$(COMPILER) $(CFLAGS) -shared -o libMIToolbox.so $(objects) -lm

WeightedMutualInformation.o: WeightedMutualInformation.c MIToolbox.h ArrayOperations.h \
 CalculateProbability.h WeightedEntropy.h
	$(COMPILER) $(CFLAGS) -DCOMPILE_C -c WeightedMutualInformation.c 
 
WeightedEntropy.o: WeightedEntropy.c MIToolbox.h ArrayOperations.h \
 CalculateProbability.h
	$(COMPILER) $(CFLAGS) -DCOMPILE_C -c WeightedEntropy.c

RenyiMutualInformation.o: RenyiMutualInformation.c MIToolbox.h ArrayOperations.h \
 CalculateProbability.h RenyiEntropy.h
	$(COMPILER) $(CFLAGS) -DCOMPILE_C -c RenyiMutualInformation.c 
 
RenyiEntropy.o: RenyiEntropy.c MIToolbox.h ArrayOperations.h \
 CalculateProbability.h
	$(COMPILER) $(CFLAGS) -DCOMPILE_C -c RenyiEntropy.c
 
MutualInformation.o: MutualInformation.c MIToolbox.h ArrayOperations.h \
 CalculateProbability.h Entropy.h MutualInformation.h
	$(COMPILER) $(CFLAGS) -DCOMPILE_C -c MutualInformation.c 
	
Entropy.o: Entropy.c MIToolbox.h ArrayOperations.h CalculateProbability.h \
 Entropy.h
	$(COMPILER) $(CFLAGS) -DCOMPILE_C -c Entropy.c
	
CalculateProbability.o: CalculateProbability.c MIToolbox.h ArrayOperations.h \
 CalculateProbability.h
	$(COMPILER) $(CFLAGS) -DCOMPILE_C -c CalculateProbability.c
	
ArrayOperations.o: ArrayOperations.c MIToolbox.h ArrayOperations.h
	$(COMPILER) $(CFLAGS) -DCOMPILE_C -c ArrayOperations.c
	
.PHONY : debug
debug:
	$(MAKE) libMIToolbox.so "CFLAGS = -g -DDEBUG -fPIC"
	
.PHONY : x86
x86:
	$(MAKE) libMIToolbox.so "CFLAGS = -O3 -fPIC -m32"
	
.PHONY : x64
x64:
	$(MAKE) libMIToolbox.so "CFLAGS = -O3 -fPIC -m64"
	
.PHONY : matlab
matlab:
	mex MIToolboxMex.c MutualInformation.c Entropy.c CalculateProbability.c ArrayOperations.c
	mex RenyiMIToolboxMex.c RenyiMutualInformation.c RenyiEntropy.c CalculateProbability.c ArrayOperations.c
	mex WeightedMIToolboxMex.c WeightedMutualInformation.c WeightedEntropy.c CalculateProbability.c ArrayOperations.c

.PHONY : matlab-debug
matlab-debug:
	mex -g MIToolboxMex.c MutualInformation.c Entropy.c CalculateProbability.c ArrayOperations.c
	mex -g RenyiMIToolboxMex.c RenyiMutualInformation.c RenyiEntropy.c CalculateProbability.c ArrayOperations.c
	mex -g WeightedMIToolboxMex.c WeightedMutualInformation.c WeightedEntropy.c CalculateProbability.c ArrayOperations.c

.PHONY : intel
intel:
	$(MAKE) libMIToolbox.so "COMPILER = icc" "CFLAGS = -O2 -fPIC -xHost"

.PHONY : clean
clean:
	rm *.o 
	rm libMIToolbox.so

.PHONY : install
install:
	$(MAKE)
	@echo "Installing libMIToolbox.so to $(PREFIX)/lib"
	@cp -v libMIToolbox.so $(PREFIX)/lib
	@mkdir -p $(PREFIX)/include/MIToolbox
	@echo "Installing MIToolbox's header files to $(PREFIX)/include/MIToolbox"
	@cp -v MIToolbox.h MutualInformation.h Entropy.h CalculateProbability.h ArrayOperations.h RenyiMutualInformation.h RenyiEntropy.h WeightedMutualInformation.h WeightedEntropy.h $(PREFIX)/include/MIToolbox/
