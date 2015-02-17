# Stoke

[![Join the chat at https://gitter.im/mhelmetag/stoke](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/mhelmetag/stoke?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
Little ruby project for scraping surf info from Surfline. More to come. Maybe getting rail-y soon.

Requires these gems:
* mechanize
```
gem install mechanize
```
* action_mailer
```
gem install actionmailer
```
* pony
```
gem install pony
```
* sms_fu
```
gem install sms_fu
```

TODO:
* Compartmentalize functions (html tag stripper, main forecast app, sms sending)
* Make code cleaner, concise and fancy while maintaining readability
* Add 3 day support (1 day currently)
* Add text messaging (using sms_fu and pony/smtp)
* Add other socal locations (SB, Ventura and North LA currently)
* Build a simple webpage with bootstrap for sign up (name, carrier from dropdown, phone, and location from dropdown)
* Integrate with Rails for deployment
* Deploy on my Raspberry Pi so that server is always up
* ~~Have fun~~ Try not to lose my mind... and still do my work and schoolwork.

If you have any tips or tricks, let me know. **If this has been done before, please _do not_ let me know!!** :)
