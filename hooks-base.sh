#!/bin/bash

##### Não Editar Start #####
AUR=
webhooks() {
echo '
curl -X POST \
-H "Accept: application/json" \
-H "Authorization: token '$CHAVE'" \
--data '"'{"'"event_type"'": "'"'AUR/$AUR'"'", "'"client_payload"'": { "'"pkgbuild"'": "'""'", "'"branch"'": "'"'stable'"'", "'"url"'": "'"https://aur.archlinux.org/'$AUR'"'", "'"version"'": "'"1.2.3"'"}}'"' \
'https://api.github.com/repos/BigLinux-Package-Build/build-package/dispatches'' > run-webhooks-aur.sh

bash -x run-webhooks-aur.sh
rm run-webhooks-aur.sh
}
##### NÃO Editar End #####


#nome do programa como está no pacman
pkgname=

#versão online no site da AUR
pkgver=$(curl -s https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=$pkgname | sed 's/<[^>]*>//g' | grep pkgver= | cut -d "=" -f2 | sed 's|\.||g' | sed 's|-||g' | cut -d "}" -f2)
pkgrel=$(curl -s https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=$pkgname | sed 's/<[^>]*>//g' | grep pkgrel= | cut -d "=" -f2 | sed 's|\.||g' | sed 's|-||g')
versite=$pkgver$pkgrel

#versão do repositorio do biglinux
verrepo=$(pacman -Ss $pkgname | grep biglinux-stable | cut -d " " -f2  | sed 's/\.//g' | sed 's/\-//')

#se versão do site foi maior que a versão do repo local
if [ "$versite" -gt "$verrepo" ]; then
    echo "Envia Package Build"
    AUR=$pkgname
    webhooks
fi


