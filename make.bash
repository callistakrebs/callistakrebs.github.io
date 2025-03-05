htmlify() {
    pandoc \
        --from markdown+backtick_code_blocks \
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
htmlify projects/adventofcode/index.md projects/adventofcode/index.html
htmlify projects/adventofcode/wrapup.md projects/adventofcode/wrapup.html
htmlify projects/swebench/index.md projects/swebench/index.html

for i in {1..19}; do
    htmlify projects/adventofcode/day$i.md projects/adventofcode/day$i.html
done
    