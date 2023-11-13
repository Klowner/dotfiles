#!/bin/sh -e

homedir=$HOME
basedir=$homedir/.dotfiles
bindir=$homedir/bin
gitbase=git://github.com/Klowner/dotfiles.git
gitorigin=git@github.com:Klowner/dotfiles.git
gitbranch=${GIT_BRANCH:-master}
tarball=http://github.com/Klowner/dotfiles/tarball/$gitbranch

function has() {
    return $( which $1 >/dev/null)
}

function note() {
    echo -e "\e[32;1m * \e[0m$*"
}

function warn() {
    echo -e "\e[31;1m * \e[0m$*"
}

function die() {
    warn $*
    exit 1
}

function install() {
    method=$1
    src=$2
    dst=$3
    if [ -e $dst ]; then
        if [ -L $dst ]; then
            # already symlinked
            return
        else
            # rename files with an ".old" extension
            warn "$dst already exists, renaming to $dst.old"
            backup=$dst.old
            # if [ -e $backup ]; then
            #     die "$backup already exists. Aborting."
            # fi
            mv -v $dst $backup
        fi
    fi

    case $method in
        link)
            # Update existing or create new symlinks
            ln -vsf $src $dst
            ;;
        copy)
            cp -a $src $dst
            ;;
        *)
            warn "Unknown install method: $1"
            ;;
    esac
}

function link() {
    install link $1 $2
}

function copy() {
    install copy $1 $2
}

function unpack_tarball() {
    note "Downloading tarball..."
    mkdir -vp $basedir
    cd $basedir
    tempfile=TEMP.tar.gz
    if has curl; then
        curl -L $tarball >$tempfile
    elif has wget; then
        wget -O $tempfile $tarball
    else:
        die "Can't download tarball."
    fi
    tar --strip-components 1 -zxvf $tempfile
    rm -v $tempfile
}

if [ -e $basedir ]; then
    # basedir exists, update it.
    cd $basedir
    if [ -e .git ]; then
        note "Updating dotfiles from git..."
        git pull --rebase origin $gitbranch
    else
        unpack_tarball
    fi
else
    # .dotfiles directory needs to be installed. Try downloading first
    # with git and then fallback to tarball.
    if has git; then
        note "Cloning from git..."
        git clone --single-branch --branch $gitbranch $gitbase $basedir
        cd $basedir
        git submodule init
        git submodule update --init --recursive
    else
        warn "Git not installed."
        unpack_tarball
    fi
fi

note "Symlinking dotfiles..."
for path in * ; do
    # Skip any files beginning with underscores.
    if [ $(expr match $path '^_') -eq 1 ]; then
        continue
    fi

    src=$basedir/$path
    dst=$homedir/.$path

    if [ -L $src ]; then
        copy $src $dst
    else
        link $src $dst
    fi
done

mkdir -p $homedir/.config
for path in _config/*; do
    path=${path##*/}
    link $basedir/_config/$path $homedir/.config/${path}
done

note "Installing bin/ directory..."
mkdir -v -p $bindir
if [ -d _bin ]; then
    for path in _bin/*; do
        relpath=${path##*/}
        link $basedir/$path $bindir/$relpath
    done
fi

note "Done."

# vim:ts=4:sw=4:et: