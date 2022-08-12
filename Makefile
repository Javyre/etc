PREFIX		=# $(abspath ./test)
CWD		= $(abspath ./)
REVERSE		= no

ifeq ($(REVERSE),yes)
LN		= set -x; _rm() { \
		  	if ! [ -L $(PREFIX)/$$2 ]; then \
				return; \
			else \
				rm $(PREFIX)/$$2; \
			fi \
		}; _rm
PP		= set -x; _rm() { \
		  	rm $(PREFIX)/$$2; \
		}; _rm
else
LN		= set -x; _ln() { \
		  	mkdir -p '$(PREFIX)'"/$$(dirname $$2)" && \
			ln -sfn $$1 $(PREFIX)/$$2; \
		}; _ln
PP		= set -x; _esh() { \
		  	mkdir -p '$(PREFIX)'"/$$(dirname $$2)" && \
			$(CWD)/esh -o $(PREFIX)/$$2 -- $$1 $(TMPL_VARS); \
		}; _esh
endif

TMPL_VARS	= XDGC=$(XDGC) XDGD=$(XDGD) LOGH=$(LOGH) \
		  XDGCACHE=$(XDGCACHE) XDG_RUNTIME_DIR=$(XDG_RUNTIME_DIR)

OS		= $(shell uname -s)
HOSTNAME	= $(shell hostname)
USER 		= $(shell whoami)

ifeq ($(HOSTNAME),jv-mbam2.local)
	XDGC		= $(HOME)/etc
	XDGD		= $(HOME)/.local/share
	LOGH		= $(HOME)/.local/var/log
	XDGCACHE	= $(HOME)/.local/var/cache
	XDG_RUNTIME_DIR	= /tmp/javyre

	XDGC_LINKS	= nvim tmux
	TASKS		= rc bin alacritty xdgc_links launchd_rc
endif

DIRS = $(XDGC) $(XDGD) $(LOGH) $(XDGCACHE) $(XDG_RUNTIME_DIR) 

.PHONY: default
default: $(TASKS)

esh:
	wget https://raw.githubusercontent.com/jirutka/esh/v0.3.2/esh
	chmod u+x esh

.PHONY: rc
.PHONY: launchd_rc
.PHONY: bin
.PHONY: xdgc
.PHONY: alacritty
.PHONY: $(XDGC_LINKS)
.PHONY: xdgc_link

rc: esh
	$(PP) $(CWD)/shell/rc		$(XDGC)/shell/rc
	$(PP) $(CWD)/shell/base-dirs.sh	$(XDGC)/shell/base-dirs.sh
	$(LN) $(CWD)/shell/rc.d		$(XDGC)/shell/rc.d
launchd_rc: esh rc
	$(PP) $(CWD)/jv-rc.plist	$(HOME)/Library/LaunchAgents/jv-rc.plist
bin: rc
	$(LN) $(CWD)/s			$(HOME)/.local/bin/s
alacritty: esh rc
	$(PP) $(CWD)/alacritty.yml 	$(XDGC)/alacritty.yml
$(XDGC_LINKS):
	$(LN) $(CWD)/$@			$(XDGC)/$@
xdgc_links: $(XDGC_LINKS)
