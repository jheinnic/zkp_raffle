_nargo() {
    local i cur prev opts cmd
    COMPREPLY=()
    if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
        cur="$2"
    else
        cur="${COMP_WORDS[COMP_CWORD]}"
    fi
    prev="$3"
    cmd=""
    opts=""

    for i in "${COMP_WORDS[@]:0:COMP_CWORD}"
    do
        case "${cmd},${i}" in
            ",$1")
                cmd="nargo"
                ;;
            nargo,c)
                cmd="nargo__check"
                ;;
            nargo,check)
                cmd="nargo__check"
                ;;
            nargo,compile)
                cmd="nargo__compile"
                ;;
            nargo,dap)
                cmd="nargo__dap"
                ;;
            nargo,debug)
                cmd="nargo__debug"
                ;;
            nargo,doc)
                cmd="nargo__doc"
                ;;
            nargo,e)
                cmd="nargo__execute"
                ;;
            nargo,execute)
                cmd="nargo__execute"
                ;;
            nargo,expand)
                cmd="nargo__expand"
                ;;
            nargo,export)
                cmd="nargo__export"
                ;;
            nargo,f)
                cmd="nargo__fuzz"
                ;;
            nargo,fmt)
                cmd="nargo__fmt"
                ;;
            nargo,fuzz)
                cmd="nargo__fuzz"
                ;;
            nargo,generate-completion-script)
                cmd="nargo__generate__completion__script"
                ;;
            nargo,help)
                cmd="nargo__help"
                ;;
            nargo,i)
                cmd="nargo__info"
                ;;
            nargo,info)
                cmd="nargo__info"
                ;;
            nargo,init)
                cmd="nargo__init"
                ;;
            nargo,interpret)
                cmd="nargo__interpret"
                ;;
            nargo,lsp)
                cmd="nargo__lsp"
                ;;
            nargo,new)
                cmd="nargo__new"
                ;;
            nargo,t)
                cmd="nargo__test"
                ;;
            nargo,test)
                cmd="nargo__test"
                ;;
            nargo__help,check)
                cmd="nargo__help__check"
                ;;
            nargo__help,compile)
                cmd="nargo__help__compile"
                ;;
            nargo__help,dap)
                cmd="nargo__help__dap"
                ;;
            nargo__help,debug)
                cmd="nargo__help__debug"
                ;;
            nargo__help,doc)
                cmd="nargo__help__doc"
                ;;
            nargo__help,execute)
                cmd="nargo__help__execute"
                ;;
            nargo__help,expand)
                cmd="nargo__help__expand"
                ;;
            nargo__help,export)
                cmd="nargo__help__export"
                ;;
            nargo__help,fmt)
                cmd="nargo__help__fmt"
                ;;
            nargo__help,fuzz)
                cmd="nargo__help__fuzz"
                ;;
            nargo__help,generate-completion-script)
                cmd="nargo__help__generate__completion__script"
                ;;
            nargo__help,help)
                cmd="nargo__help__help"
                ;;
            nargo__help,info)
                cmd="nargo__help__info"
                ;;
            nargo__help,init)
                cmd="nargo__help__init"
                ;;
            nargo__help,interpret)
                cmd="nargo__help__interpret"
                ;;
            nargo__help,lsp)
                cmd="nargo__help__lsp"
                ;;
            nargo__help,new)
                cmd="nargo__help__new"
                ;;
            nargo__help,test)
                cmd="nargo__help__test"
                ;;
            *)
                ;;
        esac
    done

    case "${cmd}" in
        nargo)
            opts="-h -V --program-dir --target-dir --help --version check c fmt compile interpret new init execute e export debug test t fuzz f info i lsp dap expand doc generate-completion-script help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 1 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --program-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --target-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__check)
            opts="-Z -h --package --workspace --overwrite --expression-width --bounded-codegen --force --show-ssa --show-ssa-pass --with-ssa-locations --show-contract-fn --skip-ssa-pass --emit-ssa --minimal-ssa --show-brillig --print-acir --benchmark-codegen --deny-warnings --silence-warnings --show-monomorphized --instrument-debug --force-brillig --debug-comptime-in-file --show-artifact-paths --skip-underconstrained-check --skip-brillig-constraints-check --enable-brillig-debug-assertions --count-array-copies --enable-brillig-constraints-check-lookback --inliner-aggressiveness --constant-folding-max-iter --small-function-max-instructions --max-bytecode-increase-percent --pedantic-solving --debug-compile-stdin --unstable-features --no-unstable-features --disable-comptime-printing --show-program-hash --program-dir --target-dir --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --expression-width)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --show-ssa-pass)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --show-contract-fn)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --skip-ssa-pass)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --debug-comptime-in-file)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inliner-aggressiveness)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --constant-folding-max-iter)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --small-function-max-instructions)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --max-bytecode-increase-percent)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --unstable-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -Z)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --program-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --target-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__compile)
            opts="-Z -h --package --workspace --expression-width --bounded-codegen --force --show-ssa --show-ssa-pass --with-ssa-locations --show-contract-fn --skip-ssa-pass --emit-ssa --minimal-ssa --show-brillig --print-acir --benchmark-codegen --deny-warnings --silence-warnings --show-monomorphized --instrument-debug --force-brillig --debug-comptime-in-file --show-artifact-paths --skip-underconstrained-check --skip-brillig-constraints-check --enable-brillig-debug-assertions --count-array-copies --enable-brillig-constraints-check-lookback --inliner-aggressiveness --constant-folding-max-iter --small-function-max-instructions --max-bytecode-increase-percent --pedantic-solving --debug-compile-stdin --unstable-features --no-unstable-features --disable-comptime-printing --watch --program-dir --target-dir --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --expression-width)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --show-ssa-pass)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --show-contract-fn)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --skip-ssa-pass)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --debug-comptime-in-file)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inliner-aggressiveness)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --constant-folding-max-iter)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --small-function-max-instructions)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --max-bytecode-increase-percent)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --unstable-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -Z)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --program-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --target-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__dap)
            opts="-h --expression-width --preflight-check --preflight-project-folder --preflight-package --preflight-prover-name --preflight-generate-acir --preflight-skip-instrumentation --preflight-test-name --pedantic-solving --program-dir --target-dir --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --expression-width)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preflight-project-folder)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preflight-package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preflight-prover-name)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --preflight-test-name)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --program-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --target-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__debug)
            opts="-p -Z -h --prover-name --package --expression-width --bounded-codegen --force --show-ssa --show-ssa-pass --with-ssa-locations --show-contract-fn --skip-ssa-pass --emit-ssa --minimal-ssa --show-brillig --print-acir --benchmark-codegen --deny-warnings --silence-warnings --show-monomorphized --instrument-debug --force-brillig --debug-comptime-in-file --show-artifact-paths --skip-underconstrained-check --skip-brillig-constraints-check --enable-brillig-debug-assertions --count-array-copies --enable-brillig-constraints-check-lookback --inliner-aggressiveness --constant-folding-max-iter --small-function-max-instructions --max-bytecode-increase-percent --pedantic-solving --debug-compile-stdin --unstable-features --no-unstable-features --disable-comptime-printing --acir-mode --skip-instrumentation --raw-source-printing --test-name --oracle-resolver --program-dir --target-dir --help [WITNESS_NAME]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --prover-name)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -p)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --expression-width)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --show-ssa-pass)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --show-contract-fn)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --skip-ssa-pass)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --debug-comptime-in-file)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inliner-aggressiveness)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --constant-folding-max-iter)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --small-function-max-instructions)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --max-bytecode-increase-percent)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --unstable-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -Z)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --skip-instrumentation)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --raw-source-printing)
                    COMPREPLY=($(compgen -W "true false" -- "${cur}"))
                    return 0
                    ;;
                --test-name)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --oracle-resolver)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --program-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --target-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__doc)
            opts="-Z -h --package --workspace --expression-width --bounded-codegen --force --show-ssa --show-ssa-pass --with-ssa-locations --show-contract-fn --skip-ssa-pass --emit-ssa --minimal-ssa --show-brillig --print-acir --benchmark-codegen --deny-warnings --silence-warnings --show-monomorphized --instrument-debug --force-brillig --debug-comptime-in-file --show-artifact-paths --skip-underconstrained-check --skip-brillig-constraints-check --enable-brillig-debug-assertions --count-array-copies --enable-brillig-constraints-check-lookback --inliner-aggressiveness --constant-folding-max-iter --small-function-max-instructions --max-bytecode-increase-percent --pedantic-solving --debug-compile-stdin --unstable-features --no-unstable-features --disable-comptime-printing --program-dir --target-dir --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --expression-width)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --show-ssa-pass)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --show-contract-fn)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --skip-ssa-pass)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --debug-comptime-in-file)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inliner-aggressiveness)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --constant-folding-max-iter)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --small-function-max-instructions)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --max-bytecode-increase-percent)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --unstable-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -Z)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --program-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --target-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__execute)
            opts="-p -Z -h --prover-name --package --workspace --expression-width --bounded-codegen --force --show-ssa --show-ssa-pass --with-ssa-locations --show-contract-fn --skip-ssa-pass --emit-ssa --minimal-ssa --show-brillig --print-acir --benchmark-codegen --deny-warnings --silence-warnings --show-monomorphized --instrument-debug --force-brillig --debug-comptime-in-file --show-artifact-paths --skip-underconstrained-check --skip-brillig-constraints-check --enable-brillig-debug-assertions --count-array-copies --enable-brillig-constraints-check-lookback --inliner-aggressiveness --constant-folding-max-iter --small-function-max-instructions --max-bytecode-increase-percent --pedantic-solving --debug-compile-stdin --unstable-features --no-unstable-features --disable-comptime-printing --oracle-resolver --oracle-file --force-comptime --program-dir --target-dir --help [WITNESS_NAME]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --prover-name)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -p)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --expression-width)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --show-ssa-pass)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --show-contract-fn)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --skip-ssa-pass)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --debug-comptime-in-file)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inliner-aggressiveness)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --constant-folding-max-iter)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --small-function-max-instructions)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --max-bytecode-increase-percent)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --unstable-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -Z)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --oracle-resolver)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --oracle-file)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --program-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --target-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__expand)
            opts="-Z -h --package --workspace --expression-width --bounded-codegen --force --show-ssa --show-ssa-pass --with-ssa-locations --show-contract-fn --skip-ssa-pass --emit-ssa --minimal-ssa --show-brillig --print-acir --benchmark-codegen --deny-warnings --silence-warnings --show-monomorphized --instrument-debug --force-brillig --debug-comptime-in-file --show-artifact-paths --skip-underconstrained-check --skip-brillig-constraints-check --enable-brillig-debug-assertions --count-array-copies --enable-brillig-constraints-check-lookback --inliner-aggressiveness --constant-folding-max-iter --small-function-max-instructions --max-bytecode-increase-percent --pedantic-solving --debug-compile-stdin --unstable-features --no-unstable-features --disable-comptime-printing --program-dir --target-dir --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --expression-width)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --show-ssa-pass)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --show-contract-fn)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --skip-ssa-pass)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --debug-comptime-in-file)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inliner-aggressiveness)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --constant-folding-max-iter)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --small-function-max-instructions)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --max-bytecode-increase-percent)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --unstable-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -Z)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --program-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --target-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__export)
            opts="-Z -h --package --workspace --expression-width --bounded-codegen --force --show-ssa --show-ssa-pass --with-ssa-locations --show-contract-fn --skip-ssa-pass --emit-ssa --minimal-ssa --show-brillig --print-acir --benchmark-codegen --deny-warnings --silence-warnings --show-monomorphized --instrument-debug --force-brillig --debug-comptime-in-file --show-artifact-paths --skip-underconstrained-check --skip-brillig-constraints-check --enable-brillig-debug-assertions --count-array-copies --enable-brillig-constraints-check-lookback --inliner-aggressiveness --constant-folding-max-iter --small-function-max-instructions --max-bytecode-increase-percent --pedantic-solving --debug-compile-stdin --unstable-features --no-unstable-features --disable-comptime-printing --program-dir --target-dir --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --expression-width)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --show-ssa-pass)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --show-contract-fn)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --skip-ssa-pass)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --debug-comptime-in-file)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inliner-aggressiveness)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --constant-folding-max-iter)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --small-function-max-instructions)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --max-bytecode-increase-percent)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --unstable-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -Z)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --program-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --target-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__fmt)
            opts="-h --check --package --workspace --program-dir --target-dir --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --program-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --target-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__fuzz)
            opts="-Z -h --corpus-dir --minimized-corpus-dir --fuzzing-failure-dir --list-all --show-output --num-threads --exact --package --workspace --expression-width --bounded-codegen --force --show-ssa --show-ssa-pass --with-ssa-locations --show-contract-fn --skip-ssa-pass --emit-ssa --minimal-ssa --show-brillig --print-acir --benchmark-codegen --deny-warnings --silence-warnings --show-monomorphized --instrument-debug --force-brillig --debug-comptime-in-file --show-artifact-paths --skip-underconstrained-check --skip-brillig-constraints-check --enable-brillig-debug-assertions --count-array-copies --enable-brillig-constraints-check-lookback --inliner-aggressiveness --constant-folding-max-iter --small-function-max-instructions --max-bytecode-increase-percent --pedantic-solving --debug-compile-stdin --unstable-features --no-unstable-features --disable-comptime-printing --oracle-resolver --timeout --max-executions --program-dir --target-dir --help [FUZZING_HARNESS_NAME]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --corpus-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --minimized-corpus-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --fuzzing-failure-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --num-threads)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --expression-width)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --show-ssa-pass)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --show-contract-fn)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --skip-ssa-pass)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --debug-comptime-in-file)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inliner-aggressiveness)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --constant-folding-max-iter)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --small-function-max-instructions)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --max-bytecode-increase-percent)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --unstable-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -Z)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --oracle-resolver)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --timeout)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --max-executions)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --program-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --target-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__generate__completion__script)
            opts="-h --program-dir --target-dir --help <SHELL>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --program-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --target-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__help)
            opts="check fmt compile interpret new init execute export debug test fuzz info lsp dap expand doc generate-completion-script help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__help__check)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__help__compile)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__help__dap)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__help__debug)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__help__doc)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__help__execute)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__help__expand)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__help__export)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__help__fmt)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__help__fuzz)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__help__generate__completion__script)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__help__help)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__help__info)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__help__init)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__help__interpret)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__help__lsp)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__help__new)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__help__test)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__info)
            opts="-p -Z -h --package --workspace --json --profile-execution --prover-name --expression-width --bounded-codegen --force --show-ssa --show-ssa-pass --with-ssa-locations --show-contract-fn --skip-ssa-pass --emit-ssa --minimal-ssa --show-brillig --print-acir --benchmark-codegen --deny-warnings --silence-warnings --show-monomorphized --instrument-debug --force-brillig --debug-comptime-in-file --show-artifact-paths --skip-underconstrained-check --skip-brillig-constraints-check --enable-brillig-debug-assertions --count-array-copies --enable-brillig-constraints-check-lookback --inliner-aggressiveness --constant-folding-max-iter --small-function-max-instructions --max-bytecode-increase-percent --pedantic-solving --debug-compile-stdin --unstable-features --no-unstable-features --disable-comptime-printing --program-dir --target-dir --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --prover-name)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -p)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --expression-width)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --show-ssa-pass)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --show-contract-fn)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --skip-ssa-pass)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --debug-comptime-in-file)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inliner-aggressiveness)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --constant-folding-max-iter)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --small-function-max-instructions)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --max-bytecode-increase-percent)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --unstable-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -Z)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --program-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --target-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__init)
            opts="-h --name --lib --bin --contract --program-dir --target-dir --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --name)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --program-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --target-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__interpret)
            opts="-Z -p -h --package --workspace --expression-width --bounded-codegen --force --show-ssa --show-ssa-pass --with-ssa-locations --show-contract-fn --skip-ssa-pass --emit-ssa --minimal-ssa --show-brillig --print-acir --benchmark-codegen --deny-warnings --silence-warnings --show-monomorphized --instrument-debug --force-brillig --debug-comptime-in-file --show-artifact-paths --skip-underconstrained-check --skip-brillig-constraints-check --enable-brillig-debug-assertions --count-array-copies --enable-brillig-constraints-check-lookback --inliner-aggressiveness --constant-folding-max-iter --small-function-max-instructions --max-bytecode-increase-percent --pedantic-solving --debug-compile-stdin --unstable-features --no-unstable-features --disable-comptime-printing --prover-name --ssa-pass --trace --step-limit --program-dir --target-dir --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --expression-width)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --show-ssa-pass)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --show-contract-fn)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --skip-ssa-pass)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --debug-comptime-in-file)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inliner-aggressiveness)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --constant-folding-max-iter)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --small-function-max-instructions)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --max-bytecode-increase-percent)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --unstable-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -Z)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --prover-name)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -p)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --ssa-pass)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --step-limit)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --program-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --target-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__lsp)
            opts="-h --program-dir --target-dir --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --program-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --target-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__new)
            opts="-h --name --lib --bin --contract --program-dir --target-dir --help <PATH>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --name)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --program-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --target-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        nargo__test)
            opts="-Z -q -h --show-output --exact --list-tests --no-run --package --workspace --expression-width --bounded-codegen --force --show-ssa --show-ssa-pass --with-ssa-locations --show-contract-fn --skip-ssa-pass --emit-ssa --minimal-ssa --show-brillig --print-acir --benchmark-codegen --deny-warnings --silence-warnings --show-monomorphized --instrument-debug --force-brillig --debug-comptime-in-file --show-artifact-paths --skip-underconstrained-check --skip-brillig-constraints-check --enable-brillig-debug-assertions --count-array-copies --enable-brillig-constraints-check-lookback --inliner-aggressiveness --constant-folding-max-iter --small-function-max-instructions --max-bytecode-increase-percent --pedantic-solving --debug-compile-stdin --unstable-features --no-unstable-features --disable-comptime-printing --oracle-resolver --test-threads --format --quiet --no-fuzz --only-fuzz --corpus-dir --minimized-corpus-dir --fuzzing-failure-dir --fuzz-timeout --fuzz-max-executions --fuzz-show-progress --program-dir --target-dir --help [TEST_NAMES]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --package)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --expression-width)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --show-ssa-pass)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --show-contract-fn)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --skip-ssa-pass)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --debug-comptime-in-file)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --inliner-aggressiveness)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --constant-folding-max-iter)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --small-function-max-instructions)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --max-bytecode-increase-percent)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --unstable-features)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                -Z)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --oracle-resolver)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --test-threads)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --format)
                    COMPREPLY=($(compgen -W "pretty terse json" -- "${cur}"))
                    return 0
                    ;;
                --corpus-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --minimized-corpus-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --fuzzing-failure-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --fuzz-timeout)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --fuzz-max-executions)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --program-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --target-dir)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
    esac
}

if [[ "${BASH_VERSINFO[0]}" -eq 4 && "${BASH_VERSINFO[1]}" -ge 4 || "${BASH_VERSINFO[0]}" -gt 4 ]]; then
    complete -F _nargo -o nosort -o bashdefault -o default nargo
else
    complete -F _nargo -o bashdefault -o default nargo
fi
