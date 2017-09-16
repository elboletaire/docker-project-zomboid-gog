Project Zomboid docker image (for gog.com version)
==================================================

[![Docker Build Status][build svg]][docker hub builds]
[![Docker Automated build][docker automated svg]][docker hub builds]
[![license][license svg]][license]

Project Zomboid GOG server Docker image.

Requirements
------------

You first need to download the game from gog, in sh format (for linux). Unzip
the file with your preferred zip extractor. On max/linux using the command line
would be something like:

~~~bash
unzip gog_project_zomboid*.sh -d project-zomboid
~~~

Taking `project-zomboid` as the extracted folder, you need to copy the contents of the
`project-zomboid/data/noarch/game` folder where you want your game files to be placed.

Let's say you want them in your home directory:

~~~bash
mkdir ~/zomboid-server
mv -fv project-zomboid zomboid-server/game
~~~

Now that we have the game, just start it:

Starting the server
-------------------

Following the requirements example, having Project Zomboid files in
`~/zomboid-server/game`, we should run:

~~~bash
docker run -d --name zomboid-server \
  --volume $HOME/zomboid-server/game:/zomboid/game \
  --volume $HOME/zomboid-server/config:/zomboid/config \
  -p 16261:16261/udp
  -e "adminpassword=ADMIN_ACCOUNT_PASSWORD" \
  -e "anyOtherOption=ItsValue" \
  elboletaire/project-zomboid-gog
~~~

> Note: the `config` folder stores all the savegame information, as well as all
the other server related configurations.

Additionally, using docker-compose, a yaml file for the previous execution would
look like this:

~~~yaml
version: '3'

services:
  project-zomboid:
    image: elboletaire/project-zomboid-gog
    ports:
    - 16261:16261/udp
    volumes:
    - "${HOME}/zomboid-server/game:/zomboid/game"
    - "${HOME}/zomboid-server/config:/zomboid/config"
    environment:
      adminpassword: ADMIN_ACCOUNT_PASSWORD
      anyOtherOption: ItsValue
~~~

Then run it with:

~~~bash
docker-compose up -d
~~~

After following any of the previous steps you should be able to access
your server using any user account, as well as the `admin` account, using
`ADMIN_ACCOUNT_PASSWORD` as its password.

### Available options

I've tried to add all the options described in the
"[Startup Parameters][startup parameters]" section of the [pzwiki][pzwiki].

All of them are specified like its said in the guide, except for the following:

| Variable     | Original     |
| ------------ | ------------ |
| `debug`      | `Ddebug`     |
| `max_memory` | `Xmx`        |
| `min_memory` | `Xms`        |
| `home`       | `Duser.home` |

Complex example using almost every var:

~~~yaml
version: '3'

services:
  project-zomboid:
    image: elboletaire/project-zomboid-gog
    ports:
    - 2323:2323/udp
    volumes:
    - "${HOME}/zomboid-server/game:/zomboid/game"
    - "${HOME}/zomboid-server/config:/zomboid/myserverdata"
    environment:
      adminpassword: ADMIN_ACCOUNT_PASSWORD
      cachedir: /zomboid/myserverdata
      modfolders: workshop,mods
      safemode: 'true'
      servername: elboletaire
      ip: '127.0.0.1'
      port: '2323'
      max_memory: '4096'
      min_memory: '1024'
      debug: 'true'
~~~

[build svg]: https://img.shields.io/docker/build/elboletaire/project-zomboid-gog.svg?style=flat-square
[docker automated svg]: https://img.shields.io/docker/automated/elboletaire/project-zomboid-gog.svg?style=flat-square
[license svg]: https://img.shields.io/github/license/elboletaire/docker-project-zomboid-gog.svg?style=flat-square

[docker hub builds]: https://hub.docker.com/r/elboletaire/project-zomboid-gog/builds/
[license]: ./LICENSE

[startup parameters]: https://pzwiki.net/wiki/Startup_Parameters
[pzwiki]: https://pzwiki.net
