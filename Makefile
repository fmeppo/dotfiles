CONF_FILES=.aliasrc .bashrc
OLD_FILES=${HOME}/.dotfiles_old

all: update install

update:
	git pull

install: $(CONF_FILES) $(OLD_FILES)
	@cd ${HOME} && for file in $(CONF_FILES); do \
            if [ ! -L $$file ]; then \
                echo linking $$file ; \
                mv $$file $(OLD_FILES) ; \
                ln -s dotfiles/$$file $$file ; \
            fi ; \
        done

$(OLD_FILES):
	mkdir $(OLD_FILES)
