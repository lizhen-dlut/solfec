include Config.mak

ifeq ($(OPENGL),yes)
  GLOBJ = \
	obj/bmp.o \
	obj/glv.o \
	obj/rnd.o \
	obj/gl2ps.o 
else
  GLOBJ =
endif

include Flags.mak

CFLAGS = -std=c99 $(POSIX) $(DEBUG) $(PROFILE) $(NOTHROW) $(MEMDEBUG) $(GEOMDEBUG)

LIB = -lm $(LAPACK) $(BLAS) $(GLLIB) $(SPQRLIB) $(UMFPACKLIB) $(PYTHONLIB)

ifeq ($(MPI),yes)
  LIBMPI = -lm $(LAPACK) $(BLAS) $(PYTHONLIB) $(MPILIBS)
endif

EXTO  = obj/fastlz.o\
	obj/csparse.o\

BASEO = obj/err.o \
	obj/alg.o \
	obj/mem.o \
	obj/pck.o \
	obj/map.o \
	obj/set.o \
	obj/ist.o \
	obj/skp.o \
	obj/svk.o \
	obj/mtx.o \
	obj/tms.o \
	obj/xyt.o \
	obj/dyr.o \
	obj/swp.o \
	obj/hsh.o \
	obj/gjk.o \
	obj/hul.o \
	obj/tri.o \
	obj/cvi.o \
	obj/spx.o \
	obj/cvx.o \
	obj/hyb.o \
	obj/msh.o \
	obj/sph.o \
	obj/shp.o \
	obj/sps.o \
	obj/mat.o \
	obj/goc.o \
	obj/cmp.o \
	obj/lss.o \
	obj/libsolfec.o \

OBJ =   $(EXTO)   \
        $(BASEO)  \
	obj/pbf.o \
	obj/box.o \
	obj/bod.o \
	obj/ldy.o \
	obj/bgs.o \
	obj/pes.o \
	obj/nts.o \
	obj/gls.o \
	obj/lin.o \
	obj/mrf.o \
	obj/glu.o \
	obj/dom.o \
	obj/dio.o \
	obj/lng.o \
	obj/sol.o \
	obj/fem.o \
	$(GLOBJ)

OBJMPI = $(EXTO)       \
         $(BASEO)      \
	 obj/pbf-mpi.o \
	 obj/put-mpi.o \
	 obj/box-mpi.o \
	 obj/bod-mpi.o \
	 obj/ldy-mpi.o \
	 obj/bgs-mpi.o \
	 obj/pes-mpi.o \
	 obj/nts-mpi.o \
	 obj/gls-mpi.o \
	 obj/lin-mpi.o \
	 obj/mrf-mpi.o \
	 obj/glu-mpi.o \
	 obj/dom-mpi.o \
	 obj/dio-mpi.o \
	 obj/lng-mpi.o \
	 obj/com-mpi.o \
	 obj/sol-mpi.o \
	 obj/fem-mpi.o \

solfec: obj/solfec.o obj/libsolfec.a obj/libkrylov.a 
	$(CC) $(PROFILE) -o $@ $< -Lobj -lsolfec -lkrylov $(LIB)

obj/libkrylov.a:
	(cd ext/krylov && make)

obj/libsolfec.a: $(OBJ)
	ar rcv $@ $(OBJ)
	ranlib $@ 

ifeq ($(MPI),yes)

all: solfec mpi

mpi: solfec-mpi

solfec-mpi: obj/solfec-mpi.o obj/libsolfec-mpi.a obj/libkrylov.a 
	$(MPICC) $(PROFILE) -o $@ $< -Lobj -lsolfec-mpi -lkrylov $(LIBMPI)

obj/libsolfec-mpi.a: $(OBJMPI)
	ar rcv $@ $(OBJMPI)
	ranlib $@ 

else

all: solfec

endif

test: solfec
	make del
	./solfec inp/tests/serial-tests.py

