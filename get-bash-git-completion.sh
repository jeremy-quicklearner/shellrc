SHRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ETCDIR=$SHRCDIR/etc
mkdir -p $ETCDIR

BASHDIR=$ETCDIR/bash
mkdir -p $BASHDIR

if [ ! -f $BASHDIR/git-completion.bash ]; then
    echo "Downloading git-completion.bash..."
    curl -L https://github.com/git/git/raw/master/contrib/completion/git-completion.bash > $BASHDIR/git-completion.bash
    chmod a+x $BASHDIR/git-completion.bash
fi
