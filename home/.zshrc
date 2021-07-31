test -f /var/run/reboot-required && cat /var/run/reboot-required /var/run/reboot-required.pkgs

[ -d "$ZPLUG_HOME" ] || git clone https://github.com/zplug/zplug $ZPLUG_HOME
source $ZPLUG_HOME/init.zsh
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt extended_glob
setopt auto_list
setopt auto_menu
setopt list_packed
setopt list_types
setopt prompt_subst
setopt correct
setopt nolistbeep
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt no_beep
setopt no_hist_beep
setopt no_list_beep
setopt magic_equal_subst
setopt transient_rprompt
unsetopt caseglob
bindkey -v
autoload -U compinit; compinit
autoload -U zmv
alias zmv='noglob zmv -W'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
function history-all { history -E 1 }

zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "mollifier/cd-gitroot"
alias gitcd='cd-gitroot'
zplug "zsh-users/zsh-completions"
zplug "hchbaw/opp.zsh"

if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
      echo; zplug install
  fi
fi
zplug load --verbose

function zle-line-init zle-keymap-select {
  printf "\a"
  PROMPT=$'%(?!\U1F60A!\U1F62D)%(?!%{${fg[blue]}%}!%{${fg[red]}%}) Last status code is %?!%{${reset_color}%}    %{${fg[cyan]}%}%n@%m:%~%{${reset_color}%}    '
  # man 3 strftime
  PROMPT=$PROMPT$'%{${fg[green]}%}[%D{%m/%d/%Y} %0(D.\U2603.%1(D.\U2603.%2(D.\U1F338.%3(D.\U1F338.%4(D.\U1F338.%5(D.\U2614.%6(D.\U1F33B.%7(D.\U1F33B.%8(D.\U1F341.%9(D.\U1F341.%10(D.\U1F341.\U2603))))))))))) %T]%{${reset_color}%}    '
  SPROMPT=$'%{${fg[yellow]}%}%{$suggest%}\U1F914 You may intend to ... %B%r%b [y(es), n(o), a(bort), e(dit)]: %{${reset_color}%}'
  case $KEYMAP in
    vicmd)
    PROMPT=$PROMPT'%{${fg[blue]}%}%BNormal%b%{${reset_color}%}'
    ;;
    main|viins)
    PROMPT=$PROMPT'%{${fg[magenta]}%}%BInsert%b%{${reset_color}%}'
    ;;
    *)
    PROMPT=$PROMPT'%{${fg[blue]}%}%BNormal%b%{${reset_color}%}'
    ;;
  esac
  PROMPT=$PROMPT$'\n  %{${fg[white]}%}%BCommand? $%b%{${reset_color}%} '
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
test -f $HOME/.zlogin && source $HOME/.zlogin
