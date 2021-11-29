Warning: In progress development, Do not use this.


# PHP Docs Build Container

Based upon process defined at http://doc.php.net/tutorial/local-setup.php.

This container will run a mirror of the php.net site to present a custom copy of the docs within.

To use this, mount a PHP docs repository as a volume to the `/docs` path 
of the container.



### Dev Command

```bash
docker run -itp 8080:8080 -v /home/dan/web/php-docs-builder/docs:/docs <container>
```

### TODO

- [x] Define and pass through a custom volume mount for editing docs files.
  - [x] If empty, clone down the PHP doc files.
- [ ] ~Rebuild docs on file change.~ Too many issues, Added menu instead.
- [ ] Make menu and output friendlier.
- [ ] Make PHP server port configurable.
- [ ] Make docs language configurable.
- [ ] Cleanup these docs.

