## Yank the Band-Aid

Automate the creation of Jira tickets.

Pretty trivial, uses ENV settings to set configuration, uses a text file to define tickets, uses the Jira REST API to create them.

Does some basic minimal massaging of inputs to try to make some things work, but this doesn't do a lot of spidering around the API to find related things, or link up complex data, or muck with custom fields, or typecasting integers, etc.

It's basically a way to keep me from web-clicking on every link and field to get a batch of tickets made for a project.

## Example input

```
# Any #-ed lines are comments
# and all blank lines are skipped


# There are three sections to the file, a first:
# header line for all-ticket key-value settings
project=SOMENAME|assignee=bob

# Another header line for field definitions ('|'-separated, in the order of ticket entry lines)
summary|description

# And a list of ticket entry lines. These are '|'-separated; \n is a newline; fields are in the order of the field definitions.
Install fooclone to master node|This is so robby can get his foo going.\n\nSee, robby? Get it.
Uninstall fooclone|That'll show old robby!
No, seriously, do some work|A ticket a day makes one sick, to be fair.
```

## Usage

```
% bundle install
% bundle exec bin/jira-tickets.rb /path/to/tickets.txt
# oh crap
% export JIRA_USER=myusername
% export JIRA_INSTANCE=https://my.jira.mycompany.io/
% export JIRA_PASSWORD="hey-have-you-heard-of-dotenv?" # because be more careful with passwords
% bundle exec bin/jira-tickets.rb /path/to/tickets.txt
# tickets!!!
```


## Maintainer

[Rick Bradley](https://github.com/rick) is a horrible maintainer of open source projects. Just get used to it. He operates by whim and compounded neglect.

## Disclaimers

This will create duplicate tickets if you run it multiple times. It will almost certainly destroy data and productivity. I mean, it's amazing that this even remotely ever worked. You'd be better off taking your data, putting it in a box, and just burning the box. Or [just putting it in a backpack, taking it to the shit store and selling it](https://www.youtube.com/watch?v=-tGL-buZ94Y).
