# Copyright 2012 Ooyala, Inc
# Author: Joe Block
#
# This is released under the BSD license.

BUCKET_BASE="s3://masterless-puppet.example.com/osx"
BINARIES_D="#{BUCKET_BASE}/binaries"
FLAVOR_D="#{BUCKET_BASE}/flavors"
MANIFEST_D="#{BUCKET_BASE}/manifests"

def git_checkout!(branch_name)
  `git checkout #{branch_name}`
end

def git_merge!(branch_name)
  `git merge #{branch_name}`
end

def git_push(branch_name)
  `git push #{branch_name}`
end

def current_branch?
  return %x[ git branch | grep '^\*' | cut -d ' ' -f2 ].chomp
end

desc "set precommit hook"
task :set_precommit do
  `cat hooks/pre-commit > .git/hooks/pre-commit`
  `chmod +x .git/hooks/pre-commit`
end

desc "setup branches"
task :setup_branches do
  %x[ git checkout -b yosemite_stable origin/yosemite_stable ]
  %x[ git checkout -b yosemite_unstable origin/yosemite_unstable ]
end

desc "setup new checkout"
task :setup_new_banches => [:set_precommit, :setup_branches] do
end

desc "Promote yosemite_unstable -> yosemite_stable, master -> yosemite_unstable"
task :bump_osx => [:set_precommit] do
  `rake promote_yosemite_unstable_to_yosemite_stable`
  `rake promote_master_to_yosemite_unstable`
end

desc "Promote master -> unstable"
task :update_unstable => [:set_precommit] do
  `rake promote_master_to_yosemite_unstable`
end

desc "Promote master -> yosemite_unstable"
task :promote_master_to_yosemite_unstable => [:set_precommit] do
  puts "promoting master to yosemite_unstable"
  git_checkout! "yosemite_unstable"
  git_merge! "master"
  git_push "origin yosemite_unstable"
  git_checkout! "master"
end

desc "Promote yosemite_unstable -> yosemite_stable"
task :promote_yosemite_unstable_to_yosemite_stable => [:set_precommit] do
  puts "promoting yosemite_unstable to yosemite_stable"
  git_checkout! "yosemite_stable"
  git_merge! "yosemite_unstable"
  git_push "origin yosemite_stable"
  git_checkout! "master"
end

def snapshot_branch_to_dmg(branch)
  dmg_output = %x[ BRANCH=#{branch} make dmg | tail -1 | cut -d':' -f2 ]
  filename = %x[ basename #{dmg_output} ].chomp
  return filename
end

def publish_branch(branch)
  filename = snapshot_branch_to_dmg(branch)
  version = filename.split('-')[1].split('.')[0]
  scratch_f = "/tmp/ronin_temp#{$$}"
  %x[ s3cmd put #{filename} #{MANIFEST_D}/#{branch}/#{filename} ]
  %x[ echo #{version} > #{scratch_f} ]
  %x[ s3cmd put #{scratch_f} #{FLAVOR_D}/#{branch} ]
  %x[ rm #{scratch_f} ]
end

desc "publish stable branch to s3"
task :publish_stable do
  fname = publish_branch("yosemite_stable")
end

desc "publish unstable branch to s3"
task :publish_unstable do
  fname = publish_branch("yosemite_unstable")
end

desc "snapshot unstable to dmg"
task :snapshot_unstable_to_dmg do
	snapshot_branch_to_dmg('yosemite_unstable')
end

desc "Test masterless mode"
task :masterless do
  `sudo puppet apply --modulepath=./modules --verbose nodeless_site.pp`
end

desc "Validate pp files"
task :validate do
  `find . -name '*.pp' -exec puppet parser validate --ignoreimport '{}' ';'`
end

desc "Clean"
task :clean do
  `find . -name .DS_Store -exec rm -v '{}' ';'`
  `find . -name '.*~' -exec rm -v '{}' ';'`
end
