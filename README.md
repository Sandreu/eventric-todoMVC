eventric-todoMVC
================


### Install

```
npm install
bower install
```

### Run only in Browser

```
gulp
```

Now point your browser to `http://localhost:2342`


### Run on Browser and Node

Make sure `mongodb` is up and running.

First

```
gulp
```

Then change in src/eventric/todomvc_client.coffee to the `eventric-remote-store-client` and start the process

```
coffee src/eventric/todomvc
```

Now point your browser to `http://localhost:2342`
