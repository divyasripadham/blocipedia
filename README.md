Blocipedia is a Rails application that lets users create their own wikis and share them publicly or privately with other collaborators.

User Stories |
------------ |
A user should be able to sign up for a free account by providing email & password |
A user should be able to sign in and out of Blocipedia |
As a user with a standard account, they can create, read, update, and delete public wikis |
There should be three user roles: admin, standard, or premium	|
Users can upgrade their account from a free to a paid plan	|
As a premium user, they should be able to create private wikis	|
Wikis should be able to be edited using Markdown syntax	|
A premium user can add and remove collaborators for their private wikis |

Testing framework used |
------------------------------------------------------ |
[RSpec](http://rspec.info/) |

Gems used |
------------ |
[Devise](https://github.com/plataformatec/devise) for account sign up, in and out. |
[Pundit](https://github.com/elabs/pundit) for authorisation based on user roles. |
[Faker](https://github.com/stympy/faker) to populate the database with fake seed data for testing. |
[Redcarpet](https://github.com/vmg/redcarpet) to enable markdown syntax in wikis. |
[Stripe](https://stripe.com/gb) payment integration to upgrade user accounts. |
