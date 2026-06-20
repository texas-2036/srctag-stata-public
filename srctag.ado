*! srctag v1.1.0 - set per-variable source-metadata characteristics
*!
*! Author: Eric Booth, Sr. Researcher, Texas 2036.org
*!
*! Standard source tags:
*!   src_agency, src_dataset, src_url, src_vintage, src_category
*!
*! Generic source tags:
*!   key(name) value("...") sets any additional variable characteristic.
*!   Example: srctag price, key(src_confidence) value("high")

program define srctag
    version 16

    gettoken first rest : 0, parse(" ,")
    if inlist(lower("`first'"), "show", "profile") {
        local rest : list clean rest
        if "`rest'" == "" {
            di as err "srctag `first': must supply one or more variable names"
            exit 198
        }
        foreach v of local rest {
            capture confirm variable `v'
            if _rc {
                di as err "srctag `first': variable `v' not found"
                exit 111
            }
            srctag_profile_one `v'
        }
        exit 0
    }

    syntax varlist, [        ///
        AGENCY(string)       ///
        DATASET(string)      ///
        URL(string)          ///
        VINTAGE(string)      ///
        CATEGORY(string)     ///
        KEY(name)            ///
        VALUE(string asis)   ///
        ]

    if ("`key'" == "" & `"`value'"' != "") | ("`key'" != "" & `"`value'"' == "") {
        di as err "srctag: key() and value() must be supplied together"
        exit 198
    }

    if `"`agency'`dataset'`url'`vintage'`category'`key'`value'"' == "" {
        di as err "srctag: supply at least one of agency() dataset() url() vintage() category() or key()/value()"
        exit 198
    }

    foreach v of local varlist {
        if `"`agency'"'   != "" char `v'[src_agency]   `"`agency'"'
        if `"`dataset'"'  != "" char `v'[src_dataset]  `"`dataset'"'
        if `"`url'"'      != "" char `v'[src_url]      `"`url'"'
        if `"`vintage'"'  != "" char `v'[src_vintage]  `"`vintage'"'
        if `"`category'"' != "" char `v'[src_category] `"`category'"'
        if "`key'" != "" char `v'[`key'] `"`value'"'
    }
end

program define srctag_profile_one
    version 16
    args v

    local lab : variable label `v'
    local type : type `v'
    local fmt : format `v'
    local vallab : value label `v'

    di as txt "{hline 72}"
    di as txt "{bf:srctag profile:} " as res `"{stata "describe `v'":`v'}"' ///
        as txt "  " `"`lab'"'
    di as txt "{hline 72}"
    di as txt "  storage type : " as res "`type'" _col(38) as txt "format: " as res "`fmt'"
    if "`vallab'" != "" {
        di as txt "  value label  : " as res "`vallab'"
    }

    local core src_agency src_dataset src_vintage src_category
    foreach c of local core {
        local cv : char `v'[`c']
        if `"`cv'"' != "" {
            di as txt "  `c' " _col(17) ": " as res ///
                `"{stata "srcfind `c' `cv'":`cv'}"'
        }
        else {
            di as txt "  `c' " _col(17) ": " as txt "(not tagged)"
        }
    }

    local url : char `v'[src_url]
    if `"`url'"' != "" {
        di as txt "  src_url " _col(17) ": " as res `"{browse "`url'":`url'}"'
    }
    else {
        di as txt "  src_url " _col(17) ": " as txt "(not tagged)"
    }

    local legacy : char `v'[source]
    if `"`legacy'"' != "" {
        di as txt "  [source] " _col(17) ": " as res `"`legacy'"'
    }

    local cnames : char `v'[]
    local extras : list cnames - core
    local drop src_url source
    local extras : list extras - drop
    if `"`extras'"' != "" {
        di as txt "  extra chars:"
        foreach c of local extras {
            local cv : char `v'[`c']
            di as txt "    `c' " _col(17) ": " as res `"`cv'"'
        }
    }
    di as txt "{hline 72}"
end
