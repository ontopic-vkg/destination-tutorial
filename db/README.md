# Build the DB Docker image

```bash
sudo docker buildx build   --platform linux/amd64,linux/arm64   -t ontopicvkg/destination-tutorial-db:latest   --push   .
```
