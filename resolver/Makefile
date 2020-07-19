TARGET=rdrama-resolver
GENERATED=y.tab.c lex.yy.c
SOURCES=$(GENERATED) resolver.cpp

$(TARGET): $(SOURCES)
	g++ $(SOURCES) -o $@

y.tab.c: resolver.y
	yacc $< -d

lex.yy.c: resolver.l
	lex $<

.PHONY: clean
clean:
	rm -f $(GENERATED) $(TARGET) y.tab.h
