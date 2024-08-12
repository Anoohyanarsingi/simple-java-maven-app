#!/usr/bin/env bash

# Display Maven install command
echo 'The following Maven command installs your Maven-built Java application'
echo 'into the local Maven repository, which will ultimately be stored in'
echo 'Jenkins''s local Maven repository (and the "maven-repository" Docker data'
echo 'volume).'
set -x
mvn jar:jar install:install

# Extract and display project name
echo 'The following command extracts the value of the <name/> element'
echo 'within <project/> of your Java/Maven project''s "pom.xml" file.'
NAME=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.name)
echo "Project name: ${NAME}"

# Extract and display project version
echo 'The following command behaves similarly to the previous one but'
echo 'extracts the value of the <version/> element within <project/> instead.'
VERSION=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.version)
echo "Project version: ${VERSION}"

# Debug: Check target directory contents
echo 'Listing contents of target directory:'
ls -la target/

# Run the JAR file
echo 'The following command runs and outputs the execution of your Java'
echo 'application (which Jenkins built using Maven) to the Jenkins UI.'
JAR_PATH="target/${NAME}-${VERSION}.jar"
echo "Checking for JAR file: $JAR_PATH"
if [ -f "$JAR_PATH" ]; then
    java -jar "$JAR_PATH"
else
    echo "JAR file not found: $JAR_PATH"
    exit 1
fi
