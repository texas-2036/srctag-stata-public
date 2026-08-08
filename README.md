# srctag

> [!NOTE]
> **A newer, merged release of srctag + srcfind lives at
> [ericabooth/srctag-stata-public](https://github.com/ericabooth/srctag-stata-public)**
> (v2.0.0, Booth & Teas; SSC submission in progress as `ssc install srctag`).
> It keeps this repo's structured `src_*` schema and subcommands, adds an
> overwrite guard, stored results, a dataset-level source manifest, a
> warehouse folder scan, tagging audits, and `sign`/`verify` staleness
> checks -- and it reads files tagged by this version without changes.
> This repo is kept for reference and is no longer updated.



`srctag` attaches source-provenance metadata to Stata variables using Stata variable characteristics. It is useful for wide analytic files where variables come from many agencies, datasets, releases, or vintages.

The companion command [`srcfind`](https://github.com/ericabooth/srcfind-stata) searches those characteristics later.

## Installation

```stata
net install srctag, from("https://raw.githubusercontent.com/ericabooth/srctag-stata/master/") replace
which srctag
help srctag
```

Install the companion package the same way:

```stata
net install srcfind, from("https://raw.githubusercontent.com/ericabooth/srcfind-stata/master/") replace
```

## Syntax

Tag variables:

```stata
srctag varlist [, agency(string) dataset(string) url(string) vintage(string) category(string) key(name) value(string)]
```

Show one variable's source metadata:

```stata
srctag show varlist
srctag profile varlist
```

At least one of `agency()`, `dataset()`, `url()`, `vintage()`, `category()`, or `key()/value()` is required when tagging variables.

## Metadata schema

`srctag` writes these Stata variable characteristics:

- `src_agency`: short agency/source-owner tag, such as `BEA`, `TEA`, `Census_ACS`, `CDC_PLACES`.
- `src_dataset`: source dataset, table, or collection, such as `CAINC1` or `ACS_5yr_2023`.
- `src_url`: canonical source landing page or download URL.
- `src_vintage`: release year, fiscal year, school year, or other vintage.
- `src_category`: broad policy or data category.

The command does not remove a legacy `source` characteristic if one is already present.

You can add custom tags. Use `key()` and `value()` together:

```stata
srctag price, key(src_confidence) value("high")
srctag weight, key(src_note) value("example custom note")
```

Custom tags show up in `srctag show` profile cards. For source-related fields, consider using the `src_` prefix.

## Quick test with auto.dta

```stata
clear all
set more off
sysuse auto, clear

* 1. Tag variables with illustrative source metadata.
srctag price mpg weight, ///
    agency("BEA") dataset("auto_example") vintage("1978") category("economics")

srctag length turn displacement, ///
    agency("FHWA") dataset("auto_example") vintage("1978") category("infrastructure")

* 2. Add custom source-profile tags.
srctag price mpg, key(src_confidence) value("high")
srctag weight, key(src_note) value("example custom note")

* 3. Inspect tagged variables with profile cards.
srctag show price mpg

* 4. Search metadata with the companion package.
srcfind src_agency BEA
srcfind src_agency B*, wildcard
srcfind src_category struct, contains

* 5. Print profile cards for matched variables.
srcfind src_agency BEA, profile

* 6. Browse the source tag card catalog.
srcfind tags
srcfind values src_agency
srcfind BEA

* 7. Reuse the matched varlist programmatically when needed.
srcfind src_agency BEA, into(beavars)
summarize `beavars'

* 8. Show raw Stata characteristics.
char list price[]
```

## Example for a public data build

```stata
srctag personal_income_2024 per_capita_income_2024, ///
    agency("BEA") dataset("CAINC1") ///
    url("https://apps.bea.gov/regional/zip/CAINC1.zip") ///
    vintage("2024") category("economics")

srcfind src_agency BEA
```

## Files

- `srctag.ado`: Stata command.
- `srctag.sthlp`: Stata help file.
- `srctag.pkg`: Stata package manifest for `net install`.
- `stata.toc`: net-install table of contents.
- `README.md`: GitHub-facing documentation.

## Author

Eric A. Booth, Sr Researcher, Texas2036.org (eric.a.booth@gmail.com).
