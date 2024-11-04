#!/usr/bin/env bash
#  ╦╔═╔═╗╦═╗╦  ╔═╗  ╦═╗╦╔═╗╔═╗
#  ╠╩╗╠═╣╠╦╝║  ╠═╣  ╠╦╝║║  ║╣
#  ╩ ╩╩ ╩╩╚═╩═╝╩ ╩  ╩╚═╩╚═╝╚═╝
## This file will configure the options
## and launch the bars corresponding to each theme.

# Set bspwm configuration for nord
set_bspwm_config() {
		bspc config border_width 3
		bspc config top_padding 48
		bspc config bottom_padding 2
		bspc config normal_border_color "#d8dee9"
		bspc config active_border_color "#5e81ac"
		bspc config focused_border_color "#81a1c1"
		bspc config presel_feedback_color "#ff79c6"
		bspc config left_padding 2
		bspc config right_padding 2
		bspc config window_gap 6
}

# Reload terminal colors
set_term_config() {
		sed -i "$HOME"/.config/alacritty/fonts.yml \
		-e "s/family: .*/family: JetBrainsMono Nerd Font/g" \
		-e "s/size: .*/size: 10/g"
		
		cat > "$HOME"/.config/alacritty/colors.yml <<- _EOF_
				# Colors (Zombie-Night color scheme) nord Rice
				colors:
				  primary:
				    background: '#2e3440'
				    foreground: '#d8dee9'

				  normal:
				    black:   '#3b4252'
				    red:     '#bf616a'
				    green:   '#a3be8c'
				    yellow:  '#ebcb8b'
				    blue:    '#81a1c1'
				    magenta: '#b48ead'
				    cyan:    '#88c0d0'
				    white:   '#e5e9f0'

				  bright:
				    black:   '#4c566a'
				    red:     '#bf616a'
				    green:   '#a3be8c'
				    yellow:  '#ebcb8b'
				    blue:    '#81a1c1'
				    magenta: '#b48ead'
				    cyan:    '#8fbcbb'
				    white:   '#eceff4'
    
				  cursor:
				     cursor: '#d8dee9'
				     text:	'#2e3440'
_EOF_
}

# Set compositor configuration
set_picom_config() {
		sed -i "$HOME"/.config/bspwm/picom.conf \
			-e "s/normal = .*/normal =  { fade = false; shadow = false; }/g" \
			-e "s/shadow-color = .*/shadow-color = \"#000000\"/g" \
			-e "s/corner-radius = .*/corner-radius = 0/g" \
			-e "s/\".*:class_g = 'Alacritty'\"/\"95:class_g = 'Alacritty'\"/g" \
			-e "s/\".*:class_g = 'FloaTerm'\"/\"95:class_g = 'FloaTerm'\"/g"
}

# Set dunst notification daemon config
set_dunst_config() {
		sed -i "$HOME"/.config/bspwm/dunstrc \
		-e "s/transparency = .*/transparency = 8/g" \
		-e "s/frame_color = .*/frame_color = \"#0E1113\"/g" \
		-e "s/separator_color = .*/separator_color = \"#353c52\"/g" \
		-e "s/font = .*/font = JetBrainsMono Nerd Font Medium 9/g" \
		-e "s/foreground='.*'/foreground='#7a44e3'/g"
		
		sed -i '/urgency_low/Q' "$HOME"/.config/bspwm/dunstrc
		cat >> "$HOME"/.config/bspwm/dunstrc <<- _EOF_
				[urgency_low]
				timeout = 3
				background = "#434c5e"
				foreground = "#d8dee9"

				[urgency_normal]
				timeout = 6
				background = "#bf616a"
				foreground = "#d8dee9"

				[urgency_critical]
				timeout = 0
				background = "#bf616a"
				foreground = "#d8dee9"
_EOF_
}

# Launch the bar
launch_bars() {
    active_interface=$(ip route get 8.8.8.8 | awk '/dev/ { print $5; exit }')
    sed -i "s/\(interface\s*=\s*\).*/\1$active_interface/" ${rice_dir}/modules.ini
		polybar -q nord-bar -c ${rice_dir}/config.ini &
		polybar -q nord-bar2 -c ${rice_dir}/config.ini &
		polybar -q nord-bar3 -c ${rice_dir}/config.ini &
}


# change rofi theme to catppuccinred
rofi_catppuccinblue(){
    $HOME/.config/rofi/Themes/colors catppuccinblue
}


network_config(){
  interface_type=$(ip route get 8.8.8.8 2>/dev/null | awk '/dev/ { print $5; exit }')

  function using_interface(){
  if [[ $interface_type = w* ]]; then
      echo "wireless"
  else
      echo "wired"
  fi
  }
using_interface
sed -i "s/\(interface-type\s*=\s*\).*/\1`using_interface`/" ${rice_dir}/modules.ini
}


### ---------- Apply Configurations ---------- ###

set_bspwm_config
set_term_config
set_picom_config
set_dunst_config
launch_bars
rofi_catppuccinblue
network_config
