---
name: add-coffee-review
description: >
  Interactively creates a new coffee review file for Ethan's website (_coffee/ directory)
  and a matching note in his Obsidian vault.
  Ask for the product page URL, fetch and parse it to extract as much frontmatter as possible,
  confirm or fill in gaps with Ethan, then download the image and write both files.
  Use when Ethan says he wants to add a coffee review, log a new coffee, or says something like
  "I just got a new bag" or "add this coffee".
---

# Add Coffee Review

When invoked, walk through these steps in order. Never create either file until all fields are confirmed.

## Step 1 — Get the product URL

Ask Ethan for the roaster's product page URL for the coffee he wants to review. This is the only thing you need to start.

## Step 2 — Fetch and extract metadata

Use `WebFetch` on the URL to pull the page content. Extract as many of the following fields as the page contains:

| Field | What to look for |
|---|---|
| `title` | Coffee name (without the roaster name prefix) |
| `roaster` | Brand/roaster name |
| `process` | Processing method — e.g. "Washed", "Natural", "Honey", "Co-fermented" |
| `region` | Country of origin only — e.g. "Colombia", "Ethiopia", "Kenya". Never use sub-regions, farm names, or city names. |
| `roast_level` | Roast descriptor — e.g. "Light", "Light-Medium", "Medium", "Dark" |
| `producer` | Farm or producer name, if listed |
| `variety` | Coffee variety/cultivar — e.g. "Catuai", "Gesha", "Bourbon" |
| `price` | Price in USD, as a plain number string — e.g. "28.00" |
| `image_url` | Best product image URL on the page (prefer the largest/primary image) |

Set `link` to the product page URL Ethan provided.

## Step 3 — Confirm with Ethan

Present a summary of everything you found, clearly flagging any fields you couldn't determine. Ask Ethan to confirm or correct each value, including producer, variety, and price if they weren't on the page. Also collect:

- `rating` — 1 to 5 (always ask; this is subjective)
- `date` — default to today's date in YYYY-MM-DD format, but let Ethan override

## Step 4 — Ask for prose

Ask: "Do you have any tasting notes or prose to include in the review body? If not, I'll leave it blank."

## Step 5 — Derive slugs and file paths

From the confirmed `roaster` and `title`:

- **roaster_slug**: lowercase, spaces → hyphens, remove all non-alphanumeric except hyphens
- **title_slug**: same treatment
- **website filename**: `_coffee/{roaster_slug}-{title_slug}.md`
- **permalink**: `/coffee/{roaster_slug}-{title_slug}` (no `.md` suffix)
- **image filename**: always `.webp` extension regardless of source format; name it using the roaster slug and title slug joined with an underscore, e.g. `perc_super-power-plum.webp`
- **image frontmatter path**: `/images/coffee/{image_filename}`
- **Obsidian filename**: `/Users/ethan/Documents/Second Brain/Coffee/Beans/{title}.md` (title only, no roaster prefix)

## Step 6 — Download and convert the image

Download to a temp file, convert to WebP at 800px wide, then clean up:

```bash
curl -L -o /tmp/{image_stem}.orig "{image_url}" && \
cwebp -q 82 -resize 800 0 /tmp/{image_stem}.orig \
  -o /Users/ethan/projects/website/extra/images/coffee/{image_filename} && \
rm /tmp/{image_stem}.orig
```

(`{image_stem}` is the image filename without the `.webp` extension.)

Confirm the output file exists and report its size before proceeding.

## Step 7 — Write the website markdown file

Write to `_coffee/{roaster_slug}-{title_slug}.md` from the project root (`/Users/ethan/projects/website`):

```markdown
---
layout: Website.CoffeeLayout
title: "{title}"
categories: coffee
roaster: "{roaster}"
rating: {rating}
date: {date}
link: {link}
permalink: /coffee/{roaster_slug}-{title_slug}
image: /images/coffee/{image_filename}
process: {process}
region: {region}
roast_level: {roast_level}
---

{prose}
```

## Step 8 — Write the Obsidian note

Write to `/Users/ethan/Documents/Second Brain/Coffee/Beans/{title}.md`:

- Wrap `roaster`, `process`, `roast level`, and `variety` values in wikilinks: `"[[Value]]"`
- `region` is a YAML list, no wikilinks
- `rating` is left blank (empty list)
- `## Notes` section contains the prose (or is left empty)

```markdown
---
name: {title}
roaster: "[[{roaster}]]"
producer: {producer}
region:
  - {region}
variety: "[[{variety}]]"
process: "[[{process}]]"
roast level: "[[{roast_level}]]"
price: "{price}"
rating:
link: {link}
tags:
  - coffee
date: {date}
---
## Notes

{prose}

---
```

If producer, variety, or price are unknown/blank, omit the wikilink wrapper and leave the value empty.

## Step 9 — Confirm

Tell Ethan both files were created: the website path and the Obsidian path.
