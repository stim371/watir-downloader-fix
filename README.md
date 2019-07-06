## Overview
This repository is an example of the issues I am running into.

I am attempting to scrape data from a website using the `watir` gem and the `headless` gem
interacting with either Firefox or Chrome's headless driver.

The Dockerfile does not currently install the correct dependencies, and I need help identifying them.

## Setup and Test
Repro Steps:
1. create the Docker container
    * `make build`
1. Run tests with container
    * `make run-test-chrome`
    * `make run-test-firefox`

## Submitting a solution
* Submit a Pull Request with changes to the Dockerfile

## Contact and questions
Please communicate through Upwork for chat.

Once a PR is created, we can also discuss in there.
