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

Then change in src/eventric/index.client.coffee `remoteStore` to `true` and start the process

```
coffee src/eventric
```

Now point your browser to `http://localhost:2342`
