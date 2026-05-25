
for file in "${ZDOTDIR:-$HOME/.config/zsh}/conf.d/"*.zsh; do 
  [ -r "$file" ] && source "$file"
done

fastfetch

source ~/.oh-my-zsh/oh-my-zsh.sh
