# Build the APK and copy it to ./output on the host
APK_PATH=app/build/outputs/apk/debug/app-debug.apk
HOST_OUTPUT_DIR=$(CURDIR)/output

apk: ## Build the debug APK and copy it to ./output
	$(PODMAN) run --rm \
	  -v $(CURDIR):$(WORKDIR) \
	  -w $(WORKDIR) \
	  $(IMAGE) \
	  bash -c "./gradlew assembleDebug && mkdir -p output && cp $(APK_PATH) output/"

# DroidPad Android build Makefile (Podman version)
.DEFAULT_GOAL := help


# Podman Android build targets
PODMAN ?= podman
IMAGE ?= droidpad-dev
CONTAINER_NAME ?= droidpad-dev-container
WORKDIR ?= /workspace

build: ## Build the DroidPad Android app using Podman
	$(PODMAN) build -t $(IMAGE) .

run: ## Run a Podman container for DroidPad development
	$(PODMAN) run --rm -it \
	  -v $(CURDIR):$(WORKDIR) \
	  --name $(CONTAINER_NAME) \
	  $(IMAGE)

###############################################################
# cleaning (optional, not used for Android build)

clean:
	echo "No clean steps defined for Android build."

#################################################################################
# Self Documenting Commands                                                     #

help: ## Show help. Only lines with ": ##" will show up!
	@awk -F':[[:space:]]*.*## ' '/^[a-zA-Z0-9_.-]+ *:.*## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)