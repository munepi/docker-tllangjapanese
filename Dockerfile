## bootstrap
FROM debian:bookworm-slim AS tllangjapanese-base

LABEL maintainer="munepixyz@gmail.com"

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

## setup
RUN apt-get update && \
        apt-get install -y --no-install-recommends \
        locales make git-core unzip wget xz-utils xzdec zstd ca-certificates \
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
ENV TL_ADDPKGS_TL12        \
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
    systeme \
    ulem
ENV TL_ADDPKGS_TL13        \
    ${TL_ADDPKGS_TL12}
ENV TL_ADDPKGS_TL14        \
    ${TL_ADDPKGS_TL13} \
    roboto
ENV TL_ADDPKGS_TL15        \
    ${TL_ADDPKGS_TL14}
ENV TL_ADDPKGS_TL16        \
    ${TL_ADDPKGS_TL15}
ENV TL_ADDPKGS_TL17        \
    ${TL_ADDPKGS_TL16} \
    plex
ENV TL_ADDPKGS_TL18        \
    ${TL_ADDPKGS_TL17} \
    stix2-otf stix2-type1
ENV TL_ADDPKGS_TL19        \
    ${TL_ADDPKGS_TL18} \
    noto-emoji
ENV TL_ADDPKGS_TL20        \
    ${TL_ADDPKGS_TL19}
ENV TL_ADDPKGS_TL21        \
    ${TL_ADDPKGS_TL20}
ENV TL_ADDPKGS_TL22        \
    ${TL_ADDPKGS_TL21}
ENV TL_ADDPKGS_TL23        \
    ${TL_ADDPKGS_TL22}
ENV TL_ADDPKGS_TL24        \
    ${TL_ADDPKGS_TL23}
ENV TL_ADDPKGS_TL25        \
    ${TL_ADDPKGS_TL24}

## reduced packages
ENV TL_DELPKGS_TL12        \
    tex4ht tex4ht.${TLARCH}-linux
ENV TL_DELPKGS_TL13        \
    ${TL_DELPKGS_TL12}
ENV TL_DELPKGS_TL14        \
    ${TL_DELPKGS_TL13}
ENV TL_DELPKGS_TL15        \
    ${TL_DELPKGS_TL14} \
    make4ht make4ht.${TLARCH}-linux tex4ebook tex4ebook.${TLARCH}-linux
ENV TL_DELPKGS_TL16        \
    ${TL_DELPKGS_TL15}
ENV TL_DELPKGS_TL17        \
    ${TL_DELPKGS_TL16} \
    tlcockpit tlcockpit.${TLARCH}-linux
ENV TL_DELPKGS_TL18        \
    ${TL_DELPKGS_TL17}
ENV TL_DELPKGS_TL19        \
    ${TL_DELPKGS_TL18} \
    haranoaji haranoaji-extra
ENV TL_DELPKGS_TL20        \
    ${TL_DELPKGS_TL19} \
    tlshell tlshell.${TLARCH}-linux
ENV TL_DELPKGS_TL21        \
    ${TL_DELPKGS_TL20}
ENV TL_DELPKGS_TL22        \
    ${TL_DELPKGS_TL21}
ENV TL_DELPKGS_TL23        \
    ${TL_DELPKGS_TL22}
ENV TL_DELPKGS_TL24        \
    ${TL_DELPKGS_TL23}
ENV TL_DELPKGS_TL25        \
    ${TL_DELPKGS_TL24}

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


## TeX Live 2012 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl12

ENV TL_VERSION					2012
ENV TL_ADDPKGS		${TL_ADDPKGS_TL12}
ENV TL_DELPKGS		${TL_DELPKGS_TL12}

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

RUN tlmgr install ${TL_ADDPKGS} && \
    tlmgr uninstall --force ${TL_DELPKGS}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys

## setup suitable texmf.cnf
RUN printf "%s\n" \
        "texmf_casefold_search = 0" \
        "font_mem_size = 16000000 " \
        "font_max = 18000         " \
        "ent_str_size = 2000      " \
        "error_line = 254         " \
        "half_error_line = 238    " \
        "max_print_line = 1048576 " \
    >>${TL_TEXDIR}/texmf.cnf


## TeX Live 2013 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl13

ENV TL_VERSION					2013
ENV TL_ADDPKGS		${TL_ADDPKGS_TL13}
ENV TL_DELPKGS		${TL_DELPKGS_TL13}

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

RUN tlmgr install ${TL_ADDPKGS} && \
    tlmgr uninstall --force ${TL_DELPKGS}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys

## setup suitable texmf.cnf
RUN printf "%s\n" \
        "texmf_casefold_search = 0" \
        "font_mem_size = 16000000 " \
        "font_max = 18000         " \
        "ent_str_size = 2000      " \
        "error_line = 254         " \
        "half_error_line = 238    " \
        "max_print_line = 1048576 " \
    >>${TL_TEXDIR}/texmf.cnf


