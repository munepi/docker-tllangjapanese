## bootstrap
FROM debian:bookworm-slim AS tllangjapanese-base

LABEL maintainer="munepixyz@gmail.com"
LABEL org.opencontainers.image.description="custom enriched Japanese TeX Live environment image"

#available: x86_64, aarch64
ARG TLARCH
ENV TLARCH=${TLARCH:-x86_64}

## optional: override repository base URL at build time
##   docker build --build-arg TL_REPO_PREFIX=http://host.docker.internal:8080 ...
ARG TL_REPO_PREFIX
ENV TL_REPO_PREFIX=${TL_REPO_PREFIX}

ENV LANG=en_US.UTF-8

## portable TDS
ENV TL_TEXDIR=/usr/local/texlive
ENV TL_TEXMFLOCAL=${TL_TEXDIR}/texmf-local
ENV TL_TEXMFVAR=${TL_TEXDIR}/texmf-var
ENV TL_TEXMFCONFIG=${TL_TEXDIR}/texmf-config
ENV TL_TEXMFDIST=${TL_TEXDIR}/texmf-dist

ENV PATH=${TL_TEXDIR}/bin/${TLARCH}-linux:${PATH}

## setup
RUN apt-get update && \
        apt-get install -y --no-install-recommends \
        locales make git-core zip unzip wget xz-utils xzdec zstd ca-certificates \
        ghostscript ruby python3-pygments file imagemagick \
        ## for XeTeX
        fontconfig \
        && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
        locale-gen en_US.UTF-8 && \
        update-locale en_US.UTF-8

## gem/Ruby: Disable documentation generation
RUN printf "%s\n"  \
    "gem:      -N" \
    "install:  -N" \
    "update:   -N" \
    > ${HOME}/.gemrc

VOLUME ["${TL_TEXMFVAR}/luatex-cache"]
CMD [ "/bin/bash" ]


## preset
FROM tllangjapanese-base AS tllangjapanese-preset
## additional packages
ENV TL_ADDPKGS_TL12="\
    algorithms algorithmicx \
    bbold bbold-type1 \
    bera \
    ebgaramond \
    esvect \
    fontawesome \
    grotesq \
    inconsolata \
    mnsymbol \
    physics \
    sourcecodepro sourcesanspro \
    stmaryrd \
    systeme \
    ulem \
"
ENV TL_ADDPKGS_TL13="\
    ${TL_ADDPKGS_TL12} \
"
ENV TL_ADDPKGS_TL14="\
    ${TL_ADDPKGS_TL13} \
    roboto \
"
ENV TL_ADDPKGS_TL15="\
    ${TL_ADDPKGS_TL14} \
"
ENV TL_ADDPKGS_TL16="\
    ${TL_ADDPKGS_TL15} \
"
ENV TL_ADDPKGS_TL17="\
    ${TL_ADDPKGS_TL16} \
    nicematrix \
    plex \
"
ENV TL_ADDPKGS_TL18="\
    ${TL_ADDPKGS_TL17} \
    stix2-otf stix2-type1 \
"
ENV TL_ADDPKGS_TL19="\
    ${TL_ADDPKGS_TL18} \
    noto-emoji \
"
ENV TL_ADDPKGS_TL20="\
    ${TL_ADDPKGS_TL19} \
"
ENV TL_ADDPKGS_TL21="\
    ${TL_ADDPKGS_TL20} \
"
ENV TL_ADDPKGS_TL22="\
    ${TL_ADDPKGS_TL21} \
"
ENV TL_ADDPKGS_TL23="\
    ${TL_ADDPKGS_TL22} \
"
ENV TL_ADDPKGS_TL24="\
    ${TL_ADDPKGS_TL23} \
"
ENV TL_ADDPKGS_TL25="\
    ${TL_ADDPKGS_TL24} \
"
ENV TL_ADDPKGS_TL26="\
    ${TL_ADDPKGS_TL25} \
"
ENV TL_ADDPKGS_TL27="\
    ${TL_ADDPKGS_TL26} \
"
## reduced packages
ENV TL_DELPKGS_TL12="\
    tex4ht tex4ht.${TLARCH}-linux \
"
ENV TL_DELPKGS_TL13="\
    ${TL_DELPKGS_TL12} \
"
ENV TL_DELPKGS_TL14="\
    ${TL_DELPKGS_TL13} \
"
ENV TL_DELPKGS_TL15="\
    ${TL_DELPKGS_TL14} \
    make4ht make4ht.${TLARCH}-linux tex4ebook tex4ebook.${TLARCH}-linux \
"
ENV TL_DELPKGS_TL16="\
    ${TL_DELPKGS_TL15} \
"
ENV TL_DELPKGS_TL17="\
    ${TL_DELPKGS_TL16} \
    tlcockpit tlcockpit.${TLARCH}-linux \
"
ENV TL_DELPKGS_TL18="\
    ${TL_DELPKGS_TL17} \
"
ENV TL_DELPKGS_TL19="\
    ${TL_DELPKGS_TL18} \
    haranoaji haranoaji-extra \
"
ENV TL_DELPKGS_TL20="\
    ${TL_DELPKGS_TL19} \
    tlshell tlshell.${TLARCH}-linux \
"
ENV TL_DELPKGS_TL21="\
    ${TL_DELPKGS_TL20} \
"
ENV TL_DELPKGS_TL22="\
    ${TL_DELPKGS_TL21} \
"
ENV TL_DELPKGS_TL23="\
    ${TL_DELPKGS_TL22} \
"
ENV TL_DELPKGS_TL24="\
    ${TL_DELPKGS_TL23} \
"
ENV TL_DELPKGS_TL25="\
    ${TL_DELPKGS_TL24} \
"
ENV TL_DELPKGS_TL26="\
    ${TL_DELPKGS_TL25} \
"
ENV TL_DELPKGS_TL27="\
    ${TL_DELPKGS_TL26} \
"

