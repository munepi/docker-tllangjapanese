# munepi/tllangjapanese

custom enriched Japanese TeX Live environment image

## Supported tags and respective `Dockerfile` links

 * [`latest` = `2022` = `2022.20220424`](https://github.com/munepi/docker-tllangjapanese/blob/20220424/Dockerfile): TeX Live 2022 current (`x86_64-linux`, `aarch64-linux`)
 * [`2021` = `2021.20220520`](https://github.com/munepi/docker-tllangjapanese/blob/20220520/Dockerfile): TeX Live 2021 frozen (`x86_64-linux`, `aarch64-linux`)
 * [`2020` = `2020.20220424`](https://github.com/munepi/docker-tllangjapanese/blob/20220424/Dockerfile): TeX Live 2020 frozen (`x86_64-linux`, `aarch64-linux`)
 * [`2019` = `2019.20220424`](https://github.com/munepi/docker-tllangjapanese/blob/20220424/Dockerfile): TeX Live 2019 frozen (`x86_64-linux`, `aarch64-linux`)
 * [`2018` = `2018.20220424`](https://github.com/munepi/docker-tllangjapanese/blob/20220424/Dockerfile): TeX Live 2018 frozen (`x86_64-linux`, `aarch64-linux`)
 * `2017` = `2017.20211024`: TeX Live 2017 frozen (`x86_64-linux`)
 * `2016` = `2016.20211024`: TeX Live 2016 frozen (`x86_64-linux`)
 * `2015` = `2015.20211024`: TeX Live 2015 frozen (`x86_64-linux`)
 * `2014` = `2014.20211024`: TeX Live 2014 frozen (`x86_64-linux`)
 * `2013` = `2013.20211024`: TeX Live 2013 frozen (`x86_64-linux`)
 * `2012` = `2012.20211024`: TeX Live 2012 frozen (`x86_64-linux`)

These images contain the following components:

 * collection-binextra
 * collection-langjapanese
 * collection-latexextra
 * collection-luatex
 * collection-fontsrecommended

Some tags below contain additional packages: 

 * `20220520`
    * tlmgr: add algorithms mnsymbol ebgaramond fontawesome inconsolata noto-emoji sourcecodepro stix2-otf stix2-type1 ulem
 * `latest` = `20220424`
    * tlmgr: add algorithms mnsymbol ebgaramond fontawesome inconsolata sourcecodepro stix2-otf stix2-type1 ulem
 * `20211024`
    * tlmgr: add algorithms mnsymbol ebgaramond inconsolata

These images are based on [munepi/tllangjapanese-base](https://hub.docker.com/r/munepi/tllangjapanese-base).

# munepi/tllangjapanese-base

custom Debian GNU/Linux image

## Supported tags and respective `Dockerfile` links

 * [`latest` = `20220424`](https://github.com/munepi/docker-tllangjapanese/blob/20220424/Dockerfile): based on `debian:bullseye-slim` (`linux/amd64`, `linux/arm64`)
 * `20211024`: based on `debian:buster-slim` (`linux/amd64`)

These images contain the following packages:

 * ca-certificates
 * git-core
 * ghostscript
 * make
 * ruby
 * wget
 * xz-utils, xzdec
