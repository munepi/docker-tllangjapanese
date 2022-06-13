## bootstrap
FROM debian:bullseye-slim AS tllangjapanese-base

LABEL maintainer="munepi@greencherry.jp"

#available: x86_64, aarch64
ARG TLARCH
ENV TLARCH=${TLARCH:-x86_64}

ENV LANG en_US.UTF-8

## portable TDS
ENV TL_TEXDIR          /usr/local/texlive
ENV TL_TEXMFLOCAL      ${TL_TEXDIR}/texmf-local
ENV TL_TEXMFVAR        ${TL_TEXDIR}/texmf-var
ENV TL_TEXMFCONFIG     ${TL_TEXDIR}/texmf-config
ENV TL_TEXMFDIST       ${TL_TEXDIR}/texmf-dist

ENV PATH               ${TL_TEXDIR}/bin/${TLARCH}-linux:${PATH}

ENV TL_ADDITIONAL_PACKAGES        \
        algorithms mnsymbol ebgaramond fontawesome inconsolata noto-emoji sourcecodepro sourcesanspro \
        stix2-otf stix2-type1 ulem

## setup
RUN apt-get update && \
        apt-get install -y --no-install-recommends \
        locales make git-core unzip wget xz-utils xzdec ca-certificates \
        ghostscript ruby \
        ## for XeTeX
        fontconfig \
        && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
        locale-gen en_US.UTF-8 && \
        update-locale en_US.UTF-8

## setup texmf-local & install HaranoAjiFont font from TL22
RUN mkdir -p ${TL_TEXMFLOCAL} && \
        wget -qO- https://texlive.texjp.org/2022/tlnet/archive/ptex-fontmaps.tar.xz | \
        tar -xJ -C ${TL_TEXMFLOCAL} --strip-components=1 && \
        wget -qO- https://texlive.texjp.org/2022/tlnet/archive/haranoaji.tar.xz | \
        tar -xJ -C ${TL_TEXMFLOCAL} --strip-components=1 && \
        wget -qO- https://texlive.texjp.org/2022/tlnet/archive/haranoaji-extra.tar.xz | \
        tar -xJ -C ${TL_TEXMFLOCAL} --strip-components=1

VOLUME ["${TL_TEXMFVAR}/luatex-cache"]
CMD [ "/bin/bash" ]


## TeX Live 2012 frozen
FROM tllangjapanese-base AS tllangjapanese-tl12

ENV TL_VERSION       2012

ENV TL_ADDITIONAL_PACKAGES        \
        algorithms mnsymbol ebgaramond fontawesome inconsolata sourcecodepro sourcesanspro \
        ulem

RUN mkdir install-tl-unx && \
        wget -qO- https://texlive.texjp.org/${TL_VERSION}/tlnet/install-tl-unx.tar.gz | \
        tar -xz -C ./install-tl-unx --strip-components=1 && \
        printf "%s\n" \
            "TEXDIR ${TL_TEXDIR}" \
            "TEXMFLOCAL ${TL_TEXMFLOCAL}" \
            "TEXMFSYSVAR ${TL_TEXMFVAR}" \
            "TEXMFSYSCONFIG ${TL_TEXMFCONFIG}" \
            "TEXMFHOME ${TL_TEXMFLOCAL}" \
            "TEXMFVAR ${TL_TEXMFVAR}" \
            "TEXMFCONFIG ${TL_TEXMFCONFIG}" \
            "selected_scheme scheme-minimal" \
            "binary_${TLARCH}-linux 1" \
            "collection-binextra 1" \
            "collection-langjapanese 1" \
            "collection-latexextra 1" \
            "collection-luatex 1" \
            "collection-fontsrecommended 1" \
            "option_adjustrepo 0" \
            "option_autobackup 0" \
            "option_doc 0" \
            "option_src 0" \
        > ./install-tl-unx/texlive.profile && \
        ./install-tl-unx/install-tl \
        -repository http://texlive.texjp.org/${TL_VERSION}/tlnet/ \
        -profile ./install-tl-unx/texlive.profile && \
        rm -rf install-tl-unx/

## install additional packages
RUN tlmgr install ${TL_ADDITIONAL_PACKAGES}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys


## TeX Live 2013 frozen
FROM tllangjapanese-base AS tllangjapanese-tl13

ENV TL_VERSION       2013

ENV TL_ADDITIONAL_PACKAGES        \
        algorithms mnsymbol ebgaramond fontawesome inconsolata sourcecodepro sourcesanspro \
        ulem

