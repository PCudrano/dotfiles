#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
export PATH="/usr/local/opt/qt@5/bin:$PATH"

# Set default CMake compilers to gcc
#export CC=gcc-11
#export CXX=g++-11

# gcc from Homebrew (instead of system Clang)
#alias gcc='gcc-12'
#alias g++='g++-12'

# Intel oneAPI (no output to screen)
. /opt/intel/oneapi/setvars.sh >/dev/null
#. /opt/intel/oneapi/compiler/latest/env/vars.sh >/dev/null

# Python
#export PYTHONHOME=/opt/intel/oneapi/intelpython/latest/
export OPENSSL_ROOT_DIR=/usr/local/opt/openssl@3
export LDFLAGS="-L/usr/local/opt/openssl@3/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@3/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@3/lib/pkgconfig"
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)"


export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:/usr/local/opt/qt@5
export PATH=$PATH:/usr/local/opt/qt@5/bin
export PATH=$PATH:/Users/archnnj/.local/bin

# Import key as env vars
set -a; source .env; set +a

# Ruby
#export PATH="/usr/local/opt/ruby/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/ruby/lib"
export CPPFLAGS="-I/usr/local/opt/ruby/include"
#export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"
# rbenv global 3.2.1

# Temp
# export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