## TeX Live 2014 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl14

ENV TL_VERSION					2014
ENV TL_ADDPKGS		${TL_ADDPKGS_TL14}
ENV TL_DELPKGS		${TL_DELPKGS_TL14}

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

RUN tlmgr install ${TL_ADDPKGS} && \
    tlmgr uninstall --force ${TL_DELPKGS}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys

## setup suitable texmf.cnf
RUN printf "%s\n" \
        "texmf_casefold_search = 0" \
        "font_mem_size = 16000000 " \
        "font_max = 18000         " \
        "ent_str_size = 2000      " \
        "error_line = 254         " \
        "half_error_line = 238    " \
        "max_print_line = 1048576 " \
    >>${TL_TEXDIR}/texmf.cnf


## TeX Live 2015 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl15

ENV TL_VERSION					2015
ENV TL_ADDPKGS		${TL_ADDPKGS_TL15}
ENV TL_DELPKGS		${TL_DELPKGS_TL15}

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

RUN tlmgr install ${TL_ADDPKGS} && \
    tlmgr uninstall --force ${TL_DELPKGS}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys

## setup suitable texmf.cnf
RUN printf "%s\n" \
        "texmf_casefold_search = 0" \
        "font_mem_size = 16000000 " \
        "font_max = 18000         " \
        "ent_str_size = 2000      " \
        "error_line = 254         " \
        "half_error_line = 238    " \
        "max_print_line = 1048576 " \
    >>${TL_TEXDIR}/texmf.cnf


## TeX Live 2016 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl16

ENV TL_VERSION					2016
ENV TL_ADDPKGS		${TL_ADDPKGS_TL16}
ENV TL_DELPKGS		${TL_DELPKGS_TL16}

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

RUN tlmgr install ${TL_ADDPKGS} && \
    tlmgr uninstall --force ${TL_DELPKGS}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys

## setup suitable texmf.cnf
RUN printf "%s\n" \
        "texmf_casefold_search = 0" \
        "font_mem_size = 16000000 " \
        "font_max = 18000         " \
        "ent_str_size = 2000      " \
        "error_line = 254         " \
        "half_error_line = 238    " \
        "max_print_line = 1048576 " \
    >>${TL_TEXDIR}/texmf.cnf


## TeX Live 2017 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl17

ENV TL_VERSION					2017
ENV TL_ADDPKGS		${TL_ADDPKGS_TL17}
ENV TL_DELPKGS		${TL_DELPKGS_TL17}

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

RUN tlmgr install ${TL_ADDPKGS} && \
    tlmgr uninstall --force ${TL_DELPKGS}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "jaEmbed haranoaji" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys

## setup suitable texmf.cnf
RUN printf "%s\n" \
        "texmf_casefold_search = 0" \
        "font_mem_size = 16000000 " \
        "font_max = 18000         " \
        "ent_str_size = 2000      " \
        "error_line = 254         " \
        "half_error_line = 238    " \
        "max_print_line = 1048576 " \
    >>${TL_TEXDIR}/texmf.cnf


## TeX Live 2018 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl18

ENV TL_VERSION					2018
ENV TL_ADDPKGS		${TL_ADDPKGS_TL18}
ENV TL_DELPKGS		${TL_DELPKGS_TL18}

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

RUN tlmgr install ${TL_ADDPKGS} && \
    tlmgr uninstall --force ${TL_DELPKGS}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "jaEmbed haranoaji" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys

## setup suitable texmf.cnf
RUN printf "%s\n" \
        "texmf_casefold_search = 0" \
        "font_mem_size = 16000000 " \
        "font_max = 18000         " \
        "ent_str_size = 2000      " \
        "error_line = 254         " \
        "half_error_line = 238    " \
        "max_print_line = 1048576 " \
    >>${TL_TEXDIR}/texmf.cnf


## TeX Live 2019 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl19

ENV TL_VERSION					2019
ENV TL_ADDPKGS		${TL_ADDPKGS_TL19}
ENV TL_DELPKGS		${TL_DELPKGS_TL19}

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

RUN tlmgr install ${TL_ADDPKGS} && \
    tlmgr uninstall --force ${TL_DELPKGS}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "jaEmbed haranoaji" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys

## setup suitable texmf.cnf
RUN printf "%s\n" \
        "texmf_casefold_search = 0" \
        "font_mem_size = 16000000 " \
        "font_max = 18000         " \
        "ent_str_size = 2000      " \
        "error_line = 254         " \
        "half_error_line = 238    " \
        "max_print_line = 1048576 " \
    >>${TL_TEXDIR}/texmf.cnf


## TeX Live 2020 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl20

ENV TL_VERSION					2020
ENV TL_ADDPKGS		${TL_ADDPKGS_TL20}
ENV TL_DELPKGS		${TL_DELPKGS_TL20}

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

RUN tlmgr install ${TL_ADDPKGS} && \
    tlmgr uninstall --force ${TL_DELPKGS}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "jaEmbed haranoaji" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys

