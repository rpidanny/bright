# bright

Sync brightness across all displays on Linux.

## Getting Started

### Prerequisites

__Disclaimer:__ _bright isn't garunteed to work on all Linux Distos, Feel free to submit bug reports._

* Linux operating system
* `curl` or `wget` should be installed
* `git` should be installed
* `build-essentials` should be installed

### Installation

bright is installed by running one of the following commands in your terminal. You can install this via the command-line with either `curl` or `wget`.

#### via curl

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/rpidanny/bright/master/install.sh)"
```

#### via wget

```shell
sh -c "$(wget https://raw.githubusercontent.com/rpidanny/bright/master/install.sh -O -)"
```

## Running Bright

### start

```shell
sudo systemctl start bright
```

### stop
```shell
sudo systemctl stop bright
```

### restart
```shell
sudo systemctl restart bright
```

### status
```shell
sudo systemctl status bright
```

### enable auto start
```shell
sudo systemctl enable bright
```

### disable auto start
```shell
sudo systemctl disable bright
```

## Wishlist

* [x] Support Apple Displays with HID Controls
* [ ] Support Generic DDC/CI Compatible Displays
  * [ ] Update Display Brightness
  * [ ] Filter out HID Displays as it supports DDC/CI aswell
* [x] Register as system service
* [ ] Dynamic Brightness Scale (Different manufactures have different brightness scales)

## License

This project is licensed under the MIT License - see the [license file](LICENSE) file for details