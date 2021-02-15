REPOS_DIR := repos
LOGS_DIR := logs

REPOS := $(notdir $(wildcard $(REPOS_DIR)/*))
LOGS := $(addprefix $(LOGS_DIR)/, $(addsuffix .txt, $(REPOS)))
LOG_FILE := $(LOGS_DIR)/complete.txt

.PHONY: all
all: $(LOG_FILE) final_logo.png

final_logo.png: logo.svg
	convert $< -resize x50 $@

$(LOG_FILE): $(LOGS)
	cat $^ | sort -n > $@

$(LOGS_DIR)/%.txt: $(REPOS_DIR)/% $(LOGS_DIR)
	gource --output-custom-log $@ $<

$(LOGS_DIR):
	mkdir $@
