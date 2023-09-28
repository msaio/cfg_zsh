# --- >>> "ENV" <<< ---
export ZSH_CFG_PATH="/home/$USER/msaio_zsh"
export ZSHRC_PATH="/home/$USER/.zshrc"
export NVIM_CFG_PATH="/home/$USER/.config/nvim"
export NVIM_CFG_PATH_DEFAUT_START="./old_school/personal.vim"
export NOTE_PATH="/home/$USER/Desktop/sea.txt"
# export EDITOR=nvim
# export VISUAL=nvim

# --- >>> "HELPERS" <<< ---
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

# DEPRECATED: excute this instead > sudo ln -s /usr/bin/code-insiders /usr/bin/code
launch_code () {
	code-insiders $*
}

config_nvim () {
	current_dir=$(pwd) ; \
	cd $NVIM_CFG_PATH ; \
	nvim $NVIM_CFG_PATH_DEFAULT_START ; \
	nvim +source\ $NVIM_CFG_PATH/init.lua +PlugInstall +qall! ; \
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

m3u8_to_mp4 () {
	# input_m3u8_link: $1, output_path: $2
	ffmpeg -i "$1" -bsf:a aac_adtstoasc -vcodec copy -c copy -crf 50 $2
}

mp4_to_mp3 () {
	# input_mp4_path: $1, output_mp3_path: $2
	ffmpeg -i video.mp4 -f mp3 192000 -vn music.mp3
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

sync_file() {
	# https://help.resilio.com/hc/en-us/articles/206178924
	sudo service resilio-sync stop
	sudo systemctl disable resilio
	sudo systemctl enable resilio-sync
	sudo systemctl stop resilio-sync
	sudo systemctl start resilio-sync
	sudo systemctl status resilio-sync
}

add_rpm (){
	if [ -z "$1" ]
	then
		echo "Need input file, fucker!"
		return
	fi
	sudo chmod +x $1 && \
	sudo alien -i $1
}

add_deb (){
	if [ -z "$1" ]
	then
		echo "Need input file, bitch!"
		return
	fi
	sudo chmod +x $1 && \
	sudo dpkg -i $1
}

sys_info (){
	sudo inxi -Fx
}

extract_vpks() {
	for file in ./*.vpk; do vpk  -x ./ $file; done
}

msaio_ghu (){
	git add -A && echo "Update: $(date +'%R, %m/%d/%Y')" | git commit -F - && git push -u origin master
}

install_matching_bundler (){
	gem install bundler -v "$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1)"
}

kill_puma (){
	pkill -9 -f puma
}

clone_src(){
    local repo_path="$1"
    if [ $# -lt 1 ]; then
        echo "Enter the fucking repo path, plz"
				echo "*** Recommend using git link ***"
        return 1
    fi
		echo "Repo path: $1"
		# Check if using specific key
    if [ $# -ge 2 ]; then
        local key_path="$2"
        echo "Key path: $2"
    fi
		# Check if using specific dir name
    if [ $# -ge 3 ]; then
        local dir_path="$3"
        echo "Dir path: $3"
    fi
		# Excute	
		if [[ -v key_path ]] && [[ -v dir_path ]]; then
			echo "Runnin.."
			echo "git clone -c core.sshCommand=\"ssh -i $key_path\" $repo_path $dir_path"
			git clone -c core.sshCommand="ssh -i $key_path" $repo_path $dir_path
		elif [[ -v key_path ]]; then 
			echo "Runnin.."
			echo "git clone -c core.sshCommand=\"ssh -i $key_path\" $repo_path"
			git clone -c core.sshCommand="ssh -i $key_path" $repo_path
		else
			echo "Runnin.."
			echo "git clone $repo_path"
			git clone $repo_path
		fi
}

# https://github.com/tanrax/terminal-AdvancedNewFile
# > pip3 install --user advance-touch
new_file(){
	ad $1
}

flush_browsers(){
	for browser in "$@"
	do
		# Select all process with name
		pgrep -f -a "$browser" | \
		# Get all renders
		grep 'type=renderer' | \
		# Exclude extensions
		grep -v "extension" | \
		# Select only PID
		egrep -o '^[0-9]{0,}' | \
		# Finally, kill'em all!
		while read pid; do kill $pid; done 
		# One line
		# > pgrep -f -a "$browser" | grep 'type=renderer' | grep -v "extension" | egrep -o '^[0-9]{0,}' | while read pid; do kill $pid; done
	done
}

flush_chrome(){
	echo "Flushin... Chrome" && \
	flush_browsers "chrome" && \
	echo "Done!"
}

# --- >>> "TMP" <<< ---
fix_dump_sugar (){
	 sed -i '/@@GLOBAL.GTID_PURGED=/d' $1
	 sed -i 's/utf8mb4_0900_ai_ci/utf8mb4_general_ci/g' $1
	 sed -i 's/utf8mb3/utf8/g' $1 
	 sed -i 's/utf8mb4/utf8/g' $1
}

# --- >>> "ALIAS" <<< ---
alias edt=resume_or_new_nvim
alias e=edt
alias vim=nvim
alias vi=nvim
alias v=vi
alias t="tmux attach-session -t $(tmux ls | awk 'NR==1{print substr($1, 1, length($1)-1)}')"
# DEPRECATED
# alias code="launch_code"
alias cfg_nvim=config_nvim
alias cfg_zsh=config_zsh
alias src_zsh="sourcin $ZSHRC_PATH"
alias sz=src_zsh
alias n='nvim $NOTE_PATH'
alias rails3000="bundle install && rake db:migrate && rake assets:clobber && rake assets:precompile && rails s -p 3000"
alias q=exit
alias nf=new_file
alias touchf=nf

