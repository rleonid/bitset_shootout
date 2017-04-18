PACKAGES=unix core ppx_jane zarith batteries bitv bitarray ocbitset containers.data core_bench
SETUP_PACKAGE_NAMES=ocamlfind ocamlbuild zarith batteries bitv ocbitset containers

.PHONY: default setup clean

default: create union diff

## TODO: Add custom installations for
## - bitarray
## - ocbitset

setup:
	opam install $(SETUP_PACKAGE_NAMES)

clean:
	ocamlbuild -clean

create:
	ocamlbuild -use-ocamlfind $(foreach package, $(PACKAGES),-package $(package)) -tag thread -I src create.native

union:
	ocamlbuild -use-ocamlfind $(foreach package, $(PACKAGES),-package $(package)) -tag thread -I src union.native

diff:
	ocamlbuild -use-ocamlfind $(foreach package, $(PACKAGES),-package $(package)) -tag thread -I src diff.native
