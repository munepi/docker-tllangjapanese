# munepi/tllangjapanese

custom enriched Japanese TeX Live environment image

## Supported tags and respective `Dockerfile` links

 * [`latest` = `2023` = `2023.20230506`](https://github.com/munepi/docker-tllangjapanese/blob/20230506/Dockerfile): TeX Live 2023 current (`x86_64-linux`, `aarch64-linux`)
 * [`2022` = `2022.20240225`](https://github.com/munepi/docker-tllangjapanese/blob/20240225/Dockerfile): TeX Live 2022 frozen (`x86_64-linux`, `aarch64-linux`)
 * [`2021` = `2021.20221111`](https://github.com/munepi/docker-tllangjapanese/blob/20221111/Dockerfile): TeX Live 2021 frozen (`x86_64-linux`, `aarch64-linux`)
 * [`2020` = `2020.20220424`](https://github.com/munepi/docker-tllangjapanese/blob/20220424/Dockerfile): TeX Live 2020 frozen (`x86_64-linux`, `aarch64-linux`)
 * [`2019` = `2019.20221112`](https://github.com/munepi/docker-tllangjapanese/blob/20221112/Dockerfile): TeX Live 2019 frozen (`x86_64-linux`, `aarch64-linux`)
 * [`2018` = `2018.20220614`](https://github.com/munepi/docker-tllangjapanese/blob/20220614/Dockerfile): TeX Live 2018 frozen (`x86_64-linux`, `aarch64-linux`)
 * [`2017` = `2017.20230508`](https://github.com/munepi/docker-tllangjapanese/blob/20230506/Dockerfile): TeX Live 2017 frozen (`x86_64-linux`, `aarch64-linux`)
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

 * `20240225`
    * tlmgr: add algorithmicx bbold bbold-type1 (TL12+)
 * `20230602`
    * tlmgr: add roboto (TL14+)
 * `20230506`
    * tlmgr: add physics systeme (TL12+)
 * `20220614`
    * tlmgr: add sourcesanspro (TL12+)
 * `20220520`
    * tlmgr: add noto-emoji (TL19+)
 * `20220424`
    * tlmgr: add fontawesome sourcecodepro ulem (TL12+)
    * tlmgr: add stix2-otf stix2-type1 (TL18+)
 * `20211024`
    * tlmgr: add algorithms mnsymbol ebgaramond inconsolata (TL12+)

These images are based on [munepi/tllangjapanese-base](https://hub.docker.com/r/munepi/tllangjapanese-base).

# munepi/tllangjapanese-base

custom Debian GNU/Linux image

## Supported tags and respective `Dockerfile` links

 * [`latest` = `20240225`](https://github.com/munepi/docker-tllangjapanese/blob/20240225/Dockerfile), [`20230703`](https://github.com/munepi/docker-tllangjapanese/blob/20230703/Dockerfile): based on `debian:bookworm-slim` (`linux/amd64`, `linux/arm64`)
 * [`20230506`](https://github.com/munepi/docker-tllangjapanese/blob/20230506/Dockerfile), [`20221111`](https://github.com/munepi/docker-tllangjapanese/blob/20220614/Dockerfile): based on `debian:bullseye-slim` (`linux/amd64`, `linux/arm64`)
 * `20211024`: based on `debian:buster-slim` (`linux/amd64`)

These images contain the following packages:

 * ca-certificates
 * file
 * imagemagick
 * git-core
 * ghostscript
 * make
 * ruby
 * wget
 * xz-utils, xzdec
