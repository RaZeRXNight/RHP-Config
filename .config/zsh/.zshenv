
for file in "${ZDOTDIR:-$HOME/.config/zsh}/conf.d/"*.zsh; do 
  [ -r "$file" ] && source "$file"
done

command -v fastfetch >/dev/null && fastfetch

[ -f ~/.oh-my-zsh/oh-my-zsh.sh ] && source ~/.oh-my-zsh/oh-my-zsh.sh
