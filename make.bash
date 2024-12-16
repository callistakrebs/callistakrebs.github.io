htmlify() {
    pandoc \
        --from markdown \
        --to html5 \
        --standalone \
        --template template.html \
        --ascii \
        $1 \
        --out $2
}

htmlify index.md index.html
htmlify contact.md contact.html
htmlify projects/index.md projects/index.html