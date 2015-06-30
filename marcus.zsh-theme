# ZSH Theme - Preview: http://gyazo.com/8becc8a7ed5ab54a0262a470555c3eed.png
setopt promptsubst
autoload -U colors && colors # Enable colors in prompt

local current_time='%B%F{green}%*%b%f'
local current_dir='%B%F{blue}  %~%b%f'

GIT_PROMPT_SYMBOL="%F{blue}±"
GIT_PROMPT_PREFIX="%F{green}[%f"
GIT_PROMPT_SUFFIX="%F{green]%}]%f"
GIT_PROMPT_UNTRACKED="%B%F{red]%}●%b%f"
GIT_PROMPT_MODIFIED="%B%F{yellow]%}●%b%f"
GIT_PROMPT_STAGED="%B%F{green]%}●%b%f"

parse_git_state() {

  # Compose this value via multiple conditional appends.
  local GIT_STATE=""

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
  fi

  if ! git diff --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
  fi

  if [[ -n $GIT_STATE ]]; then
    echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
  fi
}

# Show Git branch/tag, or name-rev if on detached head
parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

git_prompt_string() {
  local git_where="$(parse_git_branch)"
  [ -n "$git_where" ] && echo "$GIT_PROMPT_SYMBOL$(parse_git_state)$GIT_PROMPT_PREFIX%F{yellow}${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX"
}

PROMPT="╭─(${current_time}) ${current_dir}
╰─%(?..%F{red})$%f "
RPS1='$(git_prompt_string)'

