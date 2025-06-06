# Пути к MASM 6.14 (используем Wine)
ASSEMBLER = wine Z:\\bin\\ml.exe
ASSEMBLER_FLAGS = /c /coff /Fl /I"Z:\\include"
LINKER = wine Z:\\bin\\link.exe
LINKER_FLAGS = /subsystem:console /LIBPATH:"Z:\\lib"

# Исходники и выходной файл
SOURCES = hello_world.asm
PROGRAM = program.exe

# Автоматическое формирование списков файлов
SOURCES_UTF = $(patsubst %.asm, %.utf8.asm, $(SOURCES))
OBJS = $(patsubst %.asm, %.obj, $(SOURCES))
LISTINGS = $(patsubst %.asm, %.lst, $(SOURCES))

# Основная цель
all: $(PROGRAM)

$(PROGRAM): $(OBJS)
	$(LINKER) $(LINKER_FLAGS) /OUT:"$@" $^

# Правило для сборки .obj из .asm
%.obj: %.asm
	$(ASSEMBLER) $(ASSEMBLER_FLAGS) $<

# Конвертация в UTF-8 (если нужно)
%.utf8.asm: %.asm
	iconv -f cp1251 -t utf8 < $^ > $@

# Вспомогательные цели
convert_to_utf: $(SOURCES_UTF)

clean:
	rm -f $(OBJS) $(LISTINGS) $(PROGRAM) $(SOURCES_UTF)

run:
	wine $(PROGRAM)

.PHONY: all clean run convert_to_utf
