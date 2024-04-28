# Pulse - Weather and news app for the Ubuntu Desktop

WIP - Soon available as snap.

![screenshot_dark_linux](.github/images/screenshot_dark_linux.png)

- [X] Dynamic, animated weather backgrounds
- [X] Display weather of current location
- [X] Display weather of a location X
- [X] Save your favorite locations
- [X] Filter per day/week
- [ ] Show news in your location
- [ ] Show news of location X
- [ ] Filter news by topic/location

## Build

### Install Flutter

<details>
<summary>Ubuntu</summary>

Copy & paste this into your terminal, press enter, then enter your password and wait:

```
sudo apt -y install git curl cmake meson make clang libgtk-3-dev pkg-config && mkdir -p ~/development && cd ~/development && git clone https://github.com/flutter/flutter.git -b stable && echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bashrc && source ~/.bashrc
```

</details>

### Api Key

Requires an api key from [openweathermap](https://openweathermap.org) which you need to create yourself (free tier) in your own account.