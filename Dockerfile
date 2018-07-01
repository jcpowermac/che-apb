FROM quay.io/jcallen/che-fedora-base

EXPOSE 8080 8000 9191
ENV REQUIRED_PKGS="bzip2 procps python3-pip dnf-plugins-core" \
    OPTIONAL_PKGS="ansible pv python-psycopg2 zsh tmux tmux-powerline vim vim-jedi vim-powerline vim-pysmell vim-syntastic vim-syntastic-python"

USER root

RUN dnf install -y ${REQUIRED_PKGS} ${OPTIONAL_PKGS} && \
    dnf clean all

RUN dnf -y copr enable @ansible-service-broker/ansible-service-broker-latest && \
    dnf -y install apb
# Optional - download and install oh-my-zsh
ADD https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh /home/user/

RUN chown user:users /home/user/install.sh && \
    chmod 755 /home/user/install.sh

USER user

RUN pip3 install --user ${PIP_PKGS} && \
    /home/user/install.sh >/dev/null 2>&1 && \
    ln -s /usr/share/vim/vimfiles/ /home/user/.vim
COPY .vimrc /home/user
COPY .tmux.conf /home/user