del:
	rm -fr out/*

clean:
	rm -f solfec
	rm -f solfec-mpi
	rm -fr out/*
	rm -f core obj/*.o
	rm -f obj/*.a
	rm -fr *dSYM
	(cd tst && make clean)
	(cd ext/krylov && make clean)

obj/solfec.o: solfec.c
	$(CC) $(CFLAGS) $(OPENGL) -c -o $@ $<

obj/fastlz.o: ext/fastlz.c ext/fastlz.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/csparse.o: ext/csparse.c ext/csparse.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/err.o: err.c err.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/alg.o: alg.c alg.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/mem.o: mem.c mem.h err.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/pck.o: pck.c pck.h err.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/map.o: map.c map.h mem.h err.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/skp.o: skp.c skp.h mem.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/set.o: set.c set.h mem.h err.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/ist.o: ist.c ist.h mem.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/pbf.o: pbf.c pbf.h map.h mem.h err.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/svk.o: svk.c svk.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/mtx.o: mtx.c mtx.h bla.h lap.h err.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/tms.o: tms.c tms.h mem.h err.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/xyt.o: xyt.c xyt.h mem.h err.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/dyr.o: dyr.c dyr.h xyt.h box.h alg.h mem.h err.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/swp.o: swp.c swp.h dyr.h xyt.h box.h alg.h mem.h err.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/hsh.o: hsh.c hsh.h box.h alg.h mem.h err.h lis.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/gjk.o: gjk.c gjk.h alg.h err.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/hul.o: hul.c hul.h mem.h alg.h err.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/tri.o: tri.c tri.h mem.h err.h map.h set.h alg.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/cvi.o: cvi.c cvi.h tri.h hul.h alg.h gjk.h err.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/spx.o: spx.c spx.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/cvx.o: cvx.c cvx.h spx.h err.h alg.h hyb.h gjk.h mot.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/hyb.o: hyb.c hyb.h box.h err.h alg.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/box.o: box.c box.h bod.h hyb.h mem.h map.h set.h err.h alg.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/msh.o: msh.c msh.h cvx.h spx.h mem.h map.h err.h alg.h mot.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/sph.o: sph.c sph.h spx.h mem.h map.h err.h alg.h mot.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/shp.o: shp.c shp.h cvx.h msh.h sph.h err.h mot.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/bod.o: bod.c bod.h shp.h mtx.h pbf.h mem.h alg.h map.h err.h bla.h lap.h mat.h but.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/dom.o: dom.c dom.h dio.h bod.h pbf.h mem.h map.h set.h err.h box.h ldy.h sps.h mat.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/dio.o: dio.c dio.h dom.h cmp.h bod.h pbf.h mem.h map.h set.h err.h box.h ldy.h sps.h mat.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/ldy.o: ldy.c ldy.h bod.h mem.h map.h set.h err.h dom.h sps.h mtx.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/bgs.o: bgs.c bgs.h dom.h ldy.h err.h alg.h lap.h mrf.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/pes.o: pes.c pes.h dom.h ldy.h err.h alg.h lap.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/nts.o: nts.c nts.h lin.h dom.h ldy.h err.h alg.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/gls.o: gls.c gls.h dom.h bod.h alg.h mtx.h lap.h bla.h err.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/lin.o: lin.c lin.h dom.h ldy.h err.h alg.h lap.h bla.h lss.h
	$(CC) $(CFLAGS) $(SPQR) $(UMFPACK) -c -o $@ $<

obj/mrf.o: mrf.c mrf.h dom.h ldy.h err.h alg.h lap.h bla.h
	$(CC) $(CFLAGS) $(SPQR) $(UMFPACK) -c -o $@ $<

obj/glu.o: glu.c glu.h dom.h ldy.h err.h alg.h lap.h bla.h lss.h
	$(CC) $(CFLAGS) $(SPQR) $(UMFPACK) -c -o $@ $<

obj/sps.o: sps.c sps.h mem.h set.h map.h dom.h err.h alg.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/mat.o: mat.c mat.h mem.h map.h err.h alg.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/goc.o: goc.c goc.h shp.h cvi.h box.h alg.h err.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/cmp.o: cmp.c cmp.h alg.h err.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/libsolfec.o: solfec.c solfec.h
	$(CC) -DLIBSOLFEC $(CFLAGS) -c -o $@ $<

obj/fem.o: fem.c fem.h bod.h shp.h msh.h mat.h alg.h err.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/lss.o: lss.c lss.h mem.h ist.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/lng.o: lng.c lng.h sol.h dom.h box.h sps.h cvx.h sph.h msh.h shp.h
	$(CC) $(CFLAGS) $(OPENGL) $(PYTHON) -c -o $@ $<

obj/sol.o: sol.c sol.h lng.h dom.h box.h sps.h cvx.h sph.h msh.h shp.h err.h alg.h tms.h bgs.h pes.h nts.h gls.h mat.h pbf.h tmr.h
	$(CC) $(CFLAGS) -c -o $@ $<
# OPENGL

obj/glv.o: glv.c glv.h bmp.h err.h
	$(CC) $(CFLAGS) $(OPENGL) -c -o $@ $<

obj/bmp.o: bmp.c bmp.h
	$(CC) $(CFLAGS) -c -o $@ $<

obj/rnd.o: rnd.c rnd.h alg.h dom.h shp.h cvx.h msh.h sph.h err.h
	$(CC) $(CFLAGS) $(OPENGL) -c -o $@ $<

obj/gl2ps.o: ext/gl2ps.c ext/gl2ps.h
	$(CC) $(CFLAGS) -c -o $@ $<

#MPI

obj/solfec-mpi.o: solfec.c
	$(MPICC) $(CFLAGS) $(MPIFLG) -c -o $@ $<

obj/put-mpi.o: put.c put.h alg.h err.h
	$(MPICC) $(CFLAGS) $(MPIFLG) -c -o $@ $<

obj/com-mpi.o: com.c com.h map.h alg.h err.h
	$(MPICC) $(CFLAGS) $(MPIFLG) -c -o $@ $<

obj/pbf-mpi.o: pbf.c pbf.h map.h mem.h err.h
	$(MPICC) $(CFLAGS) $(MPIFLG) -c -o $@ $<

obj/box-mpi.o: box.c box.h hyb.h mem.h map.h set.h err.h alg.h
	$(MPICC) $(CFLAGS) $(MPIFLG) -c -o $@ $<

obj/bod-mpi.o: bod.c bod.h shp.h mtx.h pbf.h mem.h alg.h map.h err.h bla.h lap.h mat.h but.h
	$(MPICC) $(CFLAGS) $(MPIFLG) -c -o $@ $<

obj/dom-mpi.o: dom.c dom.h dio.h bod.h pbf.h mem.h map.h set.h err.h box.h ldy.h sps.h mat.h
	$(MPICC) $(CFLAGS) $(MPIFLG) -c -o $@ $<

obj/dio-mpi.o: dio.c dio.h dom.h cmp.h bod.h pbf.h mem.h map.h set.h err.h box.h ldy.h sps.h mat.h
	$(MPICC) $(CFLAGS) $(MPIFLG) -c -o $@ $<

obj/ldy-mpi.o: ldy.c ldy.h bod.h mem.h map.h set.h err.h dom.h sps.h
	$(MPICC) $(CFLAGS) $(MPIFLG) -c -o $@ $<

obj/bgs-mpi.o: bgs.c bgs.h dom.h ldy.h err.h alg.h lap.h mrf.h
	$(MPICC) $(CFLAGS) $(MPIFLG) -c -o $@ $<

obj/pes-mpi.o: pes.c pes.h dom.h ldy.h err.h alg.h lap.h
	$(MPICC) $(CFLAGS) $(MPIFLG) -c -o $@ $<

obj/nts-mpi.o: nts.c nts.h lin.h dom.h ldy.h err.h alg.h lap.h
	$(MPICC) $(CFLAGS) $(MPIFLG) -c -o $@ $<

obj/gls-mpi.o: gls.c gls.h dom.h bod.h alg.h mtx.h lap.h bla.h err.h
	$(MPICC) $(CFLAGS) $(MPIFLG) -c -o $@ $<

obj/lin-mpi.o: lin.c lin.h dom.h ldy.h err.h alg.h lap.h bla.h lss.h
	$(MPICC) $(CFLAGS) $(MPIFLG) $(SPQR) $(UMFPACK) $(HYPREINC) -c -o $@ $<

obj/mrf-mpi.o: mrf.c mrf.h dom.h ldy.h err.h alg.h lap.h bla.h
	$(MPICC) $(CFLAGS) $(MPIFLG) $(SPQR) $(UMFPACK) $(HYPREINC) -c -o $@ $<

obj/glu-mpi.o: glu.c glu.h dom.h ldy.h err.h alg.h lap.h bla.h lss.h
	$(MPICC) $(CFLAGS) $(MPIFLG) $(SPQR) $(UMFPACK) $(HYPREINC) -c -o $@ $<

obj/lng-mpi.o: lng.c lng.h sol.h dom.h box.h sps.h cvx.h sph.h msh.h shp.h
	$(MPICC) $(CFLAGS) $(PYTHON) $(MPIFLG) -c -o $@ $<

obj/sol-mpi.o: sol.c sol.h lng.h dom.h box.h sps.h cvx.h sph.h msh.h shp.h err.h alg.h tms.h bgs.h pes.h nts.h gls.h mat.h pbf.h tmr.h lin.h
	$(MPICC) $(CFLAGS) $(MPIFLG) -c -o $@ $<

obj/fem-mpi.o: fem.c fem.h bod.h shp.h msh.h mat.h alg.h err.h
	$(MPICC) $(CFLAGS) $(MPIFLG) -c -o $@ $<
