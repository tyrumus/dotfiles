# vim: ft=zsh
function setup_pipewire_pulse(){
    sp "Enabling PipeWire PulseAudio support"
    waitkey
    systemctl --user enable pipewire-pulse.service
}