RUN mkdir install-tl-unx && \
        wget -qO- https://texlive.texjp.org/${TL_VERSION}/tlnet/install-tl-unx.tar.gz | \
        tar -xz -C ./install-tl-unx --strip-components=1 && \
        printf "%s\n" \
            "TEXDIR ${TL_TEXDIR}" \
            "TEXMFLOCAL ${TL_TEXMFLOCAL}" \
            "TEXMFSYSVAR ${TL_TEXMFVAR}" \
            "TEXMFSYSCONFIG ${TL_TEXMFCONFIG}" \
            "TEXMFHOME ${TL_TEXMFLOCAL}" \
            "TEXMFVAR ${TL_TEXMFVAR}" \
            "TEXMFCONFIG ${TL_TEXMFCONFIG}" \
            "selected_scheme scheme-minimal" \
            "binary_${TLARCH}-linux 1" \
            "collection-binextra 1" \
            "collection-langjapanese 1" \
            "collection-latexextra 1" \
            "collection-luatex 1" \
            "collection-fontsrecommended 1" \
            "option_adjustrepo 0" \
            "option_autobackup 0" \
            "option_doc 0" \
            "option_src 0" \
        > ./install-tl-unx/texlive.profile && \
        ./install-tl-unx/install-tl \
        -repository http://texlive.texjp.org/${TL_VERSION}/tlnet/ \
        -profile ./install-tl-unx/texlive.profile && \
        rm -rf install-tl-unx/

## install additional packages
RUN tlmgr install ${TL_ADDITIONAL_PACKAGES}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys


## TeX Live 2014 frozen
FROM tllangjapanese-base AS tllangjapanese-tl14

ENV TL_VERSION       2014

ENV TL_ADDITIONAL_PACKAGES        \
        algorithms mnsymbol ebgaramond fontawesome inconsolata sourcecodepro sourcesanspro \
        ulem

RUN mkdir install-tl-unx && \
        wget -qO- https://texlive.texjp.org/${TL_VERSION}/tlnet/install-tl-unx.tar.gz | \
        tar -xz -C ./install-tl-unx --strip-components=1 && \
        printf "%s\n" \
            "TEXDIR ${TL_TEXDIR}" \
            "TEXMFLOCAL ${TL_TEXMFLOCAL}" \
            "TEXMFSYSVAR ${TL_TEXMFVAR}" \
            "TEXMFSYSCONFIG ${TL_TEXMFCONFIG}" \
            "TEXMFHOME ${TL_TEXMFLOCAL}" \
            "TEXMFVAR ${TL_TEXMFVAR}" \
            "TEXMFCONFIG ${TL_TEXMFCONFIG}" \
            "selected_scheme scheme-minimal" \
            "binary_${TLARCH}-linux 1" \
            "collection-binextra 1" \
            "collection-langjapanese 1" \
            "collection-latexextra 1" \
            "collection-luatex 1" \
            "collection-fontsrecommended 1" \
            "option_adjustrepo 0" \
            "option_autobackup 0" \
            "option_doc 0" \
            "option_src 0" \
        > ./install-tl-unx/texlive.profile && \
        ./install-tl-unx/install-tl \
        -repository http://texlive.texjp.org/${TL_VERSION}/tlnet/ \
        -profile ./install-tl-unx/texlive.profile && \
        rm -rf install-tl-unx/

## install additional packages
RUN tlmgr install ${TL_ADDITIONAL_PACKAGES}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys


## TeX Live 2015 frozen
FROM tllangjapanese-base AS tllangjapanese-tl15

ENV TL_VERSION       2015

ENV TL_ADDITIONAL_PACKAGES        \
        algorithms mnsymbol ebgaramond fontawesome inconsolata sourcecodepro sourcesanspro \
        ulem

RUN mkdir install-tl-unx && \
        wget -qO- https://texlive.texjp.org/${TL_VERSION}/tlnet/install-tl-unx.tar.gz | \
        tar -xz -C ./install-tl-unx --strip-components=1 && \
        printf "%s\n" \
            "TEXDIR ${TL_TEXDIR}" \
            "TEXMFLOCAL ${TL_TEXMFLOCAL}" \
            "TEXMFSYSVAR ${TL_TEXMFVAR}" \
            "TEXMFSYSCONFIG ${TL_TEXMFCONFIG}" \
            "TEXMFHOME ${TL_TEXMFLOCAL}" \
            "TEXMFVAR ${TL_TEXMFVAR}" \
            "TEXMFCONFIG ${TL_TEXMFCONFIG}" \
            "selected_scheme scheme-minimal" \
            "binary_${TLARCH}-linux 1" \
            "collection-binextra 1" \
            "collection-langjapanese 1" \
            "collection-latexextra 1" \
            "collection-luatex 1" \
            "collection-fontsrecommended 1" \
            "option_adjustrepo 0" \
            "option_autobackup 0" \
            "option_doc 0" \
            "option_src 0" \
        > ./install-tl-unx/texlive.profile && \
        ./install-tl-unx/install-tl \
        -repository http://texlive.texjp.org/${TL_VERSION}/tlnet/ \
        -profile ./install-tl-unx/texlive.profile && \
        rm -rf install-tl-unx/

