REPOS_DIR := repos
LOGS_DIR := logs

REPOS := $(notdir $(wildcard $(REPOS_DIR)/*))
LOGS := $(addprefix $(LOGS_DIR)/, $(addsuffix .raw.txt, $(REPOS)))
LOGS_SHORTEN := $(addprefix $(LOGS_DIR)/, $(addsuffix .shorten.txt, $(REPOS)))
LOG_FILE := $(LOGS_DIR)/complete.txt

.PHONY: all
all: video.mp4

video.mp4: video.ppm audio.mp3
	ffmpeg -y -r 30 -f image2pipe -vcodec ppm -i $< -i $(word 2, $^) \
		-c:v libx264 -preset veryslow -crf 22 -f mp4 -movflags +faststart \
		-c:a aac -b:a 192k $@

video.ppm: $(LOG_FILE) gource.conf final_logo.png
	gource --load-config gource.conf -r 30 -o video.ppm \
		-1920x1080 $<

final_logo.png: logo.svg
	inkscape --export-area-page --export-height=70 --export-png=$@ $<

$(LOG_FILE): $(LOGS_SHORTEN)
	cat $^ | sort -n > $@

$(LOGS_DIR)/%.shorten.txt: $(LOGS_DIR)/%.raw.txt shorten_paths.py
	python shorten_paths.py $< > $@

$(LOGS_DIR)/%.raw.txt: $(REPOS_DIR)/% $(LOGS_DIR)
	gource --output-custom-log - $< > $@
	sed -i -r "s#(.+)\|#\1|/$(notdir $<)#" $@

$(LOGS_DIR):
	mkdir $@
