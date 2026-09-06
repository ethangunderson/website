---
name: add-media-review
description: >
  Interactively creates a new media review file for Ethan's website (_media/ directory)
  and a matching note in his Obsidian vault. Ethan gives a title; the skill works out
  whether it is a book, game, album, movie, or tv show, looks up creator, year, and cover
  art from free keyless APIs, confirms everything with Ethan, downloads the cover, writes
  both files, and leaves the prose to him.
  Use when Ethan says he wants to add a media review, log a book/game/album/movie/show,
  or says something like "I just finished X", "add X to media", or "log X".
---

# Add Media Review

When invoked, walk through these steps in order. Never create either file until all fields are confirmed. The words are Ethan's: never write the body, the description, or anything that reads as his opinion.

## Step 1 — Get the title

Ask Ethan for the title. He may add hints in the same message: the type, the creator, the year, or a URL. Use whatever he gives; nothing else is required to start.

## Step 2 — Classify the type

The allowed types are the ones `Website.Media.types/0` returns (`lib/website/media.ex`): `book`, `game`, `album`, `movie`, `tv`. A guard test in `test/website/media_collection_test.exs` fails the suite if a `_media/` entry uses anything else.

Run all three lookups with `curl -s` piped through `jq`. They are fast and independent, so run them together. URL-encode the title (spaces as `+`).

```bash
# book
curl -s 'https://openlibrary.org/search.json?title={q}&fields=key,title,author_name,first_publish_year,cover_i&limit=5' \
  | jq -c '.docs[] | {title, author: .author_name[0], year: .first_publish_year, cover_i}'

# album
curl -s 'https://itunes.apple.com/search?term={q}&media=music&entity=album&limit=5' \
  | jq -c '.results[] | {album: .collectionName, artist: .artistName, year: .releaseDate[0:4], art: .artworkUrl100}'

# movie / tv / game (and disambiguation for everything)
curl -s 'https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch={q}&srlimit=5&format=json' \
  | jq -r '.query.search[].title'
```

Read the Wikipedia titles for their disambiguators: `(film)` means movie, `(TV series)` means tv, `(video game)` means game, `(novel)` corroborates book, `(album)` corroborates album. A bare title with no suffix is usually the most famous form of the work; open its summary (Step 3) and read the first sentence.

If more than one type has a strong match (Project Hail Mary is both a novel and a film), stop and ask Ethan which he means. Do not guess.

## Step 3 — Fetch metadata and the cover URL

| Type | Source | `creator` | `year` | Cover URL |
|---|---|---|---|---|
| book | Open Library result from Step 2 | `author_name[0]` | `first_publish_year` | `https://covers.openlibrary.org/b/id/{cover_i}-L.jpg` (redirects; `curl -L`) |
| album | iTunes result from Step 2 | `artistName` | `releaseDate` year | `artworkUrl100` with `100x100bb` replaced by `1200x1200bb` |
| movie | Wikipedia summary | director | release year | `originalimage.source` |
| tv | Wikipedia summary | creator / showrunner | first-aired year | `originalimage.source` |
| game | Wikipedia summary | developer | release year | `originalimage.source` |

Wikipedia summary, using the exact page title from Step 2 with spaces as underscores:

```bash
curl -s 'https://en.wikipedia.org/api/rest_v1/page/summary/{Page_Title}' \
  | jq -c '{title, year: .extract, image: .originalimage.source, w: .originalimage.width, h: .originalimage.height}'
```

The `extract` is one paragraph that names the director, creator, or developer and the year. Strip the `?utm_source=…` query string from the image URL before using it.

Ethan's `creator` convention is not rigid: the existing movie entry credits the novel's author rather than the director. Present what the source says and let him override.

If a source has no cover (`cover_i` missing, no `originalimage`), try the Wikipedia page for the work (`{Title} (novel)`, `{Title} (album)`). If that fails too, ask Ethan for an image URL.

## Step 4 — Confirm with Ethan

Present title, type, creator, year, and the cover URL, clearly flagging anything you could not determine. Ask him to confirm or correct each value. Also collect:

- `rating` — 1 to 7 on the shared scale (always ask; this is subjective)
- `date` — default to today's date in YYYY-MM-DD format, but let Ethan override. This is the date he is logging it, not the release year.

## Step 5 — Ask for prose

Ask: "Any thoughts to include in the body? If not, I'll leave it blank." Record his words verbatim or leave the body empty. Never draft it.

## Step 6 — Derive slug and paths

Read the existing filenames in `_media/` and `extra/images/media/` first and match their convention:

- **slug**: lowercase, spaces to hyphens, drop everything that is not alphanumeric or a hyphen. If that collides with an existing entry of a different type, suffix the type: `project-hail-mary-movie`.
- **website filename**: `_media/{slug}.md`
- **permalink**: `/media/{slug}`
- **image filename**: `extra/images/media/{slug}.webp`, referenced in frontmatter as `/images/media/{slug}.webp`
- **Obsidian filename**: `/Users/ethan/Documents/Second Brain/Media/{title}.md`

The markdown filename and the permalink slug must be identical; the guard test checks it.

## Step 7 — Download and convert the cover

```bash
curl -L -A "ethangunderson.com media skill" -o /tmp/{slug}.orig "{cover_url}" && \
cwebp -q 82 -resize 600 0 /tmp/{slug}.orig \
  -o /Users/ethan/projects/website/extra/images/media/{slug}.webp && \
rm /tmp/{slug}.orig
```

Then report the file size and pixel dimensions:

```bash
ls -l /Users/ethan/projects/website/extra/images/media/{slug}.webp
sips -g pixelWidth -g pixelHeight /Users/ethan/projects/website/extra/images/media/{slug}.webp
```

The layout renders albums square and everything else at 2:3 with `object-cover`, so a landscape image is cropped silently. TV pages on Wikipedia often carry a wide title card rather than a poster. If the aspect ratio is not close to the target, say so and offer to take a different URL from Ethan before writing either file.

## Step 8 — Write the website markdown file

Write to `_media/{slug}.md` from the project root (`/Users/ethan/projects/website`):

```markdown
---
layout: Website.MediaLayout
title: "{title}"
categories: media
type: {type}
creator: "{creator}"
rating: {rating}
date: {date}
year: {year}
permalink: /media/{slug}
image: /images/media/{slug}.webp
description: "[DESCRIPTION NEEDED]"
---

{prose}
```

`description` is the page's meta description and `og:description`. It is Ethan's copy; always write the `[DESCRIPTION NEEDED]` stub. The cover image doubles as the `og:image`, so there is no share-image step for media.

## Step 9 — Write the Obsidian note

Write to `/Users/ethan/Documents/Second Brain/Media/{title}.md`. `link` is the source page you pulled metadata from (Open Library work, iTunes album, or Wikipedia article), or a URL Ethan gave.

```markdown
---
name: {title}
type: {type}
creator: "[[{creator}]]"
year: {year}
rating: {rating}
link: {link}
tags:
  - media
  - {type}
date: {date}
---
## Notes

{prose}
```

A Templater template with the same keys lives at `templates/media.md` in the vault for notes Ethan creates by hand.

## Step 10 — Verify

```bash
mix test && mix build
ls _site/media/{slug}/index.html
```

Vale runs on staged `_media/*.md` in the pre-commit hook, so a body with prose may get style feedback at commit time.

## Step 11 — Confirm

Tell Ethan what was created: the website path, the Obsidian path, and the cover image with its dimensions. Name the fields still needing his words: `description`, and the body if he left it blank.
