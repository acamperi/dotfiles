############
### brew ###
############
/usr/local/bin/brew shellenv | source


###########################
### too many open files ###
###########################
ulimit -n 8192


############
### rust ###
############
set -gx RUST_BACKTRACE full
set -gx PATH ~/.cargo/bin $PATH


##########
### go ###
##########
set -gx GOPATH ~/.go
# set -gx GOROOT /usr/local/opt/go@1.18/libexec
set -gx GOPRIVATE "gitlab.com/levelbenefits/*"
set -gx PATH $GOPATH/bin $PATH


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
abbr -a gl3 'git log -3'
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
    set -l branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
    echo
    printf "\033[6 q"
    set_color green
    printf ' %s' (prompt_pwd)
    # set_color red
    # printf '%s' (fish_git_prompt)
    # echo
    if not test -z $branch
        set_color white
        printf ' ('
        set_color red
        printf '%s' (echo $branch)
        set_color white
        printf ')'
        echo
    end
    set_color --bold yellow
    echo -n ' >>>>> '
    set_color normal
end


#############
### level ###
#############
set -gx LEVEL_REPO_ROOT ~/code/level
abbr -a brg 'bazel run //:gazelle'
abbr -a mgp 'gitroot; make go-proto'
abbr -a gmt 'gitroot; cd go; go mod tidy; cd ..'
abbr -a mbf 'gitroot; make bazel-fmt'
abbr -a tf 'terraform'
abbr -a tfi 'terraform init'
abbr -a tfp 'terraform plan'
abbr -a tfa 'terraform apply'
set -gx KUBECONFIG ~/.kube/config:$LEVEL_REPO_ROOT/k8s/clusters.yaml
abbr -a tm 'sh ~/dotfiles/scripts/init_level_tmux.sh'
if [ -f '/usr/local/bin/google-cloud-sdk/path.fish.inc' ]; . '/usr/local/bin/google-cloud-sdk/path.fish.inc'; end
function kctl
    if test (string match -r '^'$LEVEL_REPO_ROOT'.*$' $PWD)
        if test -f $LEVEL_REPO_ROOT'/bazel-bin/kubectl'
            $LEVEL_REPO_ROOT/bazel-bin/kubectl $argv
        else
            bazel run //:kubectl -- $argv
        end
    else
        kubectl $argv
    end
end
abbr kdev 'kctl --context admin-dev'
abbr kdevqa 'kctl --context admin-devqa'
abbr kstaging 'kctl --context admin-staging'
abbr kprod 'kctl --context admin-prod'
abbr kcanary 'kctl --context admin-canary'
function kz
    if test (string match -r '^'$LEVEL_REPO_ROOT'.*$' $PWD)
        if test -f $LEVEL_REPO_ROOT'/bazel-bin/kustomize'
            $LEVEL_REPO_ROOT/bazel-bin/kustomize $argv
        else
            bazel run //:kustomize -- $argv
        end
    else
        kustomize $argv
    end
end
function kzbuild
    kz build --load-restrictor=LoadRestrictionsNone $argv
end
function tfswitch_on_pwd_change --on-variable PWD
    if test -f 'main.tf' && rg 'backend "' *.tf &>/dev/null
        tfswitch
    end
end
eksctl completion fish > ~/.config/fish/completions/eksctl.fish
