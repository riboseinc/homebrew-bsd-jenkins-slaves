# Homebrew for bsd-jenkins-slaves

This tap contains formulae relating to [bsd-jenkins-slaves](https://github.com/riboseinc/bsd-jenkins-slaves).


## Quick Install

Run this and it's all done.

``` sh
brew tap riboseinc/bsd-jenkins-slaves
brew install --HEAD freebsd-jenkins-slave
# brew install --HEAD netbsd-jenkins-slave
# brew install --HEAD openbsd-jenkins-slave
```

Or:

``` sh
brew install --HEAD riboseinc/bsd-jenkins-slaves/freebsd-jenkins-slave
```

## Install Tap

``` sh
brew tap riboseinc/bsd-jenkins-slaves
```

## Install bsd-jenkins-slaves

Currently it is a HEAD-only formula, i.e., you must install it using the `--HEAD` option:

``` sh
brew install --HEAD freebsd-jenkins-slave
```

If the formula conflicts with one from `Homebrew/homebrew` or another
tap, you can run:

``` sh
brew install --HEAD riboseinc/bsd-jenkins-slaves/freebsd-jenkins-slave
```

You can also install via URL:

``` sh
brew install --HEAD https://raw.githubusercontent.com/riboseinc/homebrew-bsd-jenkins-slaves/master/freebsd-jenkins-slave.rb
```

## Acceptable Formulae

You can read Homebrew’s Acceptable Formulae document [here](https://github.com/Homebrew/brew/blob/master/docs/Acceptable-Formulae.md).

## Troubleshooting

First, please run `brew update` and `brew doctor`.

Second, read the [Troubleshooting Checklist](https://github.com/Homebrew/brew/blob/master/docs/Troubleshooting.md#troubleshooting).

## More Documentation

`brew help`, `man brew` or check [our documentation](https://github.com/Homebrew/brew/tree/master/docs#readme).

## License

Code is under the [BSD 2 Clause license](https://github.com/Homebrew/brew/tree/master/LICENSE.txt).
