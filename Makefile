PWD := $(shell pwd)

.PHONY: all
all:
	bear -a -o temp.json $(MAKE) -C $(KDIR) ARCH=arm64 M=$(PWD) modules

.PHONY: clean
clean:
	make -C $(KDIR) ARCH=arm64 M=$(PWD) clean
	rm -f compile_commands.json
