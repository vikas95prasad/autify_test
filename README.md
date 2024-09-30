
# Autify Test

This Rails application provides an API to assert whether a given webpage contains a specific string of text. It also records metadata about each assertion made, such as the number of links and images on the page.

## Features

- Perform assertions on web pages to check for the presence of a specific string.
- Record metadata for each assertion (links, images, and timestamps).
- Fetch snapshots of pages, which can be re-hosted locally.

## Prerequisites

Make sure you have the following installed:

- Docker
- Docker Compose

## Running the App with Docker

### Follow these steps to run the application using Docker:

### 1. Clone the Repository

```bash
git clone https://github.com/vikas95prasad/autify_test.git
cd autify_test
```

### 2. Build and Start the Containers

Build the Docker images for the app and the PostgreSQL database. Start the containers and map ports `3000` (Rails) and `5432` (PostgreSQL) to your local machine.

```bash
docker-compose up --build
```

### 3. Setup the Database

After starting the containers, in a new terminal, run:

```bash
docker-compose run web bin/rails db:create db:migrate
```

This will create the development database and run any pending migrations.

### 4. Access the Application

Once everything is up and running, you can access the Rails app in your browser at:

```bas
http://localhost:3000
```

The app is now running in Docker, with PostgreSQL as the database.

### 5. Running Tests

To run the test suite inside the Docker container, use the following command:

```bash
docker-compose run web bundle exec rspec
```

This will execute your tests inside the container.

### 6. Stopping the Containers

When you're done, you can stop the running containers with:

```bash
docker-compose down
```

This command will stop and remove all containers, networks, and volumes created by Docker Compose.

## API Endpoints

Here’s a brief overview of the available API endpoints:

### 1. Perform an Assertion

**Endpoint:** `POST /api/v1/assertions`

**Request Body:**

```json
{
  "url": "https://nocode.autify.com",
  "text": "AI-Powered"
}
```

**Response:**

```json
{
  "status": "PASS"
}
```

### 2. Fetch Assertion Metadata

**Endpoint:** `GET /api/v1/assertions`

**Response:**

```json
[
  {
    "url": "https://nocode.autify.com",
    "text": "ai-powered",
    "status": "PASS",
    "createdAt": "2024-08-16T06:40:22Z",
    "numLinks": 63,
    "numImages": 86,
    "snapshotUrl": "http://localhost:3000/snapshots/1/index.html"
  }
]
```

## Environment Variables

Here are the environment variables you can set for customizing the app:

- `POSTGRES_USER`: Username for the PostgreSQL database (default: `postgres`).
- `POSTGRES_PASSWORD`: Password for the PostgreSQL database (default: `password`).
- `POSTGRES_DB`: The name of the database (default: `app_development`).
- `DATABASE_URL`: The URL for the PostgreSQL database.

## Troubleshooting

If you run into any issues, check the logs using:

```bash
docker-compose logs
```
