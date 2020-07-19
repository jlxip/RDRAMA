PRE=preprocessor
PREBIN=rdrama-preprocessor
RES=resolver
RESBIN=rdrama-resolver
ASM=assembler
ASMBIN=rdrama-assembler

TARGETS=$(PRE)/$(PREBIN) $(RES)/$(RESBIN) $(ASM)/$(ASMBIN)

.PHONY: all install uninstall clean

all: $(TARGETS)

install: all
	cp -v $(PRE)/$(PREBIN) /bin/$(PREBIN)
	cp -v $(RES)/$(RESBIN) /bin/$(RESBIN)
	cp -v $(ASM)/$(ASMBIN) /bin/$(ASMBIN)
	cp -v rdrama.sh /bin/rdrama

uninstall:
	rm -v /bin/$(PREBIN)
	rm -v /bin/$(RESBIN)
	rm -v /bin/$(ASMBIN)
	rm -v /bin/rdrama

$(PRE)/$(PREBIN): $(PRE)
	cd $< && $(MAKE) && cd ..

$(RES)/$(RESBIN): $(RES)
	cd $< && $(MAKE) && cd ..

$(ASM)/$(ASMBIN): $(ASM)
	cd $< && $(MAKE) && cd ..

clean:
	cd $(PRE) && $(MAKE) clean && cd ..
	cd $(RES) && $(MAKE) clean && cd ..
	cd $(ASM) && $(MAKE) clean && cd ..
