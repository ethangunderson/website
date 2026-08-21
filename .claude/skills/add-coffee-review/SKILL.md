---
name: add-coffee-review
description: >
  Interactively creates a new coffee review file for Ethan's website (_coffee/ directory)
  and a matching note in his Obsidian vault.
  Ask for the product page URL, fetch and parse it to extract as much frontmatter as possible,
  confirm or fill in gaps with Ethan, then download the image, write both files, and
  generate the Open Graph share image.
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

Roasters sometimes publish an Agtron number (e.g. "62.2 Agtron") instead of a roast descriptor. Propose the matching word from the list above and let Ethan confirm — the frontmatter field renders as text in the sidebar.

## Step 3 — Confirm with Ethan

Present a summary of everything you found, clearly flagging any fields you couldn't determine. Ask Ethan to confirm or correct each value, including producer, variety, and price if they weren't on the page. Also collect:

- `rating` — 1 to 7 (always ask; this is subjective)
- `date` — default to today's date in YYYY-MM-DD format, but let Ethan override

## Step 4 — Ask for prose and brew recipes

Ask: "Do you have any tasting notes or prose to include in the review body? If not, I'll leave it blank."

Then ask whether he has brew recipes to log. Ethan dictates recipe parameters conversationally ("30g in, 500g out, bloom at 60g for 30 seconds"). Two values are routinely ambiguous — resolve both before writing:

- Whether pour volumes are cumulative or per-pour.
- Whether a stated shot time includes preinfusion or runs after it.

Never invent a parameter he didn't state. Grind setting in particular is per-brewer and unguessable — ask, or write `[GRIND NEEDED]`.

## Step 5 — Derive slugs and file paths

Read the existing filenames in `_coffee/` and `extra/images/coffee/` before deriving anything, and match their convention rather than transliterating the roaster name in full:

- **roaster_slug**: the short brand token already in use — `perc` (not `perc-coffee`), `ruby-coffee-roasters`, `portrait`, `dcds`
- **title_slug**: lowercase, spaces → hyphens, remove all non-alphanumeric except hyphens
- **website filename**: `_coffee/{roaster_slug}-{title_slug}.md`
- **permalink**: `/coffee/{roaster_slug}-{title_slug}` (no `.md` suffix)
- **image filename**: `.webp` regardless of source format, CamelCase, matching neighbours in `extra/images/coffee/` — e.g. `PERC_ColombiaFrankyHoyos.webp`, `Ruby_PeruDavidFloresLaNeblina.webp`
- **image frontmatter path**: `/images/coffee/{image_filename}`
- **Obsidian filename**: `/Users/ethan/Documents/Second Brain/Coffee/Beans/{title}.md` (title only, no roaster prefix)

Keep the markdown filename and the permalink slug identical. `mix gen_coffee_og_images` names its output from the markdown filename while the layout points `og:image` at the permalink, so a mismatch produces a broken share image.

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
price: "{price}"
permalink: /coffee/{roaster_slug}-{title_slug}
image: /images/coffee/{image_filename}
process: {process}
region: {region}
roast_level: {roast_level}
description: "[DESCRIPTION NEEDED]"
---

{prose}

## Brewing Recipes

### Filter — V60

30g in / 500g out (1:16.7) · 210°F · DF54 at 70 · ~2:30 total

| Stage | Water (total) | Time |
| --- | --- | --- |
| Bloom | 60g | 0:30 |
| Second bloom | 100g | 0:30 |
| Single pour | 500g | ~1:30 |
```

`description` is the page's meta description and `og:description`. It is Ethan's copy — always write the `[DESCRIPTION NEEDED]` stub and let him fill it in.

`price` feeds `offers` in the Review JSON-LD (`review_schema/1` in `lib/layouts/root_layout.ex`). Omit the key entirely if the price is unknown; the schema drops nil fields.

Recipe formatting, when Ethan gives you recipes:

- Spec line first (dose / yield / ratio / temp / grind / total time), pour or stage table below it.
- One `###` sub-heading per brewer, labelled by method — `### Filter — V60`, `### Espresso — Flair 58 Plus 2`. Don't repeat the brewer name in the spec line underneath.
- Espresso tables carry no water column; the yield is already in the spec line.

**Keep every recipe below a `##` heading.** `review_schema/1` derives the JSON-LD `reviewBody` from the markdown above the first `##`, so a recipe placed before one puts brew tables into the Google search snippet.

## Step 8 — Write the Obsidian note

Write to `/Users/ethan/Documents/Second Brain/Coffee/Beans/{title}.md`:

- Wrap `roaster`, `process`, `roast level`, and `variety` values in wikilinks: `"[[Value]]"`
- `region` is a YAML list, no wikilinks
- `rating` is left blank (empty list)
- `## Notes` section contains the prose (or is left empty)
- Brew recipes are copied verbatim from the website file, below the notes

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

## Step 9 — Generate the Open Graph image

```bash
cd /Users/ethan/projects/website && mix gen_coffee_og_images
```

Without this the page's `og:image` points at a file that does not exist and every share renders blank. The task globs all of `_coffee/*.md`, so it rewrites all existing PNGs in `extra/images/og/coffee/` — expect them to show as modified in `git status`, and tell Ethan that churn is from the regeneration, not from his new review.

Then rebuild and confirm the new PNG is 1200x630 and carries the right title and bag image:

```bash
cd /Users/ethan/projects/website && mix build
```

## Step 10 — Confirm

Tell Ethan what was created: the website path, the Obsidian path, the coffee image, and the OG image. Name the fields still needing his words — `description`, and the review body if he hasn't written it yet.
