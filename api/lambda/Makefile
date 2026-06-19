.PHONY: all clean

DIST_DIR := dist
BUILD_DIR := build

# Find all directories that contain a main.go
LAMBDAS := $(patsubst %/main.go,%,$(wildcard */main.go))

# All .zip artifact files suitable for deployment to Lambda
ARTIFACTS := $(addprefix $(DIST_DIR)/, $(addsuffix .zip, $(LAMBDAS)))

$(DIST_DIR)/%.zip: %/main.go
	mkdir -p $(DIST_DIR) $(BUILD_DIR)/$*
	GOOS=linux GOARCH=amd64 go build -tags lambda.norpc -o $(BUILD_DIR)/$*/bootstrap $<
	zip -j $@ $(BUILD_DIR)/$*/bootstrap
	
all: $(ARTIFACTS)

clean:
	rm -rf $(DIST_DIR)
	rm -rf $(BUILD_DIR)