## setup texmf-local & install the latest HaranoAji fonts
RUN mkdir -p ${TL_TEXMFLOCAL} && \
        wget -qO- https://texlive.texjp.org/current/tlnet/archive/ptex-fontmaps.tar.xz | \
        tar -xJ -C ${TL_TEXMFLOCAL} --strip-components=1 && \
            rm -rf tlpobj tlpostcode && \
        wget -qO- https://texlive.texjp.org/current/tlnet/archive/haranoaji.tar.xz | \
        tar -xJ -C ${TL_TEXMFLOCAL} --strip-components=1 && \
            rm -rf tlpobj tlpostcode && \
        wget -qO- https://texlive.texjp.org/current/tlnet/archive/haranoaji-extra.tar.xz | \
        tar -xJ -C ${TL_TEXMFLOCAL} && \
            rm -rf tlpkg

## copy common setup script
COPY setup-texlive.sh /usr/local/bin/setup-texlive.sh
RUN chmod +x /usr/local/bin/setup-texlive.sh


########################################
## Per-version stages
## Usage: setup-texlive.sh <VERSION> <REPO_SCHEME> <UPDMAP_MODE>
##   REPO_SCHEME : "http" (TL12-TL19) or "https" (TL20+)
##   UPDMAP_MODE : "legacy" (TL12-TL16) or "modern" (TL17+, adds jaEmbed)
##
## Override repository:
##   docker build --build-arg TL_REPO_PREFIX=http://host.docker.internal:8080 ...
########################################

## TeX Live 2012 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl12
ENV TL_VERSION=2012 TL_ADDPKGS=${TL_ADDPKGS_TL12} TL_DELPKGS=${TL_DELPKGS_TL12}
RUN setup-texlive.sh 2012 http legacy

## TeX Live 2013 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl13
ENV TL_VERSION=2013 TL_ADDPKGS=${TL_ADDPKGS_TL13} TL_DELPKGS=${TL_DELPKGS_TL13}
RUN setup-texlive.sh 2013 http legacy

