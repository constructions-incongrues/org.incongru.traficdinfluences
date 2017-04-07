# net.constructions-incongrues.skel

## Développement

### Installation locale

```bash
git clone git@github.com:constructions-incongrues/org.incongru.traficdinfluences.git
cd org.incongru.traficdinfluences
vagrant up
```

### Récupération des sources de la production

Test :

```bash
rsync \
    -avz \
    --dry-run \
    --exclude=*.mp3 \
    --exclude=/test \
    --exclude=/wp-content/cache \
    --exclude=/wp-content/uploads \
    --exclude=/wp-config.php \
    --exclude=/tmp \
    -e 'ssh -p 2222' \
    incongru_org@ftp.pastis-hosting.net:traficdinfluences.incongru.org/ \
    ./src/web/
```

Réel : 

```bash
rsync \
    -avz \
    --exclude=*.mp3 \
    --exclude=/test \
    --exclude=/wp-content/cache \
    --exclude=/wp-content/uploads \
    --exclude=/wp-config.php \
    --exclude=/tmp \
    -e 'ssh -p 2222' \
    incongru_org@ftp.pastis-hosting.net:traficdinfluences.incongru.org/ \
    ./src/web/
```

### Déploiement en production

Test :

```bash
ant deploy -Dprofile=pastishosting
```

Réel:

```bash
ant deploy -Dprofile=pastishosting -Drsync.options=
```

## TODO

- [] [doc] Import d'une nouvelle émission
- [] [helpers] Mise au carré de wordpress_import_podcasts.sh
- [] [helpers] wordpress_import_podcasts.sh comme package wp-cli ?
- [] [helpers] wordpress_import_podcasts.sh comme extension wordpress ?
- [] [gfx] favicon (carré jaune)
- [] [abt] module wordpress (ant wordpress.pull)
- [x] .gitignore
- [x] [doc] Déploiement
- [x] [doc] Rapatriement
- [x] [dev] rapatrier les CSS additionels dans un child theme
- [x] [gfx] ajouter la phrase "Ce site est développé par, etc"