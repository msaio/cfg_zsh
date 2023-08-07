export ZSH_CFG_PATH="/home/$USER/msaio_zsh"
export ZSHRC_PATH="/home/$USER/.zshrc"
export NVIM_CFG_PATH="/home/$USER/.config/nvim"
export NOTE_PATH="/home/$USER/Desktop/sea.txt"
# export EDITOR=nvim
# export VISUAL=nvim

check_if_exist () {
	if [[ -f $1 ]]
	then
		echo 1
	else
		echo 0
	fi
}

resume_or_new_nvim () {
	if [[ $(check_if_exist Session.vim) -eq 1 ]]
	then
		nvim -S
	else
		nvim $*
	fi
}

sourcin () {
	echo  "Sourcin... $1" ; \
	source $1 && \
	echo "Done!"
}

launch_code () {
	code-insiders $*
}

config_nvim () {
	current_dir=$(pwd) ; \
	cd $NVIM_CFG_PATH ; \
	nvim . ; \
	nvim +source\ $NVIM_CFG_PATH/init.vim +PlugInstall +qall! ; \
	echo "Nvim updated!" ;
	echo "return to $current_dir" ; \
	cd $current_dir
}

config_zsh () {
	current_dir=$(pwd) ; \
	cd $ZSH_CFG_PATH ; \
	echo "$ZSH_CFG_PATH"
	
	resume_or_new_nvim ./personal.sh ; \

	sourcin $ZSHRC_PATH ; \
	echo "return to $current_dir" ; \
	cd $current_dir
}

re_attach_or_generate () {
	
}

alias edt=resume_or_new_nvim
alias e=edt

alias vim=nvim
alias vi=nvim
alias v=vi

alias t="tmux attach-session -t $(tmux ls | awk 'NR==1{print substr($1, 1, length($1)-1)}')"
alias code="launch_code"

alias cfg_nvim=config_nvim

alias cfg_zsh=config_zsh

alias src_zsh="sourcin $ZSHRC_PATH"
alias sz=src_zsh

alias n='nvim $NOTE_PATH'

alias rails3000="bundle install && rake db:migrate && rake assets:clobber && rake assets:precompile && rails s -p 3000"

alias q=exit

restart () {
	for var in "$@"
	do
		sudo service "$var" restart && echo "$var restarted"
	done
}

mp3_to_mp4 () {
	for var in "$@"
	do
		# ffmpeg -f lavfi -i color=c=black:s=1280x720:r=5 -i "$var.mp3" -crf 0 -c:a copy -shortest "$var.mp4"
		ffmpeg -f lavfi -i color=c=black:s=1280x720:r=5 -i $var -crf 0 -c:a copy -shortest "$var.mp4"
	done
}

meson_init () {
	mkdir TMP_dir ; \
	meson setup TMP_dir && \
	meson compile -C TMP_dir && \
	meson install -C TMP_dir && \
	rm -rf TMP_dir
}

rails_flush () {
	rails db:drop:_unsafe && rails db:create && rails db:migrate && rails db:seed
}

sync_file_restart() {
		service resilio-sync restart && \
		echo "Current user sync file service restarted"
}
sync_file_start() {
		service resilio-sync start && \
		echo "Current user sync file service started"
}
sync_file_stop() {
		service resilio-sync stop && \
		echo "Current user sync file service stop"
}

sync_file() {
	# https://help.resilio.com/hc/en-us/articles/206178924
	root="root"
	if [[ $1 == $root ]]
	then
		echo "Hello"
		service resilio-sync stop && \
		sudo service resilio-sync restart && \
		echo "Root 's sync file service restarted"
	else
		sudo service resilio-sync stop && \
		service resilio-sync restart && \
		echo "Current user sync file service restared"
	fi
}

install_rpm (){
	if [ -z "$1" ]
	then
		echo "Need input file, fucker!"
		return
	fi
	sudo alien $1 && \
	sudo dpkg -i $1
}

sys_info (){
	sudo inxi -Fx
}

extract_vpks() {
	for file in ./*.vpk; do vpk  -x ./ $file; done
}

###

fix_dump_sugar (){
	 sed -i '/@@GLOBAL.GTID_PURGED=/d' $1
	 sed -i 's/utf8mb4_0900_ai_ci/utf8mb4_general_ci/g' $1
	 sed -i 's/utf8mb3/utf8/g' $1 
	 sed -i 's/utf8mb4/utf8/g' $1
}


