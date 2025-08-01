[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-2e0aaae1b6195c2367325f4f02e2d04e9abb55f0b24a779b69b11b9e10269abc.svg)](https://classroom.github.com/online_ide?assignment_repo_id=19981443&assignment_repo_type=AssignmentRepo)
# Code challenge 🧑‍💻

Congratulations on passing the initial assessment, now it's time to prove your skills!

## Objective

Your task is to implement a basic service which fetches an org and its users from GitHub's API (you can use either GitHub's REST API or GraphQL API), and stores them in the database (via the GithubUser model and GithubOrg ActiveRecord models)

## Getting started

### Setup

There are two ways to set up this project: with a dev container, or manually.

#### With a dev container

This project comes with a dev container configuration. This means if you use Visual Studio Code or RubyMine, you can open the project in a dev container, and all the setup (installing the right ruby version, installing gems, preparing the database) will be done automatically.

See docs for using dev containers in:

- Visual Studio Code: https://code.visualstudio.com/docs/devcontainers/tutorial (once the devcontainers extension is installed, use cmd+shift+p and run 'Dev containers: Reopen in container')
- RubyMine: https://www.jetbrains.com/help/ruby/connect-to-devcontainer.html

#### Manually

To manually set up the project, do the following:

- Install ruby 3.2.2
- Run `gem install bundler`
- Run `bundle install`
- Run `rails db:prepare`

### Database

The project uses an SQLite database. Take a look at `db/schema.rb` to understand the structure of the tables.

Note that the `source_org_id` column in the `github_orgs` table refers to the org's id in GitHub. Likewise with the `source_user_id` column in the `github_users` table.

### Implementing the service

The service has already been created for you: it's called `GithubSyncService` and lives in `app/services/github_sync_service.rb`. Your task is to implement the `sync` method.

Here's an example of how the service will be invoked (from the rails console). Here we're using the publicly accessible 'docker' org found [here](https://github.com/orgs/docker/people)

```ruby
GithubSyncService.sync(org_name: "docker")
```

### Testing your solution

Within the rails console, after running the above command, you should see something like this when you query the org via ActiveRecord:

```
irb(main):001> GithubOrg.first
  GithubOrg Load (0.6ms)  SELECT "github_orgs".* FROM "github_orgs" ORDER BY "github_orgs"."id" ASC LIMIT ?  [["LIMIT", 1]]
=>
#<GithubOrg:0x00000001063bfd38
 id: 1,
 name: "Docker",
 login: "docker",
 description: "Docker helps developers bring their ideas to life by conquering the complexity of app development.",
 url: "https://github.com/docker",
 avatar_url: "https://avatars.githubusercontent.com/u/5429470?v=4",
 created_at: Thu, 20 Jun 2024 00:28:40.030241000 UTC +00:00,
 updated_at: Thu, 20 Jun 2024 00:28:40.030241000 UTC +00:00>
```

Likewise, you should see something like this when you query the first user:

```
irb(main):002> GithubUser.first
  GithubUser Load (0.1ms)  SELECT "github_users".* FROM "github_users" ORDER BY "github_users"."id" ASC LIMIT ?  [["LIMIT", 1]]
=>
#<GithubUser:0x00000001059f0578
 id: 1,
 github_org_id: 1,
 login: "akerouanton",
 firstname: "Albin",
 lastname: "Kerouanton",
 avatar_url: "https://avatars.githubusercontent.com/u/557933?v=4",
 user_type: "User",
 created_at: Thu, 20 Jun 2024 00:28:40.533189000 UTC +00:00,
 updated_at: Fri, 21 Jun 2024 09:51:46.017541000 UTC +00:00>
irb(main):003>
```

## Requirements

- You must only use the gems provided in the gemfile. Notably, you must use Faraday for HTTP requests. Links to the documentation for each gem are included in the gemfile
- The service must be idempotent. That is, if you run the service twice for the same org, it should not create a duplicate org and it should not create duplicate users.
- If the org/users have changed since the last time the service was called, the org/users should be updated.
- Please write tests for the service, in `spec/services/github_sync_service_spec.rb`. We use rspec as the testing framework. To run rspec tests, run `bundle exec rspec`

Feel free to ask us any clarifying questions you'd like if anything is unclear.

## Deadline

There is _no_ deadline for this task. Feel free to take your time to showcase your skills.

## Submission

To submit your solution:

- raise a pull request against this repo
- add a description to the pull request explaining:
  1. any assumptions you made when writing the code
  2. any challenges you experienced
  3. how you would improve the code if you had more time

Then let us know that the PR is ready for review.

We may ask questions or request changes on the pull request, so be prepared to explain your code or make some adjustments.