## install additional packages
RUN tlmgr install ${TL_ADDITIONAL_PACKAGES}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys


## TeX Live 2016 frozen
FROM tllangjapanese-base AS tllangjapanese-tl16

ENV TL_VERSION       2016

ENV TL_ADDITIONAL_PACKAGES        \
        algorithms mnsymbol ebgaramond fontawesome inconsolata sourcecodepro sourcesanspro \
        ulem

RUN mkdir install-tl-unx && \
        wget -qO- https://texlive.texjp.org/${TL_VERSION}/tlnet/install-tl-unx.tar.gz | \
        tar -xz -C ./install-tl-unx --strip-components=1 && \
        printf "%s\n" \
            "TEXDIR ${TL_TEXDIR}" \
            "TEXMFLOCAL ${TL_TEXMFLOCAL}" \
            "TEXMFSYSVAR ${TL_TEXMFVAR}" \
            "TEXMFSYSCONFIG ${TL_TEXMFCONFIG}" \
            "TEXMFHOME ${TL_TEXMFLOCAL}" \
            "TEXMFVAR ${TL_TEXMFVAR}" \
            "TEXMFCONFIG ${TL_TEXMFCONFIG}" \
            "selected_scheme scheme-minimal" \
            "binary_${TLARCH}-linux 1" \
            "collection-binextra 1" \
            "collection-langjapanese 1" \
            "collection-latexextra 1" \
            "collection-luatex 1" \
            "collection-fontsrecommended 1" \
            "option_adjustrepo 0" \
            "option_autobackup 0" \
            "option_doc 0" \
            "option_src 0" \
        > ./install-tl-unx/texlive.profile && \
        ./install-tl-unx/install-tl \
        -repository http://texlive.texjp.org/${TL_VERSION}/tlnet/ \
        -profile ./install-tl-unx/texlive.profile && \
        rm -rf install-tl-unx/

## install additional packages
RUN tlmgr install ${TL_ADDITIONAL_PACKAGES}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys


## TeX Live 2017 frozen
FROM tllangjapanese-base AS tllangjapanese-tl17

ENV TL_VERSION       2017

ENV TL_ADDITIONAL_PACKAGES        \
        algorithms mnsymbol ebgaramond fontawesome inconsolata sourcecodepro sourcesanspro \
        ulem

RUN mkdir install-tl-unx && \
        wget -qO- https://texlive.texjp.org/${TL_VERSION}/tlnet/install-tl-unx.tar.gz | \
        tar -xz -C ./install-tl-unx --strip-components=1 && \
        printf "%s\n" \
            "TEXDIR ${TL_TEXDIR}" \
            "TEXMFLOCAL ${TL_TEXMFLOCAL}" \
            "TEXMFSYSVAR ${TL_TEXMFVAR}" \
            "TEXMFSYSCONFIG ${TL_TEXMFCONFIG}" \
            "TEXMFHOME ${TL_TEXMFLOCAL}" \
            "TEXMFVAR ${TL_TEXMFVAR}" \
            "TEXMFCONFIG ${TL_TEXMFCONFIG}" \
            "selected_scheme scheme-minimal" \
            "binary_${TLARCH}-linux 1" \
            "collection-binextra 1" \
            "collection-langjapanese 1" \
            "collection-latexextra 1" \
            "collection-luatex 1" \
            "collection-fontsrecommended 1" \
            "option_adjustrepo 0" \
            "option_autobackup 0" \
            "option_doc 0" \
            "option_src 0" \
        > ./install-tl-unx/texlive.profile && \
        ./install-tl-unx/install-tl \
        -repository http://texlive.texjp.org/${TL_VERSION}/tlnet/ \
        -profile ./install-tl-unx/texlive.profile && \
        rm -rf install-tl-unx/

