Course Cart [![Build Status](https://travis-ci.org/biola/course-cart.svg)](https://travis-ci.org/biola/course-cart)
===========

Online signups and payment for online courses

Requirements
------------

- Ruby
- MongoDB
- Rack compatible web server
- CAS Server
- TouchNet site _(for payments)_
- Banner Oracle Database _(only for some validators)_

Installation
------------

```bash
git clone git@github.com:biola/course-cart.git
cd course-cart
bundle install
cp config/blazing.rb.example config/blazing.rb
cp config/mongoid.yml.example config/mongoid.yml
cp config/settings.local.yml.example config/settings.local.yml
cp config/newrelic.yml.example config/newrelic.yml
```

Configuration
-------------

Edit `config/blazing.rb`, `config/mongoid.yml`, `config/settings.local.yml` and `config/newrelic.yml` accordingly.

TouchNet uPay Store Configuration
---------------------------------

TODO: passed_amount_validation_key, posting_key, posting_url


Testing
-------

Simply run `rspec` to run the automated test suite.

To test a credit card transaction against the staging TouchNet servers, simply use the following credit card details.

__Credit Card Type:__ Visa
__Account Number:__ 4111111111111111
__Security Code:__ 123


Related Documentation
---------------------

- [blazing](https://github.com/effkay/blazing)
- [turnout](https://github.com/biola/turnout)
- [pinglish](https://github.com/jbarnette/pinglish)

Deployment
----------
```bash
blazing setup [target name in blazing.rb]
git push [target name in blazing.rb]
```

_Note: `blazing setup` only has to be run on your first deploy._

License
-------
[MIT](https://github.com/biola/course-cart/blob/master/MIT-LICENSE)
