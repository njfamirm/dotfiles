OPEN_AT_START=(
  project/book/Linux-diary
)

for d in $OPEN_AT_START; do
  tmux new-window -d -c "$HOME/$d"
done
