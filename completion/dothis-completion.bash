#/usr/bin/env bash
_package_manager_completions()
{
    package_manager_args=(update search install remove uninstall --help)
    COMPREPLY=($(compgen -W "${package_manager_args[@]}""${COMP_WORDS[1]}"))
    #echo $COMP_WORDS
    #COMPREPLY=($(compgen -W "now tomorrow never" "${COMP_WORDS[1]}"))

}

complete -F _package_manager_completions package_manager
complete -F _package_manager_completions package_manager.sh
