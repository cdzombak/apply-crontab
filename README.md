# apply-crontab

Better crontab management.

`apply-crontab` allows you to keep your crontab configuration in a version-controlled set of files (in `~/crontab.d` by default).

## Usage

```text
apply-crontab [OPTIONS]
```

With no options given, `apply-crontab` generates a crontab from the `*.cron` files in your `$CRONTAB_DIR` and applies them using the `crontab` command.

### Options

- `-i`: Init: create the `crontab.d` directory, populate it with the output of `crontab -l`, and initialize a Git repo in it.
- `-p`: Preview: do not write to `crontab`; instead, preview the output in your `PAGER` (default: `less`).
- `-h`: Print help to stderr and exit.
- `-v`: Print version to stdout and exit.

### Environment Variables

- `CRONTAB_DIR`: Sets your crontab source directory. Defaults to `$HOME/crontab.d`.

## Installation

### Debian via PackageCloud

Install my PackageCloud Debian repository if you haven't already:
```shell
curl -s https://packagecloud.io/install/repositories/cdzombak/oss/script.deb.sh?any=true | sudo bash
```

Then install `apply-crontab` via `apt-get`:
```shell
sudo apt-get install apply-crontab
```

### Manual installation from build artifacts

Pre-built binaries for are downloadable from each [GitHub Release](https://github.com/cdzombak/apply-crontab/releases). Debian packages for each release are available as well.

### Build and install locally

```shell
git clone https://github.com/cdzombak/apply-crontab.git
cd apply-crontab
make build

cp out/apply-crontab-[VERSION]-all $INSTALL_DIR/apply-crontab
```

## About

- Issues: https://github.com/cdzombak/apply-crontab/issues/new
- Author: [Chris Dzombak](https://www.dzombak.com)
    - [GitHub: @cdzombak](https://www.github.com/cdzombak)

## License

LGPLv3; see `LICENSE` in this repository.
