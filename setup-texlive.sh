#!/bin/bash
## setup-texlive.sh — common TeX Live installation routine
## Usage: setup-texlive.sh <TL_VERSION> <REPO_SCHEME> <UPDMAP_MODE>
##   REPO_SCHEME : "http" or "https"
##   UPDMAP_MODE : "legacy" (kanjiEmbed only) or "modern" (+ jaEmbed)
##
## Environment:
##   TL_REPO_PREFIX : override repository base URL
##                    (default: https://texlive.texjp.org)
##                    e.g. http://host.docker.internal:8080
set -eu

TL_VERSION="$1"
REPO_SCHEME="${2:-https}"
UPDMAP_MODE="${3:-modern}"

## resolve repository base URL
if [ -n "${TL_REPO_PREFIX:-}" ]; then
    REPO_BASE="${TL_REPO_PREFIX}"
else
    REPO_BASE="${REPO_SCHEME}://texlive.texjp.org"
fi

## ---- 1. install TeX Live ----
mkdir install-tl-unx
wget -qO- "${REPO_BASE}/${TL_VERSION}/tlnet/install-tl-unx.tar.gz" | \
    tar -xz -C ./install-tl-unx --strip-components=1

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
> ./install-tl-unx/texlive.profile


./install-tl-unx/install-tl \
    -repository "${REPO_BASE}/${TL_VERSION}/tlnet/" \
    -profile ./install-tl-unx/texlive.profile

rm -rf install-tl-unx/

## ---- 2. add / remove packages ----
tlmgr install ${TL_ADDPKGS} ||:
tlmgr uninstall --force ${TL_DELPKGS} ||:

## ---- 3. updmap: font map files & kanji profile ----
mkdir -p "${TL_TEXMFCONFIG}/web2c/"

if [ "${UPDMAP_MODE}" = "modern" ]; then
    printf "%s\n" \
        "jaEmbed haranoaji" \
        "kanjiEmbed haranoaji" \
        "kanjiVariant " \
    > "${TL_TEXMFCONFIG}/web2c/updmap.cfg"
else
    printf "%s\n" \
        "kanjiEmbed haranoaji" \
        "kanjiVariant " \
    > "${TL_TEXMFCONFIG}/web2c/updmap.cfg"
fi

mktexlsr "${TL_TEXMFLOCAL}/" "${TL_TEXMFCONFIG}/"
updmap-sys

## ---- 4. texmf.cnf ----
printf "%s\n" \
    "texmf_casefold_search = 0" \
    "font_mem_size = 16000000 " \
    "font_max = 18000         " \
    "ent_str_size = 2000      " \
    "error_line = 254         " \
    "half_error_line = 238    " \
    "max_print_line = 1048576 " \
>>"${TL_TEXDIR}/texmf.cnf"

## ---- 5. update tlnet ----
sed -i \
    -e "s,\(depend opt_location:\).*,\1${REPO_SCHEME}://texlive.texjp.org/${TL_VERSION}/tlnet/," \
    ${TL_TEXDIR}/tlpkg/texlive.tlpdb
