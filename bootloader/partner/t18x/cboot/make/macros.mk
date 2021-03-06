# Find the local dir of the make file
GET_LOCAL_DIR    = $(patsubst %/,%,$(dir $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))))

# makes sure the target dir exists
MKDIR = if [ ! -d $(dir $@) ]; then mkdir -p $(dir $@); fi

# relative-path from TEGRA_TOP
LOCALIZE_DIR = $(subst $(abspath $(TEGRA_TOP))/,,$(abspath $(1)))

# absolute path to build-dir
TOBUILDDIR = $(abspath $(addprefix $(BUILDDIR)/,$(call LOCALIZE_DIR,$(1))))

COMMA := ,
SPACE :=
SPACE +=

# test if two files are different, replacing the first
# with the second if so
# args: $1 - temporary file to test
#       $2 - file to replace
define TESTANDREPLACEFILE
	if [ -f "$2" ]; then \
		if cmp "$1" "$2"; then \
			rm -f $1; \
		else \
			mv $1 $2; \
		fi \
	else \
		mv $1 $2; \
	fi
endef

# generate a header file at $1 with an expanded variable in $2
define MAKECONFIGHEADER
	$(MKDIR); \
	echo generating $(call LOCALIZE_DIR,$1); \
	rm -f $1.tmp; \
	LDEF=`echo $1 | tr '/\\.-' '_'`; \
	echo \#ifndef __$${LDEF}_H > $1.tmp; \
	echo \#define __$${LDEF}_H >> $1.tmp; \
	for d in `echo $($2) `; do \
		echo "$$d" | sed "s/-/_/g;s/\//_/g;s/\./_/g;s/\//_/g;s/\([^=]\+\)=/#define \U\1\ /" >> $1.tmp; \
	done; \
	echo \#endif >> $1.tmp; \
	$(call TESTANDREPLACEFILE,$1.tmp,$1)
endef
