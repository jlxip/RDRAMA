TARGET=rdrama-assembler
GENERATED=y.tab.c lex.yy.c
SOURCES=$(GENERATED) assembler.cpp

$(TARGET): $(SOURCES)
	g++ $(SOURCES) -o $@

y.tab.c: assembler.y
	yacc assembler.y -d

lex.yy.c: assembler.l
	lex $<

.PHONY: clean
clean:
	rm -f $(TARGET) $(GENERATED) y.tab.h