## install additional packages
RUN tlmgr install ${TL_ADDITIONAL_PACKAGES}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "jaEmbed haranoaji" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys


## TeX Live 2018 frozen
FROM tllangjapanese-base AS tllangjapanese-tl18

ENV TL_VERSION       2018

ENV TL_ADDITIONAL_PACKAGES        \
        algorithms mnsymbol ebgaramond fontawesome inconsolata sourcecodepro sourcesanspro \
        stix2-otf stix2-type1 ulem

RUN mkdir install-tl-unx && \
        wget -qO- https://texlive.texjp.org/${TL_VERSION}/tlnet/install-tl-unx.tar.gz | \
        tar -xz -C ./install-tl-unx --strip-components=1 && \
        printf "%s\n" \
            "TEXDIR ${TL_TEXDIR}" \
            "TEXMFLOCAL ${TL_TEXMFLOCAL}" \
            "TEXMFSYSVAR ${TL_TEXMFVAR}" \
            "TEXMFSYSCONFIG ${TL_TEXMFCONFIG}" \
            "TEXMFHOME ${TL_TEXMFLOCAL}" \
            "TEXMFVAR ${TL_TEXMFVAR}" \
            "TEXMFCONFIG ${TL_TEXMFCONFIG}" \
            "selected_scheme scheme-minimal" \
            "binary_${TLARCH}-linux 1" \
            "collection-binextra 1" \
            "collection-langjapanese 1" \
            "collection-latexextra 1" \
            "collection-luatex 1" \
            "collection-fontsrecommended 1" \
            "option_adjustrepo 0" \
            "option_autobackup 0" \
            "option_doc 0" \
            "option_src 0" \
        > ./install-tl-unx/texlive.profile && \
        ./install-tl-unx/install-tl \
        -repository http://texlive.texjp.org/${TL_VERSION}/tlnet/ \
        -profile ./install-tl-unx/texlive.profile && \
        rm -rf install-tl-unx/

## install additional packages
RUN tlmgr install ${TL_ADDITIONAL_PACKAGES}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "jaEmbed haranoaji" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys


## TeX Live 2019 frozen
FROM tllangjapanese-base AS tllangjapanese-tl19

ENV TL_VERSION       2019

RUN mkdir install-tl-unx && \
        wget -qO- https://texlive.texjp.org/${TL_VERSION}/tlnet/install-tl-unx.tar.gz | \
        tar -xz -C ./install-tl-unx --strip-components=1 && \
        printf "%s\n" \
            "TEXDIR ${TL_TEXDIR}" \
            "TEXMFLOCAL ${TL_TEXMFLOCAL}" \
            "TEXMFSYSVAR ${TL_TEXMFVAR}" \
            "TEXMFSYSCONFIG ${TL_TEXMFCONFIG}" \
            "TEXMFHOME ${TL_TEXMFLOCAL}" \
            "TEXMFVAR ${TL_TEXMFVAR}" \
            "TEXMFCONFIG ${TL_TEXMFCONFIG}" \
            "selected_scheme scheme-minimal" \
            "binary_${TLARCH}-linux 1" \
            "collection-binextra 1" \
            "collection-langjapanese 1" \
            "collection-latexextra 1" \
            "collection-luatex 1" \
            "collection-fontsrecommended 1" \
            "option_adjustrepo 0" \
            "option_autobackup 0" \
            "option_doc 0" \
            "option_src 0" \
        > ./install-tl-unx/texlive.profile && \
        ./install-tl-unx/install-tl \
        -repository http://texlive.texjp.org/${TL_VERSION}/tlnet/ \
        -profile ./install-tl-unx/texlive.profile && \
        rm -rf install-tl-unx/

## install additional packages
RUN tlmgr install ${TL_ADDITIONAL_PACKAGES}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "jaEmbed haranoaji" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys


## TeX Live 2020 frozen
FROM tllangjapanese-base AS tllangjapanese-tl20

ENV TL_VERSION       2020

