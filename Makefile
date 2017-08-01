CONF_FILES=.aliasrc .bashrc .bash_logout .bash_profile .cvsrc .exrc .netrc .sig .tmux.conf .vim .vimrc .Xresources
OBSOLETE_FILES=.lesspipe.sh
OLD_FILES=${HOME}/.dotfiles_old

.PHONY: all update install

all: update install

update:
	git pull

install: .submodules $(CONF_FILES) $(OLD_FILES)
	@cd ${HOME} && for file in $(OBSOLETE_FILES); do \
            if [ -f $$file ]; then \
                echo removing $$file ; \
                mv $$file $(OLD_FILES) ; \
            fi ; \
        done
	@cd ${HOME} && for file in $(CONF_FILES); do \
            if [ ! -L $$file ]; then \
                echo linking $$file ; \
                if [ -f $$file -o -d $$file ]; then \
                    mv $$file $(OLD_FILES) ; \
                fi; \
                ln -s dotfiles/$$file $$file ; \
            fi ; \
        done

$(OLD_FILES):
	mkdir $(OLD_FILES)

.submodules: .gitmodules
	git submodule init
	git submodule update
	touch .submodules
