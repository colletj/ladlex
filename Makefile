CFLAGS = -Wall -Wextra -ggdb3 -Wno-unused-function
YFLAGS = -v -d


OBJ_PRE = pre-proc-lexer.o
.INTERMEDIATE: $(OBJECTS)

pre-proc: $(OBJ_PRE)
	gcc $^ -o $@


.PHONY: clean
clean:
	@rm -f pre-proc pre-proc-lexer.o
	@rm -f y.tab.h y.output
	@rm -f *~
