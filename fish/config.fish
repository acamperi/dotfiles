############
### brew ###
############
/usr/local/bin/brew shellenv | source


############
### rust ###
############
set -gx RUST_BACKTRACE full
set -gx PATH ~/.cargo/bin $PATH


##########
### go ###
##########
set -gx GOPATH ~/.go
set -gx GOROOT /usr/local/Cellar/go@1.16/1.16.9/libexec
set -gx GOPRIVATE "gitlab.com/levelbenefits/*"
set -gx PATH $GOPATH/bin $GOROOT/bin $PATH


##############
### python ###
##############
if command -v pyenv > /dev/null
    set -gx PYENV_ROOT $HOME/.pyenv
    set -gx PATH $PYENV_ROOT/bin $PATH
    status is-login; and pyenv init --path | source
    status is-interactive; and pyenv init - | source
end


############################
### other path locations ###
############################
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH


##############
### editor ###
##############
set -gx EDITOR nvim


########################
### ls abbreviations ###
########################
if command -v exa > /dev/null
    abbr -a l 'exa -F'
    abbr -a ls 'exa -F'
    abbr -a la 'exa -Fa'
    abbr -a ll 'exa -Fl'
    abbr -a lla 'exa -Fla'
else
    abbr -a l 'ls -FG'
    abbr -a la 'ls -FGa'
    abbr -a ll 'ls -FGl'
    abbr -a lla 'ls -FGla'
end


#########################
### git abbreviations ###
#########################
abbr -a gspr 'git stash; and git pull --rebase; and git stash pop'
abbr -a grsh 'git reset --soft HEAD^'
abbr -a gcom 'git checkout master'
abbr -a grbm 'git rebase master'
abbr -a gpr 'git pull --rebase'
abbr -a gpu 'git push -u origin (git branch --show-current)'
abbr -a gpf 'git push --force'
abbr -a grbc 'git rebase --continue'
abbr -a grbs 'git rebase --skip'
abbr -a grba 'git rebase --abort'
abbr -a gc 'git commit'
abbr -a gca 'git commit --amend'
abbr -a gsl 'git summary --line'
abbr -a gl1 'git log -1'
abbr -a gl2 'git log -2'
abbr -a grpo 'git remote prune origin'
abbr -a wip 'git add .; git commit -m "WIP"'
abbr -a awip 'git add .; git commit --amend -m "WIP"'


###########################
### other abbreviations ###
###########################
abbr -a brewup 'brew update; and brew upgrade; and brew cleanup -s'
abbr -a xcodeclean 'rm -frd ~/Library/Developer/Xcode/DerivedData/*; and rm -frd ~/Library/Caches/com.apple.dt.Xcode/*'


#####################################
### get to the root of a git repo ###
#####################################
function gitroot
    while test $PWD != "/"
        if test -d .git
            break
        end
        cd ..
    end
end
abbr -a gr 'gitroot'


#############################################
### source bash output and export to fish ###
#############################################
function sourcesh
    exec bash -c "source $argv[1]; exec fish"
end


#######################
### old fish prompt ###
#######################
function fish_prompt2
    set -l branch (git branch ^/dev/null | grep '*' | sed -e 's/* \(.*\)/\1/')
    set -l hasChanges (git diff --no-ext-diff --quiet ^/dev/null)
    set -l changeIndicator (if not eval $hasChanges; echo "*"; else; echo ""; end)
    if not test -z $branch
        printf '(%s%s%s%s) ' (set_color red) (echo $branch) (echo $changeIndicator) (set_color normal)
    end

    printf '%s>>>>> %s' (set_color --bold yellow) (set_color normal)
end


###################
### fish prompt ###
###################
set -g __fish_git_prompt_showuntrackedfiles
set -g __fish_git_prompt_showdirtystate
set -e __fish_git_prompt_showstashstate
set -g __fish_git_prompt_showupstream none
set -g fish_prompt_pwd_dir_length 0
function fish_prompt
    echo
    printf "\033[6 q"
    set_color green
    printf ' %s' (prompt_pwd)
    set_color red
    printf '%s' (fish_git_prompt)
    echo
    set_color --bold yellow
    echo -n ' >>>>> '
    set_color normal
end


#############
### level ###
#############
abbr -a brg 'bazel run //:gazelle'
abbr -a mgp 'gitroot; make go-proto'
function local_k8s
    set -ge KUBECONFIG
    kubectl config set-context minikube --namespace=local
end
function prod_k8s
    set -gx KUBECONFIG ~/code/level/k8s/clusters.yaml
end
abbr -a tm 'sh ~/dotfiles/scripts/init_level_tmux.sh'
