# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal blog built with Jekyll and hosted on GitHub Pages. The site (jonkap.com) features posts about travel, meditation, and personal reflections. It uses a custom dark theme based on Minima and includes several interactive elements.

## Design Influences

The site's design is inspired by [Gwern Branwen's website](https://github.com/gwern/gwern.net/), particularly its approach to typography and interactive reading features. The implementation is custom-built for Jekyll/Kramdown rather than Gwern's Hakyll-based system.

## Working Modes

This project has two distinct working modes that determine how Claude Code should approach tasks:

### CODE Mode (Default)
**When to use:** For all technical work including development, styling, configuration, and site functionality.

**Focus areas:**
- Jekyll configuration and build system
- HTML/CSS/JavaScript implementation
- Site architecture and layouts
- Interactive features and functionality
- Dependencies and tooling
- Technical debugging

**Approach:** Technical precision, code quality, testing changes with `bundle exec jekyll serve`

### EDITOR Mode
**When to use:** When the user explicitly requests content analysis or editing of blog posts. User will specify "EDITOR mode" or similar language.

**Focus areas:**
- Analyzing full post content for clarity, flow, and coherence
- Evaluating argument structure and logical progression
- Identifying unclear passages or awkward phrasing
- Suggesting improvements to prose and style
- Answering questions about post content and themes
- Making content edits (grammar, structure, phrasing)
- Reviewing how ideas connect within a post

**Approach:**
1. **Read the entire post** from `_posts/` directory when entering EDITOR mode
2. **Analyze holistically** - consider the full narrative arc, not just individual sentences
3. **Preserve the author's voice** - suggest edits that maintain the personal, reflective tone
4. **Be specific** - reference exact passages when suggesting changes
5. **Focus on content, not code** - ignore technical markdown details unless they affect readability
6. **Ask clarifying questions** about the author's intent before making significant structural changes

**Out of scope in EDITOR mode:**
- Technical implementation details (unless they directly impact content display)
- Styling or layout changes
- Adding new features or functionality
- Jekyll configuration

**Switching modes:** The user will explicitly state when they want to enter EDITOR mode and which post to analyze. Return to CODE mode when technical work is requested or EDITOR session is complete.

## Development Commands

### Local Development
```bash
bundle exec jekyll serve
```
Runs the Jekyll development server. Changes to most files will be auto-reloaded, but `_config.yml` changes require a server restart.

**To view drafts in development:**
```bash
bundle exec jekyll serve --drafts
```
This includes draft posts in the site and displays them with a gold "DRAFT" badge in the blog listing and on individual post pages.

### Building
```bash
bundle exec jekyll build
```
Builds the site to `_site/` directory.

### Dependencies
```bash
bundle install
```
Install or update Ruby gems defined in Gemfile.

## Architecture

### Jekyll Configuration
- Uses GitHub Pages gem for deployment compatibility
- Kramdown markdown processor with footnotes support
- Plugins: jekyll-feed, jekyll-seo-tag
- Permalink structure: `/:title:output_ext` (no date in URLs)
- Configured in `_config.yml:1`

### Content Structure
- **Published posts** in `_posts/` following Jekyll naming convention: `YYYY-MM-DD-title.md`
- **Draft posts** in `_drafts/` without date prefix (e.g., `title.md`)
- Posts include front matter with: `layout`, `title`, `date`, `section`, `categories`
- Drafts do NOT need `published: false` flag (handled by folder location)
- Static pages (About, Books, Content) in root as `.md` files
- Uses `layout: post` for blog entries, `layout: blog` for blog index

### Layouts & Templates
- `_layouts/default.html` - Base template with head, header, footer includes
- `_layouts/post.html` - Blog post layout that loads footnotes JavaScript
- `_layouts/blog.html` - Blog index/listing page
- `_layouts/home.html` - Homepage with interactive robot animation
- `_layouts/page.html` - Static pages

### Styling Architecture
Custom styles are in `_sass/custom.scss:1` and include:

1. **Table of Contents** (`.toc`, lines 1-60) - Collapsible navigation with hover effects
2. **Footnotes System** (lines 62-267) - Hover popups and bottom footnotes section styled for dark theme
3. **Draft Badge** (`.draft-badge`, lines 304+) - Gold badge indicating draft posts (visible only with `--drafts` flag)
4. **Responsive Design** - Mobile-friendly layouts

Font definitions in `_sass/_fonts.scss` reference self-hosted Lato and Source Serif fonts in `assets/fonts/`.

### Interactive Features

**Footnotes System** (`assets/js/sidenotes.js:1`):
- Hover popups that appear after 350ms delay when hovering over footnote citations
- Touch support for mobile devices
- Footnotes always visible at bottom of page
- Gwern-inspired double-border styling on popups

**Homepage Animation** (`index.md:53`):
- Interactive "Johnny 5" robot with rotating arm
- Cloud click triggers lightning video and animation sequence
- Dialog system with typewriter effect
- State management for "alive" animation (runs once)

### Assets Organization
- `/assets/images/` - Site images including profile pics, logos
- `/assets/videos/` - Video files for homepage animation
- `/assets/fonts/` - Self-hosted Lato and Source Serif 4 fonts
- `/assets/js/` - JavaScript (currently only sidenotes.js)

## Key Implementation Details

### Footnotes System
The footnotes system enhances Kramdown's standard footnote output with hover popups. Key components:
1. **Kramdown** generates standard `<a class="footnote">` citations and `.footnotes` section at bottom
2. **JavaScript** (`sidenotes.js`) adds hover popup functionality - shows footnote content on hover without navigation
3. **CSS** (`custom.scss`) styles both the popups (gwern-style double borders) and bottom footnotes section

Footnotes always appear at the bottom of the page. Hover popups provide quick preview without scrolling.

### Dark Theme
Site uses Minima dark skin (`_config.yml:32`) with extensive custom overrides. All interactive elements (footnotes, TOC, animations) are styled for dark mode with subtle highlights and borders.

### Post Content
Posts support Kramdown-flavored markdown including footnotes `[^1]` syntax. The post layout automatically loads the footnotes JavaScript for hover popup enhancement.

## Common Workflows

### Working with Drafts
**Creating a new draft:**
1. Create file in `_drafts/` with format: `title.md` (no date prefix needed)
2. Include front matter with required fields: `layout: post`, `title`, `date`, `section`
3. Do NOT include `published: false` - folder location handles draft status

**Viewing drafts:**
- Run `bundle exec jekyll serve --drafts` to view drafts locally
- Drafts will appear in the blog listing with a gold "DRAFT" badge
- Individual draft posts also show the "DRAFT" badge in the page title

**Publishing a draft:**
1. Move file from `_drafts/` to `_posts/`
2. Rename file to include date prefix: `YYYY-MM-DD-title.md`
3. Verify the `date` field in front matter is correct
4. The draft badge will automatically disappear once published

### Adding a New Published Post
1. Create file in `_posts/` with format: `YYYY-MM-DD-title.md`
2. Include front matter with required fields: `layout: post`, `title`, `date`, `section`
3. Use Kramdown syntax for footnotes: `[^n]` for citation, `[^n]: text` for definition

### Testing Footnotes
View test post at `_posts/2024-12-11-sidenotes-test.md:1` for reference implementation. Hover over footnote citations to see popups.

### Modifying Styles
Primary custom styles in `_sass/custom.scss`. Changes auto-reload with jekyll serve. Uses SCSS nesting and variables.

### Publishing to Substack

The `publish_to_substack.rb` script copies a post to your clipboard, ready to paste into Substack.

**Workflow:**
```bash
bundle exec jekyll build
ruby publish_to_substack.rb monks-bowl   # by slug
ruby publish_to_substack.rb --latest     # most recent post
ruby publish_to_substack.rb              # interactive menu
```

Then paste into Substack and set the canonical URL shown in the output.

**What the script does:**
- Reads your RSS feed (`_site/feed.xml`)
- Cleans HTML for Substack's editor
- Converts footnotes to simple `[1]` format with Notes section
- Adds canonical attribution at bottom
- Copies directly to clipboard

**Note:** Posts with `hide_from_feed: true` won't appear.
