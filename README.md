### Pulse - Weather app for the Linux Desktop

[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/pulse)

![screenshot_dark_linux](.github/images/screenshot_dark_linux.png)

### Api Key

Requires an api key from [openweathermap](https://openweathermap.org) which you need to create yourself (free tier) in your own account.


## Build

### Install libsecret

`sudo apt install libsecret-1-dev`

### Install Flutter

<details>
<summary>Ubuntu</summary>

Copy & paste this into your terminal, press enter, then enter your password and wait:

```
sudo apt -y install git curl cmake meson make clang libgtk-3-dev pkg-config && mkdir -p ~/development && cd ~/development && git clone https://github.com/flutter/flutter.git -b stable && echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bashrc && source ~/.bashrc
```

</details>

### Run the app

For the first run or after every `flutter clean`, the app needs to be started with your API_KEY:

`flutter run --dart-define=API_KEY=YOUR_API_KEY_HERE_WITHOUT_QUOTES`

any other times you can use

`flutter run`
