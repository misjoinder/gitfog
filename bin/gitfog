#!/usr/bin/env ruby
# GitFog

require 'rubygems'
require 'commander/import'
require 'highline/import'
require 'fileutils'
require 'git'

program :version, '0.0.2'
program :description, 'Camouflage git commit and push'

def verify_gitfog
  unless File.directory?('.gitfog')
    puts '.gitfog not found: run gitfog in the top level of an init-ed gitfog repo.'
    exit
  end
end

def update_gitfog
  # remove any existing .gitfog, update from .git
  unless File.directory?('.git')
    puts "no .git directory available to copy to .gitfog"
    exit
  end
  if File.directory?('.gitfog')
    FileUtils.rm_rf('.gitfog')
  end

  begin
    # make new .gitfog
    FileUtils.copy_entry('.git', '.gitfog', preserve: true, remove_destination: true)

    # remove old .git directory
    FileUtils.rm_rf('.git')
  rescue
    puts "did not finish copying .git back to .gitfog"
    exit
  end
end

def restore_git
  # copy .gitfog directory to .git
  verify_gitfog
  if File.directory?('.git')
    FileUtils.rm_rf('.git')
  end
  FileUtils.copy_entry('.gitfog', '.git', preserve: true, remove_destination: true)
end

command :init do |c|
  c.syntax = 'gitfog init'
  c.summary = 'Disable git and enable gitfog commands.'
  c.description = 'This enables gitfog commands and prevents you from using the regular git commands by habit. You will be asked to set a user email and password to use in your commits.'
  c.action do |args, options|
    # check if .gitfog already exists
    if File.directory?('.gitfog')
      puts ".gitfog already exists: run 'gitfog off' to reset."
      exit
    end

    # check if .git exists
    unless File.directory?('.git')
      puts '.git not found: run gitfog in the top level of an init-ed git repo.'
      exit
    end

    # check if .gitignore exists
    if File.exist?('.gitignore')
      has_gitignore = false
      has_gitfog = false
      ignored = IO.readlines('.gitignore').map do |line|
        has_gitignore = true if line.strip == '.gitignore'
        has_gitfog = true if line.strip == '.gitfog'
        line
      end
      unless has_gitfog
        ignored << "\n.gitfog\n"
        puts "Added .gitfog to the .gitignore file"
      end
      unless has_gitignore
        ignored << "\n.gitignore\n"
        puts "Added .gitignore to the .gitignore file"
      end
      # output modified .gitignore
      File.open('.gitignore', 'w') do |ifile|
        ifile.puts ignored
      end
    else
      # create .gitignore
      puts 'Creating a .gitignore file to hide some files from git'
      File.open('.gitignore', 'w') do |file|
        file.puts ".gitfog\n.gitignore\n"
      end
    end

    # set user and email
    set_user = ask 'Show what name on git? '
    set_mail = ask 'Show what email on git? '
    # open old .git/config
    config = IO.readlines('.git/config').map do |line|
      if line.index('email') != nil
        "\temail = " + set_mail
      elsif line.index('name') != nil
        "\tname = " + set_user
      else
        line
      end
    end

    # copy .git to .gitfog
    update_gitfog
    unless File.directory?('.gitfog')
      puts "Copy from .git to .gitfog failed"
      exit
    end

    # write new .gitfog/config
    File.open('.gitfog/config', 'w') do |cfile|
      cfile.puts config
    end

    # remove old .git directory
    FileUtils.rm_rf('.git')
    puts "When you want to restore regular git commands, run 'gitfog off'."
  end
end

command :off do |c|
  c.syntax = 'gitfog off'
  c.summary = 'Restore git and disable gitfog commands.'
  c.description = 'Restore git and disable gitfog commands.'
  c.action do |args, options|
    # verify .gitfog exists
    verify_gitfog

    # copy .gitfog back to .git
    restore_git

    # remove .gitfog
    FileUtils.rm_rf('.gitfog')
    puts "Thanks for using GitFog! You can resume using GitFog with 'gitfog init'"
  end
end

command :status do |c|
  c.syntax = 'gitfog status [options]'
  c.summary = 'Replaces git status.'
  c.action do |args, options|
    # verify .gitfog exists
    verify_gitfog

    # copy .gitfog directory to .git
    restore_git

    # run git status with given args
    system 'git status ' + args.join(' ')

    # remove old .git directory
    FileUtils.rm_rf('.git')
  end
