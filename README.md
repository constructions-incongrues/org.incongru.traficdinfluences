# net.constructions-incongrues.skel

## Utilisation

### Import d'une nouvelle émission

Le fichier de l'émission doit être nommé ainsi : `traficdinfluences_<numéro de l'épisode sur trois chiffres>_<YYYYMMDD>.mp3`

```bash
```

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
- [] [helpers] refacto wordpress_import_podcasts.sh pour pouvoir tagger et importer vers un post de podcast existant
- [] [abt] module wordpress (ant wordpress.pull)
- [] [wordpress] activer le publication automatique sur Facebook
- [] [wordpress] reporter les textes des annonces Facebook s'il y a lieu
- [] [wordpress] reporter les playlists si elles existent
- [] [comm] créer un post pour annoncer le nouveau site
- [] [wordpress] installer un plugin OGP
- [] [facebook] inline player
- [x] [abt] modifier le module rsync2 pour accepter un paramètre "rsync.local.path"
- [x] [gfx] favicon (carré jaune)
- [x] .gitignore
- [x] [doc] Déploiement
- [x] [doc] Rapatriement
- [x] [dev] rapatrier les CSS additionels dans un child theme
- [x] [gfx] ajouter la phrase "Ce site est développé par, etc"