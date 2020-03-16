<h1 align="center">
<a href="https://undraw.co/"><img src="logo/landing_page.svg" alt="Docs Toolchain Logo"></a>
</h1>

# docs-toolchain [![Github workflow](https://github.com/wirecard/docs-toolchain/workflows/Main/badge.svg)](https://github.com/wirecard/docs-toolchain/actions)   [![GitHub Issues](https://img.shields.io/github/issues-raw/wirecard/docs-toolchain)](https://github.com/wirecard/docs-toolchain/issues)  [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)   [![Inline docs](http://inch-ci.org/github/wirecard/docs-toolchain.svg?branch=master)](http://inch-ci.org/github/wirecard/docs-toolchain)

Toolchain for TecDoc managed documentation repositories

<div align="center">

[![Built with Ruby](https://forthebadge.com/images/badges/made-with-ruby.svg)](https://forthebadge.com) [![Built with Science](https://forthebadge.com/images/badges/built-with-science.svg)](https://forthebadge.com) [![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)](https://forthebadge.com) [![Uses Badges](https://forthebadge.com/images/badges/uses-badges.svg)](https://forthebadge.com) [![Approved](https://forthebadge.com/images/badges/approved-by-george-costanza.svg)](https://forthebadge.com)

</div>


## Disclaimer

Under heavy development, everything is subject to change and most likely will not be up-to-date!


## Docs and Metrics
* [Source Code Documentation (rdoc)](https://wirecard.github.io/docs-toolchain/rdoc/)
* [SimpleCov Coverage](https://wirecard.github.io/docs-toolchain/coverage/)
* [RubyCritic](https://wirecard.github.io/docs-toolchain/rubycritic)


## Stages (out-of-date)
The toolchain is designed to run through different stages, that have specific responsibilities:
1. **setup**: install required dependencies
2. **test**:
    * validate all configuration files
    * test the current commit with:
    * predefined tests by the toolchain (`lib/extensions.d/`)
    * [*future*] custom tests (`${CONTENT_REPO}/extensions.d/`)
    * abort the build if necessary
    * keep a log of all events which will be used in the notify stage
3. **test**:
    * combine Javascript files to BLOB file and transpile (cross-browser compatibility and loading speed)
4. **build**:
    * invoke asciidoctor (with multipage converter)
    * `DEBUG` build for local testing:
    * passthrough as `:debug:` to asciidoctor
    * [*future*] run custom build scripts `build.d/*.sh`
5. **post**:
    * create Table of Content
    * create search index (Lunr)
    * [*future*] trigger translation
6. **deploy**:
    * [wirecard/s3-deploy](https://github.com/wirecard/s3-deploy)
    * [crazy-max/ghaction-github-pages](https://github.com/crazy-max/ghaction-github-pages)
    * required variables, see [Configuration/Secret/AWS](#Secret)
7. **notify**:
    * send Slack message stating the fail status and a description if the build failed, see [Configuration/Secret/Slack](#Secret)

## Development
**Quality assurance:**
* `rake toolchain:lint` calls rubocop
* `rake toolchain:test` runs unit tests with `simplecov` and writes report to `coverage/index.html`
* `rake toolchain:quality` runs `rubycritic` and generates an overview in `/tmp/rubycritic/overview.html`
* `rake toolchain:rdoc` generates rdoc documentation in `/tmp/rdoc`
* `rake toolchain:inch:grade` or `rake toolchain:inch:suggest` runs `inch` on the code base

## Configuration
There are some variables that need to be secret, while others can be public.
Configuration files are public.

### Frontend Configuration
#### CDN
By default, Font Awesome is loaded via CDN.
To disable the loading via CDN:
1. add `font-awesome.css` to the `css/` folder 
2. the Font Awesome font files to `fonts/`
3. add the following to your `index.adoc` below `:icons: font`:
```
:!iconfont-remote:
:iconfont-cdn:
:!webfonts:
```


### Environment Variables
* `FAST` includes contains the following variables:
    * `SKIP_COMBINE`: skips the Javascript combine and transpile operation.
    * `SKIP_HTMLCHECK`: skips the HTML Check Post process.
    * `SKIP_RAKE_{stage}`
        * `SKIP_RAKE_TEST`: skips test stage (i.e. `rake docs:test`)

### Secrets
#### AWS

**Needed:**
* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_REGION`
* `AWS_S3_BUCKET`

#### Slack

**Needed:**
* `SLACK_TOKEN` (Optional)

The **test** and **build** stages produce `/tmp/slack.json`, a central file containing all warnings and errors that occured during the **test** or **build** stages.
`lib/notify/slack.rb` sends these warnings and/or errors (if there are any) to a Slack channel, defined in the secret variable `SLACK_TOKEN`.

### Public
#### Variables

#### Files
Configuration files:
* `config/default.yaml`: default settings
* `config/invalid-patterns.json`: WIP
* `static/privacy-policy.(txt|adoc)`: WIP
* `content/docinfo-search.html`: search overlay for the frontend

## Run

To run the toolchain locally, or run the unit tests, the following requirements must be met:
* Ruby 2.x
    * installed dependencies (Gemfile)

In order to install dependencies, run the following at the root of the project:
```bash
export TOOLCHAIN_PATH="$(pwd)"
bash stages/setup/setup_main.sh
```

