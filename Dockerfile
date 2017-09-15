FROM debian:jessie-slim

MAINTAINER Òscar Casajuana <elboletaire@underave.net>

ENV pz_base=/zomboid
ENV entrypoint=$pz_base/entrypoint.sh

RUN mkdir $pz_base

ADD entrypoint.sh $entrypoint

RUN chmod +x $entrypoint

ENTRYPOINT ["/zomboid/entrypoint.sh"]
