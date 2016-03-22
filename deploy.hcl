# There can only be a single job definition per file.
job "project-web-staging" {
    region = "global"
    datacenters = ["staging"]
    type = "service"
    priority = 50

    update {
        stagger = "10s"
        max_parallel = 1
    }

    group "project-web-staging" {
        count = 3

    constraint {  # set to true for debugging convenience
        distinct_hosts = true
    }

        restart {
            interval = "5m"
            attempts = 10
            delay = "25s"
            mode = "delay"
        }

        # Define a task to run
        task "project-web-staging" {
            # Use Docker to run the task.
            driver = "docker"

            # Configure Docker driver with the image
            config {
                image = "gcr.io/project-stage/project_services:1.0"
        auth {
            server_address = "https://gcr.io"
        }
                port_map {
                    project_web = 80
                }
            }

            env {
                DEPLOY_ENVIRONMENT = "staging" # deployment environment
                PROJECT_DBNAME = "staging"
                START_PROGRAM = "/home/project/env/bin/project_web"
                RESTART_BUMPER = 0 #just a way to force restarts
            }

             service {
                 name = "project-web-staging"
                 tags = ["global", "web", "http", "env-staging", "path-@webapp"]
                 port = "project_web"
             }

            resources {
                cpu = 100 # 500 Mhz
                memory = 200 # 256MB
                network {
                    mbits = 10
                    port "project_web" {
                    }
                }
            }
        }
    }
}
