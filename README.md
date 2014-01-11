# GitFog

Inspired by <a href="http://bitcoinfog.com/">Bitcoin Fog</a>, GitFog is a
command line tool to replace ```git commit``` and ```git push``` with
randomized timestamps.

## Use case

You are contributing anonymously to a project. Someone suspects that you
might be involved, and finds out that you often commit to personal
projects on Tuesday afternoons. They can examine whether your commits and
pushes happen at similar days and times as others.

## Alternatives

The easiest option would be to schedule a commit and push at a regular time
(for example, 3am every morning) but this requires you to have the computer
always running, makes it obvious that you are scheduling your commits, and
any immediate commits and pushes (ie to fix a bug on the site) will break
the pattern.

## How to use GitFog

```gitfog init``` will disable git and enable gitfog commands. This prevents
you from using the regular git commands by habit. You will be asked to set
a user email and password to connect to commits (this prevents you from
leaking your global git config though commits)

```gitfog off``` will disable gitfog and re-enable git commands. Make sure
you do not commit data that you do not want to be shared.


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
