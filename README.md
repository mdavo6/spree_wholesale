[![Build Status](https://travis-ci.org/mdavo6/spree_wholesale.svg?branch=3-1-stable)](https://travis-ci.org/mdavo6/spree_wholesale)

Spree wholesale is a wholesale solution for Spree Commerce. Spree wholesale adds a wholesaler login and signup page as well as an admin to approve and deny applicants. This gem builds on the great work of citrus and patrickmcelwee, and has been updated to Spree v3.1.

PLEASE NOTE: This is a work in progress.

This requires Ruby > 2.0, in order to use module prepend.

------------------------------------------------------------------------------
Installation
------------------------------------------------------------------------------


```ruby
# spree 3.1
gem 'spree_wholesale', :git => 'git://github.com/mdavo6/spree_wholesale', :branch => '3-1-stable'

Then install the necessary migrations, db:migrate, and create the wholesale role:

```bash
# spree 0.50.x and above
rails g spree_wholesale:install
rake db:migrate spree_wholesale:create_role


------------------------------------------------------------------------------
Testing
------------------------------------------------------------------------------

If you'd like to run tests:

```bash
git clone git://github.com/patrickmcelwee/spree_wholesale.git
cd spree_wholesale
bundle install
bundle exec test_app
bundle exec rake
```


------------------------------------------------------------------------------
Demo
------------------------------------------------------------------------------

If you'd like a demo of spree_wholesale:

```bash
git clone git://github.com/mdavo6/spree_wholesale.git
cd spree_wholesale
bundle install
bundle exec rake test_app
cd test/dummy
rails s
```


------------------------------------------------------------------------------
To Do
------------------------------------------------------------------------------

* Write more/better tests
* Finish i18n implementation
* Fork this README more


------------------------------------------------------------------------------
Known Issues
------------------------------------------------------------------------------

* A user created in the 'user' tab, or an already existing user with an added 'wholesaler' flag will not be able to purchase at wholesale price. They will see the retail and wholesale price, but when added to cart will purchase at retail price. Only accounts created using wholesale interface work properly.


------------------------------------------------------------------------------
Contributors
------------------------------------------------------------------------------

* Michael Davidson ([@mdavo6](https://github.com/mdavo6))
* Patrick McElwee ([@patrickmcelwee](https://github.com/patrickmcelwee))
* Spencer Steffen ([@citrus](https://github.com/citrus))
* John Hwang      ([@tavon](https://github.com/tavon))
* Cameron Carroll ([@sanarothe](https://github.com/sanarothe))
* Les Cochrane    ([@oldtinroof](https://github.com/oldtinroof))


------------------------------------------------------------------------------
License
------------------------------------------------------------------------------

Copyright (c) 2017 Michael Davidson, Spencer Steffen and Citrus, released under the New BSD License All rights reserved.
