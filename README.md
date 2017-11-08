# abuildd

an Alpine archive management software replacement


## synopsis

`abuildd` contains multiple components that replaces the entire Alpine archive management
software.  These are:

 * `abuildd-build`: runs a build and stages artifacts to a designated location

 * `abuildd-agentd`: runs as an agent and consumes MQTT messages for build requests

 * `abuildd-collect`: retrieves artifacts from a build server for a specific build

 * `abuildd-compose`: gathers all collected artifacts and composes a repository or
                      distribution

 * `abuildd-enqueue`: enqueues new packages for building with dependency resolution

 * `abuildd-git-hook`: runs `abuild-enqueue` as necessary when new git commits are
                       received

 * `abuildd-monitord`: a monitoring daemon which watches the MQTT server for feedback from
                       the build servers

 * `abuildd.webhook`: a webhook implementation which enqueues new packages based on
                      changeset notifications

 * `abuildd.status`: an `aiohttp.web` application which shows current status of the
                     build servers, also includes `abuildd.webhook`

`abuildd` depends on a preconfigured postgresql database and mqtt server, you can use any
mqtt server you wish for the task (mosquitto, rabbitmq, etc.).  It also depends on bubblewrap
being installed for sandboxing the build.


## PPAs

`abuildd` can be configured to build PPAs, as well as official repos.  See the `abuildd-git-hook`
documentation for more details.  Alternatively, a Github webhook can be found in the
`abuildd.webhook` module.  The webhook module requires gunicorn and aiohttp.

TODO: explain how to set up the webhook