## TeX Live 2014 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl14
ENV TL_VERSION=2014 TL_ADDPKGS=${TL_ADDPKGS_TL14} TL_DELPKGS=${TL_DELPKGS_TL14}
RUN setup-texlive.sh 2014 http legacy

## TeX Live 2015 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl15
ENV TL_VERSION=2015 TL_ADDPKGS=${TL_ADDPKGS_TL15} TL_DELPKGS=${TL_DELPKGS_TL15}
RUN setup-texlive.sh 2015 http legacy

## TeX Live 2016 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl16
ENV TL_VERSION=2016 TL_ADDPKGS=${TL_ADDPKGS_TL16} TL_DELPKGS=${TL_DELPKGS_TL16}
RUN setup-texlive.sh 2016 http legacy

## TeX Live 2017 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl17
ENV TL_VERSION=2017 TL_ADDPKGS=${TL_ADDPKGS_TL17} TL_DELPKGS=${TL_DELPKGS_TL17}
RUN setup-texlive.sh 2017 http modern

## TeX Live 2018 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl18
ENV TL_VERSION=2018 TL_ADDPKGS=${TL_ADDPKGS_TL18} TL_DELPKGS=${TL_DELPKGS_TL18}
RUN setup-texlive.sh 2018 http modern

## TeX Live 2019 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl19
ENV TL_VERSION=2019 TL_ADDPKGS=${TL_ADDPKGS_TL19} TL_DELPKGS=${TL_DELPKGS_TL19}
RUN setup-texlive.sh 2019 http modern

## TeX Live 2020 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl20
ENV TL_VERSION=2020 TL_ADDPKGS=${TL_ADDPKGS_TL20} TL_DELPKGS=${TL_DELPKGS_TL20}
RUN setup-texlive.sh 2020 https modern

## TeX Live 2021 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl21
ENV TL_VERSION=2021 TL_ADDPKGS=${TL_ADDPKGS_TL21} TL_DELPKGS=${TL_DELPKGS_TL21}
RUN setup-texlive.sh 2021 https modern

## TeX Live 2022 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl22
ENV TL_VERSION=2022 TL_ADDPKGS=${TL_ADDPKGS_TL22} TL_DELPKGS=${TL_DELPKGS_TL22}
RUN setup-texlive.sh 2022 https modern

## TeX Live 2023 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl23
ENV TL_VERSION=2023 TL_ADDPKGS=${TL_ADDPKGS_TL23} TL_DELPKGS=${TL_DELPKGS_TL23}
RUN setup-texlive.sh 2023 https modern

## TeX Live 2024 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl24
ENV TL_VERSION=2024 TL_ADDPKGS=${TL_ADDPKGS_TL24} TL_DELPKGS=${TL_DELPKGS_TL24}
RUN setup-texlive.sh 2024 https modern

## TeX Live 2025 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl25
ENV TL_VERSION=2025 TL_ADDPKGS=${TL_ADDPKGS_TL25} TL_DELPKGS=${TL_DELPKGS_TL25}
RUN setup-texlive.sh 2025 https modern

## TeX Live 2026 current
# FROM tllangjapanese-preset AS tllangjapanese-tl26-orig
FROM tllangjapanese-preset AS tllangjapanese-tl26
ARG TL_REPO_PREFIX
ENV TL_VERSION=2026 TL_ADDPKGS=${TL_ADDPKGS_TL26} TL_DELPKGS=${TL_DELPKGS_TL26}
RUN setup-texlive.sh 2026 https modern

# ########################################
# ## Update the latest image from base image
#
# FROM munepi/tllangjapanese:2026.20260314 AS tllangjapanese-tl26
# RUN tlmgr update --self --all && \
#     tlmgr install ${TL_ADDPKGS} && \
#     tlmgr uninstall --force ${TL_DELPKGS} ||:

# end of file
