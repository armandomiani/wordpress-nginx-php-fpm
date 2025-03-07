# Containerizing WordPress: A Step-by-Step Guide

This repository contains the solution for the article [Containerizing WordPress: A Step-by-Step Guide](https://wearecommunity.io/communities/36148Gdy5W/articles/6187]).

The goal of this repository is to:
- Demonstrate how to containerize WordPress.
- Showcase basic NGINX and PHP-FPM configurations.
- Provide a hands-on example for readers to experiment with.

## Limitations
This setup is not production-ready and has the following limitations:

* No Security Hardening: The configuration lacks security best practices such as SSL/TLS, secure database credentials, and user permissions.

* No Performance Optimizations: The NGINX and PHP-FPM configurations are basic and not optimized for high traffic or performance.

* No Scalability: The setup is designed for local development and does not include scaling mechanisms like load balancing or caching.

**Use this repository as a learning tool only!**

## Article
This repository accompanies the article [Containerizing WordPress: A Step-by-Step Guide](https://wearecommunity.io/communities/36148Gdy5W/articles/6187]).

----

## Using the repository

### Starting the stack

To start the stack, run the following command

```shell
docker-compose up --build --force-recreate -V
```

#### Command Options

* `--build`: Rebuilds the image before starting the containers, ensuring that any changes are applied.
* `--force-recreate`: Force containers re-creation, useful for ensuring a clean state
* `-V`: Removes any anonymous volumes, also ensuring a clean state.

### Accessing the Application

Once the stack is running, you can access the WordPress application in your browser:

1. WordPress Frontend:
    * Open your browser and navigate to: http://localhost
2. WordPress Admin Dashboard:
    * Use the admin credentials set in your .env file

### Performance testing your WordPress installation

To test the performance of your WordPress setup, you can use [Apache Bench (ab)](https://httpd.apache.org/docs/current/programs/ab.html) to run the load tests.

#### Requisites

* [Apache Bench](https://httpd.apache.org/docs/current/programs/ab.html)
    * Check how to install in your distribution: https://command-not-found.com/ab

#### Run Apache Bench

Execute the following command to run a load test with 1000 requests and 100 concurrent connections:

```shell
ab -n 1000 -c 100 -g tests/output.tsv http://localhost
```

##### Command Options

* `-n`: Total number of requests to be performed
* `-c`: Max number of requests at the same time
* `-g`: TSV results output file

#### Generate Response Time over Requests chart

Run the following commands to set up the environment, install the dependencies, and generate the chart:

```shell
# Navigate to the tests directory
cd tests/

# Create a Python virtual environment (if not already set up)
virtualenv -p $(which python3) env

# Activate the virtual environment
source env/bin/activate

# Install required Python libraries
pip install -r requirements.txt

# Generate the performance chart
python3 generate.py output.tsv

# Deactivate the virtual environment (optional)
deactivate
```

#### Destroy all resources:

```shell
docker-compose down -v
```

##### Command Options

* `-v`: For destroying all volumes.

## License
This project is licensed under the MIT License. See the LICENSE file for details.
