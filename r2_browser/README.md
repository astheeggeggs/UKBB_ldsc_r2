To run the rg_browser portion of the website using docker, follow these instructions...

Download and install docker. Annoyingly, you'll need to create an account. 
`https://docs.docker.com/install/`

Next, create a new folder and move a few files from this repository over there. You'll just need app.R from the r2_browser folder, and `Dockerfile` from the main folder. Move these over and create some directories where required so that the file structure in your new folder looks like this:

```
my_dockerfolder
├── Dockerfile
└── app
    └── app.R
```

Next, build the docker image. To do this, navigate to the `my_dockerfolder` and run:

```
docker build -t ukbb-rg .
```

Finally, you should be able to run the shiny app using docker:

```
docker run -p 80:80 ukbb-rg
```