# ATAK-CIV SDK Development Container
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV ANDROID_HOME=/opt/android-sdk
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV GRADLE_HOME=/opt/gradle
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$GRADLE_HOME/bin

# Install system dependencies
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    wget \
    unzip \
    git \
    curl \
    build-essential \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Android SDK
RUN mkdir -p $ANDROID_HOME/cmdline-tools && \
    cd $ANDROID_HOME/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && \
    unzip commandlinetools-linux-9477386_latest.zip && \
    mv cmdline-tools latest && \
    rm commandlinetools-linux-9477386_latest.zip

# Accept Android SDK licenses
RUN yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses

# Install Android SDK components
RUN $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager \
    "platform-tools" \
    "platforms;android-30" \
    "build-tools;30.0.3" \
    "extras;android;m2repository" \
    "extras;google;m2repository"

# Install Gradle
RUN cd /opt && \
    wget -q https://services.gradle.org/distributions/gradle-7.6-bin.zip && \
    unzip gradle-7.6-bin.zip && \
    mv gradle-7.6 gradle && \
    rm gradle-7.6-bin.zip

# Get current version from build
COPY VERSION.txt /tmp/VERSION.txt
RUN VERSION=$(cat /tmp/VERSION.txt | tr -d '\n\r') && \
    echo "Building ATAK-CIV SDK version: $VERSION"

# Copy SDK files based on version
RUN VERSION=$(cat /tmp/VERSION.txt | tr -d '\n\r') && \
    mkdir -p /opt/atak-civ-sdk

COPY ATAK-CIV-*-SDK/ /opt/atak-civ-sdk/

# Set working directory
WORKDIR /workspace

# Create development user
RUN useradd -m -s /bin/bash developer && \
    chown -R developer:developer /workspace /opt/atak-civ-sdk

USER developer

# Set entrypoint
CMD ["/bin/bash"]