export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1 
export PATH="$PATH:$HOME/zls/zig-out/bin"
export PATH="$PATH:$HOME/zig-source/zig/build/stage3/bin"
[ -f /opt/miniconda3/etc/fish/conf.d/conda.fish ] && source /opt/miniconda3/etc/fish/conf.d/conda.fish
 
if status is-interactive
    # Commands to run in interactive sessions can go here
end
