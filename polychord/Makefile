# Object files
# ============
FOBJECTS = $(patsubst %.F90,%.o,$(patsubst %.f90,%.o,$(wildcard *90)))

OBJECTS = $(FOBJECTS)

include makefile.dep

ifortErr = $(shell which ifort >/dev/null; echo $$?)
ifeq "$(ifortErr)" "0"
FFLAGS += -assume noold_maxminloc
endif

AR = ar r

# "make" builds all
all: libchord.a

# The polychord library
libchord.a: $(OBJECTS)
	$(AR) $@ $^

# General rule for building object file (.o)  from fortran files (.f90)
%.o: %.f90
	$(F90C) $(FFLAGS) -c $<

# General rule for building object file (.o)  from fortran files (.F90)
%.o: %.F90
	$(F90C) $(FFLAGS) -c $<

# Utility targets
.PHONY: clean veryclean

clean:
	rm -f *.o *.mod *.MOD libchord.a

veryclean: clean
	rm -f *~ *.a
