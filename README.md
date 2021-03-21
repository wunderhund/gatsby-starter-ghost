# GGJAM Frontend
This is a Gatsby frontend for Ghost based on [gatsby-starter-ghost](https://github.com/TryGhost/gatsby-starter-ghost.git).

This version's styling has been customized for my personal blog:
![Craig's Blog](static/images/blog-sample.png "Sample of Craig's Blog")

This is a Gatsby static site generator that queries a Ghost CMS backend to generate static site files for a blog. 

It is intended to run primarily in the AWS infrastructure I built for it, located in my [ggjam](https://github.com/wunderhund/ggjam) repo, or with my customized Ghost backend setup in my [ggjam-backend](https://github.com/wunderhund/ggjam-backend) repo.

Once the static site files are created, they can be hosted from from anywhere. I host my personal copy in an AWS S3 bucket.

### Keeping Up to Date
This repo is a fork of [gatsby-starter-ghost](https://github.com/TryGhost/gatsby-starter-ghost.git), which is updated fairly regularly. In order to pull the latest updates from the upstream, use:
```
git remote add upstream git://github.com/TryGhost/gatsby-starter-ghost.git
git fetch upstream
git pull upstream master
```

### Local Setup and Use
This repo contains a Makefile to make building a static site from Ghost easier using Docker!

1. First, you'll need a running [Ghost](https://ghost.org/) CMS. If you don't already have one, you can use my [ggjam-backend](https://github.com/wunderhund/ggjam-backend) to set one up.

1. Once you have a Ghost CMS running, you'll need to create a custom integration in it in order to obtain an API key for Gatsby to use to pull all the content from Ghost's Content API. Instructions for setting up the custom integration can be found here: [Ghost Custom Integrations](https://ghost.org/integrations/custom-integrations/).

1. Once you have a Ghost CMS and a content API key, copy the `.env.example` file in this repository to `.env`:
`cp .env.example .env`

1. Edit `.env` and modify `GHOST_API_URL` and `GHOST_CONTENT_API_KEY` to your own values. If you're using my [ggjam-backend](https://github.com/wunderhund/ggjam-backend) docker-compose file, the API URL will be `http://ggjam-backend_ghost_1:2368`

1. Build the container locally:
`make init`

1. Build the static site using the container:
`make package`

This will access your Ghost CMS and build the frontend static site, dropping all of the files into a folder called `public`. You can then move this folder to anywhere you want to host the site.

For example, to upload the site to a public S3 bucket in AWS:
```aws s3 sync ./public "s3://my.bucket.name/" --delete```

### Makefile

Options included in the Makefile:
* `make init`: builds the container locally and runs `yarn` inside it to configure Gatsby.
* `make dev`: runs [gatsby develop](https://www.gatsbyjs.com/docs/reference/gatsby-cli/#develop) in the container, exposing it on port 8000.
* `make package`: removes any previous build and then builds the static site in `./public`. Also creates a .tar file of the `./public` folder.
* `make serve`: runs [gatsby serve](https://www.gatsbyjs.com/docs/reference/gatsby-cli/#serve) on the container, exposing it on port 9000.
* `make clean`: removes the `./public` and `./frontend.tar` files.
* `make shell`: runs BASH in the container (for debugging)
* `make create-network`: creates the docker network used by these containers.

### Further References
More detail about how this Gatsby static site generator works can be found at its upstream project, [gatsby-starter-ghost](https://github.com/TryGhost/gatsby-starter-ghost.git).