end

command :add do |c|
  c.syntax = 'gitfog add [options]'
  c.summary = 'Replaces git add.'
  c.action do |args, options|
    # verify .gitfog exists
    verify_gitfog

    # copy .gitfog directory to .git
    restore_git

    # run git add with given args
    system 'git add ' + args.join(' ')

    # move .git directory over .gitfog
    update_gitfog
  end
end

command :rm do |c|
  c.syntax = 'gitfog rm [options]'
  c.summary = 'Replaces git rm.'
  c.action do |args, options|
    # verify .gitfog exists
    verify_gitfog

    # copy .gitfog directory to .git
    restore_git

    # run git rm with given args
    system 'git rm ' + args.join(' ')

    # copy .git directory over .gitfog
    update_gitfog
  end
end

command :commit do |c|
  c.syntax = 'gitfog commit [options]'
  c.summary = 'Make a commit with a randomized timestamp'
  c.description = 'Makes the commit with a timestamp between the last commit and now (up to 48 hours ago)'
  c.option '-m STRING', String, 'Public commit message'
  c.option '--now', 'Make the commit timestamp happen now'
  c.action do |args, options|
    # verify .gitfog exists
    verify_gitfog

    # copy .gitfog directory to .git
    restore_git

    unless options.now
      # find the last commit time
      repo = Git.open './'
      last_commit = Time.now - 48 * 60 * 60
      begin
        repo.log(1).each do |commit|
          # actually returns a Time object
          last_commit = commit.date
        end
      rescue
        # usually means a repo has no prior commits
      end

      # warn if last commit was recent
      ok_to_commit = true
      seconds_diff = Time.now - last_commit
      if seconds_diff < 60 * 60
        if seconds_diff < 10 * 60
          puts "Last commit timestamp was within the last 10 minutes."
        else
          puts "Last commit timestamp was within the last hour."
        end

        # get user approval
        puts "Continue with less randomized commit time?"
        ok_to_commit = false
        commit_input = ask 'Enter Y or Yes to confirm; anything else will cancel commit '
        if commit_input.strip.downcase == "y" || commit_input.strip.downcase == "yes"
          ok_to_commit = true
        end
      end

      if ok_to_commit
        # choose a past time
        seconds_diff = Time.now - last_commit
        commit_time = last_commit + Random.rand(0..seconds_diff)
        commit_time = commit_time.to_s
        puts "Backdating to the commit to " + commit_time

        # make a timed commit
        if options.m
          system "GIT_AUTHOR_DATE='" + commit_time + "' GIT_COMMITTER_DATE='" + commit_time + "' git commit -m \"" + options.m + "\""
        else
          system "GIT_AUTHOR_DATE='" + commit_time + "' GIT_COMMITTER_DATE='" + commit_time + "' git commit"
        end
      else
        puts "Try again after more time has passed."
      end
    else
      puts "Making the commit with local system time"
      # make a commit without changing time
      if options.m
        system 'git commit -m "' + options.m + '"'
      else
        system 'git commit'
      end
    end

    # copy .git directory over .gitfog
    update_gitfog
  end
end
 
command :push do |c|
  c.syntax = 'gitfog push [options]'
  c.summary = 'Make a push at a random time in the next 8 hours'
  c.description = 'Make a push at a random time in the next several hours'
  c.option '--max N', Integer, 'Specify the maximum time to wait'
  c.option '--now', 'Make the push happen now'

  c.action do |args, options|
    # verify .gitfog exists
    verify_gitfog
    
    # determine time to delay
    unless options.now
      # randomized delay time
      delay_push = 8 * 60 * 60
      if options.limit
        # get maximum delay from user
        delay_push = options.limit * 60 * 60
      end
      delay_push = Random.rand(0..delay_push)
      push_time = Time.now + delay_push
      puts "Delaying push " + delay_push.to_s + " seconds, until " + push_time.to_s

      sleep delay_push
    end

    # restore .git
    restore_git

    # do the push
    system "git push " + args.join(' ')

    # move .git over .gitfog
    update_gitfog
  end
end