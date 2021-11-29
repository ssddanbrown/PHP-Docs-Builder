# PHP Docs Build Container

The project provides a container which:

- Has the dependencies to build the PHP documentation.
- Builds source documentation into a php.net mirror.
- Runs a development server hosting the php.net mirror.
- Allows easy build/configure/render upon user command.

The process used by this container is based upon the process defined at http://doc.php.net/tutorial/local-setup.php.

### Usage

This container can be ran as per the example below, where `<DOCS_REPO>` is the path on your 
host system that contains a `php/doc-<lang>` repository instance.

```bash
docker run -itp 8080:8080 -v <DOCS_REPO>:/docs ghcr.io/ssddanbrown/php-docs-builder:latest
```

If a volume is not mounted, or if the mounted `<DOCS_REPO>` is empty, then the repository for the 
configured language will be pulled down from GitHub on startup.

### Options

This container can take the following as ENV options:

- `PORT` - (Integer) - Port to run the development webserver on. Defaults to `8080`.
- `LANG` - (String)  - Lower case 2-character language code for the lang you want to work on. Defaults to `en`.

Note: When using a non-en language, the latest en repository files will be pulled from GitHub on start-up
to be used for building.

### Contributing

Feel free to raise any issues here on GitHub. Pull requests for fixes and patches are welcome.
If you're considering a PR to add a new feature or change please open an issue first for discussion to see if it's something that would be accepted.
I generally want to keep the scope of this container focused to keep maintenance feasible.