RUN mkdir install-tl-unx && \
        wget -qO- https://texlive.texjp.org/${TL_VERSION}/tlnet/install-tl-unx.tar.gz | \
        tar -xz -C ./install-tl-unx --strip-components=1 && \
        printf "%s\n" \
            "TEXDIR ${TL_TEXDIR}" \
            "TEXMFLOCAL ${TL_TEXMFLOCAL}" \
            "TEXMFSYSVAR ${TL_TEXMFVAR}" \
            "TEXMFSYSCONFIG ${TL_TEXMFCONFIG}" \
            "TEXMFHOME ${TL_TEXMFLOCAL}" \
            "TEXMFVAR ${TL_TEXMFVAR}" \
            "TEXMFCONFIG ${TL_TEXMFCONFIG}" \
            "selected_scheme scheme-minimal" \
            "binary_${TLARCH}-linux 1" \
            "collection-binextra 1" \
            "collection-langjapanese 1" \
            "collection-latexextra 1" \
            "collection-luatex 1" \
            "collection-fontsrecommended 1" \
            "option_adjustrepo 0" \
            "option_autobackup 0" \
            "option_doc 0" \
            "option_src 0" \
        > ./install-tl-unx/texlive.profile && \
        ./install-tl-unx/install-tl \
        -repository https://texlive.texjp.org/${TL_VERSION}/tlnet/ \
        -profile ./install-tl-unx/texlive.profile && \
        rm -rf install-tl-unx/

## install additional packages
RUN tlmgr install ${TL_ADDITIONAL_PACKAGES}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "jaEmbed haranoaji" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys


## TeX Live 2021 frozen
FROM tllangjapanese-base AS tllangjapanese-tl21

ENV TL_VERSION       2021

RUN mkdir install-tl-unx && \
        wget -qO- https://texlive.texjp.org/${TL_VERSION}/tlnet/install-tl-unx.tar.gz | \
        tar -xz -C ./install-tl-unx --strip-components=1 && \
        printf "%s\n" \
            "TEXDIR ${TL_TEXDIR}" \
            "TEXMFLOCAL ${TL_TEXMFLOCAL}" \
            "TEXMFSYSVAR ${TL_TEXMFVAR}" \
            "TEXMFSYSCONFIG ${TL_TEXMFCONFIG}" \
            "TEXMFHOME ${TL_TEXMFLOCAL}" \
            "TEXMFVAR ${TL_TEXMFVAR}" \
            "TEXMFCONFIG ${TL_TEXMFCONFIG}" \
            "selected_scheme scheme-minimal" \
            "binary_${TLARCH}-linux 1" \
            "collection-binextra 1" \
            "collection-langjapanese 1" \
            "collection-latexextra 1" \
            "collection-luatex 1" \
            "collection-fontsrecommended 1" \
            "option_adjustrepo 0" \
            "option_autobackup 0" \
            "option_doc 0" \
            "option_src 0" \
        > ./install-tl-unx/texlive.profile && \
        ./install-tl-unx/install-tl \
        -repository https://texlive.texjp.org/${TL_VERSION}/tlnet/ \
        -profile ./install-tl-unx/texlive.profile && \
        rm -rf install-tl-unx/

## install additional packages
RUN tlmgr install ${TL_ADDITIONAL_PACKAGES}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "jaEmbed haranoaji" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys


## TeX Live 2022 frozen
FROM tllangjapanese-base AS tllangjapanese-tl22

ENV TL_VERSION       2022

RUN mkdir install-tl-unx && \
        wget -qO- https://texlive.texjp.org/${TL_VERSION}/tlnet/install-tl-unx.tar.gz | \
        tar -xz -C ./install-tl-unx --strip-components=1 && \
        printf "%s\n" \
            "TEXDIR ${TL_TEXDIR}" \
            "TEXMFLOCAL ${TL_TEXMFLOCAL}" \
            "TEXMFSYSVAR ${TL_TEXMFVAR}" \
            "TEXMFSYSCONFIG ${TL_TEXMFCONFIG}" \
            "TEXMFHOME ${TL_TEXMFLOCAL}" \
            "TEXMFVAR ${TL_TEXMFVAR}" \
            "TEXMFCONFIG ${TL_TEXMFCONFIG}" \
            "selected_scheme scheme-minimal" \
            "binary_${TLARCH}-linux 1" \
            "collection-binextra 1" \
            "collection-langjapanese 1" \
            "collection-latexextra 1" \
            "collection-luatex 1" \
            "collection-fontsrecommended 1" \
            "option_adjustrepo 0" \
            "option_autobackup 0" \
            "option_doc 0" \
            "option_src 0" \
        > ./install-tl-unx/texlive.profile && \
        ./install-tl-unx/install-tl \
        -repository https://texlive.texjp.org/${TL_VERSION}/tlnet/ \
        -profile ./install-tl-unx/texlive.profile && \
        rm -rf install-tl-unx/

## install additional packages
RUN tlmgr install ${TL_ADDITIONAL_PACKAGES}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "jaEmbed haranoaji" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys

# end of file
