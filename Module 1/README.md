# Solutions to Module 1 homework: Docker & SQL

https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2026/01-docker-terraform/homework.md

Shell commands etc. required to answer questions have been run in a GitHub Codespace created in this repo.

## Question 1. Understanding Docker images
Run docker with the python:3.13 image. Use an entrypoint bash to interact with the container.

What's the version of pip in the image?

25.3
24.3.1
24.2.1
23.3.1

### Answer: 25.3
### Steps
1. Start a container with:
   *docker run -it --rm --entrypoint=bash python:3.13*
3. Once inside the container:
   *pip --version*

