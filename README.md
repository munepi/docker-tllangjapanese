# munepi/tllangjapanese

custom enriched Japanese TeX Live environment image

## Supported tags and respective `Dockerfile` links

 * [`latest` = `2024` = `2024.20240525`](https://github.com/munepi/docker-tllangjapanese/blob/20240525/Dockerfile): TeX Live 2024 current (`x86_64-linux`, `aarch64-linux`)
 * [`2023` = `2023.20240323`](https://github.com/munepi/docker-tllangjapanese/blob/20240323/Dockerfile): TeX Live 2023 frozen (`x86_64-linux`, `aarch64-linux`)
 * [`2022` = `2022.20240225`](https://github.com/munepi/docker-tllangjapanese/blob/20240225/Dockerfile): TeX Live 2022 frozen (`x86_64-linux`, `aarch64-linux`)
 * [`2021` = `2021.20221111`](https://github.com/munepi/docker-tllangjapanese/blob/20221111/Dockerfile): TeX Live 2021 frozen (`x86_64-linux`, `aarch64-linux`)
 * [`2020` = `2020.20220907`](https://github.com/munepi/docker-tllangjapanese/blob/20220614/Dockerfile): TeX Live 2020 frozen (`x86_64-linux`, `aarch64-linux`)
 * [`2019` = `2019.20221112`](https://github.com/munepi/docker-tllangjapanese/blob/20221112/Dockerfile): TeX Live 2019 frozen (`x86_64-linux`, `aarch64-linux`)
 * [`2018` = `2018.20220614`](https://github.com/munepi/docker-tllangjapanese/blob/20220614/Dockerfile): TeX Live 2018 frozen (`x86_64-linux`, `aarch64-linux`)
 * [`2017` = `2017.20230508`](https://github.com/munepi/docker-tllangjapanese/blob/20230506/Dockerfile): TeX Live 2017 frozen (`x86_64-linux`, `aarch64-linux`)
 * [`2016` = `2016.20240303`](https://github.com/munepi/docker-tllangjapanese/blob/20240225/Dockerfile): TeX Live 2016 frozen (`x86_64-linux`)
 * [`2015` = `2015.20240303`](https://github.com/munepi/docker-tllangjapanese/blob/20240225/Dockerfile): TeX Live 2015 frozen (`x86_64-linux`)
 * [`2014` = `2014.20240303`](https://github.com/munepi/docker-tllangjapanese/blob/20240225/Dockerfile): TeX Live 2014 frozen (`x86_64-linux`)
 * [`2013` = `2013.20240303`](https://github.com/munepi/docker-tllangjapanese/blob/20240225/Dockerfile): TeX Live 2013 frozen (`x86_64-linux`)
 * [`2012` = `2012.20240303`](https://github.com/munepi/docker-tllangjapanese/blob/20240225/Dockerfile): TeX Live 2012 frozen (`x86_64-linux`)

These images contain the following components:

 * collection-binextra
 * collection-langjapanese
 * collection-latexextra
 * collection-luatex
 * collection-fontsrecommended
 * the latest haranoaji haranoaji-extra

Some tags below have additional/reduced packages:

 * `20240323` or higher
    * tlmgr: delete tex4ht (TL12+)
    * tlmgr: delete make4ht tex4ebook (TL14+)
    * tlmgr: delete tlcockpit (TL17+)
    * tlmgr: delete haranoaji haranoaji-extra (TL19+)
 * `20240225` or higher 
    * tlmgr: add algorithmicx bbold bbold-type1 (TL12+)
 * `20230602` or higher 
    * tlmgr: add roboto (TL14+)
 * `20230506` or higher 
    * tlmgr: add physics systeme (TL12+)
 * `20220614` or higher 
    * tlmgr: add algorithms fontawesome mnsymbol ebgaramond inconsolata sourcecodepro sourcesanspro ulem (TL12+)
    * tlmgr: add stix2-otf stix2-type1 (TL18+)
    * tlmgr: add noto-emoji (TL19+)

These images are based on [munepi/tllangjapanese-base](https://hub.docker.com/r/munepi/tllangjapanese-base).


# munepi/tllangjapanese-base

custom Debian GNU/Linux image

## Supported tags and respective `Dockerfile` links

 * [`latest` = `20240525`](https://github.com/munepi/docker-tllangjapanese/blob/20240525/Dockerfile): based on `debian:bookworm-slim` (`linux/amd64`, `linux/arm64`)

These images contain the following packages:

 * ca-certificates
 * file
 * fontconfig
 * imagemagick
 * git-core
 * ghostscript
 * make
 * python3-pygments
 * ruby
 * unzip
 * wget
 * xz-utils, xzdec
 * zstd


--------------------

Munehiro Yamamoto
https://github.com/munepi
