# Online Boutique - Containerized Microservices

This repository contains a containerized deployment of Google Cloud's [Online Boutique](https://github.com/GoogleCloudPlatform/microservices-demo) microservices application. Each individual service has been packaged with a custom multi-stage `Dockerfile`, and the entire 11-tier microservice architecture is orchestrated locally via `docker-compose`.

.
├── src/
│   ├── adservice/                 # Java
│   │   └── Dockerfile
│   ├── cartservice/              # C# (.NET)
│   │   └── Dockerfile
│   ├── checkoutservice/          # Go
│   │   └── Dockerfile
│   ├── currencyservice/          # Node.js
│   │   └── Dockerfile
│   ├── emailservice/             # Python
│   │   └── Dockerfile
│   ├── frontend/                 # Go
│   │   └── Dockerfile
│   ├── loadgenerator/            # Python / Locust (Optional)
│   │   └── Dockerfile
│   ├── paymentservice/           # Node.js
│   │   └── Dockerfile
│   ├── productcatalogservice/    # Go
│   │   └── Dockerfile
│   ├── recommendationservice/    # Python
│   │   └── Dockerfile
│   └── shippingservice/          # Go
│       └── Dockerfile
├── docker-compose.yml
└── README.md

#how can you run this 
git clone [https://github.com/Abhinav389/microservices-demo.git](https://github.com/Abhinav389/microservices-demo.git)
cd microservices-demo

docker compose up --build -d

docker compose ps

#Now you can check in local browser for this 
http://localhost:8080

#finally you can close it 

docker compose down
