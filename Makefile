include Makefile.user
include Makefile.config

STENCIL_KERNELS_FILE=stencil_kernels_$(STENCIL).h
STENCIL_KERNELS_FLAG=-DSTENCIL_KERNELS_H=\"$(STENCIL_KERNELS_FILE)\" -DSTENCIL=\"$(STENCIL)\"
ifneq ($(BLOCKSIZEX),)
BLOCKSIZEX_FLAG=-DBLOCKSIZEX=$(BLOCKSIZEX)
endif
ifneq ($(BLOCKSIZEY),)
BLOCKSIZEY_FLAG=-DBLOCKSIZEY=$(BLOCKSIZEY)
endif
ALIGN_FLAG=-DALIGN=$(ALIGN)
LAYOUT_FLAG=-DLAYOUT=$(LAYOUT)
ifeq ($(MCDRAM),CACHE)
MCDRAM_FLAG=-DCACHE_MODE
else
MCDRAM_FLAG=-DFLAT_MODE
endif

CONFIG_FLAGS=$(STENCIL_KERNELS_FLAG) $(BLOCKSIZEX_FLAG) $(BLOCKSIZEY_FLAG) $(ALIGN_FLAG) $(LAYOUT_FLAG) $(MCDRAM_FLAG)

stencil_bench: main.cpp tools.h $(STENCIL_KERNELS_FILE)
	CC $(CONFIG_FLAGS) -std=c++11 -O3 -qopenmp -ffreestanding -DNDEBUG -DJSON_ISO_STRICT $(USERFLAGS) -Igridtools_storage/include -Ilibjson -Llibjson $< -ljson -lmemkind -o $@

.PHONY: clean

clean:
	rm -f stencil_bench

