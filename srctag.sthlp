{smcl}
{* *! version 1.1.0 19jun2026 Author: Eric A. Booth, Sr Researcher, Texas2036.org}{...}
{vieweralsosee "srcfind" "help srcfind"}{...}
{vieweralsosee "char" "help char"}{...}
{viewerjumpto "Syntax" "srctag##syntax"}{...}
{viewerjumpto "Description" "srctag##description"}{...}
{viewerjumpto "Options" "srctag##options"}{...}
{viewerjumpto "Metadata schema" "srctag##schema"}{...}
{viewerjumpto "Examples" "srctag##examples"}{...}
{viewerjumpto "Author" "srctag##author"}{...}

{title:Title}

{pstd}
{cmd:srctag} {hline 2} Attach source-provenance metadata to Stata variables


{marker syntax}{...}
{title:Syntax}

{pstd}
Tag one or more variables:

{p 8 17 2}
{cmd:srctag} {it:varlist} [{cmd:,}
{opt agency(string)}
{opt dataset(string)}
{opt url(string)}
{opt vintage(string)}
{opt category(string)}
{opt key(name)}
{opt value(string)}]

{pstd}
Show source metadata on one variable:

{p 8 17 2}
{cmd:srctag show} {it:varlist}

{p 8 17 2}
{cmd:srctag profile} {it:varlist}


{marker description}{...}
{title:Description}

{pstd}
{cmd:srctag} stores source-provenance metadata as Stata variable
characteristics. These characteristics travel with the dataset and can be
queried later with {help srcfind}, {help char}, or custom Stata code.

{pstd}
This is useful for wide analytic files where columns come from many source
agencies, releases, vintages, or policy domains. For example, a county
crosswalk may contain Census, BEA, TEA, CDC, and derived variables side by
side. {cmd:srctag} makes it easier to ask "which variables came from BEA?"
or "which variables are from the 2024 vintage?"

{pstd}
{cmd:srctag} is additive. It writes {cmd:src_*} characteristics and does not
remove a legacy {cmd:[source]} characteristic if one already exists.

{pstd}
The five standard source tags are recommended for consistency, but they are
not the only tags allowed. Use {opt key()} and {opt value()} to add a custom
variable characteristic such as {cmd:src_confidence}, {cmd:src_license}, or
{cmd:src_method_note}. Custom tags appear in {cmd:srctag show} profile cards.


{marker options}{...}
{title:Options}

{phang}
{opt agency(string)} stores a short, stable agency tag in
{cmd:varname[src_agency]}; examples include {cmd:BEA}, {cmd:TEA},
{cmd:Census_ACS}, and {cmd:CDC_PLACES}.

{phang}
{opt dataset(string)} stores a dataset, table, collection, or release tag in
{cmd:varname[src_dataset]}; examples include {cmd:CAINC1},
{cmd:ACS_5yr_2023}, or {cmd:PLACES_2024}.

{phang}
{opt url(string)} stores a canonical landing page or download URL in
{cmd:varname[src_url]}.

{phang}
{opt vintage(string)} stores the source vintage in {cmd:varname[src_vintage]},
such as {cmd:2024}, {cmd:2024-25}, or {cmd:1978}.

{phang}
{opt category(string)} stores a high-level policy or data category in
{cmd:varname[src_category]}, such as {cmd:demographics}, {cmd:economics},
{cmd:education}, {cmd:health}, {cmd:infrastructure}, or {cmd:derived}.

{phang}
{opt key(name)} and {opt value(string)} set one additional custom characteristic.
They must be supplied together. For example,
{cmd:srctag price, key(src_confidence) value("high")}.


{marker schema}{...}
{title:Metadata schema}

{pstd}
{cmd:srctag} writes up to five source-metadata characteristics:

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{cmd:src_agency}}short agency or source-owner tag{p_end}
{synopt:{cmd:src_dataset}}specific dataset, table, or collection{p_end}
{synopt:{cmd:src_url}}canonical source URL{p_end}
{synopt:{cmd:src_vintage}}release year, school year, fiscal year, or other vintage{p_end}
{synopt:{cmd:src_category}}broad policy or data category{p_end}
{synoptline}

{pstd}
Custom tags are allowed through {opt key()} and {opt value()}. Consider using
the {cmd:src_} prefix for source-related custom fields so they are easy to
recognize later.


{marker examples}{...}
{title:Examples}

{pstd}
Use the built-in {cmd:auto.dta} dataset to tag variables from two illustrative
source agencies:

{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. srctag price mpg weight, agency("BEA") dataset("auto_example") vintage("1978") category("economics")}{p_end}
{phang2}{cmd:. srctag length turn displacement, agency("FHWA") dataset("auto_example") vintage("1978") category("infrastructure")}{p_end}
{phang2}{cmd:. srctag price mpg, key(src_confidence) value("high")}{p_end}
{phang2}{cmd:. srctag weight, key(src_note) value("example custom note")}{p_end}

{pstd}
Inspect one or more tagged variables. Variable names and source values are
shown as clickable SMCL links in the Results window where possible:

{phang2}{cmd:. srctag show price mpg}{p_end}

{pstd}
Find all variables tagged to an agency using the companion command
{help srcfind}:

{phang2}{cmd:. srcfind src_agency BEA}{p_end}

{pstd}
Expected display:

{p 8 12 2}{cmd:vars with char[src_agency] == "BEA"  (n=3):}{p_end}
{p 8 12 2}{cmd:  price}{p_end}
{p 8 12 2}{cmd:  mpg}{p_end}
{p 8 12 2}{cmd:  weight}{p_end}

{pstd}
Store the matched variables and summarize them:

{phang2}{cmd:. srcfind src_agency BEA, into(beavars)}{p_end}
{phang2}{cmd:. summarize `beavars'}{p_end}

{pstd}
Print profile cards for every matched variable:

{phang2}{cmd:. srcfind src_agency BEA, profile}{p_end}

{pstd}
List all source agencies as a clickable catalog:

{phang2}{cmd:. srcfind tags}{p_end}
{phang2}{cmd:. srcfind values src_agency}{p_end}
{phang2}{cmd:. srcfind BEA}{p_end}

{pstd}
Show the raw characteristics directly:

{phang2}{cmd:. char list price[]}{p_end}


{marker author}{...}
{title:Author}

{pstd}
Eric Booth{break}
Sr Researcher, Texas2036.org (eric.a.booth@gmail.com)
{p_end}
