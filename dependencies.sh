#!/usr/bin/env bash
#
# build/dependencies.sh
#
#   Configure Ubuntu, Fixup Git Source repo, Configure Web Server, Install WP CLI and run Composer.
#

declare=${ARTIFACTS_FILE:=}
declare=${CIRCLE_ARTIFACTS:=}
declare=${SHARED_SCRIPTS:=}
declare=${INCLUDES_ROOT:=}
declare=${SERVERS_ROOT:=}
declare=${TEST_WEBSERVER:=}
declare=${DEPLOY_PROVIDER:=}
declare=${DEPLOY_PROVIDER_ROOT:=}


#
# Set artifacts file for this script
#
ARTIFACTS_FILE="${CIRCLE_ARTIFACTS}/dependencies.log"

#
# Ensure shared scripts are executable
#
echo "Make shared scripts ${SHARED_SCRIPTS} executable"
sudo chmod +x "${SHARED_SCRIPTS}"

#
# Load the shared scripts
#
source "${SHARED_SCRIPTS}"

#
# Make changes to the Linux environment
#
announce "Running ${INCLUDES_ROOT}/configure-env.sh"
source "${INCLUDES_ROOT}/configure-env.sh"

#
# Fixup anything that needs to be done to
# source files.
#
announce "Running ${INCLUDES_ROOT}/fixup-source.sh"
source "${INCLUDES_ROOT}/fixup-source.sh"

#
# Configure Apache & PHP to operate correctly
#
announce "Running ${INCLUDES_ROOT}/configure-apache.sh"
source "${SERVERS_ROOT}/${TEST_WEBSERVER}/configure-apache.sh"

#
# Install WP-CLI
#
announce "Running ${INCLUDES_ROOT}/install-wp-cli.sh"
source "${INCLUDES_ROOT}/install-wp-cli.sh"

#
# Run composer install to bring in WordPresss core, plugins and extra themes
#
announce "Running ${INCLUDES_ROOT}/compose.sh"
source "${INCLUDES_ROOT}/compose.sh"

#
# Run deploy provider's dependencies
#
DEPLOY_PROVIDER_DEPENDENCIES="${DEPLOY_PROVIDER_ROOT}/${DEPLOY_PROVIDER}-dependencies.sh"
if [ -f "${DEPLOY_PROVIDER_DEPENDENCIES}" ] ; then
    announce "Running deploy provider's dependencies: ${DEPLOY_PROVIDER_DEPENDENCIES}"
    source "${DEPLOY_PROVIDER_DEPENDENCIES}"
fi
