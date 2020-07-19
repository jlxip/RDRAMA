TARGET=rdrama-preprocessor
GENERATED=y.tab.c lex.yy.c
SOURCES=$(GENERATED) preprocessor.cpp

$(TARGET): $(SOURCES)
	g++ $(SOURCES) -o $@

y.tab.c: preprocessor.y
	yacc $< -d

lex.yy.c: preprocessor.l
	lex $<

.PHONY: clean
clean:
	rm -f $(GENERATED) $(TARGET) y.tab.h