## setup suitable texmf.cnf
RUN printf "%s\n" \
        "texmf_casefold_search = 0" \
        "font_mem_size = 16000000 " \
        "font_max = 18000         " \
        "ent_str_size = 2000      " \
        "error_line = 254         " \
        "half_error_line = 238    " \
        "max_print_line = 1048576 " \
    >>${TL_TEXDIR}/texmf.cnf


## TeX Live 2021 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl21

ENV TL_VERSION					2021
ENV TL_ADDPKGS		${TL_ADDPKGS_TL21}
ENV TL_DELPKGS		${TL_DELPKGS_TL21}

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

RUN tlmgr install ${TL_ADDPKGS} && \
    tlmgr uninstall --force ${TL_DELPKGS}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "jaEmbed haranoaji" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys

## setup suitable texmf.cnf
RUN printf "%s\n" \
        "texmf_casefold_search = 0" \
        "font_mem_size = 16000000 " \
        "font_max = 18000         " \
        "ent_str_size = 2000      " \
        "error_line = 254         " \
        "half_error_line = 238    " \
        "max_print_line = 1048576 " \
    >>${TL_TEXDIR}/texmf.cnf


## TeX Live 2022 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl22

ENV TL_VERSION					2022
ENV TL_ADDPKGS		${TL_ADDPKGS_TL22}
ENV TL_DELPKGS		${TL_DELPKGS_TL22}

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

RUN tlmgr install ${TL_ADDPKGS} && \
    tlmgr uninstall --force ${TL_DELPKGS}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "jaEmbed haranoaji" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys

## setup suitable texmf.cnf
RUN printf "%s\n" \
        "texmf_casefold_search = 0" \
        "font_mem_size = 16000000 " \
        "font_max = 18000         " \
        "ent_str_size = 2000      " \
        "error_line = 254         " \
        "half_error_line = 238    " \
        "max_print_line = 1048576 " \
    >>${TL_TEXDIR}/texmf.cnf


## TeX Live 2023 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl23

ENV TL_VERSION					2023
ENV TL_ADDPKGS		${TL_ADDPKGS_TL23}
ENV TL_DELPKGS		${TL_DELPKGS_TL23}

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

RUN tlmgr install ${TL_ADDPKGS} && \
    tlmgr uninstall --force ${TL_DELPKGS}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "jaEmbed haranoaji" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys

## setup suitable texmf.cnf
RUN printf "%s\n" \
        "texmf_casefold_search = 0" \
        "font_mem_size = 16000000 " \
        "font_max = 18000         " \
        "ent_str_size = 2000      " \
        "error_line = 254         " \
        "half_error_line = 238    " \
        "max_print_line = 1048576 " \
    >>${TL_TEXDIR}/texmf.cnf


## TeX Live 2024 frozen
FROM tllangjapanese-preset AS tllangjapanese-tl24

ENV TL_VERSION					2024
ENV TL_ADDPKGS		${TL_ADDPKGS_TL24}
ENV TL_DELPKGS		${TL_DELPKGS_TL24}

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

RUN tlmgr install ${TL_ADDPKGS} && \
    tlmgr uninstall --force ${TL_DELPKGS}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "jaEmbed haranoaji" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys

## setup suitable texmf.cnf
RUN printf "%s\n" \
        "texmf_casefold_search = 0" \
        "font_mem_size = 16000000 " \
        "font_max = 18000         " \
        "ent_str_size = 2000      " \
        "error_line = 254         " \
        "half_error_line = 238    " \
        "max_print_line = 1048576 " \
    >>${TL_TEXDIR}/texmf.cnf


## TeX Live 2025 pretest
FROM tllangjapanese-preset AS tllangjapanese-tl25

ENV TL_VERSION					2025
ENV TL_ADDPKGS		${TL_ADDPKGS_TL25}
ENV TL_DELPKGS		${TL_DELPKGS_TL25}

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

RUN tlmgr install ${TL_ADDPKGS} && \
    tlmgr uninstall --force ${TL_DELPKGS}

## update font map files & check current kanji profile
RUN mkdir -p ${TL_TEXMFCONFIG}/web2c/ && \
        printf "%s\n" \
            "jaEmbed haranoaji" \
            "kanjiEmbed haranoaji" \
            "kanjiVariant " \
        > ${TL_TEXMFCONFIG}/web2c/updmap.cfg && \
        mktexlsr ${TL_TEXMFLOCAL}/ ${TL_TEXMFCONFIG}/ && \
        updmap-sys

## setup suitable texmf.cnf
RUN printf "%s\n" \
        "texmf_casefold_search = 0" \
        "font_mem_size = 16000000 " \
        "font_max = 18000         " \
        "ent_str_size = 2000      " \
        "error_line = 254         " \
        "half_error_line = 238    " \
        "max_print_line = 1048576 " \
    >>${TL_TEXDIR}/texmf.cnf


# end of file
