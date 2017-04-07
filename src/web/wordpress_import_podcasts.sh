#!/bin/bash

# TODO
# Script d'import :
# - Tagger les MP3 !
# - Réembrayer publicize Facebook quand c'est fini

GLOB=${1:=./*.mp3}

# Pour chaque fichier correspondant au glob
for FILE in $GLOB; do
    # Extraction des données utiles depuis le nom du fichier
    IFS='_' read -r -a PARTS <<< $(basename "$FILE" .mp3)
    EPISODE=$(echo ${PARTS[1]} | bc)
    DATE_RAW=${PARTS[2]}
    DATE_LONG=$(date +%Y-%m-%d:%H:%M:%S -d "$DATE_RAW")
    DATE_SHORT=$(date +%Y-%m-%d -d "$DATE_RAW")
    DATE_YEAR=$(date +%Y -d "$DATE_RAW")

    # Création d'un brouillon du podcast
    echo "Creating post Épisode #$EPISODE"
    POST_ID=$(wp post create --post_type=podcast --post_title="Épisode #$EPISODE ($DATE_SHORT)" --post_date="$DATE_LONG" --porcelain)
    echo "post_id=$POST_ID"

    # Récupération des propriétés du post
    POST_JSON=$(wp post get $POST_ID --format=json)

    # Édition des tags id3 de l'émission
    echo "Tagging media $FILE"
    eyeD3 --remove-all "$FILE"
    eyeD3 \
        --artist="Trafic d'Influences" \
        --album="Radio Campus Paris" \
        --title="Trafic d'Influences #$EPISODE" \
        --track="$EPISODE" \
        --year="$DATE_YEAR" \
        --set-url-frame="WORS:$(echo $POST_JSON | jq -r .guid)" \
        "$FILE"

    # Import de l'émission en MP3
    echo "Importing media $FILE"
    ATTACHMENT_ID=$(wp media import $FILE --post_id=$POST_ID --porcelain)
    echo "attachment_id=$ATTACHMENT_ID"

    # Récupération de l'URI du media  
    ATTACHMENT_URI=$(wp post meta get $ATTACHMENT_ID _wp_attached_file)

    # Récupération des métadonnées du media
    ATTACHMENT_JSON_METADATA=$(wp post meta get $ATTACHMENT_ID _wp_attachment_metadata --format=json)

    # Définition des métadonnées du post
    wp post meta set "$POST_ID" episode_type audio
    wp post meta set "$POST_ID" audio_file "http://traficdinfluences.incongru.org/wp-content/uploads/$ATTACHMENT_URI"
    wp post meta set "$POST_ID" date_recorded "$DATE_SHORT"
    wp post meta set "$POST_ID" enclosure "http://traficdinfluences.incongru.org/wp-content/uploads/$ATTACHMENT_URI"
    wp post meta set "$POST_ID" duration $(echo $ATTACHMENT_JSON_METADATA | jq -r .length_formatted)
    wp post meta set "$POST_ID" filesize_raw $(echo $ATTACHMENT_JSON_METADATA | jq -r .filesize)
    wp post meta set "$POST_ID" filesize "$(($(echo $ATTACHMENT_JSON_METADATA | jq -r .filesize) / 1024 / 1024))M"

    # Publication du podcast
    wp post update "$POST_ID" --post_status=publish
    wp post update "$POST_ID" --post_date="$DATE_LONG"
done;
