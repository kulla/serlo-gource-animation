REPOS_DIR := repos
LOGS_DIR := logs

REPOS := $(notdir $(wildcard $(REPOS_DIR)/*))
LOGS := $(addprefix $(LOGS_DIR)/, $(addsuffix .raw.txt, $(REPOS)))
LOGS_SHORTEN := $(addprefix $(LOGS_DIR)/, $(addsuffix .shorten.txt, $(REPOS)))
LOG_FILE := $(LOGS_DIR)/complete.txt

.PHONY: all
all: $(LOG_FILE) final_logo.png

final_logo.png: logo.svg
	convert $< -resize x50 $@

$(LOG_FILE): $(LOGS_SHORTEN)
	cat $^ | sort -n > $@

$(LOGS_DIR)/%.shorten.txt: $(LOGS_DIR)/%.raw.txt shorten_paths.py
	python shorten_paths.py $< > $@

$(LOGS_DIR)/%.raw.txt: $(REPOS_DIR)/% $(LOGS_DIR)
	gource --output-custom-log - $< > $@
	sed -i -r "s#(.+)\|#\1|/$(notdir $<)#" $@

$(LOGS_DIR):
	mkdir $@
