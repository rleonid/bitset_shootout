PACKAGES=unix core ppx_jane zarith batteries bitv bitarray core_bench 
SETUP_PACKAGE_NAMES=ocamlfind ocamlbuild zarith batteries bitv 

.PHONY: default setup clean

default: create operation

setup:
	opam install $(SETUP_PACKAGE_NAMES)

clean:
	ocamlbuild -clean

create:
	ocamlbuild -use-ocamlfind $(foreach package, $(PACKAGES),-package $(package)) -tag thread -I src create.native

operation:
	ocamlbuild -use-ocamlfind $(foreach package, $(PACKAGES),-package $(package)) -tag thread -I src operation.native

