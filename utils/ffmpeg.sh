# Function to send a notification using the Terminal Notifier
function ncWatch() {
  local local_ip=$(localIp)
	echo "nc watch on ${local_ip}:"
	nc -l 2080 | while read message; do
		echo "$message" | pbcopy
		echo "$message"
		echo "Copied!"
	done
}

function echoNc() {
	local ip="$1"
	local message="$2"
	echo "$message" | nc "$ip" 2080
	echo "Sent!"
}

# get gzipped size
function gz {
	echo "orig size    (bytes): "
	cat "$1" | wc -c
	echo "gzipped size (bytes): "
	gzip -c "$1" | wc -c
}

# whois a domain or a URL
function whois {
	local domain=$(echo "$1" | awk -F/ '{print $3}') # get domain from URL
	if [ -z $domain ] ; then
		domain=$1
	fi
	echo "Getting whois record for: $domain …"

	# avoid recursion
					# this is the best whois server
													# strip extra fluff
	/usr/bin/whois -h whois.internic.net $domain | sed '/NOTICE:/q'
}

# Extract archives - use: extract <file>
# Based on http://dotfiles.org/~pseup/.bashrc
function extract {
	if [ -f "$1" ] ; then
		local filename=$(basename "$1")
		local foldername="${filename%%.*}"
		local fullpath=`perl -e 'use Cwd "abs_path";print abs_path(shift)' "$1"`
		local didfolderexist=false
		if [ -d "$foldername" ]; then
			didfolderexist=true
			read -p "$foldername already exists, do you want to overwrite it? (y/n) " -n 1
			echo
			if [[ $REPLY =~ ^[Nn]$ ]]; then
				return
			fi
		fi
		mkdir -p "$foldername" && cd "$foldername"
		case $1 in
			*.tar.bz2) tar xjf "$fullpath" ;;
			*.tar.gz) tar xzf "$fullpath" ;;
			*.tar.xz) tar Jxvf "$fullpath" ;;
			*.tar.Z) tar xzf "$fullpath" ;;
			*.tar) tar xf "$fullpath" ;;
			*.taz) tar xzf "$fullpath" ;;
			*.tb2) tar xjf "$fullpath" ;;
			*.tbz) tar xjf "$fullpath" ;;
			*.tbz2) tar xjf "$fullpath" ;;
			*.tgz) tar xzf "$fullpath" ;;
			*.txz) tar Jxvf "$fullpath" ;;
			*.zip) unzip "$fullpath" ;;
			*) echo "'$1' cannot be extracted via extract()" && cd .. && ! $didfolderexist && rm -r "$foldername" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

# animated gifs from any video
# from alex sexton   gist.github.com/SlexAxton/4989674
function gifify {
  if [[ -n "$1" ]]; then
	if [[ $2 == '--good' ]]; then
	  ffmpeg -i $1 -r 10 -vcodec png out-static-%05d.png
	  time convert -verbose +dither -layers Optimize -resize 900x900\> out-static*.png  GIF:- | gifsicle --colors 128 --delay=5 --loop --optimize=3 --multifile - > $1.gif
	  rm out-static*.png
	else
	  ffmpeg -i $1 -s 600x400 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > $1.gif
	fi
  else
	echo "proper usage: gifify <input_movie.mov>. You DO need to include extension."
  fi
}

# turn that video into webm.
# brew reinstall ffmpeg --with-libvpx
function webmify {
	ffmpeg -i $1 -vcodec libvpx -acodec libvorbis -isync -copyts -aq 80 -threads 3 -qmax 30 -y $2 $1.webm
}

# ffmpeg

function ffm {
  ffmpeg "${@:1:$#-1}" -map_metadata 0 -movflags +faststart -benchmark "${!#}"
}

function convert2m4a {
  input="$1"; shift;

  echo "Convert (-c:a aac -b:a 64k -ar 22050)"
  ffm -i "$input" -vn -c:a aac -b:a 64k -ar 22050 "$@" "${input}-low-quality.m4a"

  echo "Convert (-c:a aac -b:a 128k -ar 44100)"
  ffm -i "$input" -vn -c:a aac -b:a 128k -ar 44100 "$@" "${input}-medium-quality.m4a"

  echo "Convert (-c:a aac -b:a 192k -ar 48000)"
  ffm -i "$input" -vn -c:a aac -b:a 192k -ar 48000 "$@" "${input}-high-quality.m4a"
}

function convert2mp4 {
	input="$1"; shift;
  ffm -i "$input" -c:v libx264 -c:a aac -q:a 0.5 $@ "${input}.mp4"
}
