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

Creating an Offering and Products
---------------------------------
There is no web interface for creating offerings and products/courses. In order to setup a new offering you'll have to work with the Rails console. Here is an example of creating a new offering with associated products.

```ruby
offering = Offering.create! name: 'Greendale Online', layout: 'application', default: true
Product.create offering: offering, name: 'Can I fry that?', description: "Learn what you can and can't fry", price: 42, available: 50
```

__Notes:__
- The example above won't work because the TouchNet attributes are required. See the TouchNet uPay Store Configuration section below for details on setting those attributes
- The `period` can be left `nil` if there is no registration window.
- When an offering is set to `default = true` it means it's the one that will show up at the root URL.

Creating Questions
------------------

If you'd like customers to answer certain questions during the registration process, simply add questions to an offering like so:

```ruby
Offering.first.questions.create! name: 'Who is the worst?', type: :select, options: ['Brita', 'Chang'], required: true
```

Available types are `text_field`, `text_area`, `check_box` and `select`.

Validations
-----------
Validators are available to either prevent the customer from ordering or to warn them about their order. Three validator types are available:
- __preflight_checks__ Stops the customer as soon as they login. Good for checking if the customer is eligible.
- __order_validators__ Prevents the customer from paying for an order. Good for ensuring the product combination is acceptable.
- __order_warners__ Warn the customer but do not prevent them from ordering. Good for warning them about a potential issue.

Validators can be added to an offering like so:

```ruby
Order.first.update order_validators: {'ProductLimitValidator' => {limit: 2}}
```

If you don't need to provide options, simply pass in an empty hash like so:

```ruby
Order.first.update order_validators: {'ProductLimitValidator' => {}}
```

*__Note:__ validators can be found in `/lib/validators` and `/lib/warners`.*

TouchNet uPay Store Configuration
---------------------------------
A TouchNet uPay store will need to be configured in order for payments to be processed.

Once the uPay store is created the Offering will need to be updated with the appropriate `upay_store_id` and `context`.

*__Note:__ The `context` can be found in the TouchNet uPay store URL. For example this URL (`https://test.secure.touchnet.net:8443/C12345_test_upay/web/index.jsp`) has a context of `C12345_test_upay`.*

Once the offering is created, a `passed_amount_validation_key` and `posting_key` will automatically be generated. The `passed_amount_validation_key` should be entered as the "Posted Amount Validation Key" in the Misc Settings TouchNet form. The `posting_key` will need to be entered in TouchNet under "Additional Posting Value".

The "Posting URL" field in the Misc Settings TouchNet form should be set to something like `http://course-cart.dev/payment`. depending on your staging/production URL.

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
