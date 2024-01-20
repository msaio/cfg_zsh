# --- >>> "ENV" <<< ---
export ZSH_CFG_PATH="$HOME/cfg_zsh"
export ZSHRC_PATH="$HOME/.zshrc"
export BASHRC_PATH="$HOME/.bashrc"
export NVIM_CFG_PATH="$HOME/cfg_nvim"
export NVIM_CFG_PATH_DEFAULT_START="$NVIM_CFG_PATH/old_school/personal.vim"
export NOTE_PATH="$HOME/Desktop/sea.txt"
alias nvim="/usr/bin/nvim"
export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"
export TIL_PATH="$HOME/til/"

# --- >>> "HELPERS" <<< ---
check_if_cli_cmd_exists() {
  type "$1" &> /dev/null
}

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

config_nvim () {
	current_dir=$(pwd) ; \
	cd $NVIM_CFG_PATH ; \
  resume_or_new_nvim $NVIM_CFG_PATH_DEFAULT_START ; \
	nvim +source\ $NVIM_CFG_PATH/init.lua +PlugInstall +qall! ; \
	echo "Nvim updated!" ;
	echo "return to $current_dir" ; \
	cd $current_dir
}

config_zsh () {
	current_dir=$(pwd) ; \
	cd $ZSH_CFG_PATH ; \
	echo "$ZSH_CFG_PATH"
	resume_or_new_nvim ./personal.sh
  current_shell=$(ps -p $$ -o 'comm=')
  if [[ $current_shell = "zsh" ]]
  then
    sourcin $ZSHRC_PATH
  else
    sourcin $BASHRC_PATH
  fi
	echo "return to $current_dir" ; \
	cd $current_dir
}

config_tmux () {
	current_dir=$(pwd) ; \
	cd $ZSH_CFG_PATH ; \
	echo "$ZSH_CFG_PATH"
	resume_or_new_nvim ./msaio_tmux.conf.local ; \
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

sync_file() {
	# https://help.resilio.com/hc/en-us/articles/206178924
	# Install
	# sudo apt-get update
	# sudo apt-get install resilio-sync
	# sudo usermod -aG $USER rslsync
	# sudo usermod -aG rslsync $USER
	# sudo chmod g+rw /home/$USER
	# systemctl --user enable resilio-sync
	systemctl --user restart resilio-sync
}

add_rpm (){
	if [ -z "$1" ]
	then
		echo "Need input file, fucker!"
		return 1
	fi
	sudo chmod +x $1 && \
	sudo alien -i $1
}

add_deb (){
	if [ -z "$1" ]
	then
		echo "Need input file, bitch!"
		return 1
	fi
	sudo chmod +x $1 && \
	sudo dpkg -i $1
}

add_debs (){
	if [ -z "$@" ]
	then
		echo "Need input files, biatch!"
		return 1
	fi
	for package in "$@"
	do
		add_deb $package
	done
}

sys_info (){
	sudo inxi -Fx
}

extract_vpks() {
	for file in ./*.vpk; do
		vpk  -x ./ $file;
	done
}

msaio_ghu (){
	git add -A && echo "Update: $(date -u +'%R, %m/%d/%Y')" | \
	git commit -F - && \
  git push -u origin master
}

msaio_ghu_nvim (){
	current_dir=$(pwd) ; \
	cd $NVIM_CFG_PATH ; \
	msaio_ghu ; \
	cd $current_dir
}

msaio_ghu_zsh (){
	current_dir=$(pwd) ; \
	cd $ZSH_CFG_PATH ; \
	msaio_ghu ; \
	cd $current_dir
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

new_file(){
	# https://github.com/tanrax/terminal-AdvancedNewFile
	# > pip3 install --user advance-touch
  # allow to create files via path (auto create dir)
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

flush_thorium(){
	echo "Flushin... Thorium" && \
	flush_browsers "thorium" && \
	echo "Done!"
}

ultimate_fix_ssh(){
  YOURUSER=$(whoami)
  sudo chown $YOURUSER:$YOURUSER /home/$YOURUSER/{.,.ssh/,.ssh/authorized_keys}
  sudo chmod u+rwX,go-rwX,-t /home/$YOURUSER/{.ssh/,.ssh/authorized_keys}
  sudo chmod go-w /home/$YOURUSER/
}

fix_freezing_panel(){
  # https://bbs.archlinux.org/viewtopic.php?id=287858
  killall plasmashell; nohup plasmashell &
}

back_up_kde_settings(){
  if check_if_cli_cmd_exists "konsave"; then
  else
    echo "Not found 'konsave' command" 
    echo "Plz install konsave:"
    echo "https://github.com/Prayag2/konsave"
    return 1
  fi
  bkd="$ZSH_CFG_PATH/kde_settings"
  profile="$(date -u +'utc_%H_%M_%S__%m_%d_%Y')"
  konsave -s "$profile" && konsave -e "$profile" -d "$bkd" -f
  tar -c $bkd | xz -c -9 -T0 > $ZSH_CFG_PATH/kde_settings.tar.xz
  rm -rf $bkd
}

# --- >>> "TMP" <<< ---
fix_dump_sugar (){
	 sed -i '/@@GLOBAL.GTID_PURGED=/d' $1
	 sed -i 's/utf8mb4_0900_ai_ci/utf8mb4_general_ci/g' $1
	 sed -i 's/utf8mb3/utf8/g' $1 
	 sed -i 's/utf8mb4/utf8/g' $1
}

# --- >>> "ALIAS" <<< ---
alias edt="resume_or_new_nvim"
alias e="edt"
alias pe="nvim -u NONE"
alias lz="~/.asdf/shims/nvim"
alias plz="lz -u NONE"
alias cfg_nvim="config_nvim"
alias cn="cfg_nvim"

alias n='nvim $NOTE_PATH'

alias cfg_zsh="config_zsh"
alias cz="cfg_zsh"
alias src_zsh="sourcin $ZSHRC_PATH"
alias sz="src_zsh"

alias t="tmux attach-session -t $(tmux ls | awk 'NR==1{print substr($1, 1, length($1)-1)}')"
alias cfg_tmux="config_tmux"
alias ct=cfg_tmux
# still need to reload with: <prefix>+r
alias tbtx="tmux show-buffer | xclip -selection clipboard"

alias advanced_history="fc -li 100"
alias ah="advanced_history"

alias q=exit

alias nf=new_file
alias touchf=nf

alias sb="source ~/.bashrc"

alias ffzp="fix_freezing_panel"

alias bk_kde="back_up_kde_settings"

# SUPER_QUICK
alias rails3000="bundle install && rake db:migrate && rake assets:clobber && rake assets:precompile && rails s -p 3000"
alias sp_s="bundle exec sidekiq -C config/sidekiq.yml"
alias sp_s_log="tail -f log/sidekiq.log -n "
alias sp_c_rs="clear && rails s -p 4000"
alias sp_rs="rails s -p 4000"

rails_flush () {
	rails db:drop:_unsafe && rails db:create && rails db:migrate && rails db:seed
}

