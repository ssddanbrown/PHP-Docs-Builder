# PHP Docs Builder

The project provides a docker container which:

- Has the dependencies to build the PHP documentation.
- Builds source documentation into a php.net mirror.
- Runs a development server hosting the php.net mirror.
- Allows easy build/configure/render upon user command.

The process used by this container is based upon the process defined at http://doc.php.net/tutorial/local-setup.php.

## Command Line Demo

[![asciicast](https://asciinema.org/a/XNob6HPowsLWEgVsTyhkoSGVs.svg)](https://asciinema.org/a/XNob6HPowsLWEgVsTyhkoSGVs)

## Usage

This container can be ran as per the example below, where `<DOCS_REPO>` is the path on your 
host system that contains a `php/doc-<lang>` repository instance ([English Example](https://github.com/php/doc-en)).

```bash
docker run -itp 8080:8080 -v <DOCS_REPO>:/docs ghcr.io/ssddanbrown/php-docs-builder:latest
```

You'd then be able to access the documentation via http://localhost:8080/manual/en.

If a volume is not mounted, or if the mounted `<DOCS_REPO>` is empty, then the repository for the 
configured language will be pulled down from GitHub on startup.

#### Examples

Note, You'll need to change any `/home/me` paths in examples below.

**Getting started with the English docs**

```bash
git clone https://github.com/php/doc-en.git /home/me/doc-en
docker run -itp 8080:8080 -v /home/me/doc-en:/docs ghcr.io/ssddanbrown/php-docs-builder:latest
```

Then open http://localhost:8080/manual/en in your browser to view.

**Getting started with the Italian docs**

```bash
git clone https://github.com/php/doc-it.git /home/me/doc-it
docker run -itp 8080:8080 -v /home/me/doc-it:/docs -e LANG=it ghcr.io/ssddanbrown/php-docs-builder:latest
```

Then open http://localhost:8080/manual/it in your browser to view.

## Options

This container can take the following as ENV options:

- `PORT` - (Integer) - Port to run the development webserver on. Defaults to `8080`.
- `LANG` - (String)  - Lower case 2-character language code for the lang you want to work on. Defaults to `en`.

Note: When using a non-en language, the latest en repository files will be pulled from GitHub on start-up
to be used for building.

## Contributing

Feel free to raise any issues here on GitHub. Pull requests for fixes and patches are welcome.
If you're considering a PR to add a new feature or change please open an issue first for discussion to see if it's something that would be accepted.
I generally want to keep the scope of this container focused to keep maintenance feasible.