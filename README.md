# GitFog

Inspired by <a href="http://bitcoinfog.com/">Bitcoin Fog</a>, GitFog is a
command line tool that camouflages your work with git by randomizing timestamps on
```git commit``` and ```git push```.

## Use case

When you contribute code with git, you share your name, email, and work schedule with
everyone. GitFog helps you change your git/config, then goes further to better anonymize
your work. Suppose someone suspects that you are involved, and finds out that you often
commit to personal projects on Tuesday afternoons. They would examine whether your commits and
pushes happen at similar days and times as others. By using GitFog, your commits are spaced
out and randomized.

## Alternatives

The easiest option would be to schedule a commit and push at a regular time
(for example, 3am every morning) but this requires you to have the computer
always running, makes it obvious that you are scheduling your commits, and
any immediate commits and pushes (ie to fix a bug on the site) will break
the pattern.

## How to install GitFog

Have Ruby and RubyGems installed on your computer.

Then run ```gem install gitfog```

Currently at version 0.0.4

## How to use GitFog

```gitfog init``` will disable git and enable gitfog commands. This prevents
you from using the regular git commands by habit. You will be asked to set
a user email and password to connect to commits (this prevents you from
leaking your global git config though commits)

```gitfog off``` will disable gitfog and re-enable git commands. Make sure
you do not commit data that you do not want to be shared. You can always re-enable
GitFog with ```gitfog init```.

```gitfog status```, ```gitfog add```, and ```gitfog rm``` replace the standard git
commands.

```gitfog commit``` will set the timestamp on your commit to sometime between
the previous commit and the present, up to 48 hours in the past. This makes
it possible for you to make a few commits in quick succession which in the
timescale may be spaced out over several hours. The timestamp will not affect
the order of commits. ```gitfog commit --now``` will use your system time.

```gitfog push``` will hold your push for a random time in the next 8 hours.
You can cancel the push with Ctrl+C, make an immediate push with
```gitfog push --now```, or change the maximum time with
```gitfog push --max 4```.
