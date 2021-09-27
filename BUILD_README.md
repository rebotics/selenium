## Why do we use this?
Selenium 3 is incompatible with Python 3.9:\
https://github.com/SeleniumHQ/selenium/issues/8762

Author recommend Selenium 4.0.0a5 as a "drop in" replacement,
But it has missing config files, so gives the error:\
`FileNotFoundError: [Errno 2] No such file or directory: '/usr/local/lib/python3.9/dist-packages/selenium/webdriver/firefox/webdriver_prefs.json'`

Mentioned here:\
https://github.com/SeleniumHQ/selenium/issues/8469

Fix goes to Selenium 4.0.0a7, which gives another error:\
`ModuleNotFoundError: No module named 'selenium.webdriver.phantomjs'`

Due to `phantom.js` missing. Probably, it was removed in Selenium 4.0.0.

## Prerequisites
**Note:** You don't need to follow the steps described in selenium documentation!
They are for building drivers themselves, not selenium bindings!

Official python guide for building packages:\
https://packaging.python.org/guides/distributing-packages-using-setuptools/

## Example steps
```shell
cd py
python3 -m pip install build
python3 -m build --wheel
```

Here we're:
* going to the python sources dir.
* installing `build` package which is required to build other packages.
* building package distribution wheel into `py/dist` folder.

Then install it using `pip install`.

## Versioning

To avoid version conflicts with original selenium change versions in `py/setup.py`.

## Missing files

Selenium-Python uses some JS and webdriver files which are not present in the `py` folder.
They are put in place during the build by a pipeline, which we don't have.
Instead, we copy them from installed Selenium versions.

List of files:
* `selenium/webdriver/remote/getAttribute.js`
* `selenium/webdriver/remote/isDisplayed.js`
* `selenium/webdriver/firefox/webdriver_prefs.json`

Current version:\
`3.141.0`.

If you ever need to update these files, use the same strategy.

Note:\
https://github.com/SeleniumHQ/selenium/issues/9175
