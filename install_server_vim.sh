# if needed,
sudo apt remove vim vim-runtime vim-tiny vim-common vim-gui-common
sudo apt update && sudo apt install -y make
# installation
git clone https://github.com/vim/vim.git && cd vim && git pull && cd src
# make distclean  # if you build Vim before
./configure --with-features=huge \
            --enable-multibyte \
            --enable-python3interp=yes \
            --with-python3-config-dir=$(python3-config --configdir) \
            --enable-cscope \
            --prefix=/usr/local
            # for python3 binding
make && sudo make install

# sudo ln -sf /usr/local/bin/vim /usr/bin/vi # if needed
