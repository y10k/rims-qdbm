RIMS::QDBM
==========

RIMS key-value store plug-in for QDBM.
This gem provides 2 plug-ins (`qdbm_depot` and `qdbm_curia`).

RIMS is IMAP sever and see https://github.com/y10k/rims.

Installation
------------

Add this line to your application's Gemfile:

```ruby
git_source(:github) {|repo_name| "https://github.com/#{repo_name}.git" }
gem 'rims-qdbm', github: 'y10k/rims-qdbm'
```

And then execute:

    $ bundle

Usage
-----

Add these lines to your config.yml of RIMS:

```yaml
load_libraries:
  - rims/qdbm
meta_key_value_store:
  plug_in: qdbm_depot
  configuration:
    bnum: 1200000
text_key_value_store:
  plug_in: qdbm_curia
  configuration:
    bnum: 50000
    dnum: 8
```

Contributing
------------

Bug reports and pull requests are welcome on GitHub at https://github.com/y10k/rims-qdbm.

License
-------

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
