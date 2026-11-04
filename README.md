# Natewave Mono

Natewave Mono is a monospaced coding font. Its choices trace to type-design practices and legibility research:

- **Proportions:** a 0.6 em cell with a 0.545 em x-height and ascenders taller than capitals.
- **Distinct glyphs:** look-alikes such as `0 O Ø`, `1 l I |` and `9 g q` are separated at their stroke ends.
- **Weight:** a slightly heavier Regular for small screen sizes.
- **Operators:** they share one axis, so `->`, `=>`, `<=` and `!=` read cleanly without ligatures. Ligatures are off by default and available on request.

## Build
The font is built from [Iosevka](https://github.com/be5invis/Iosevka) `v34.4.0` with one build plan, [`private-build-plans.toml`](private-build-plans.toml).

Run these from the repository root in a POSIX shell (macOS or Linux terminal, WSL, or Git Bash):

```sh
git clone --depth 1 --branch v34.4.0 https://github.com/be5invis/Iosevka.git
cp private-build-plans.toml Iosevka/
cd Iosevka && npm install
npm run build -- --jCmd=4 webfont-unhinted::NatewaveMono
```

`Iosevka/` is a build checkout; [`.gitignore`](.gitignore) keeps it out of commits.

### Prerequisites

- **Git and Node.js.**
  - The tag's `package.json` declares `"engines": { "node": ">=16.0.0" }`; its `doc/custom-build.md` asks for Node 18 or later.
  - Use a current Node LTS. This plan was built with Node 26.12.1.
- **`ttfautohint`.** Only the hinted targets need it (`ttf::`, `webfont::`, `woff2::` and `contents::`):
  - macOS: `brew install ttfautohint`
  - Debian or Ubuntu: `sudo apt install ttfautohint`
  - Fedora: `sudo dnf install ttfautohint`
  - Windows: download `ttfautohint-1.8.4-win32.7z` from the [ttfautohint site](https://freetype.org/ttfautohint/), extract it, and add the folder to `PATH`. Alternatively, build inside WSL with the Ubuntu command.

### Build targets

Replace the target in the last command with one of these:

| Target | Produces | Needs `ttfautohint` |
|---|---|---|
| `ttf::NatewaveMono` | Hinted TTF | yes |
| `ttf-unhinted::NatewaveMono` | Unhinted TTF | no |
| `webfont::NatewaveMono` | Hinted WOFF2 and TTF, plus CSS | yes |
| `webfont-unhinted::NatewaveMono` | Unhinted WOFF2 and TTF, plus CSS | no |
| `contents::NatewaveMono` | All of the above | yes |

`woff2::NatewaveMono` and `woff2-unhinted::NatewaveMono` build WOFF2 only.

### Parallelism

`--jCmd=N` sets how many build jobs run at once. The default is one job per CPU thread, and each job can use more than 1 GB of RAM at its peak, so lower `N` if memory is tight.

### Output

Each folder holds four styles: `NatewaveMono-Regular`, `-Italic`, `-Bold` and `-BoldItalic`.

```text
Iosevka/dist/NatewaveMono/
├── TTF/                        hinted TTF            (ttf::, webfont::, contents::)
├── TTF-Unhinted/               unhinted TTF          (ttf-unhinted::, webfont-unhinted::, contents::)
├── WOFF2/                      hinted WOFF2          (webfont::, woff2::, contents::)
├── WOFF2-Unhinted/             unhinted WOFF2        (webfont-unhinted::, woff2-unhinted::, contents::)
├── NatewaveMono.css            @font-face for hinted web fonts   (family "Natewave Mono Web")
└── NatewaveMono-Unhinted.css   @font-face for unhinted web fonts (family "Natewave Mono Web")
```

## Install

Paths below are relative to the repository root, so run `cd ..` after the build.

Which build to install:
- **Unhinted TTF:** macOS and high-DPI screens.
- **Hinted TTF:** Windows and standard-DPI (1x) Linux screens. If you built without `ttfautohint`, use `TTF-Unhinted` instead.

- **macOS:** `cp Iosevka/dist/NatewaveMono/TTF-Unhinted/*.ttf ~/Library/Fonts/`
- **Linux:**

  ```sh
  mkdir -p ~/.local/share/fonts/NatewaveMono
  cp Iosevka/dist/NatewaveMono/TTF/*.ttf ~/.local/share/fonts/NatewaveMono/
  fc-cache -f
  fc-list :spacing=mono family | grep "Natewave Mono"
  ```

- **Windows:** open `Iosevka\dist\NatewaveMono\TTF` in File Explorer, select the four `.ttf` files, right-click, and choose **Install** (or **Install for all users**).

Editor (VS Code `settings.json`):

```json
"editor.fontFamily": "'Natewave Mono', monospace", "editor.lineHeight": 1.35, "editor.fontLigatures": false
```

To turn ligatures on, use `"editor.fontLigatures": "'dlig'"`.

Terminal (kitty, `kitty.conf`):

```text
font_family Natewave Mono
```

## Release checklist

1. **Pick a release tag**, for example `v1.0.0`. The fonts' internal version stays Iosevka's (`Version 34.4.0`), which records the upstream build.
2. **Build everything** from the repository root (needs `ttfautohint`): `(cd Iosevka && npm run build -- --jCmd=4 contents::NatewaveMono)`
3. **Package and publish** from the repository root. Each archive carries Iosevka's licence file as `OFL.txt`:

   ```sh
   VERSION=v1.0.0
   cd Iosevka/dist/NatewaveMono
   cp ../../LICENSE.md OFL.txt
   mkdir -p ../../release
   zip -r ../../release/NatewaveMono-TTF-$VERSION.zip TTF OFL.txt
   zip -r ../../release/NatewaveMono-TTF-Unhinted-$VERSION.zip TTF-Unhinted OFL.txt
   zip -r ../../release/NatewaveMono-WebFont-$VERSION.zip NatewaveMono.css WOFF2 TTF OFL.txt
   zip -r ../../release/NatewaveMono-WebFont-Unhinted-$VERSION.zip NatewaveMono-Unhinted.css WOFF2-Unhinted TTF-Unhinted OFL.txt
   cd ../../..
   gh release create "$VERSION" Iosevka/release/*.zip --title "Natewave Mono $VERSION" --notes "Built from Iosevka v34.4.0 with private-build-plans.toml at $VERSION. Licensed under the SIL Open Font License 1.1; see OFL.txt in each archive."
   ```

4. **Licence obligations.** The fonts are a Modified Version of Iosevka (© Renzhi Li) under the SIL Open Font License 1.1. This repository has no LICENSE file, so each release asset must carry the licence itself:
   - Include the copyright notice and the full OFL text in every archive (`OFL.txt` above).
   - Distribute the fonts only under OFL 1.1; they can't be relicensed.
   - Don't sell the fonts by themselves. Bundling them with software is allowed.
   - Don't use Iosevka's author name to promote this font, other than to acknowledge the contribution.
   - Iosevka declares no Reserved Font Name, and this family doesn't reuse "Iosevka" in its name.

## Website

[`site/index.html`](site/index.html) is a one-page specimen of the font, set in Natewave Mono itself. Its CSS and JavaScript are inline, and it makes no external requests. It's published with GitHub Pages at https://natewave.github.io/natewave-mono/.

The font files on the page aren't committed; `.gitignore` excludes them. On every push to `main` that changes `site/`, the build plan or the workflow, [`.github/workflows/pages.yml`](.github/workflows/pages.yml) builds `webfont-unhinted::NatewaveMono` and adds:

- `site/fonts/`: the four WOFF2 files and `OFL.txt`.
- `site/download/NatewaveMono-TTF-Unhinted.zip`: the four unhinted TTFs and `OFL.txt` in a `NatewaveMono/` folder, for the Download button.

The built files are cached with a key from the build plan and the workflow, so page-only changes skip the font build.

**One-time setup:** in the repository's **Settings → Pages → Build and deployment**, set **Source** to **GitHub Actions**. Then push, or run the workflow from the **Actions** tab.

**Local preview:** after the build, run these from the repository root:

```sh
mkdir -p site/fonts
cp Iosevka/dist/NatewaveMono/WOFF2-Unhinted/*.woff2 site/fonts/
cp Iosevka/LICENSE.md site/fonts/OFL.txt
python3 -m http.server --directory site 8000
```

Then open http://localhost:8000. The Download button needs the zip, which the workflow's packaging step builds.

## Design notes

Evidence labels:
- **strong**: replicated, or a review where several studies agree.
- **moderate**: one controlled study, or several with caveats.
- **convention**: established type-design practice.
- **preference**: what users like.

Almost all of the research tested prose, proportional fonts or print. No study tests fonts for code (Jacques & Kristensson, 2015; Oliveira et al., 2023), so the evidence below is extrapolated to code.

Every confusable group was checked at 11 px, 1x, in light and dark themes, next to Iosevka's default, JetBrains Mono, Intel One Mono and Atkinson Hyperlegible Mono.

| Decision | Value | Basis | Evidence |
|---|---|---|---|
| Size and x-height | x-height 545/1000 (Iosevka default 520) | Code at 11–14 px sits at or below the critical print size; x-height sets effective size (Legge & Bigelow, 2011) | strong |
| Ascenders and descenders | Ascender 780, cap 730, descender −235 (0.43 × x-height) | A large x-height costs ascender and descender letters (Larson & Carter, 2016) | moderate |
| Width | 0.6 em cell (Iosevka default 0.5) | Wider letters help recognition and low-vision acuity (Beier et al., 2021; Oderkerk & Beier, 2022); width changes eye movements, not speed (Minakata & Beier, 2021) | moderate |
| Spacing | Sidebearings × 0.9, same pitch | Standard monospaced spacing is already optimal (Chung, 2002; Pelli et al., 2007); fixed-width fonts improved with slightly less letter spacing (Slattery et al., 2016) | moderate |
| Line height | 1.35 em | 1.2–1.4 em beats tight setting (Paterson & Tinker, 1932; Kruk & Muter, 1984; Ling & van Schaik, 2007; Chung, 2004) | moderate |
| Weight | Regular stems about 0.09 em (shape 450, named 400); Bold 700 | Boldness helps at small sizes (Beier & Oderkerk, 2019); low contrast suits sans (Minakata & Beier, 2022) | moderate |
| Polarity | One Regular, no lighter "dark" cut; in dark themes, use 1 px more size instead | Dark-on-light is more legible and the gap grows at small sizes (Piepenbrock et al., 2013, 2014; Dobres et al., 2016); grade only mattered in light mode (Palmén et al., 2023) | strong / moderate |
| Glyph identity | Tailed `l`, footed and flagged `1`, barred `I`, dotted oval `0`, double-storey `g`, flat-top `3`, larger `i`/`j` dots | Stroke ends identify letters (Fiset et al., 2008); breaking look-alike groups cut errors in a monospace (Bernard et al., 2016); narrow letters improve when widened (Beier & Larson, 2010) | moderate |
| Serifs | Sans, with serifs and tails only on narrow letters | Serifs alone don't change legibility (Arditi & Cho, 2005) | moderate |
| Operators and punctuation | `+ - = < > *` share one axis; `_` sits low, clear of the underline; period 15% larger | No study found. `_` visibility matters for under_score identifiers (Sharif & Maletic, 2010) | convention |
| Italic | 9.4°, mostly oblique; only `a` and `f` cursive | Italics read slightly slower (Tinker & Paterson, 1928; Rello & Baeza-Yates, 2013); no study compares cursive with oblique | moderate / convention |
| Ligatures | None by default; opt in with the `dlig` feature | No study of programming ligatures exists; ligatures can misrepresent code (Butterick, 2019); readers differ (Wallace et al., 2022) | convention / preference |
| Spacing mode | `fontconfig-mono`: every glyph is exactly one cell, so fontconfig lists the font as monospace; `dlig` stays available | Coding requirement: grid alignment in editors and terminals | convention |
| Hinting | Ship hinted (Windows, 1x Linux) and unhinted (macOS, high-DPI) builds | No study isolates hinting; ClearType doesn't beat well-tuned greyscale (Sheedy et al., 2008) | convention |

Limits of Iosevka `v34.4.0` that the plan can't fix:
- `−` (U+2212) is drawn almost the same as `-`. Rely on your editor's confusable-character highlighting for it.
- The gap in `¦` is about 1 px at 11 px.
- The tilde sits about 0.08 × x-height below the operator axis.
- Apertures of `c`, `e` and `s` stay narrower than in Fira Mono or Intel One Mono.

### References

Each source was read at least as an abstract by an AI agent.

- Arditi, A., & Cho, J. (2005). Serifs and font legibility. *Vision Research, 45*(23), 2926–2933. https://doi.org/10.1016/j.visres.2005.06.013
- Beier, S., & Larson, K. (2010). Design improvements for frequently misrecognized letters. *Information Design Journal, 18*(2), 118–137. https://doi.org/10.1075/idj.18.2.03bei
- Beier, S., & Oderkerk, C. A. T. (2019). Smaller visual angles show greater benefit of letter boldness than larger visual angles. *Acta Psychologica, 199*, 102904. https://doi.org/10.1016/j.actpsy.2019.102904
- Beier, S., Oderkerk, C. A. T., Bay, B., & Larsen, M. (2021). Increased letter spacing and greater letter width improve reading acuity in low vision readers. *Information Design Journal, 26*(1), 73–88. https://doi.org/10.1075/idj.19033.bei
- Bernard, J.-B., Aguilar, C., & Castet, E. (2016). A new font, specifically designed for peripheral vision, improves peripheral letter and word recognition, but not eye-mediated reading performance. *PLOS ONE, 11*(4), e0152506. https://doi.org/10.1371/journal.pone.0152506
- Butterick, M. (2019). *Ligatures in programming fonts: Hell no*. Practical Typography. https://practicaltypography.com/ligatures-in-programming-fonts-hell-no.html
- Chung, S. T. L. (2002). The effect of letter spacing on reading speed in central and peripheral vision. *Investigative Ophthalmology & Visual Science, 43*(4), 1270–1276. https://pubmed.ncbi.nlm.nih.gov/11923275/
- Chung, S. T. L. (2004). Reading speed benefits from increased vertical word spacing in normal peripheral vision. *Optometry and Vision Science, 81*(7), 525–535. https://doi.org/10.1097/00006324-200407000-00014
- Dobres, J., Chahine, N., Reimer, B., Gould, D., Mehler, B., & Coughlin, J. F. (2016). Utilising psychophysical techniques to investigate the effects of age, typeface design, size and display polarity on glance legibility. *Ergonomics, 59*(10), 1377–1391. https://doi.org/10.1080/00140139.2015.1137637
- Fiset, D., Blais, C., Éthier-Majcher, C., Arguin, M., Bub, D., & Gosselin, F. (2008). Features for identification of uppercase and lowercase letters. *Psychological Science, 19*(11), 1161–1168. https://doi.org/10.1111/j.1467-9280.2008.02218.x
- Jacques, J. T., & Kristensson, P. O. (2015). Understanding the effects of code presentation. In *Proceedings of PLATEAU '15* (pp. 27–30). ACM. https://doi.org/10.1145/2846680.2846685
- Kruk, R. S., & Muter, P. (1984). Reading of continuous text on video screens. *Human Factors, 26*(3), 339–345. https://doi.org/10.1177/001872088402600309
- Larson, K., & Carter, M. (2016). Sitka: A collaboration between type design and science. In M. C. Dyson & C. Y. Suen (Eds.), *Digital fonts and reading* (pp. 37–53). World Scientific. https://doi.org/10.1142/9789814759540_0003
- Legge, G. E., & Bigelow, C. A. (2011). Does print size matter for reading? A review of findings from vision science and typography. *Journal of Vision, 11*(5), 8. https://doi.org/10.1167/11.5.8
- Ling, J., & van Schaik, P. (2007). The influence of line spacing and text alignment on visual search of web pages. *Displays, 28*(2), 60–67. https://doi.org/10.1016/j.displa.2007.04.003
- Minakata, K., & Beier, S. (2021). The effect of font width on eye movements during reading. *Applied Ergonomics, 97*, 103523. https://doi.org/10.1016/j.apergo.2021.103523
- Minakata, K., & Beier, S. (2022). The dispute about sans serif versus serif fonts: An interaction between the variables of serif and stroke contrast. *Acta Psychologica, 228*, 103623. https://doi.org/10.1016/j.actpsy.2022.103623
- Oderkerk, C. A. T., & Beier, S. (2022). Fonts of wider letter shapes improve letter recognition in parafovea and periphery. *Ergonomics, 65*(5), 753–761. https://doi.org/10.1080/00140139.2021.1991001
- Oliveira, D., Santos, R., Madeiral, F., Masuhara, H., & Castor, F. (2023). A systematic literature review on the impact of formatting elements on code legibility. *Journal of Systems and Software, 203*, 111728. https://doi.org/10.1016/j.jss.2023.111728
- Palmén, H., Gilbert, M., & Crossland, D. (2023). How bold can we be? The impact of adjusting font grade on readability in light and dark polarities. In *Proceedings of CHI '23* (pp. 1–11). ACM. https://doi.org/10.1145/3544548.3581552
- Paterson, D. G., & Tinker, M. A. (1932). Studies of typographical factors influencing speed of reading. VIII. Space between lines or leading. *Journal of Applied Psychology, 16*(4), 388–397. https://doi.org/10.1037/h0074988
- Pelli, D. G., Tillman, K. A., Freeman, J., Su, M., Berger, T. D., & Majaj, N. J. (2007). Crowding and eccentricity determine reading rate. *Journal of Vision, 7*(2), 20. https://doi.org/10.1167/7.2.20
- Piepenbrock, C., Mayr, S., Mund, I., & Buchner, A. (2013). Positive display polarity is advantageous for both younger and older adults. *Ergonomics, 56*(7), 1116–1124. https://doi.org/10.1080/00140139.2013.790485
- Piepenbrock, C., Mayr, S., & Buchner, A. (2014). Positive display polarity is particularly advantageous for small character sizes. *Human Factors, 56*(5), 942–951. https://doi.org/10.1177/0018720813515509
- Rello, L., & Baeza-Yates, R. (2013). Good fonts for dyslexia. In *Proceedings of ASSETS '13* (pp. 1–8). ACM. https://doi.org/10.1145/2513383.2513447
- Sharif, B., & Maletic, J. I. (2010). An eye tracking study on camelCase and under_score identifier styles. In *2010 IEEE 18th International Conference on Program Comprehension* (pp. 196–205). https://doi.org/10.1109/ICPC.2010.41
- Sheedy, J., Tai, Y.-C., Subbaram, M., Gowrisankaran, S., & Hayes, J. (2008). ClearType sub-pixel text rendering: Preference, legibility and reading performance. *Displays, 29*(2), 138–151. https://doi.org/10.1016/j.displa.2007.09.016
- Slattery, T. J., Yates, M., & Angele, B. (2016). Interword and interletter spacing effects during reading revisited: Interactions with word and font characteristics. *Journal of Experimental Psychology: Applied, 22*(4), 406–422. https://doi.org/10.1037/xap0000104
- Tinker, M. A., & Paterson, D. G. (1928). Influence of type form on speed of reading. *Journal of Applied Psychology, 12*(4), 359–368. https://doi.org/10.1037/h0073699
- Wallace, S., Bylinskii, Z., Dobres, J., Kerr, B., Berlow, S., Treitman, R., Kumawat, N., Arpin, K., Miller, D. B., Huang, J., & Sawyer, B. D. (2022). Towards individuated reading experiences: Different fonts increase reading speed for different individuals. *ACM Transactions on Computer-Human Interaction, 29*(4), 38. https://doi.org/10.1145/3502222

Type-design sources also used:
- Iosevka `v34.4.0` `doc/custom-build.md` and `params/`
- the JetBrains Mono site: https://www.jetbrains.com/lp/mono/
- the Intel One Mono README: https://github.com/intel/intel-one-mono
- Input: https://input.djr.com/info/
- the Source Code Pro announcement: https://blog.typekit.com/2012/09/24/source-code-pro/
- the ttfautohint site: https://freetype.org/ttfautohint/
