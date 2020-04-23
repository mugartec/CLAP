# CLAP - Command Line Accessible Passwords

Clap is a (very) simple password manager for the command line. It works on most GNU/Linux distributions. It might work on MacOS. It does not work on Windows (as usual for decent software).

## Installation

### Dependencies

You'll need `openssl`, `oathtool` and `xclip`. For example, in a debian-based distribution you'd need to
```
apt install openssl oathtool xclip
```

### Steps
1) Clone this repository into a directory called `.clap` in your home.

```
git clone https://github.com/mugartec/CLAP.git ~/.clap
```

2) Copy the `clap` script to a directory in your path. For example you might use `~/.bin`.

```
cp ~/.clap/clap ~/.bin
```

## Using CLAP
Using CLAP is very simple. Here is the output of `clap -h`

```
##################################################
#### CLAP - Command Line Accessible Passwords ####
##################################################

    usage: clap <option> entry_name

    options:
    -n, --new          new manually-generated password
    -g, --generate     new randomly-generated password
    -c, --copy         copy password to clipboard
    -s, --show         show password in plaintext
    -nt, --new-token   assign a TOTP token secret to a password
```

## Autocomplete
For instructions on how to install autocompletion go to the [autocomplete directory](https://github.com/mugartec/CLAP/tree/master/autocomplete).
