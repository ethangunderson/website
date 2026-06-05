---
name: add-coffee-review
description: >
  Interactively creates a new coffee review file for Ethan's website (_coffee/ directory).
  Ask for the product page URL, fetch and parse it to extract as much frontmatter as possible,
  confirm or fill in gaps with Ethan, then download the image and write the file.
  Use when Ethan says he wants to add a coffee review, log a new coffee, or says something like
  "I just got a new bag" or "add this coffee".
---

# Add Coffee Review

When invoked, walk through these steps in order. Never create the file until all fields are confirmed.

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
| `image_url` | Best product image URL on the page (prefer the largest/primary image) |

Set `link` to the product page URL Ethan provided.

## Step 3 — Confirm with Ethan

Present a summary of everything you found, clearly flagging any fields you couldn't determine. Ask Ethan to confirm or correct each value. Also collect:

- `rating` — 1 to 5 (always ask; this is subjective)
- `date` — default to today's date in YYYY-MM-DD format, but let Ethan override

## Step 4 — Ask for prose

Ask: "Do you have any tasting notes or prose to include in the review body? If not, I'll leave it blank."

## Step 5 — Derive slugs and file paths

From the confirmed `roaster` and `title`:

- **roaster_slug**: lowercase, spaces → hyphens, remove all non-alphanumeric except hyphens
- **title_slug**: same treatment
- **filename**: `_coffee/{roaster_slug}-{title_slug}.md`
- **permalink**: `/coffee/{roaster_slug}-{title_slug}` (no `.md` suffix)
- **image filename**: preserve the original file extension from the image URL; name it using the roaster slug and title slug joined with an underscore, e.g. `perc_super-power-plum.webp`
- **image frontmatter path**: `/images/coffee/{image_filename}`

## Step 6 — Download the image

```bash
curl -L -o /Users/ethan/projects/website/extra/images/coffee/{image_filename} "{image_url}"
```

Confirm the download succeeded before proceeding.

## Step 7 — Write the markdown file

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

## Step 8 — Confirm

Tell Ethan the file was created and show him the relative path. Mention the image was saved to `extra/images/coffee/{image_filename}`.
