# How to Contribute

This project is [Apache 2.0 licensed](LICENSE) and accepts contributions via
GitHub pull requests. Everyone interacting with this project is expected
to abide by the [code of conduct](CODE_OF_CONDUCT.md), anyone not abiding by
the code will not be allowed to participate.

# Certificate of Origin

By contributing to this project you agree to the Developer Certificate of
Origin (DCO). This document was created by the Linux Kernel community and is a
simple statement that you, as a contributor, have the legal right to make the
contribution. See the [DCO](DCO) file for details.

The way you communicate that agreement is by adding a Signed-off-by: declaration
to each of your commits. This means that you add a line at the bottom of each
commit message with a name and email that matches your git config. For example:

Signed-off-by: Elliot Murphy <statik@users.noreply.com>

One way to add this line is to use the [dco] tool to add a commit-msg hook
to your repo configuration. This is handy if you use an IDE or GUI tool to
make your git commits.

If you use git from the command line, another way is to set up a template
for the git commit message that has this line already in id.
For example, if you already have your name and email set, this will
generate the correct file:

    $ echo "Signed-off-by: `git config --get user.name` <`git config --get user.email`>" > $HOME/.gitmessage
		$ git config --global --add commit.template '~/.gitmessage'

You can also use the -s option to git commit.

However you do it, the Signed-off-by line is essential, and commits that
are not signed off cannot be accepted into the project. This is some
extra work the first time you set it up. Please know that we appreciate
your contribution, and don't hesitate to ask if you need help.

If you already have a commit that you forgot to sign off, you can 
adjust it with

    $ git commit --amend -s

## Getting Started

- Fork the repository on GitHub
- Read the [README](README.md) for build and test instructions
- Play with the project, submit pull requests!

## Contribution Flow

This is a rough outline of what a contributor's workflow looks like:

- Create a topic branch from where you want to base your work (usually master).
- Make commits of logical units.
- Push your changes to a topic branch in your fork of the repository.
- Make sure the tests pass, and add any new tests as appropriate.
- Submit a pull request to the original repository.

Thanks for your contributions!

Note that proposing a change does not obligate the project to accept your
change, and not all changes can be accepted. If you need help implementing
Haven GRC in an organization, consider hiring [Kindly Ops](https://kindlyops.com)
in order to support the project.
